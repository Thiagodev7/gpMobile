//https://github.com/iang12/flutter_url_launcher_example/blob/master/lib/main.dart
//https://github.com/tonydavidx/chattie-ui-design - 17/08/21 chat-ui

import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/conditional_switch.dart';

import 'package:gpmobile/src/pages/documentos/bloc/ListarDocBloc.dart';
import 'package:gpmobile/src/pages/documentos/model/ListarDocModel.dart'
    as ListarDocModel;
import 'package:gpmobile/src/pages/documentos/view/DocsWidget.dart';
import 'package:gpmobile/src/util/Estilo.dart';
import 'package:multi_select_item/multi_select_item.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListaDocWidget extends StatefulWidget {
  @override
  _ListaDocWidgetState createState() => _ListaDocWidgetState();
}

class _ListaDocWidgetState extends State<ListaDocWidget> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  // final _atualizaPorTempo = AtualizarPorTimer(milisegundos: 250);
  // List heroType = <HeroType>[];
  ListarDocModel.TtRetorno2 objDocEndDrawer;

  String titulo;
  String mensg;
  String data;
  int sequencia;
  String matriculasView;
  bool lido;
  bool aceite;

  List<ListarDocModel.TtRetorno2> listaFinal = [];
  //
  final GlobalKey<ScaffoldState> _scaffoldKeyListaDocWidget =
      GlobalKey<ScaffoldState>();
  int indexPage;
  int count = 0;
  String origemClick = "";
  //
  List mainList = new List();
  Random random = Random();
  MultiSelectController controller;
  //
  @override
  void initState() {
    controller = MultiSelectController();
    controller.disableEditingWhenNoneSelected = true;
    controller.set(listaFinal.length);

    super.initState();

    LisartDocsBloc()
        .getListDocs(context: context, barraStatus: true, operacao: 1)
        .then((map) {
      if (map != null) {
        setState(() {
          listaFinal = map.response.ttRetorno.ttRetorno2;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  ///////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKeyListaDocWidget,
      body: Container(
        decoration: AppGradients.gradient,
        child: ScreenTypeLayout(
          breakpoints: ScreenBreakpoints(desktop: 899, tablet: 730, watch: 279),
          mobile: OrientationLayoutBuilder(
            portrait: (context) => _listarDocMobile(),
            landscape: (context) => _listarDocMobile(),
          ),
          //  tablet: _buildWeb(),
          // desktop: _buildWeb(),
        ),
      ),

      //////////////////////////////////?????????????/////////////////////////////////
      endDrawer: ConditionalSwitch.single<String>(
          context: context,
          valueBuilder: (BuildContext context) => origemClick,
          caseBuilders: {
            'viewMensa': (BuildContext context) =>
                // new VisualizaMensaWidget(objDocEndDrawer),
                new DocsWidget(),
            // 'createMensa': (BuildContext context) => EnviarMensaWidget(),
            // 'EnviarMensaWidget': (BuildContext context) => ProductCard(),
            // 'editMensa': (BuildContext context) => new EditarMensaWidget(objDocEndDrawer),
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
    );
  }
  ///////////////////////////////////////////////////////////

  //MOBILE
  Widget _listarDocMobile() {
    //
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    //
    final txtAppBarTitle = (controller.isSelecting)
        ? Text('Selecionado(s) ${controller.selectedIndexes.length}  ')
        : Text(
            "Documentos",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          );
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
    //           int pageRandom = random.nextInt(100); // from 0 upto 99 included
    //           setState(() {
    //             origemClick = "createMensa";
    //             _openEndDrawer(pageRandom);
    //             // _onRefresh();
    //           });
    //         },
    //       );

    final btnRefresh = new IconButton(
      icon: Icon(
        Icons.autorenew,
        color: AppColors.iconSemFundo,
        size: 30,
      ),
      // onPressed: refreshAction,
      onPressed: () => null, //_listaMensaBloc.refreshList(context),
    );
    //
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: txtAppBarTitle,
        actions: [
          // btnAddMensa,
          // btnRefresh
        ],
      ),

      body: SmartRefresher(
        header: WaterDropHeader(waterDropColor: Colors.green),
        controller: _refreshController,
        onRefresh: _onRefresh,
        //
        child: listaFinal == null || listaFinal.isEmpty
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
                  ListarDocModel.TtRetorno2 objDocMob = listaFinal[index];

                  return MultiSelectItem(
                    isSelecting: controller.isSelecting,
                    onSelected:
                        // _habilitaButton == false
                        //     ? () {}
                        //     :
                        () => onSelected(index),
                    child: Column(
                      children: [
                        //acao click!
                        GestureDetector(
                          onTap: () => acaoClick(index),
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
                                          child: objDocMob.documentoLido == null
                                              ? Icon(
                                                  Icons.document_scanner,
                                                  color: Colors.green,

                                                  // : Colors.purple[200] ,
                                                  size: 30,
                                                )
                                              : Icon(
                                                  Icons.document_scanner,
                                                  // Icons.document_scanner_outline,
                                                  color:
                                                      objDocMob.documentoLido ==
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
                                                0, 0, 20, 0),
                                            child: Text(
                                              objDocMob.titulo,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight:
                                                    objDocMob.documentoLido ==
                                                            null
                                                        ? FontWeight.bold
                                                        : FontWeight.normal,
                                                color:
                                                    objDocMob.documentoLido ==
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
                                        //     objDocMob.dataCriacao ==
                                        //             DateFormat('dd/MM/yy')
                                        //                 .format(DateTime.now())
                                        //                 .toString()
                                        //         ? objDocMob.horaCriacao
                                        //         : objDocMob
                                        //             .dataCriacao, //dias
                                        //     style: TextStyle(
                                        //       fontWeight:
                                        //           objDocMob.documentoLido == null
                                        //               ? FontWeight.bold
                                        //               : FontWeight.normal,
                                        //       color:
                                        //           objDocMob.documentoLido == null
                                        //               ? null
                                        //               : Colors.grey,
                                        //       fontSize: 12,
                                        //     ),
                                        //   ),
                                        // ),
                                        objDocMob == null
                                            ? Container()
                                            : Expanded(
                                                flex: 1,
                                                child: objDocMob.requerCiencia ==
                                                            true &&
                                                        objDocMob
                                                                .documentoLido ==
                                                            null //pendente == isFalse
                                                    ? Icon(
                                                        Icons
                                                            .drive_file_rename_outline,
                                                        color:
                                                            Colors.orange[200],
                                                        size: 30,
                                                      )
                                                    : objDocMob.requerCiencia ==
                                                                true &&
                                                            objDocMob
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
                //   onPressed: edit,
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
  ///[MOBILE]
  void acaoClick(index) {
    //
    abrirDoc(index);
    //
    setState(() {
      refreshAction();
    });
  }

  // void edit() {
  //   var list = controller.selectedIndexes;
  //   list.sort((b, a) =>
  //       a.compareTo(b)); //reoder from biggest number, so it wont error
  //   list.forEach((element) {
  //     ListarDocModel.ListarDocModel.TtRetorno objDoc = listaFinal[element];
  //     editarMensa(objDoc);
  //   });
  // }

  // void delete() {
  //   var list = controller.selectedIndexes;
  //   //reoder from biggest number, so it wont error
  //   list.forEach((element) async {
  //     final objDoc = listaFinal[element];
  //     //action delete obj
  //     await exlcuirMensa(objDoc);
  //   });
  //
  //   setState(() {
  //     controller.deselectAll();
  //     // controller.set(listaFinal.length);
  //   });
  // }

  // abrirDoc(
  //     objAbrirDoc, List<ListarDocModel.TtRetorno2> listOutrosDocs) {
  //   setState(() {
  //     ListaMensaBloc()
  //         .actionOpenMsg(context, objAbrirDoc, true, listOutrosDocs);
  //   });
  //   // refreshAction();
  // }

  void abrirDoc(index) async {
    var base;
    final listDocs = listaFinal[index];
    await LisartDocsBloc()
        .getListDocs(
            context: context,
            barraStatus: true,
            cienciaConfirmada: true,
            codDocumento: index,
            operacao: 2)
        .then((value) =>
            {base = value.response.ttRetorno.ttRetorno2[0].arquivoBase64})
        .whenComplete(() {
      print(base);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (document) => DocsWidget()),
      );
    });
  }

  // editarMensa(objDoc) {
  //   setState(() {
  //     Navigator.of(context).push(
  //       PageRouteBuilder(
  //         fullscreenDialog: true,
  //         transitionDuration: Duration(milliseconds: 500),
  //         pageBuilder: (BuildContext context, Animation<double> animation,
  //             Animation<double> secondaryAnimation) {
  //           return EditarMensaWidget(objDoc);
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

  // exlcuirMensa(objDoc) {
  //   Alert(
  //     buttons: [
  //       DialogButton(
  //         onPressed: () async {
  //           titulo = objDoc.titulo;
  //           mensg = objDoc.mensagem;
  //           data = objDoc.data;
  //           sequencia = objDoc.sequencia;
  //           //
  //           if (sequencia != null) {
  //             await new EnviarMensaBloc().postEnviarMensagem(
  //                 context, titulo, mensg, data, 3, sequencia, null, true);
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
//   ///[WEB]
//   void editWeb() {
//     var list = controller.selectedIndexes;
//     list.sort((b, a) =>
//         a.compareTo(b)); //reoder from biggest number, so it wont error
//     list.forEach((element) {
//       setState(() {
//         origemClick = "editMensa";
//         _openEndDrawer(element);
//       });
//     });
//   }

  // void _visualizarMensaWeb(objDoc, pageIndex) {
  //   // HeroType heroType;
  //
  //   setState(() {
  //     //
  //     String tituloViewMensa = objDoc.titulo;
  //     String mensgViewMensa = objDoc.mensagem;
  //     String dataViewMensa = objDoc.data;
  //     int sequenciaViewMensa = objDoc.sequencia;
  //     bool lidoViewMensa = objDoc.lido = true; //objDoc.lido true == lido!
  //     //
  //     //atualiza status datasul
  //
  //     // EnviarMensaBloc()
  //     //     .postEnviarMensagem(context, tituloViewMensa, mensgViewMensa,
  //     //         dataViewMensa, 2, sequenciaViewMensa, objDoc, lidoViewMensa)
  //     //     .then((map) async {
  //     //   setState(() {
  //     //     origemClick = "viewMensa";
  //     //     objDocEndDrawer = objDoc;
  //     //     _openEndDrawer(pageIndex);
  //     //   });
  //     // });
  //
  //     // ListaMensaBloc()
  //     //     .gravaStatus(context, tituloViewMensa, mensgViewMensa, dataViewMensa,
  //     //     matriculasView, sequenciaViewMensa, lidoViewMensa, false)
  //     //     .then((map) async {
  //     //   setState(() {
  //     //     origemClick = "view";
  //     //     _openEndDrawer(pageIndex);
  //     //   });
  //     // });
  //   });
  // }

  //METODOS COMPARTILHADOS
  Future<int> _openEndDrawer(i) async {
    indexPage = i;
    _scaffoldKeyListaDocWidget.currentState.openEndDrawer();
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
            if (map != null) {
              setState(() {
                listaFinal = map.response.ttRetorno.ttRetorno2;
              });
            }
          });
        });
      });

  void onSelected(int value) {
    setState(() {
      controller.toggle(value);
    });
  }
}

class Flight {
  static Widget flightShuttleBuilder(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    return DefaultTextStyle(
      style: DefaultTextStyle.of(toHeroContext).style,
      child: toHeroContext.widget,
    );
  }
}
