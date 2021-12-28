import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:gpmobile/src/pages/documentos/bloc/ListarDocBloc.dart';
import 'package:gpmobile/src/pages/documentos/model/ListarDocModel.dart';
import 'package:gpmobile/src/pages/documentos/view/DocsWidget.dart';
import 'package:gpmobile/src/util/AlertDialogTemplate.dart';
import 'package:gpmobile/src/util/AtualizarPorTimer.dart';
import 'package:gpmobile/src/util/Estilo.dart';
import 'package:gpmobile/src/util/Globals.dart';
import 'package:gpmobile/src/util/SharedPreferencesBloc.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_item/multi_select_item.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListaDocWidgetWeb extends StatefulWidget {
  @override
  _ListaDocWidgetWebState createState() => _ListaDocWidgetWebState();
}

class _ListaDocWidgetWebState extends State<ListaDocWidgetWeb> {
  List<TtRetorno2> listaGlobal;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  List statusModel = <TtRetorno2>[];
  TtRetorno2 objMensaEndDrawer;

  List<TtRetorno2> listaFinal = [];
  //
  bool _userAdmin;
  bool _habilitaButton = false;
  //
  final GlobalKey<ScaffoldState> _scaffoldKeyListaDocWidgetWeb =
      GlobalKey<ScaffoldState>();
  int index;

  int count = 0;
  String origemClick = "";
  //

  Random random = Random();
  MultiSelectController controller;

  String documentofile;
  //
  @override
  void initState() {
    controller = MultiSelectController();
    controller.disableEditingWhenNoneSelected = true;
    controller.set(listaFinal.length);

    setState(() {
      SharedPreferencesBloc().buscaParametroBool("userAdmin").then((retorno2) {
        _userAdmin = retorno2;

        if (_userAdmin == false) {
          setState(() {
            _habilitaButton = _userAdmin;
          });
        } else {
          setState(() {
            _habilitaButton = _userAdmin;
          });
        }
      });
    });
    super.initState();

    //Msg Back
    SharedPreferences.getInstance().then((prefs) {
      LisartDocsBloc()
          .getListDocs(context: context, barraStatus: true, operacao: 1)
          .then((map) {
        if (map != null) {
          setState(() {
            listaFinal = map.response.ttRetorno.ttRetorno2;
          });
        }
      });
    });
  }

  ///////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent.withOpacity(0.3),
      key: _scaffoldKeyListaDocWidgetWeb,
      body:
          Container(color: Colors.transparent, child: _ListaDocWidgetWebWeb()),
      endDrawer: ConditionalSwitch.single<String>(
          context: context,
          valueBuilder: (BuildContext context) => origemClick,
          caseBuilders: {
            'viewDoc': (BuildContext context) =>
                DocsWidget(index: listaFinal[index].codDocumento),
          },
          fallbackBuilder: (BuildContext context) {
            return Card(
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: closeEndDrawer,
                    icon: Icon(Icons.close, size: 60, color: Colors.red),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  const Text(
                    'Erro: Favor contactar o departameto de tecnologia!!!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }),
      endDrawerEnableOpenDragGesture: false,
      onEndDrawerChanged: (isOpened) {
        if (isOpened == false) {
          refreshAction();
        }
      },
    );
  }

  ///////////////////////////////////////////////////////////

//   //WEB
  Widget _ListaDocWidgetWebWeb() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
//
    final btnRefresh = new IconButton(
        icon: Icon(
          Icons.autorenew,
          color: AppColors.iconSemFundo,
          size: 30,
        ),
        onPressed: refreshAction);
    //

    //
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "DOCUMENTOS",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          InkWell(
            onTap: () {
              AlertDialogTemplate().showAlertDialogAno(
                context,
                'Selecione o Ano',
              );
            },
            child: Container(
                margin: new EdgeInsets.fromLTRB(10, 0, 10, 0),
                width: width * 0.89, // 0.29 web
                height: 55.0, //height * 0.07
                decoration: BoxDecoration(
                  // color: _selectedColorRight,
                  // gradient: AppGradients.linear2,
                  border: Border.fromBorderSide(
                    BorderSide(
                      color: AppColors.border,
                    ),
                  ),
                  borderRadius: BorderRadius.circular(5),
                  color: AppColors.white,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: Icon(
                                Icons.request_page,
                                size: 30,
                              )),
                          Expanded(
                            flex: 5,
                            child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                                child: new Text(
                                  'Cedula C (extrato imposto de renda)',
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15,
                                  ),
                                )),
                          ),
                          Icon(
                            Icons.download,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
          SizedBox(height: 10),
          Expanded(
            child: SmartRefresher(
              header: WaterDropHeader(waterDropColor: Colors.green),
              controller: _refreshController,
              onRefresh: _onRefresh,
              //
              child: listaFinal.isEmpty
                  ? Center(
                      child: Text(
                        'Lista vazia no momento!',
                        style: TextStyle(
                          color: AppColors.txtSemFundo,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: listaFinal.length,
                      itemBuilder: (BuildContext context, int index) {
                        TtRetorno2 objDocMob = listaFinal[index];

                        bool documentoLido;
                        if (listaFinal[index].requerCiencia) {
                          if (listaFinal[index].documentoLido &&
                              listaFinal[index].documentoAssinado) {
                            documentoLido = true;
                          } else {
                            documentoLido = false;
                          }
                        } else {
                          if (listaFinal[index].documentoLido) {
                            documentoLido = true;
                          } else {
                            documentoLido = false;
                          }
                        }

                        return Column(
                          children: [
                            //acao click!

                            GestureDetector(
                              onTap: () => _visualizaDocWeb(index),
                              child: Container(
                                  margin: new EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  width: width * 0.89, // 0.29 web
                                  height: 55.0, //height * 0.07
                                  decoration: BoxDecoration(
                                    border: Border.fromBorderSide(
                                      BorderSide(
                                        color: AppColors.border,
                                      ),
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                    color: controller.isSelected(index)
                                        ? AppColors.black
                                        : AppColors.white,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Expanded(
                                                flex: 1,
                                                child: Icon(
                                                  Icons.find_in_page,
                                                  color: documentoLido
                                                      ? Colors.grey
                                                      : Colors.green,
                                                  size: 30,
                                                )),
                                            Expanded(
                                              flex: 5,
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 0, 20, 0),
                                                  child: new Text(
                                                    listaFinal[index].titulo,
                                                    style: TextStyle(
                                                      fontWeight: documentoLido
                                                          ? FontWeight.normal
                                                          : FontWeight.bold,
                                                      color: documentoLido
                                                          ? Colors.grey
                                                          : null,
                                                      fontSize: 15,
                                                    ),
                                                  )),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                listaFinal[index].dataCriacao ==
                                                        DateFormat('dd/MM/yy')
                                                            .format(
                                                                DateTime.now())
                                                            .toString()
                                                    ? listaFinal[index]
                                                        .dataCriacao
                                                    : listaFinal[index]
                                                        .horaCriacao,
                                                style: TextStyle(
                                                  fontWeight: documentoLido
                                                      ? FontWeight.normal
                                                      : FontWeight.bold,
                                                  color: documentoLido
                                                      ? Colors.grey
                                                      : null,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                            listaFinal[index].requerCiencia
                                                ? Icon(
                                                    Icons
                                                        .drive_file_rename_outline,
                                                    color: listaFinal[index]
                                                            .documentoAssinado
                                                        ? Colors.grey
                                                        : Colors.green,
                                                  )
                                                : Icon(null),
                                            SizedBox(
                                              width: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                            SizedBox(height: 10),
                          ],
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

////////////////////////////////////////////////////////////////////////////////
  ///[WEB]

  void _visualizaDocWeb(pageIndex) {
    setState(() {
      origemClick = "viewDoc";
      _openEndDrawer(pageIndex);
    });
  }

  //METODOS COMPARTILHADOS
  Future<int> _openEndDrawer(i) async {
    index = i;
    _scaffoldKeyListaDocWidgetWeb.currentState.openEndDrawer();
  }

  void closeEndDrawer() {
    setState(() {
      count = count - 1;
      Navigator.of(context).pop();
    });
  }

  _onRefresh() {
    refreshAction();
    print('atualizando Box');
    Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  Future<void> refreshAction() async => setState(() {
        SharedPreferences.getInstance().then((prefs) {
          LisartDocsBloc()
              .getListDocs(
                  context: context,
                  barraStatus: true,
                  operacao: 1,
                  codDocumento: 1)
              .then((map) {
            setState(() {
              if (map != null) {
                //listaGlobal = map1;

                TtRetorno2 mensagem = map.response.ttRetorno.ttRetorno2
                    .firstWhere(
                        (element) =>
                            element.requerCiencia == true &&
                            element.documentoLido == null,
                        orElse: () => null);
                if (mensagem == null) {
                  Globals.bloqueiaMenu = false;
                } else {
                  Globals.bloqueiaMenu = true;
                }
                listaFinal = map.response.ttRetorno.ttRetorno2;
              } else {
                Globals.bloqueiaMenu = false;
              }
            });
          });
        });
      });
}
