//https://github.com/iang12/flutter_url_launcher_example/blob/master/lib/main.dart

import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:gpmobile/src/pages/documentos/bloc/ListarDocBloc.dart';
import 'package:gpmobile/src/pages/documentos/model/ListarDocModel.dart';
import 'package:gpmobile/src/pages/documentos/view/DocsWidget.dart';
import 'package:gpmobile/src/util/Estilo.dart';
import 'package:gpmobile/src/util/Globals.dart';
import 'package:gpmobile/src/util/SharedPreferencesBloc.dart';
import 'package:multi_select_item/multi_select_item.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListaDocLidasWidget extends StatefulWidget {
  const ListaDocLidasWidget({
    Key key,
  }) : super(key: key);

  @override
  _ListaDocLidasWidgetState createState() => _ListaDocLidasWidgetState();
}

class _ListaDocLidasWidgetState extends State<ListaDocLidasWidget> {
  //
  TtRetorno2 objMensaEndDrawer;
  //
  String origemClick = "";
  //
  int indexPage;
  int count = 0;
  //
  int operacaoVisualizar = 2;
  int operacaoExcluir = 3;
  //
  List statusModel = <TtRetorno2>[];
  List<TtRetorno2> listaFinal = [];
  List mainList = new List();
  //
  bool _userAdmin;
  bool _habilitaButton = false;
  //
  List<TtRetorno2> listaMapeada = [];
  //
  final GlobalKey<ScaffoldState> _tabKeyListaDocLidasWidget =
      GlobalKey<ScaffoldState>();
  //
  Random random = Random();
  MultiSelectController controller;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  //
  @override
  void initState() {
    // mainList.add({"key": "1"});
    // _animationController = AnimationController(vsync: this);
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
    // _atualizaPorTempo.run(() {
    //inicio
    SharedPreferences.getInstance().then((prefs) {
      LisartDocsBloc()
          .getListDocs(context: context, barraStatus: true, operacao: 1)
          .then((map) {
        setState(() {
          listaFinal.clear();
          if (map != null) {
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
            listaFinal = map.response.ttRetorno.ttRetorno2;
          } else {
            Globals.bloqueiaMenu = false;
          }
        });
      });
    });
    // });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      key: _tabKeyListaDocLidasWidget,
      body: Container(
        color: Colors.transparent,
        // decoration: AppGradients.gradient,
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 599) return listaDocWeb();
            if (constraints.maxWidth > 599) listaDocWeb();
            return listaDocWeb();
          },
        ),
      ),
      endDrawer: ConditionalSwitch.single<String>(
          context: context,
          valueBuilder: (BuildContext context) => origemClick,
          caseBuilders: {
            'viewDoc': (BuildContext context) =>
                // new VisualizaMensaWidget(objMensaEndDrawer),
                new DocsWidget(
                  file: objMensaEndDrawer.arquivoBase64,
                  title: objMensaEndDrawer.titulo,
                ),
            // 'createMensa': (BuildContext context) => EnviarMensaWidget(),
            // // 'EnviarMensaWidget': (BuildContext context) => ProductCard(),
            // 'editMensa': (BuildContext context) => new EditarMensaWidget(objMensaEndDrawer),
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

  //WEB
  Widget listaDocWeb() {
    //
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
//
    final txtAppBarTitle = (controller.isSelecting)
        ? Text('Selecionado(s) ${controller.selectedIndexes.length}  ')
        : Text(
            "DOCUMENTOS LIDOS",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12),
          );
    //
    // final btnAddMensa = _habilitaButton == false
    //     ? new IconButton(
    //         icon: Icon(Icons.add_comment,
    //             size: 30, color: Colors.amber.withOpacity(0.0)),
    //         splashColor: Colors.blue,
    //         splashRadius: 20,
    //         onPressed: null)
    //     : new IconButton(
    //         icon: Icon(
    //           Icons.add_comment,
    //           color: AppColors.iconSemFundo,
    //           size: 30,
    //         ),
    //         splashColor: Colors.blue,
    //         splashRadius: 20,
    //         onPressed: () {
    //           setState(() {
    //             origemClick = "createMensa";
    //             _openEndDrawer(9999);
    //           });
    //         },
    //       );
    //
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        title: txtAppBarTitle,
        actions: [
          // btnAddMensa,
          // btnRefresh,
        ],
      ),
      //
      body: SmartRefresher(
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
                  TtRetorno2 objDocWeb = listaFinal[index];

                  return MultiSelectItem(
                    isSelecting: controller.isSelecting,
                    onSelected: _habilitaButton == false
                        ? () {}
                        : () => onSelected(index),
                    child: Column(
                      children: [
                        //acao click!
                        GestureDetector(
                          onTap: () {
                            _visualizarDocWeb(objDocWeb, index);
                          },
                          child: Container(
                            margin: new EdgeInsets.fromLTRB(10, 0, 10, 0),
                            width: width * 0.89, // 0.29 web
                            height: 55.0, //height * 0.07

                            // child: Card(
                            //   clipBehavior: Clip.antiAlias,
                            //   shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(8.0)),
                            //   color: controller.isSelected(index)
                            //       ? AppColors.black
                            //       : AppColors.white,
                            //   child:
                            decoration: BoxDecoration(
                              // color: _selectedColorRight,
                              // gradient: AppGradients.linear2,
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
                                // Container(
                                //   color: AppColors.primary,
                                //   width: 10.0,
                                // ),
                                // SizedBox(
                                //   width: 10.0,
                                // ),
                                Expanded(
                                  child: AbsorbPointer(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: objDocWeb.documentoLido == null
                                              ? Icon(
                                                  Icons.document_scanner,
                                                  color: Colors.green,

                                                  // : Colors.purple[200] ,
                                                  size: 30,
                                                )
                                              : Icon(
                                                  Icons.document_scanner,
                                                  color:
                                                      objDocWeb.documentoLido ==
                                                              null
                                                          ? null
                                                          : Colors.grey,
                                                  size: 30,
                                                ),
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 120, 0),
                                            child: Text(
                                              objDocWeb.titulo,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight:
                                                    objDocWeb.documentoLido ==
                                                            null
                                                        ? FontWeight.bold
                                                        : FontWeight.normal,
                                                color:
                                                    objDocWeb.documentoLido ==
                                                            null
                                                        ? null
                                                        : Colors.grey,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Expanded(
                                        //   flex: 2,
                                        //   child: Text(
                                        //     objDocWeb.dataCriacao ==
                                        //             DateFormat('dd/MM/yy')
                                        //                 .format(DateTime.now())
                                        //                 .toString()
                                        //         ? objDocWeb.horaCriacao
                                        //         : objDocWeb
                                        //             .dataCriacao, //dias
                                        //     style: TextStyle(
                                        //       fontWeight:
                                        //           objDocWeb.documentoLido == null
                                        //               ? FontWeight.bold
                                        //               : FontWeight.normal,
                                        //       color:
                                        //           objDocWeb.documentoLido == null
                                        //               ? null
                                        //               : Colors.grey,
                                        //       fontSize: 12,
                                        //     ),
                                        //   ),
                                        // ),
                                        objDocWeb == null
                                            ? Container()
                                            : Expanded(
                                                flex: 1,
                                                child: objDocWeb.requerCiencia ==
                                                            true &&
                                                        objDocWeb
                                                                .documentoLido ==
                                                            null //pendente == isFalse
                                                    ? Icon(
                                                        Icons
                                                            .drive_file_rename_outline,
                                                        color:
                                                            Colors.orange[200],
                                                        size: 30,
                                                      )
                                                    : objDocWeb.requerCiencia ==
                                                                true &&
                                                            objDocWeb
                                                                    .documentoLido !=
                                                                null
                                                        ? Icon(
                                                            Icons
                                                                .check_circle_sharp,
                                                            color: Colors.green,
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
                    ),

                    //   actionPane: SlidableDrawerActionPane(),
                  );
                },
              ),
      ),
      //
      floatingActionButton: (controller.isSelecting)
          ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //1
                IconButton(
                  icon: Icon(
                    Icons.design_services_rounded,
                    color: AppColors.darkRed,
                    size: 30,
                  ),
                  onPressed: undoSelect,
                ),
                //2
                // IconButton(
                //   icon: Icon(
                //     Icons.edit,
                //     color: AppColors.darkRed,
                //     size: 30,
                //   ),
                //   onPressed: () => editWeb(),
                // ),
                // //3
                // IconButton(
                //   icon: Icon(
                //     Icons.delete,
                //     color: AppColors.darkRed,
                //     size: 30,
                //   ),
                //   onPressed: delete,
                // ),
              ],
            )
          : null,
    );
  }

////////////////////////////////////////////////////////////////////////////////

  // void edit() {
  //   var list = controller.selectedIndexes;
  //   list.sort((b, a) =>
  //       a.compareTo(b)); //reoder from biggest number, so it wont error
  //   list.forEach((element) {
  //     TtRetorno2 objMensa = listaFinal[element];
  //     editarMensa(objMensa);
  //   });
  // }
  //
  // void delete() {
  //   var list = controller.selectedIndexes;
  //   //reoder from biggest number, so it wont error
  //   list.forEach((element) async {
  //     final objMensa = listaFinal[element];
  //     //action delete obj
  //     await exlcuirMensa(objMensa);
  //   });
  //
  //   setState(() {
  //     controller.deselectAll();
  //     // controller.set(listaFinal.length);
  //   });
  // }

  // abrirMensa(objAbrirMensa, List<TtRetorno2> listOutrasMensagens) {
  //   setState(() {
  //     ListaMensaBloc()
  //         .actionOpenMsg(context, objAbrirMensa, true, listOutrasMensagens);
  //   });
  // }

  // editarMensa(objMensa) {
  //   setState(() {
  //     Navigator.of(context).push(
  //       PageRouteBuilder(
  //         fullscreenDialog: true,
  //         transitionDuration: Duration(milliseconds: 500),
  //         pageBuilder: (BuildContext context, Animation<double> animation,
  //             Animation<double> secondaryAnimation) {
  //           return EditarMensaWidget(objMensa);
  //         },
  //         transitionsBuilder: (BuildContext context,
  //             Animation<double> animation,
  //             Animation<double> secondaryAnimation,
  //             Widget child) {
  //           return Align(
  //             child: FadeTransition(
  //               opacity: animation,
  //               child: child,
  //             ),
  //           );
  //         },
  //       ),
  //     );
  //   });
  // }
  //
  // exlcuirMensa(objMensa) {
  //   Alert(
  //     buttons: [
  //       DialogButton(
  //         onPressed: () async {
  //           titulo = objMensa.titulo;
  //           mensg = objMensa.mensagem;
  //           data = objMensa.data;
  //           sequencia = objMensa.sequencia;
  //           //
  //           if (sequencia != null) {
  //             await new EnviarMensaBloc().postEnviarMensagem(context, titulo,
  //                 mensg, data, operacaoExcluir, sequencia, null, true);
  //             Navigator.of(context).pop();
  //           }
  //           refreshAction();
  //         },
  //         child: Text('OK'),
  //         color: AppColors.green,
  //       )
  //     ],
  //     context: context,
  //     title: 'Mensagem excluida com sucesso!',
  //     useRootNavigator: true,
  //   ).show();
  // }

  Future<bool> undoSelect() async {
    //block app from quitting when selecting
    var before = !controller.isSelecting;
    setState(() {
      controller.deselectAll();
    });
    return before;
  }

////////////////////////////////////////////////////////////////////////////////
  ///[WEB]

  void _visualizarDocWeb(objMensa, pageIndex) {
    setState(() async {
      final listDocs = listaFinal[pageIndex];
      var base;
      await LisartDocsBloc()
          .getListDocs(
              context: context,
              barraStatus: true,
              cienciaConfirmada: true,
              codDocumento: pageIndex,
              operacao: 2)
          .then((value) =>
              {base = value.response.ttRetorno.ttRetorno2[0].arquivoBase64})
          .whenComplete(() {
        print(base);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (document) => DocsWidget(
                    file: base,
                    title: listDocs.titulo,
                  )),
        );
      });
    });
  }

  // void editWeb() {
  //   var list = controller.selectedIndexes;
  //   list.sort((b, a) =>
  //       a.compareTo(b)); //reoder from biggest number, so it wont error
  //   list.forEach((element) {
  //     StatusModel objMensa = listaFinal[element];
  //     setState(() {
  //       origemClick = "editMensa";
  //       objMensaEndDrawer = objMensa;
  //       _openEndDrawer(element);
  //     });
  //   });
  // }

  //METODOS COMPARTILHADOS
  Future<int> _openEndDrawer(i) async {
    indexPage = i;
    _tabKeyListaDocLidasWidget.currentState.openEndDrawer();
    return indexPage;
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
              .getListDocs(context: context, barraStatus: true, operacao: 1)
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
