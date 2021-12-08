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

class ListaDocNovos extends StatefulWidget {
  @override
  _ListaDocNovosState createState() => _ListaDocNovosState();
}

class _ListaDocNovosState extends State<ListaDocNovos> {
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
  final GlobalKey<ScaffoldState> _scaffoldKeyListaDocNovos =
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
              ..where((element) => element.documentoLido == null).toList();
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
      backgroundColor: Colors.transparent,
      key: _scaffoldKeyListaDocNovos,
      body: Container(
        color: Colors.transparent,
        // decoration: AppGradients.gradient,
        child: ScreenTypeLayout(
          breakpoints: ScreenBreakpoints(desktop: 899, tablet: 730, watch: 279),
          mobile: OrientationLayoutBuilder(
              //   portrait: (context) => _ListaDocNovosMobile(),
              // landscape: (context) => _ListaDocNovosMobile(),
              ),
          tablet: _ListaDocNovosWeb(),
          desktop: _ListaDocNovosWeb(),
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
                    title: objMensaEndDrawer.titulo)
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

//   //MOBILE
//   Widget _ListaDocNovosMobile() {
//     //
//     double width = MediaQuery.of(context).size.width;
//     double height = MediaQuery.of(context).size.height;
//     //
//     final txtAppBarTitle = (controller.isSelecting)
//         ? Text('Selecionado(s) ${controller.selectedIndexes.length}  ')
//         : Text(
//             "MENSAGENS NOVAS",
//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.w500,
//               fontSize: 12,
//             ),
//           );
//     final btnAddMensa = _habilitaButton == false
//         ? new IconButton(
//             icon: Icon(Icons.add_comment,
//                 size: 30, color: Colors.amber.withOpacity(0.0)),
//             splashColor: Colors.blue,
//             splashRadius: 20,
//             onPressed: null)
//         : new IconButton(
//             icon: Icon(
//               Icons.add_comment,
//               color: AppColors.iconSemFundo,
//               size: 30,
//             ),
//             splashColor: Colors.blue,
//             splashRadius: 20,
//             onPressed: () {
//               int pageRandom = random.nextInt(100); // from 0 upto 99 included
//               setState(() {
//                 origemClick = "createMensa";
//                 _openEndDrawer(pageRandom);
//               });
//             },
//           );

//     final btnRefresh = new IconButton(
//       icon: Icon(
//         Icons.autorenew,
//         color: AppColors.iconSemFundo,
//         size: 30,
//       ),
//       onPressed: refreshAction,
//       // onPressed: () => _listaMensaBloc.refreshList(context),
//     );
//     //
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         centerTitle: true,
//         title: txtAppBarTitle,
//         actions: [
//           btnAddMensa,
//           // btnRefresh
//         ],
//       ),

//       body: SmartRefresher(
//         header: WaterDropHeader(waterDropColor: Colors.green),
//         controller: _refreshController,
//         onRefresh: _onRefresh,
// //
//         child: listaFinal.isEmpty
//             ? Center(
//                 child: Text(
//                   'Lista vazia no momento!',
//                   style: TextStyle(
//                     color: AppColors.txtSemFundo,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               )
//             : ListView.builder(
//                 itemCount: listaFinal.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   TtRetorno2 objMensaMob = listaFinal[index];

//                   return MultiSelectItem(
//                     isSelecting: controller.isSelecting,
//                     onSelected: _habilitaButton == false
//                         ? () {}
//                         : () => onSelected(index),
//                     child: Column(
//                       children: [
//                         //acao click!
//                         GestureDetector(
//                           onTap: () => acaoClick(objMensaMob),
//                           child: Container(
//                               margin: new EdgeInsets.fromLTRB(10, 0, 10, 0),
//                               width: width * 0.89, // 0.29 web
//                               height: 55.0, //height * 0.07

//                               child: Card(
//                                 clipBehavior: Clip.antiAlias,
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(8.0)),
//                                 color: controller.isSelected(index)
//                                     ? AppColors.black
//                                     : AppColors.white,
//                                 child: Row(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: <Widget>[
//                                     // Container(
//                                     //   color: AppColors.primary,
//                                     //   width: 10.0,
//                                     // ),
//                                     // SizedBox(
//                                     //   width: 10.0,
//                                     // ),
//                                     Expanded(
//                                       child: AbsorbPointer(
//                                         child: Row(
//                                           children: [
//                                             Expanded(
//                                               flex: 1,
//                                               child: objMensaMob.documentoLido == null
//                                                   ? Icon(
//                                                       Icons.messenger,
//                                                       color: Colors.green,

//                                                       // : Colors.purple[200] ,
//                                                       size: 30,
//                                                     )
//                                                   : Icon(
//                                                       Icons.messenger,
//                                                       color: objMensaMob.documentoLido == null
//                                                           ? null
//                                                           : Colors.grey,
//                                                       size: 30,
//                                                     ),
//                                             ),
//                                             Expanded(
//                                               flex: 5,
//                                               child: Padding(
//                                                 padding:
//                                                     const EdgeInsets.fromLTRB(
//                                                         0, 0, 120, 0),
//                                                 child: Text(
//                                                   objMensaMob.titulo,
//                                                   overflow:
//                                                       TextOverflow.ellipsis,
//                                                   style: TextStyle(
//                                                     fontWeight:
//                                                     objMensaMob.documentoLido == null
//                                                             ? FontWeight.bold
//                                                             : FontWeight.normal,
//                                                     color: objMensaMob.documentoLido == null
//                                                         ? null
//                                                         : Colors.grey,
//                                                     fontSize: 15,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                             Expanded(
//                                               flex: 2,
//                                               child: Text(
//                                                 objMensaMob.dataCriacao ==   DateFormat('dd/MM/yy').format(DateTime.now()).toString() ? objMensaMob.horaCriacao : objMensaMob.dataCriacao, //dias
//                                                 style: TextStyle(
//                                                   fontWeight:
//                                                   objMensaMob.documentoLido == null
//                                                       ? FontWeight.bold
//                                                       : FontWeight.normal,
//                                                   color: objMensaMob.documentoLido == null
//                                                       ? null
//                                                       : Colors.grey,
//                                                   fontSize: 12,
//                                                 ),
//                                               ),
//                                             ),
//                                             objMensaMob == null
//                                                 ? Container()
//                                                 : Expanded(
//                                               flex: 1,
//                                               child: objMensaMob.requerCiencia == true && objMensaMob.documentoLido == null //pendente == isFalse
//                                                   ? Icon(Icons.drive_file_rename_outline,
//                                                 color: Colors.orange[200],
//                                                 size: 30,
//                                               )
//                                                   : objMensaMob.requerCiencia == true && objMensaMob.documentoLido != null ? Icon(Icons.check_circle_sharp,
//                                                 color: Colors.green,
//                                                 size: 30,
//                                               ): Icon(null) ,
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               )),
//                         ),
//                         SizedBox(height: 10),
//                       ],
//                     ),

//                     //   actionPane: SlidableDrawerActionPane(),
//                   );
//                 },
//               ),
//       ),
//       //
//       floatingActionButton: (controller.isSelecting)
//           ? Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 //1
//                 IconButton(
//                   icon: Icon(
//                     Icons.design_services_rounded,
//                     color: AppColors.darkRed,
//                     size: 30,
//                   ),
//                   onPressed: undoSelect,
//                 ),
//                 //2
//                 // IconButton(
//                 //   icon: Icon(
//                 //     Icons.edit,
//                 //     color: AppColors.darkRed,
//                 //     size: 30,
//                 //   ),
//                 //   onPressed: edit,
//                 // ),
//                 // //3
//                 // IconButton(
//                 //   icon: Icon(
//                 //     Icons.delete,
//                 //     color: AppColors.darkRed,
//                 //     size: 30,
//                 //   ),
//                 //   onPressed: delete,
//                 // ),
//               ],
//             )
//           : null,
//     );
//   }

//   //WEB
  Widget _ListaDocNovosWeb() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
//
    final txtAppBarTitle = (controller.isSelecting)
        ? Text('Selecionado(s) ${controller.selectedIndexes.length}  ')
        : Text(
            "DOCUMENTOS NOVOS",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
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
        title: txtAppBarTitle,
        actions: [
          // btnAddMensa,
          // btnRefresh,
        ],
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
                itemBuilder: (BuildContext context, int index) =>
                    MultiSelectItem(
                      isSelecting: controller.isSelecting,
                      onSelected: () {
                        setState(() {
                          controller.toggle(index);
                        });
                      },
                      child: Column(
                        children: [
                          //acao click!
                          GestureDetector(
                            onTap: () {
                              _visualizaDocWeb(listaFinal[index], index);
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
                                          // Expanded(
                                          //   flex: 2,
                                          //   child: Text(
                                          //     listaFinal[index].dataCriacao ==   DateFormat('dd/MM/yy').format(DateTime.now()).toString() ? listaFinal[index].horaCriacao : listaFinal[index].dataCriacao, //dias
                                          //     style: TextStyle(
                                          //       fontWeight:
                                          //       listaFinal[index].documentoLido == null
                                          //           ? FontWeight.bold
                                          //           : FontWeight.normal,
                                          //       color: listaFinal[index].documentoLido == null
                                          //           ? null
                                          //           : Colors.grey,
                                          //       fontSize: 12,
                                          //     ),
                                          //   ),
                                          // ),
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
                      ),
                      // child: Card(
                      //   color: controller.isSelected(index)
                      //       ? AppColors.black
                      //       : AppColors.white,
                      //   child: ListTile(
                      //     //acao do click
                      //     onTap: () {
                      //       _visualizaDocWeb(objMensaWeb, index);
                      //     },
                      //     leading: objMensaWeb.lido == false
                      //         ? Icon(
                      //             Icons.messenger,
                      //             color: Colors.green,
                      //             size: 30,
                      //           )
                      //         : Icon(
                      //             Icons.messenger,
                      //             color: objMensaWeb.lido == false
                      //                 ? null
                      //                 : Colors.grey,
                      //             size: 30,
                      //           ),
                      //     title: Row(
                      //       // mainAxisAlignment: MainAxisAlignment.start,
                      //       children: [
                      //         Flexible(
                      //           flex: 1,
                      //           child: Text(
                      //             objMensaWeb.titulo,
                      //             overflow: TextOverflow.clip,
                      //             style: TextStyle(
                      //               fontWeight: objMensaWeb.lido == false
                      //                   ? FontWeight.bold
                      //                   : FontWeight.normal,
                      //               color: objMensaWeb.lido == false
                      //                   ? null
                      //                   : Colors.grey,
                      //               fontSize: 15,
                      //             ),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //     trailing: Text(
                      //       objMensaWeb.data.split(' ').first ==
                      //               periodoAtualGeral.toString() //true == horas
                      //           ? objMensaWeb.data
                      //               .split(' ')
                      //               .last
                      //               .substring(0, 5) //horas
                      //           : objMensaWeb.data.split(' ').first, //dias
                      //       style: TextStyle(
                      //         fontWeight: objMensaWeb.lido == false
                      //             ? FontWeight.bold
                      //             : FontWeight.normal,
                      //         color:
                      //             objMensaWeb.lido == false ? null : Colors.grey,
                      //         fontSize: 12,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    )),
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
                //   onPressed: editWeb,
                // ),
                //3
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
  //void acaoClick(TtRetorno2 obj) {
  //
  //  abrirMensa(obj);
  //
  // setState(() {
  //   // refreshAction();
  // });
  //}

  // void edit() {
  //   var list = controller.selectedIndexes;
  //   list.sort((b, a) =>
  //       a.compareTo(b)); //reoder from biggest number, so it wont error
  //   list.forEach((element) {
  //     TtRetorno2 objMensa = listaFinal[element];
  //     editarMensa(objMensa);
  //   });
  // }

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

  // abrirMensa(objAbrirMensa) {
  // setState(() {
  //  _listaMensaBloc.actionOpenMsg(context, objAbrirMensa, true, listaFinal);
  // });
  // refreshAction();
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
  ///[WEB]
  void editWeb() {
    var list = controller.selectedIndexes;
    list.sort((b, a) =>
        a.compareTo(b)); //reoder from biggest number, so it wont error
    list.forEach((element) {
      setState(() {
        origemClick = "editMensa";
        _openEndDrawer(element);
      });
    });
  }

  void _visualizaDocWeb(objMensa, pageIndex) {
    setState(() {
      origemClick = "viewDoc";
      objMensaEndDrawer = objMensa;
      _openEndDrawer(pageIndex);
    });
  }

  //METODOS COMPARTILHADOS
  Future<int> _openEndDrawer(i) async {
    indexPage = i;
    _scaffoldKeyListaDocNovos.currentState.openEndDrawer();
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
