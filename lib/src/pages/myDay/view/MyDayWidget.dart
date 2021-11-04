//Filtro: https://www.youtube.com/watch?v=-EUsRa2G1zk
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:gpmobile/src/pages/myDay/model/MyDayModel.dart';
import 'package:gpmobile/src/util/Estilo.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:simple_search_bar/simple_search_bar.dart';

import '../bloc/MyDayBloc.dart';

class MyDayWidget extends StatefulWidget {
  @override
  _MyDayWidgetState createState() => _MyDayWidgetState();
}

class _MyDayWidgetState extends State<MyDayWidget> {
  List<TtMeudia2> regMeuDia = []; //instancia do objeto
  final AppBarController appBarController = AppBarController();
  RefreshController _refreshController;

  // String mes = DateTime.now().month.toString();
  String obs = "true";

  MyDayModel objMyDay = new MyDayModel();
  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: false);
    // _atualizaPorTempo.run(() {

    MyDayBloc().getMyDays(context, obs, true).then((map) {
      setState(() {
        if (map != null) {
          objMyDay = map;
          regMeuDia = objMyDay.response.ttMeudia.ttMeudia2;
        }
      });
    });
    // });
  }

  @override
  void dispose() {
    super.dispose();
  }

  ///////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent.withOpacity(0.3),
      body: Container(
        // color: Colors.transparent.withOpacity(0.3),
        child: ScreenTypeLayout(
          breakpoints: ScreenBreakpoints(desktop: 899, tablet: 730, watch: 279),
          mobile: OrientationLayoutBuilder(
            portrait: (context) => myDayWidgetMobile(),
            landscape: (context) => myDayWidgetMobile(),
          ),
          tablet: myDayWidgetWeb(),
          desktop: myDayWidgetWeb(),
        ),
      ),
    );
  }

///////////////////////////////////////////////////////////////////

  Widget myDayWidgetMobile() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      decoration: AppGradients.gradient,
      child: Scaffold(
        backgroundColor: Estilo().backgroundMeuDia,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Meu Dia',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.left,
          ),
          centerTitle: true,
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: 320,
              maxWidth: 768,
            ),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: SmartRefresher(
                    header: WaterDropHeader(waterDropColor: Colors.green),
                    controller: _refreshController,
                    onRefresh: _onRefresh,
                    child: regMeuDia.isEmpty
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
                            itemCount: regMeuDia.length,
                            itemBuilder: (BuildContext ctxt, int index) {
                              //como será mostrado os dados na tela
                              final objMyDay = regMeuDia[index];
                              DateFormat f = new DateFormat('dd/MM/yyyy', 'pt');
                              Key(objMyDay.empresa);
                              return Container(
                                child: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10)),
                                    side: BorderSide(
                                      color: objMyDay.observacao == ""
                                          ? Colors.green
                                          : Colors.redAccent[100],
                                      // width: width * 0.4, //ajuste da borda do card
                                    ),
                                  ),
                                  child: Row(
                                    //um linha com 3 colunas
                                    children: [
                                      //BARRA STATUS
                                      Container(
                                        width: width * 0.02,
                                        height: height * 0.17, //card
                                        decoration: BoxDecoration(
                                          color: objMyDay.observacao == ""
                                              ? Colors.green
                                              : Colors.redAccent[100],
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(5),
                                            topLeft: Radius.circular(5),
                                          ),
                                        ),
                                      ),

                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          //COL1
                                          Container(
                                            child: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 3, 3, 3),
                                              child: Container(
                                                alignment: Alignment.center,
                                                width: 60,
                                                height: 60,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(60)),
                                                  color: Theme.of(context)
                                                      .backgroundColor,
                                                ),
                                                child: Text(
                                                  objMyDay.ano.toString(),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Estilo().textCor,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ),
                                          //COL2
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              SizedBox(
                                                height: 8,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    "Periodo Inicial: ",
                                                  ),
                                                  Container(
                                                    child: Container(
                                                      width: width * 0.24,
                                                      child:
                                                          objMyDay.periodoIni ==
                                                                  null
                                                              ? Text(
                                                                  "",
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .italic,
                                                                      color: objMyDay.observacao ==
                                                                              ""
                                                                          ? Colors
                                                                              .green
                                                                          : Colors
                                                                              .redAccent[100]),
                                                                )
                                                              : Text(
                                                                  f.format(
                                                                    DateTime
                                                                        .parse(
                                                                      objMyDay
                                                                          .periodoIni,
                                                                    ),
                                                                  ),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .italic,
                                                                      color: objMyDay.observacao ==
                                                                              ""
                                                                          ? Colors
                                                                              .green
                                                                          : Colors
                                                                              .redAccent[100]),
                                                                ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Text(
                                                    "Periodo Final: ",
                                                  ),
                                                  Container(
                                                      child: Container(
                                                          width: width * 0.24,
                                                          child:
                                                              objMyDay.periodoFim ==
                                                                      null
                                                                  ? Text(
                                                                      "",
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontStyle: FontStyle
                                                                              .italic,
                                                                          color: objMyDay.observacao == ""
                                                                              ? Colors.green
                                                                              : Colors.redAccent[100]),
                                                                    )
                                                                  : Text(
                                                                      // objMyDay.periodoFim,
                                                                      f.format(
                                                                        DateTime
                                                                            .parse(
                                                                          objMyDay
                                                                              .periodoFim,
                                                                        ),
                                                                      ),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontStyle: FontStyle
                                                                              .italic,
                                                                          color: objMyDay.observacao == ""
                                                                              ? Colors.green
                                                                              : Colors.redAccent[100]),
                                                                    )))
                                                ],
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Column(
                                                    children: [
                                                      Text(
                                                        "Observacao: ",
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        width: width * 0.47,
                                                        child: Text(
                                                          objMyDay.observacao,
                                                          overflow:
                                                              TextOverflow.clip,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic,
                                                              color: objMyDay
                                                                          .observacao ==
                                                                      ""
                                                                  ? Colors.green
                                                                  : Colors.redAccent[
                                                                      100]),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              // Row(
                                              //   children: <Widget>[
                                              //     Container(
                                              //         width: width * 0.45,
                                              //         height: height * 0.05,
                                              //         child: Text(
                                              //           objMyDay.observacao,
                                              //           style: TextStyle(
                                              //               fontWeight:
                                              //                   FontWeight.bold,
                                              //               fontSize: 12,
                                              //               fontStyle: FontStyle
                                              //                   .italic,
                                              //               color: objMyDay
                                              //                           .observacao ==
                                              //                       ""
                                              //                   ? Colors.green
                                              //                   : Colors.redAccent[
                                              //                       100]),
                                              //         )
                                              //     )
                                              //   ],
                                              // ),
                                              SizedBox(
                                                height: 1,
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget myDayWidgetTablet() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 320,
            maxWidth: 768,
          ),
          child: Column(
            children: <Widget>[
              Expanded(
                child: regMeuDia.isEmpty
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
                        itemCount: regMeuDia.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          //como será mostrado os dados na tela
                          final objMyDay = regMeuDia[index];
                          DateFormat f = new DateFormat('dd/MM/yyyy', 'pt');
                          Key(objMyDay.empresa);
                          return Container(
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                side: BorderSide(
                                  color: objMyDay.observacao == ""
                                      ? Colors.green
                                      : Colors.redAccent[100],
                                  // width: width * 0.4, //ajuste da borda do card
                                ),
                              ),
                              child: Row(
                                //um linha com 3 colunas
                                children: [
                                  //BARRA STATUS
                                  Container(
                                    width: width * 0.02,
                                    height: height * 0.17, //card
                                    decoration: BoxDecoration(
                                      color: objMyDay.observacao == ""
                                          ? Colors.green
                                          : Colors.redAccent[100],
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(5),
                                        topLeft: Radius.circular(5),
                                      ),
                                    ),
                                  ),

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      //COL1
                                      Container(
                                        child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 3, 3, 3),
                                          child: Container(
                                            alignment: Alignment.center,
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(60)),
                                              color: Theme.of(context)
                                                  .backgroundColor,
                                            ),
                                            child: Text(
                                              objMyDay.ano.toString(),
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Estilo().textCor,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                      //COL2
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                "Periodo Inicial: ",
                                              ),
                                              Container(
                                                child: Container(
                                                  width: width * 0.24,
                                                  child: objMyDay.periodoIni ==
                                                          null
                                                      ? Text(
                                                          "",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic,
                                                              color: objMyDay
                                                                          .observacao ==
                                                                      ""
                                                                  ? Colors.green
                                                                  : Colors.redAccent[
                                                                      100]),
                                                        )
                                                      : Text(
                                                          f.format(
                                                            DateTime.parse(
                                                              objMyDay
                                                                  .periodoIni,
                                                            ),
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic,
                                                              color: objMyDay
                                                                          .observacao ==
                                                                      ""
                                                                  ? Colors.green
                                                                  : Colors.redAccent[
                                                                      100]),
                                                        ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                "Periodo Final: ",
                                              ),
                                              Container(
                                                  child: Container(
                                                      width: width * 0.24,
                                                      child:
                                                          objMyDay.periodoFim ==
                                                                  null
                                                              ? Text(
                                                                  "",
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .italic,
                                                                      color: objMyDay.observacao ==
                                                                              ""
                                                                          ? Colors
                                                                              .green
                                                                          : Colors
                                                                              .redAccent[100]),
                                                                )
                                                              : Text(
                                                                  // objMyDay.periodoFim,
                                                                  f.format(
                                                                    DateTime
                                                                        .parse(
                                                                      objMyDay
                                                                          .periodoFim,
                                                                    ),
                                                                  ),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .italic,
                                                                      color: objMyDay.observacao ==
                                                                              ""
                                                                          ? Colors
                                                                              .green
                                                                          : Colors
                                                                              .redAccent[100]),
                                                                )))
                                            ],
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Column(
                                                children: [
                                                  Text(
                                                    "Observacao: ",
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: width * 0.47,
                                                    child: Text(
                                                      objMyDay.observacao,
                                                      overflow:
                                                          TextOverflow.clip,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12,
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          color: objMyDay
                                                                      .observacao ==
                                                                  ""
                                                              ? Colors.green
                                                              : Colors.redAccent[
                                                                  100]),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                          // Row(
                                          //   children: <Widget>[
                                          //     Container(
                                          //         width: width * 0.45,
                                          //         height: height * 0.05,
                                          //         child: Text(
                                          //           objMyDay.observacao,
                                          //           style: TextStyle(
                                          //               fontWeight:
                                          //                   FontWeight.bold,
                                          //               fontSize: 12,
                                          //               fontStyle: FontStyle
                                          //                   .italic,
                                          //               color: objMyDay
                                          //                           .observacao ==
                                          //                       ""
                                          //                   ? Colors.green
                                          //                   : Colors.redAccent[
                                          //                       100]),
                                          //         )
                                          //     )
                                          //   ],
                                          // ),
                                          SizedBox(
                                            height: 1,
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget myDayWidgetWeb() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Meu Dia',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.left,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 320,
            maxWidth: 730,
          ),
          child: Column(
            children: <Widget>[
              Expanded(
                child: regMeuDia.isEmpty
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
                        itemCount: regMeuDia.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          //como será mostrado os dados na tela
                          final objMyDay = regMeuDia[index];
                          DateFormat f = new DateFormat('dd/MM/yyyy', 'pt');
                          Key(objMyDay.empresa);
                          return Container(
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                side: BorderSide(
                                  color: objMyDay.observacao == ""
                                      ? Colors.green
                                      : Colors.redAccent[100],
                                  // width: width * 0.4, //ajuste da borda do card
                                ),
                              ),
                              child: Row(
                                //um linha com 3 colunas
                                children: [
                                  //BARRA STATUS
                                  Container(
                                    width: width * 0.02,
                                    height: height * 0.17, //card
                                    decoration: BoxDecoration(
                                      color: objMyDay.observacao == ""
                                          ? Colors.green
                                          : Colors.redAccent[100],
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(5),
                                        topLeft: Radius.circular(5),
                                      ),
                                    ),
                                  ),

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      //COL1
                                      Container(
                                        child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 3, 3, 3),
                                          child: Container(
                                            alignment: Alignment.center,
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(60)),
                                              color: Theme.of(context)
                                                  .backgroundColor,
                                            ),
                                            child: Text(
                                              objMyDay.ano.toString(),
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Estilo().textCor,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                      //COL2
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                "Periodo Inicial: ",
                                              ),
                                              Container(
                                                child: Container(
                                                  width: width * 0.24,
                                                  child: objMyDay.periodoIni ==
                                                          null
                                                      ? Text(
                                                          "",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic,
                                                              color: objMyDay
                                                                          .observacao ==
                                                                      ""
                                                                  ? Colors.green
                                                                  : Colors.redAccent[
                                                                      100]),
                                                        )
                                                      : Text(
                                                          f.format(
                                                            DateTime.parse(
                                                              objMyDay
                                                                  .periodoIni,
                                                            ),
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic,
                                                              color: objMyDay
                                                                          .observacao ==
                                                                      ""
                                                                  ? Colors.green
                                                                  : Colors.redAccent[
                                                                      100]),
                                                        ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                "Periodo Final: ",
                                              ),
                                              Container(
                                                  child: Container(
                                                      width: width * 0.24,
                                                      child:
                                                          objMyDay.periodoFim ==
                                                                  null
                                                              ? Text(
                                                                  "",
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .italic,
                                                                      color: objMyDay.observacao ==
                                                                              ""
                                                                          ? Colors
                                                                              .green
                                                                          : Colors
                                                                              .redAccent[100]),
                                                                )
                                                              : Text(
                                                                  // objMyDay.periodoFim,
                                                                  f.format(
                                                                    DateTime
                                                                        .parse(
                                                                      objMyDay
                                                                          .periodoFim,
                                                                    ),
                                                                  ),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .italic,
                                                                      color: objMyDay.observacao ==
                                                                              ""
                                                                          ? Colors
                                                                              .green
                                                                          : Colors
                                                                              .redAccent[100]),
                                                                )))
                                            ],
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Column(
                                                children: [
                                                  Text(
                                                    "Observacao: ",
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: width * 0.24,
                                                    child: Text(
                                                      objMyDay.observacao,
                                                      overflow:
                                                          TextOverflow.clip,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12,
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          color: objMyDay
                                                                      .observacao ==
                                                                  ""
                                                              ? Colors.green
                                                              : Colors.redAccent[
                                                                  100]),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 1,
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _onRefresh() {
    // monitor network fetch
    refreshAction();
    print('atualizando Box');
    // if failed,use refreshFailed()
    Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  void refreshAction() {
    regMeuDia = [];
    MyDayBloc().getMyDays(context, obs, true).then((map) {
      setState(() {
        if (map != null) {
          objMyDay = map;
          regMeuDia = objMyDay.response.ttMeudia.ttMeudia2;
        }
      });
    });
  }
}
