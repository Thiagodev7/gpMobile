import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gpmobile/src/util/AtualizarPorTimer.dart';
import 'package:gpmobile/src/util/Estilo.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../bloc/FeriasBloc.dart';
import '../model/FeriasModel.dart';

//Filtro: https://www.youtube.com/watch?v=-EUsRa2G1zk
//https://medium.com/flutter-community/a-guide-to-using-screensize-in-flutter-a-more-readable-approach-901e82556195

class FeriasWidget extends StatefulWidget {
  @override
  _FeriasWidgetState createState() => _FeriasWidgetState();
}

class _FeriasWidgetState extends State<FeriasWidget> {
  List<TtFerias2> listFerias = List();
  final _atualizaPorTempo = AtualizarPorTimer(milisegundos: 500);
  FeriasModel objFerias = new FeriasModel();
  @override
  void initState() {
    super.initState();
    _atualizaPorTempo.run(() {
      FeriasBloc().getFerias(context, true).then((map) {
        setState(() {
          objFerias = map;
          listFerias = objFerias.response.ttFerias.ttFerias2;
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  //PRINCIPAL
  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.width;
    // final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent.withOpacity(0.3),
      body: Container(
        color: Colors.transparent,
        // decoration: AppGradients.gradient,
        child: ScreenTypeLayout(
          breakpoints:
              ScreenBreakpoints(desktop: 1200, tablet: 650, watch: 280),
          mobile: OrientationLayoutBuilder(
            portrait: (context) => listFeriasMobile(),
          ),
          tablet: listFeriasWeb(),
          desktop: listFeriasWeb(),
        ),
      ),
    );
  }

//MOBILE
  Widget listFeriasMobile() {
    double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.width;
    return Container(
      decoration: AppGradients.gradient,
      child: Scaffold(
        backgroundColor: Estilo().backgroundFerias,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Center(
            child: Text(
              "Férias",
            ),
          ),
        ),
        body: Center(
          child: Container(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 320,
                maxWidth: 768,
              ),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: listFerias.isEmpty
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
                            itemCount: listFerias.length,
                            itemBuilder: (BuildContext ctx, int index) {
                              //como será mostrado os dados na tela
                              final objFerias = listFerias[index];
                              Key(objFerias.concessaoI.toString());

                              return Column(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: Card(
                                      // color: Estilo().fillColor,
                                      elevation: 15,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10)),
                                        side: BorderSide(
                                          color: objFerias.executadas == true
                                              ? Colors.grey
                                              : Colors.green,
                                        ),
                                      ),
                                      child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 10, 0, 10),
                                        child: Row(
                                          // crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            //row
                                            Expanded(
                                              flex: 0,
                                              child: Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    10, 10, 30, 10),
                                                child: Container(
                                                  // width: width * 0.30,
                                                  //   height: height * 0.13,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(5),
                                                      topLeft:
                                                          Radius.circular(5),
                                                    ),
                                                  ),
                                                  child: Container(
                                                    child: Icon(
                                                      objFerias.executadas ==
                                                              true
                                                          ? Icons
                                                              .flight_land_outlined
                                                          : Icons
                                                              .flight_takeoff,
                                                      size: 60,
                                                      color: objFerias
                                                                  .executadas ==
                                                              true
                                                          ? Colors.grey
                                                          : Colors.green,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            //
                                            Expanded(
                                              flex: 3,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  ///////////////////////////////////
                                                  Container(
                                                    width: width * 0.60,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: objFerias
                                                                      .executadas ==
                                                                  true
                                                              ? Colors.grey
                                                              : Colors.green,
                                                          width: 2.0),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          10, 5, 10, 5),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                objFerias
                                                                    .concessaoI,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: TextStyle(
                                                                    color: objFerias.executadas ==
                                                                            true
                                                                        ? Colors
                                                                            .grey
                                                                        : Colors
                                                                            .green,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                "a",
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                objFerias
                                                                    .concessaoF,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                textAlign:
                                                                    TextAlign
                                                                        .right,
                                                                style: TextStyle(
                                                                    color: objFerias.executadas ==
                                                                            true
                                                                        ? Colors
                                                                            .grey
                                                                        : Colors
                                                                            .green,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ],
                                                          ),
                                                          /////////
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  /////////////////////////////////////////
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Text(
                                                        "Dias a Gozar: ",
                                                      ),
                                                      Text(
                                                        objFerias.diasAGozar
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          color: objFerias
                                                                      .executadas ==
                                                                  true
                                                              ? Colors.grey
                                                              : Colors.green,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Text(
                                                        "Dias Abono: ",
                                                      ),
                                                      Container(
                                                          child: Container(
                                                        child: Text(
                                                          objFerias.abono
                                                              .toString(),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            fontStyle: FontStyle
                                                                .italic,
                                                            color: objFerias
                                                                        .executadas ==
                                                                    true
                                                                ? Colors.grey
                                                                : Colors.green,
                                                          ),
                                                        ),
                                                      ))
                                                    ],
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Text(
                                                        "Período Ref.: ",
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Text(
                                                        objFerias.periodoI,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          color: objFerias
                                                                      .executadas ==
                                                                  true
                                                              ? Colors.grey
                                                              : Colors.green,
                                                        ),
                                                      ),
                                                      Text(
                                                        " a ",
                                                      ),
                                                      Container(
                                                          child: Container(
                                                        // width: width * 0.50,
                                                        // height: height * 0.02,
                                                        child: Text(
                                                          objFerias.periodoF,
                                                          textAlign:
                                                              TextAlign.right,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            fontStyle: FontStyle
                                                                .italic,
                                                            color: objFerias
                                                                        .executadas ==
                                                                    true
                                                                ? Colors.grey
                                                                : Colors.green,
                                                          ),
                                                        ),
                                                      ))
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                                //                    ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

// //TABLET
//   Widget listFeriasTablet() {
//     return Center(
//       child: Container(
//         child: ConstrainedBox(
//           constraints: BoxConstraints(
//             minWidth: 320,
//             maxWidth: 768,
//             // minHeight: double.infinity,
//             // maxHeight: double.infinity,
//           ),
//           child: Column(
//             children: <Widget>[
//               // Container(
//               //   padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
//               // ),
//               Expanded(
//                 child: listFerias.isEmpty
//                     ? Center(
//                         child: Text(
//                           'Lista vazia no momento!',
//                           style: TextStyle(
//                             color: AppColors.txtSemFundo,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       )
//                     : ListView.builder(
//                         itemCount: listFerias.length,
//                         itemBuilder: (BuildContext ctx, int index) {
//                           //como será mostrado os dados na tela
//                           final objFerias = listFerias[index];
//                           Key(objFerias.concessaoI.toString());
//
//                           return Column(
//                             children: <Widget>[
//                               Padding(
//                                 padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
//                                 child: Card(
//                                   elevation: 5,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.only(
//                                         topLeft: Radius.circular(10),
//                                         topRight: Radius.circular(10),
//                                         bottomLeft: Radius.circular(10),
//                                         bottomRight: Radius.circular(10)),
//                                     side: BorderSide(
//                                       color: objFerias.executadas == true
//                                           ? Colors.grey
//                                           : Colors.green,
//                                     ),
//                                   ),
//                                   child: Padding(
//                                     padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
//                                     child: Row(
//                                       children: [
//                                         Flexible(
//                                           // fit: FlexFit.loose,
//                                           // fit: FlexFit.tight,
//                                           child: Padding(
//                                             padding: EdgeInsets.fromLTRB(
//                                                 10, 10, 30, 10),
//                                             child: Container(
//                                               //   width: width * 0.20,
//                                               //   height: height * 0.13,
//                                               decoration: BoxDecoration(
//                                                 borderRadius: BorderRadius.only(
//                                                   bottomLeft:
//                                                       Radius.circular(5),
//                                                   topLeft: Radius.circular(5),
//                                                 ),
//                                               ),
//                                               child: Container(
//                                                 child: Icon(
//                                                   Icons.flight_takeoff,
//                                                   size: 60,
//                                                   color: objFerias.executadas ==
//                                                           true
//                                                       ? Colors.grey
//                                                       : Colors.green,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         Expanded(
//                                           child: Column(
//                                             // crossAxisAlignment:
//                                             //     CrossAxisAlignment.start,
//                                             children: <Widget>[
//                                               ///////////////////////////////////
//                                               Container(
//                                                 decoration: BoxDecoration(
//                                                   border: Border.all(
//                                                       color: Estilo().ref,
//                                                       width: 1.5),
//                                                   borderRadius:
//                                                       BorderRadius.all(
//                                                           Radius.circular(20)),
//                                                   // color: Estilo().body,
//                                                 ),
//                                                 child: Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.center,
//                                                   children: [
//                                                     Text(
//                                                       objFerias.concessaoI,
//                                                       overflow:
//                                                           TextOverflow.ellipsis,
//                                                       textAlign: TextAlign.left,
//                                                       style: TextStyle(
//                                                           fontWeight:
//                                                               FontWeight.bold),
//                                                     ),
//                                                     // SizedBox(
//                                                     //   width: 5,
//                                                     // ),
//                                                     Text(
//                                                       " à ",
//                                                       style: TextStyle(
//                                                           color: Estilo().body,
//                                                           fontWeight:
//                                                               FontWeight.bold),
//                                                     ),
//                                                     // SizedBox(
//                                                     //   width: 5,
//                                                     // ),
//                                                     Text(
//                                                       objFerias.concessaoF,
//                                                       overflow:
//                                                           TextOverflow.ellipsis,
//                                                       textAlign:
//                                                           TextAlign.right,
//                                                       style: TextStyle(
//                                                           fontWeight:
//                                                               FontWeight.bold),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                               /////////////////////////////////////////
//                                               SizedBox(
//                                                 height: 5,
//                                               ),
//                                               Row(
//                                                 children: <Widget>[
//                                                   Text(
//                                                     "Dias a Gozar: ",
//                                                   ),
//                                                   Text(
//                                                     objFerias.diasAGozar
//                                                         .toString(),
//                                                     style: TextStyle(
//                                                         fontStyle:
//                                                             FontStyle.italic,
//                                                         color: Estilo().ref),
//                                                   ),
//                                                 ],
//                                               ),
//                                               Row(
//                                                 children: <Widget>[
//                                                   Text(
//                                                     "Dias Abono: ",
//                                                   ),
//                                                   Container(
//                                                       child: Container(
//                                                     child: Text(
//                                                       objFerias.abono
//                                                           .toString(),
//                                                       overflow:
//                                                           TextOverflow.ellipsis,
//                                                       style: TextStyle(
//                                                           fontStyle:
//                                                               FontStyle.italic,
//                                                           color: Colors
//                                                               .deepPurple),
//                                                     ),
//                                                   ))
//                                                 ],
//                                               ),
//                                               Row(
//                                                 children: <Widget>[
//                                                   Text(
//                                                     "Período Ref.: ",
//                                                   ),
//                                                 ],
//                                               ),
//                                               Row(
//                                                 children: <Widget>[
//                                                   Text(
//                                                     objFerias.periodoI,
//                                                     overflow:
//                                                         TextOverflow.ellipsis,
//                                                     style: TextStyle(
//                                                         fontStyle:
//                                                             FontStyle.italic,
//                                                         color: Estilo().ref),
//                                                   ),
//                                                   Text(
//                                                     " à ",
//                                                   ),
//                                                   Container(
//                                                       child: Container(
//                                                     // width: width * 0.50,
//                                                     // height: height * 0.02,
//                                                     child: Text(
//                                                       objFerias.periodoF,
//                                                       textAlign:
//                                                           TextAlign.right,
//                                                       overflow:
//                                                           TextOverflow.ellipsis,
//                                                       style: TextStyle(
//                                                           fontStyle:
//                                                               FontStyle.italic,
//                                                           color: Colors
//                                                               .deepPurple),
//                                                     ),
//                                                   ))
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
// //                    ),
//                           );
//                         },
//                       ),
//               ),
//               // new Padding(
//               //   padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
//               //   child: ListTile(
//               //       title: Center(
//               //         child: Text(
//               //           'VOLTAR',
//               //           style: TextStyle(
//               //             fontWeight: FontWeight.bold,
//               //             color: Estilo().ref,
//               //           ),
//               //         ),
//               //       ),
//               //       onTap: () {
//               //         // Navigator.of(context).pop(true);
//               //         Navigator.of(context).pushReplacement(
//               //                         MaterialPageRoute(
//               //                             fullscreenDialog: true,
//               //                             builder: (context) =>
//               //                                 HomeWidget()));
//               //
//               //       }),
//               // ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

  //WEB
  Widget listFeriasWeb() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        title: Center(
          child: Text(
            "Férias",
          ),
        ),
      ),
      body: Center(
        child: Container(
          // decoration: AppGradients.gradient,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: 320,
              maxWidth: 768,
              // minHeight: double.infinity,
              // maxHeight: double.infinity,
            ),
            child: Column(
              children: <Widget>[
                // Container(
                //   padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                // ),
                Expanded(
                  child: listFerias.isEmpty
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
                          itemCount: listFerias.length,
                          itemBuilder: (BuildContext ctx, int index) {
                            //como será mostrado os dados na tela
                            final objFerias = listFerias[index];
                            Key(objFerias.concessaoI.toString());

                            return Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child: Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10)),
                                      side: BorderSide(
                                        color: objFerias.executadas == true
                                            ? Colors.grey
                                            : Colors.green,
                                      ),
                                    ),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 10, 0, 10),
                                      child: Row(
                                        children: [
                                          Flexible(
                                            // fit: FlexFit.loose,
                                            // fit: FlexFit.tight,
                                            child: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 10, 30, 10),
                                              child: Container(
                                                //   width: width * 0.20,
                                                //   height: height * 0.13,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(5),
                                                    topLeft: Radius.circular(5),
                                                  ),
                                                ),
                                                child: Container(
                                                  child: Icon(
                                                    objFerias.executadas == true
                                                        ? Icons
                                                            .flight_land_outlined
                                                        : Icons.flight_takeoff,
                                                    size: 60,
                                                    color:
                                                        objFerias.executadas ==
                                                                true
                                                            ? Colors.grey
                                                            : Colors.green,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              // crossAxisAlignment:
                                              //     CrossAxisAlignment.start,
                                              children: <Widget>[
                                                ///////////////////////////////////
                                                Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: objFerias
                                                                    .executadas ==
                                                                true
                                                            ? Colors.grey
                                                            : Colors.green,
                                                        width: 1.5),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20)),
                                                    // color: Estilo().body,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        objFerias.concessaoI,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                            color: objFerias
                                                                        .executadas ==
                                                                    true
                                                                ? Colors.grey
                                                                : Colors.green,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      // SizedBox(
                                                      //   width: 5,
                                                      // ),
                                                      Text(
                                                        " à ",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      // SizedBox(
                                                      //   width: 5,
                                                      // ),
                                                      Text(
                                                        objFerias.concessaoF,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.right,
                                                        style: TextStyle(
                                                            color: objFerias
                                                                        .executadas ==
                                                                    true
                                                                ? Colors.grey
                                                                : Colors.green,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                /////////////////////////////////////////
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Text(
                                                      "Dias a Gozar: ",
                                                    ),
                                                    Text(
                                                      objFerias.diasAGozar
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        color: objFerias
                                                                    .executadas ==
                                                                true
                                                            ? Colors.grey
                                                            : Colors.green,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Text(
                                                      "Dias Abono: ",
                                                    ),
                                                    Container(
                                                        child: Container(
                                                      child: Text(
                                                        objFerias.abono
                                                            .toString(),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          color: objFerias
                                                                      .executadas ==
                                                                  true
                                                              ? Colors.grey
                                                              : Colors.green,
                                                        ),
                                                      ),
                                                    ))
                                                  ],
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Text(
                                                      "Período Ref.: ",
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Text(
                                                      objFerias.periodoI,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        color: objFerias
                                                                    .executadas ==
                                                                true
                                                            ? Colors.grey
                                                            : Colors.green,
                                                      ),
                                                    ),
                                                    Text(
                                                      " à ",
                                                    ),
                                                    Container(
                                                        child: Container(
                                                      // width: width * 0.50,
                                                      // height: height * 0.02,
                                                      child: Text(
                                                        objFerias.periodoF,
                                                        textAlign:
                                                            TextAlign.right,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          color: objFerias
                                                                      .executadas ==
                                                                  true
                                                              ? Colors.grey
                                                              : Colors.green,
                                                        ),
                                                      ),
                                                    ))
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
//                    ),
                            );
                          },
                        ),
                ),
                // new Padding(
                //   padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                //   child: ListTile(
                //       title: Center(
                //         child: Text(
                //           'VOLTAR',
                //           style: TextStyle(
                //             fontWeight: FontWeight.bold,
                //             color: Estilo().ref,
                //           ),
                //         ),
                //       ),
                //       onTap: () {
                //         // Navigator.of(context).pop(true);
                //         Navigator.of(context).pushReplacement(
                //                         MaterialPageRoute(
                //                             fullscreenDialog: true,
                //                             builder: (context) =>
                //                                 HomeWidget()));
                //
                //       }),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
