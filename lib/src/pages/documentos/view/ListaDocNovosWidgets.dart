//https://github.com/iang12/flutter_url_launcher_example/blob/master/lib/main.dart

import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:gpmobile/src/pages/documentos/bloc/ListarDocBloc.dart';
import 'package:gpmobile/src/pages/documentos/model/ListarDocModel.dart';
import 'package:gpmobile/src/pages/documentos/view/DocsWidget.dart';
import 'package:gpmobile/src/util/AtualizarPorTimer.dart';
import 'package:gpmobile/src/util/Estilo.dart';
import 'package:gpmobile/src/util/Globals.dart';
import 'package:gpmobile/src/util/SharedPreferencesBloc.dart';
import 'package:multi_select_item/multi_select_item.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListaDocWidgetWeb extends StatefulWidget {
  @override
  _ListaDocWidgetWebState createState() => _ListaDocWidgetWebState();
}

class _ListaDocWidgetWebState extends State<ListaDocWidgetWeb> {
  LisartDocsBloc _listaMensaBloc = new LisartDocsBloc();
  List<TtRetorno2> listaGlobal;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  //
  final _atualizaPorTempo = AtualizarPorTimer(milisegundos: 250);
  //
  // List heroType = <HeroType>[];
  List statusModel = <TtRetorno2>[];
  TtRetorno2 objMensaEndDrawer;

  //
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

  List mainList = new List();
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
        setState(() {
          listaFinal.clear();
          if (map != null && map.response.ttRetorno.ttRetorno2 != null) {
            //listaGlobal = map1;

            TtRetorno2 mensagem = map.response.ttRetorno.ttRetorno2.firstWhere(
                (element) =>
                    element.requerCiencia == true &&
                    element.documentoLido == null,
                orElse: () => null);
            if (mensagem == null) {
              Globals.bloqueiaMenu = false;
            } else {
              Globals.bloqueiaMenu = true;
            }
            listaFinal = map.response.ttRetorno.ttRetorno2
              ..where((element) => element.documentoLido == true).toList();
          } else {
            Globals.bloqueiaMenu = false;
          }
        });
      });
    });
  }

  ///////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent.withOpacity(0.3),
      key: _scaffoldKeyListaDocWidgetWeb,
      body: Container(
        color: Colors.transparent,
        child: ScreenTypeLayout(
          breakpoints: ScreenBreakpoints(desktop: 899, tablet: 730, watch: 279),
          mobile: OrientationLayoutBuilder(
              //   portrait: (context) => _ListaDocWidgetWebMobile(),
              // landscape: (context) => _ListaDocWidgetWebMobile(),
              ),
          tablet: _ListaDocWidgetWebWeb(),
          desktop: _ListaDocWidgetWebWeb(),
        ),
      ),
      endDrawer: ConditionalSwitch.single<String>(
          context: context,
          valueBuilder: (BuildContext context) => origemClick,
          caseBuilders: {
            'viewDoc': (BuildContext context) =>
                // new VisualizaMensaWidget(objMensaEndDrawer),
                DocsWidget(index: listaFinal[index].codDocumento),

            // 'createMensa': (BuildContext context) => EnviarMensaWidget(),
            // // 'EnviarMensaWidget': (BuildContext context) => ProductCard(),
            // 'editMensa': (BuildContext context) =>
            //     new EditarMensaWidget(objMensaEndDrawer),
          },
          fallbackBuilder: (BuildContext context) {
            return Card(
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  // const Icon(Icons.close, size: 60, color: Colors.red),
                  IconButton(
                    // color: Colors.red,
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
    final txtAppBarTitle = Text(
      "DOCUMENTOS NOVOS",
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
        title: Text(
          "DOCUMENTOS",
          style: TextStyle(
            color: Colors.white,
            // fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: SmartRefresher(
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
                  itemBuilder: (BuildContext context, index) => Column(
                        children: [
                          //acao click!
                          GestureDetector(
                            onTap: () {
                              _visualizaDocWeb(index);
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
                                color: AppColors.white,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: AbsorbPointer(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: listaFinal[index]
                                                        .documentoLido ==
                                                    null
                                                ? Icon(
                                                    Icons.messenger,
                                                    color: Colors.green,

                                                    // : Colors.purple[200] ,
                                                    size: 30,
                                                  )
                                                : Icon(
                                                    Icons.messenger,
                                                    color: listaFinal[index]
                                                                .documentoLido ==
                                                            null
                                                        ? null
                                                        : Colors.grey,
                                                    size: 30,
                                                  ),
                                          ),
                                          Expanded(
                                            flex: 5,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 0, 120, 0),
                                              child: Text(
                                                listaFinal[index].titulo,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontWeight: listaFinal[index]
                                                              .documentoLido ==
                                                          null
                                                      ? FontWeight.bold
                                                      : FontWeight.normal,
                                                  color: listaFinal[index]
                                                              .documentoLido ==
                                                          null
                                                      ? null
                                                      : Colors.grey,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                          listaFinal[index] == null
                                              ? Container()
                                              : Expanded(
                                                  flex: 1,
                                                  child: listaFinal[index]
                                                                  .requerCiencia ==
                                                              true &&
                                                          listaFinal[index]
                                                                  .documentoLido ==
                                                              null //pendente == isFalse
                                                      ? Icon(
                                                          Icons
                                                              .drive_file_rename_outline,
                                                          color: Colors
                                                              .orange[200],
                                                          size: 30,
                                                        )
                                                      : listaFinal[index]
                                                                      .requerCiencia ==
                                                                  true &&
                                                              listaFinal[index]
                                                                      .documentoLido !=
                                                                  null
                                                          ? Icon(
                                                              Icons
                                                                  .check_circle_sharp,
                                                              color:
                                                                  Colors.green,
                                                              size: 30,
                                                            )
                                                          : Icon(null),
                                                ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // ),
                          SizedBox(height: 10),
                        ],
                      )),
        ),
      ),
      //
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
    // monitor network fetch
    refreshAction();
    print('atualizando Box');
    // if failed,use refreshFailed()
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
              listaFinal.clear();
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

  void onSelected(int value) {
    setState(() {
      controller.toggle(value);
    });
  }
}
