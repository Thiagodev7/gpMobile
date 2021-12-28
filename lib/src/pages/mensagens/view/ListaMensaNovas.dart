import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:gpmobile/src/pages/mensagens/model/MensagemRetornoModel.dart'
    as msg;
import 'package:gpmobile/src/pages/mensagens/view/VisualizaMensaWidget.dart';
import 'package:gpmobile/src/util/AtualizarPorTimer.dart';
import 'package:gpmobile/src/util/Estilo.dart';
import 'package:gpmobile/src/util/Globals.dart';
import 'package:gpmobile/src/util/SharedPreferencesBloc.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_item/multi_select_item.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../bloc/ListaMensaBloc.dart';

class ListaMensaNovas extends StatefulWidget {
  @override
  _ListaMensaNovasState createState() => _ListaMensaNovasState();
}

class _ListaMensaNovasState extends State<ListaMensaNovas> {
  List<msg.TtRetorno2> listaGlobal;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  //List statusModel = <msg.TtRetorno>[];
  msg.TtRetorno objMensaEndDrawer;

  //
  List<msg.TtRetorno2> listaFinal = [];
  //
  bool _userAdmin;
  bool _habilitaButton = false;
  //
  final GlobalKey<ScaffoldState> _scaffoldKeyListaMensaNovas =
      GlobalKey<ScaffoldState>();
  int index;
  int count = 0;
  String origemClick = "";
  //

  Random random = Random();
  MultiSelectController controller;
  //
  @override
  void initState() {
    controller = MultiSelectController();
    controller.disableEditingWhenNoneSelected = true;

    //controller.set(listaFinal.length);

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
      ListaMensaBloc()
          .getMessageBack(context: context, barraStatus: true, operacao: 1)
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
      backgroundColor: Colors.transparent,
      key: _scaffoldKeyListaMensaNovas,
      body: Container(
        color: Colors.transparent,
        // decoration: AppGradients.gradient,
        child: _ListaMensaNovasWeb(),
      ),
      endDrawer: ConditionalSwitch.single<String>(
          context: context,
          valueBuilder: (BuildContext context) => origemClick,
          caseBuilders: {
            'viewMensa': (BuildContext context) =>
                VisualizaMensaWidget(index: listaFinal[index].codMensagem),
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

  //WEB
  Widget _ListaMensaNovasWeb() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
//
    final txtAppBarTitle = Text(
      "MENSAGENS NOVAS",
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w500,
        fontSize: 12,
      ),
    );

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
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'MENSAGENS',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ),
      body: SmartRefresher(
        header: WaterDropHeader(waterDropColor: Colors.green),
        controller: _refreshController,
        onRefresh: _onRefresh,
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
                  msg.TtRetorno2 objDocMob = listaFinal[index];

                  bool mensagemLida;
                  if (listaFinal[index].requerCiencia) {
                    if (listaFinal[index].mensagemLida &&
                        listaFinal[index].mensagemAssinada) {
                      mensagemLida = true;
                    } else {
                      mensagemLida = false;
                    }
                  } else {
                    if (listaFinal[index].mensagemLida) {
                      mensagemLida = true;
                    } else {
                      mensagemLida = false;
                    }
                  }

                  return Column(
                    children: [
                      //acao click!
                      GestureDetector(
                        onTap: () {
                          _visualizarMensaWeb(index);
                        },
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child: Icon(
                                          Icons.message,
                                          color: mensagemLida
                                              ? Colors.grey
                                              : Colors.green,
                                          size: 30,
                                        )),
                                    Expanded(
                                      flex: 5,
                                      child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 20, 0),
                                          child: new Text(
                                            listaFinal[index].titulo,
                                            style: TextStyle(
                                              fontWeight: mensagemLida
                                                  ? FontWeight.normal
                                                  : FontWeight.bold,
                                              color: mensagemLida
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
                                                    .format(DateTime.now())
                                                    .toString()
                                            ? listaFinal[index].dataCriacao
                                            : listaFinal[index].horaCriacao,
                                        style: TextStyle(
                                          fontWeight: mensagemLida
                                              ? FontWeight.normal
                                              : FontWeight.bold,
                                          color:
                                              mensagemLida ? Colors.grey : null,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    listaFinal[index].requerCiencia
                                        ? Icon(
                                            Icons.drive_file_rename_outline,
                                            color: listaFinal[index]
                                                    .mensagemAssinada
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
                          ),
                        ),
                      ),
                      // ),
                      SizedBox(height: 10),
                    ],
                  );
                },
              ),
      ),
    );
  }

  ///[WEB]

  void _visualizarMensaWeb(pageIndex) {
    setState(() {
      origemClick = "viewMensa";
      // objMensaEndDrawer = objMensa;
      _openEndDrawer(pageIndex);
    });
  }

  //METODOS COMPARTILHADOS
  Future<int> _openEndDrawer(i) async {
    index = i;
    _scaffoldKeyListaMensaNovas.currentState.openEndDrawer();
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
          ListaMensaBloc()
              .getMessageBack(barraStatus: true, context: context, operacao: 1)
              .then((map) {
            setState(() {
              if (map != null) {
                //listaGlobal = map1;

                msg.TtRetorno2 mensagem = map.response.ttRetorno.ttRetorno2
                    .firstWhere(
                        (element) =>
                            element.requerCiencia == true &&
                            element.mensagemLida == false,
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
