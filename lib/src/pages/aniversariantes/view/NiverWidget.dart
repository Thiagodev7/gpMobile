import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:gpmobile/src/pages/aniversariantes/model/NiverModel.dart';
import 'package:gpmobile/src/util/AtualizarPorTimer.dart';
import 'package:gpmobile/src/util/Estilo.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:simple_search_bar/simple_search_bar.dart';

import '../bloc/NiverBloc.dart';

//Filtro: https://www.youtube.com/watch?v=-EUsRa2G1zk

class NiverWidget extends StatefulWidget {
  @override
  _NiverWidgetState createState() => _NiverWidgetState();
}

class _NiverWidgetState extends State<NiverWidget> {
  // ignore: deprecated_member_use
  final AppBarController appBarController = AppBarController();
  List<TtAniversariantes2> regNiver = List(); //lista de objetos
  List<TtAniversariantes2> filterNivers = List();
  NiverModel nivers = new NiverModel();
  TextEditingController fieldFiltro = new TextEditingController();
  RefreshController _refreshController;
  String mes = DateTime.now().month.toString();
  final _controller = TextEditingController();
  final _atualizaPorTempo = AtualizarPorTimer(milisegundos: 500);
  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: false);
    _atualizaPorTempo.run(() {
      // setState(() {
      NiverBloc().getAllAniversarios(context, mes, true).then((map) {
        setState(() {
          nivers = map;
          filterNivers = nivers.response.ttAniversariantes.ttAniversariantes2;
        });
      });
      // });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  ///////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppGradients.gradient,
        child: ScreenTypeLayout(
          breakpoints:
              ScreenBreakpoints(desktop: 1200, tablet: 650, watch: 280),
          mobile: OrientationLayoutBuilder(
            portrait: (context) => listAniverWidgetMobile(),
          ),
          tablet: listAniverWidgetWeb(),
          desktop: listAniverWidgetWeb(),
        ),
      ),
    );
  }

  ///////////////////////////////////////////////////////////////////
  Widget listAniverWidgetMobile() {
    // int dropdownValue = DynamicTheme.of(context).themeId;
    double width = MediaQuery.of(context).size.width * 0.85; //alterado 20-04-21
    // double width = MediaQuery.of(context).size.width * 0.8;
    // double height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Center(
            child: Text(
              NiverBloc().getNomeMes(mes),
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.light
                    ? Color(0xB3ffffff)
                    : Color(0xB3ffffff),
              ),
            ),
          ),
          actions: [
            // IconButton(
            //   icon: Icon(
            //     Icons.autorenew,
            //     size: 30,
            //   ),
            //   color: Estilo().gray,
            //   onPressed: () {
            //     setState(() {
            //       regNiver.clear();
            //       // _controller.dispose();
            //     });
            //     NiverBloc().getAllAniversarios(context, mes, true).then((map2) {
            //       setState(() {
            //         nivers = map2;
            //         regNiver =
            //             nivers.response.ttAniversariantes.ttAniversariantes2;
            //       });
            //     });
            //   },
            // ),
          ],
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: 320,
              maxWidth: 800,
              // minHeight: double.infinity,
              // maxHeight: double.infinity,
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 10, 15),
                  child: Container(
                    child: TextField(
                        style: TextStyle(
                            // background: Paint(),
                            // backgroundColor: Theme.of(context).accentColor,
                            color: Color(0xB3ffffff),
                            fontWeight: FontWeight.bold),
                        controller: fieldFiltro,
                        cursorColor: Estilo().secon,
                        decoration: InputDecoration(
                          prefixIcon: Icon(AntDesign.search1,
                              size: 30, color: Color(0xB3ffffff)),
                          contentPadding: EdgeInsets.all(16.0),
                          hintText: "Buscar",
                          hintStyle: TextStyle(color: Color(0xB3ffffff)),
                          labelStyle: TextStyle(color: Color(0xB3ffffff)),
                          fillColor: Colors.blueGrey,
                          focusedBorder: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                            borderSide: new BorderSide(color: Estilo().secon),
                          ),
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                            borderSide: new BorderSide(color: Colors.blueGrey),
                          ),
                        ),
                        /////////////////////////filtro 1//////////////////////////
                        onChanged: (string) {
                          setState(() {
                            filterNivers = nivers
                                .response.ttAniversariantes.ttAniversariantes2
                                .where((user) => (user.nomeFuncionario
                                        .toString()
                                        .toLowerCase()
                                        .contains(string.toLowerCase()) ||
                                    user.diaNascimento
                                        .toString()
                                        .contains(string) ||
                                    user.cargo
                                        .toString()
                                        .toLowerCase()
                                        .contains(string.toLowerCase()) ||
                                    user.empresa
                                        .toString()
                                        .toLowerCase()
                                        .contains(string.toLowerCase())))
                                .toList();
                          });
                        }),
                  ),
                ),
                Expanded(
                  child: SmartRefresher(
                    header: WaterDropHeader(waterDropColor: Colors.green),
                    controller: _refreshController,
                    onRefresh: _onRefresh,
                    child: filterNivers
                            .isEmpty //se retorno null(renderiza a mensagem)
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
                            itemCount:
                                filterNivers.length, //passa o tamanho da lista
                            itemBuilder: (BuildContext ctxt, int index) {
                              //como será mostrado os dados na tela
                              var objNiver = filterNivers[
                                  index]; //variavel recebe cada indice do array(objeto)

                              return Container(
                                child: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    //um linha com varias colunas
                                    children: [
                                      Container(
                                        child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 0, 0, 0),
                                          child: Column(
                                            //ajuste da bola de aniversario
                                            children: <Widget>[
                                              Container(
                                                child: Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 3, 3, 3),
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    // width: width * 0.19,
                                                    width:
                                                        40, //manter (40)valores fixos 30-04-21
                                                    // height: height * 0.09,
                                                    height:
                                                        40, //manter (40)valores fixos 30-04-21
                                                    //color: Estilo().,
                                                    decoration: BoxDecoration(
                                                      color: Estilo().secon,
                                                      border: Border.all(
                                                          color: Estilo().secon,
                                                          width: 1.5),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  60)),
                                                      // color: Estilo().body,
                                                    ),
                                                    child: Text(
                                                      objNiver.diaNascimento
                                                          .toString(),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color:
                                                              Estilo().branca,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      // Flexible(

                                      // ),
                                      Container(
                                        //ajuste coluna de textos
                                        // width: width * 0.72,

                                        // height: height * 0.12,
                                        height: 80,
                                        child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 10, 0, 0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Container(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              0, 0, 0, 0),
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: width * 0.7,
                                                        // height: height * 0.032,
                                                        height: 19,

                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color: Estilo()
                                                                  .prima,
                                                              width: 1.5),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                          // color: Estilo().body,
                                                        ),
                                                        child: Text(
                                                          objNiver
                                                              .nomeFuncionario,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color: Estilo()
                                                                  .secon,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 6,
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Text(
                                                    "Empresa: ",
                                                  ),
                                                  Container(
                                                      child: Container(
                                                          width: width * 0.50,
                                                          child:
                                                              // filterNivers[index]
                                                              //             .empresa ==
                                                              //         null
                                                              //     ?
                                                              Text(
                                                            objNiver.empresa,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                                color: Estilo()
                                                                    .prima,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )
                                                          //     :
                                                          // Text(
                                                          //   filterNivers[index]
                                                          //       .empresa,
                                                          //         overflow: TextOverflow
                                                          //             .ellipsis,
                                                          //         style: TextStyle(
                                                          //             fontStyle:
                                                          //                 FontStyle
                                                          //                     .italic,
                                                          //             color: Colors
                                                          //                 .deepPurple),
                                                          //       ),
                                                          ))
                                                ],
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Text(
                                                    "Cargo: ",
                                                  ),
                                                  Container(
                                                      child: Container(
                                                    width: width * 0.58,
                                                    child: Text(
                                                      objNiver.cargo,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          color: Estilo().prima,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ))
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
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
        ));
  }

  Widget listAniverWidgetTablet() {
    // int dropdownValue = DynamicTheme.of(context).themeId;
    double width = MediaQuery.of(context).size.width * 0.85; //alterado 20-04-21
    // double width = MediaQuery.of(context).size.width * 0.8;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: 320,
              maxWidth: 800,
              // minHeight: double.infinity,
              // maxHeight: double.infinity,
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 10, 15),
                  child: Container(
                    child: TextField(
                        style: TextStyle(
                            // background: Paint(),
                            // backgroundColor: Theme.of(context).accentColor,
                            color: Color(0xB3ffffff),
                            fontWeight: FontWeight.bold),
                        controller: fieldFiltro,
                        cursorColor: Estilo().ref,
                        decoration: InputDecoration(
                          prefixIcon: Icon(AntDesign.search1,
                              size: 30, color: Color(0xB3ffffff)),
                          contentPadding: EdgeInsets.all(16.0),
                          hintText: "Buscar",
                          hintStyle: TextStyle(color: Color(0xB3ffffff)),
                          labelStyle: TextStyle(color: Color(0xB3ffffff)),
                          fillColor: Colors.blueGrey,
                          focusedBorder: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                            borderSide: new BorderSide(color: Estilo().ref),
                          ),
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                            borderSide: new BorderSide(color: Colors.blueGrey),
                          ),
                        ),
                        /////////////////////////filtro 1//////////////////////////
                        onChanged: (string) {
                          setState(() {
                            filterNivers = nivers
                                .response.ttAniversariantes.ttAniversariantes2
                                .where((user) => (user.nomeFuncionario
                                        .toString()
                                        .toLowerCase()
                                        .contains(string.toLowerCase()) ||
                                    user.diaNascimento
                                        .toString()
                                        .contains(string) ||
                                    user.cargo
                                        .toString()
                                        .toLowerCase()
                                        .contains(string.toLowerCase()) ||
                                    user.empresa
                                        .toString()
                                        .toLowerCase()
                                        .contains(string.toLowerCase())))
                                .toList();
                          });
                        }),
                  ),
                ),
                Expanded(
                  child: filterNivers
                          .isEmpty //se retorno null(renderiza a mensagem)
                      ? Center(
                          child: Text(
                            "Lista nao encontrada!",
                            style: TextStyle(color: Color(0xFFD6D6D6)),
                          ),
                        )
                      : Card(
                          color: Theme.of(context).backgroundColor,
                          child: ListView.builder(
                            itemCount:
                                filterNivers.length, //passa o tamanho da lista
                            itemBuilder: (BuildContext ctxt, int index) {
                              //como será mostrado os dados na tela
                              var objNiver = filterNivers[
                                  index]; //variavel recebe cada indice do array(objeto)

                              return Container(
                                child: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    //um linha com varias colunas
                                    children: [
                                      Container(
                                        child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 0, 0, 0),
                                          child: Column(
                                            //ajuste da bola de aniversario
                                            children: <Widget>[
                                              Container(
                                                child: Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 3, 3, 3),
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    // width: width * 0.19,
                                                    width:
                                                        40, //manter (40)valores fixos 30-04-21
                                                    // height: height * 0.09,
                                                    height:
                                                        40, //manter (40)valores fixos 30-04-21
                                                    //color: Estilo().,
                                                    decoration: BoxDecoration(
                                                      // color: Estilo().prima,
                                                      color: Theme.of(context)
                                                          .backgroundColor,
                                                      border: Border.all(
                                                          color: Theme.of(
                                                                  context)
                                                              .backgroundColor,
                                                          width: 1.5),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  60)),
                                                      // color: Estilo().body,
                                                    ),
                                                    child: Text(
                                                      objNiver.diaNascimento
                                                          .toString(),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color:
                                                              Estilo().branca,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      // Flexible(

                                      // ),
                                      Container(
                                        //ajuste coluna de textos
                                        // width: width * 0.72,

                                        // height: height * 0.12,
                                        height: 80,
                                        child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 10, 0, 0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Container(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              0, 0, 0, 0),
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: width * 0.5,
                                                        // height: height * 0.032,
                                                        height: 19,
                                                        //color: Estilo().,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              // color:
                                                              //     Estilo().ref,
                                                              color: Estilo()
                                                                  .linha,
                                                              width: 1.5),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                          // color: Estilo().body,
                                                        ),
                                                        child: Text(
                                                          objNiver
                                                              .nomeFuncionario,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color: Theme.of(context)
                                                                          .brightness ==
                                                                      Brightness
                                                                          .light
                                                                  ? Theme.of(
                                                                          context)
                                                                      .primaryColorDark
                                                                  : Theme.of(
                                                                          context)
                                                                      .primaryColorLight,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 6,
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Text(
                                                    "Empresa: ",
                                                  ),
                                                  Container(
                                                      child: Container(
                                                          width: width * 0.50,
                                                          child:
                                                              // filterNivers[index]
                                                              //             .empresa ==
                                                              //         null
                                                              //     ?
                                                              Text(
                                                            objNiver.empresa,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                                color: Theme.of(context)
                                                                            .brightness ==
                                                                        Brightness
                                                                            .light
                                                                    ? Theme.of(
                                                                            context)
                                                                        .primaryColorDark
                                                                    : Theme.of(
                                                                            context)
                                                                        .primaryColorLight,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )
                                                          //     :
                                                          // Text(
                                                          //   filterNivers[index]
                                                          //       .empresa,
                                                          //         overflow: TextOverflow
                                                          //             .ellipsis,
                                                          //         style: TextStyle(
                                                          //             fontStyle:
                                                          //                 FontStyle
                                                          //                     .italic,
                                                          //             color: Colors
                                                          //                 .deepPurple),
                                                          //       ),
                                                          ))
                                                ],
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Text(
                                                    "Cargo: ",
                                                  ),
                                                  Container(
                                                      child: Container(
                                                    width: width * 0.58,
                                                    child: Text(
                                                      objNiver.cargo,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          color: Theme.of(context)
                                                                      .brightness ==
                                                                  Brightness
                                                                      .light
                                                              ? Theme.of(
                                                                      context)
                                                                  .primaryColorDark
                                                              : Theme.of(
                                                                      context)
                                                                  .primaryColorLight,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ))
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
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
        ));
  }

  Widget listAniverWidgetWeb() {
    // int dropdownValue = DynamicTheme.of(context).themeId;
    double width = MediaQuery.of(context).size.width * 0.85; //alterado 20-04-21
    // double width = MediaQuery.of(context).size.width * 0.8;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          elevation: 0,
          centerTitle: true,
          title: Center(
            child: Text(
              NiverBloc().getNomeMes(mes),
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.light
                    ? Color(0xB3ffffff)
                    : Color(0xB3ffffff),
              ),
            ),
          ),
          actions: [
            // IconButton(
            //   icon: Icon(
            //     Icons.autorenew,
            //     size: 30,
            //   ),
            //   color: Estilo().gray,
            //   onPressed: () {
            //     setState(() {
            //       regNiver.clear();
            //       // _controller.dispose();
            //     });
            //     NiverBloc().getAllAniversarios(context, mes, true).then((map2) {
            //       setState(() {
            //         nivers = map2;
            //         regNiver =
            //             nivers.response.ttAniversariantes.ttAniversariantes2;
            //       });
            //     });
            //   },
            // ),
          ],
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: 320,
              maxWidth: 768,
              // minHeight: double.infinity,
              // maxHeight: double.infinity,
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 10, 15),
                  child: Container(
                    child: TextField(
                        style: TextStyle(
                            // background: Paint(),
                            // backgroundColor: Theme.of(context).accentColor,
                            color: Color(0xB3ffffff),
                            fontWeight: FontWeight.bold),
                        controller: fieldFiltro,
                        cursorColor: Estilo().secon,
                        decoration: InputDecoration(
                          prefixIcon: Icon(AntDesign.search1,
                              size: 30, color: Color(0xB3ffffff)),
                          contentPadding: EdgeInsets.all(16.0),
                          hintText: "Buscar",
                          hintStyle: TextStyle(color: Color(0xB3ffffff)),
                          labelStyle: TextStyle(color: Color(0xB3ffffff)),
                          fillColor: Colors.blueGrey,
                          focusedBorder: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                            borderSide: new BorderSide(color: Estilo().secon),
                          ),
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                            borderSide: new BorderSide(color: Colors.blueGrey),
                          ),
                        ),
                        /////////////////////////filtro 1//////////////////////////
                        onChanged: (string) {
                          setState(() {
                            filterNivers = nivers
                                .response.ttAniversariantes.ttAniversariantes2
                                .where((user) => (user.nomeFuncionario
                                        .toString()
                                        .toLowerCase()
                                        .contains(string.toLowerCase()) ||
                                    user.diaNascimento
                                        .toString()
                                        .contains(string) ||
                                    user.cargo
                                        .toString()
                                        .toLowerCase()
                                        .contains(string.toLowerCase()) ||
                                    user.empresa
                                        .toString()
                                        .toLowerCase()
                                        .contains(string.toLowerCase())))
                                .toList();
                          });
                        }),
                  ),
                ),
                Expanded(
                  child: SmartRefresher(
                    header: WaterDropHeader(waterDropColor: Colors.green),
                    controller: _refreshController,
                    onRefresh: _onRefresh,
                    child: filterNivers
                            .isEmpty //se retorno null(renderiza a mensagem)
                        ? Center(
                            child: Text(
                              "Lista nao encontrada!",
                              style: TextStyle(color: Color(0xFFD6D6D6)),
                            ),
                          )
                        : ListView.builder(
                            itemCount:
                                filterNivers.length, //passa o tamanho da lista
                            itemBuilder: (BuildContext ctxt, int index) {
                              //como será mostrado os dados na tela
                              var objNiver = filterNivers[
                                  index]; //variavel recebe cada indice do array(objeto)

                              return Container(
                                child: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    //um linha com varias colunas
                                    children: [
                                      Container(
                                        child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 0, 0, 0),
                                          child: Column(
                                            //ajuste da bola de aniversario
                                            children: <Widget>[
                                              Container(
                                                child: Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 3, 3, 3),
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    // width: width * 0.19,
                                                    width:
                                                        40, //manter (40)valores fixos 30-04-21
                                                    // height: height * 0.09,
                                                    height:
                                                        40, //manter (40)valores fixos 30-04-21
                                                    //color: Estilo().,
                                                    decoration: BoxDecoration(
                                                      color: Estilo().secon,
                                                      border: Border.all(
                                                          color: Estilo().secon,
                                                          width: 1.5),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  60)),
                                                      // color: Estilo().body,
                                                    ),
                                                    child: Text(
                                                      objNiver.diaNascimento
                                                          .toString(),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color:
                                                              Estilo().branca,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      // Flexible(

                                      // ),
                                      Expanded(
                                        child: Container(
                                          //ajuste coluna de textos
                                          width: width * 0.35,
                                          // height: height * 0.12,
                                          height: 80,
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                10, 10, 0, 0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    Container(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                0, 0, 0, 0),
                                                        child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          width: width * 0.3,
                                                          // height: height * 0.032,
                                                          height: 19,

                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                                color: Estilo()
                                                                    .prima,
                                                                width: 0.9),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10)),
                                                            // color: Estilo().body,
                                                          ),
                                                          child: Text(
                                                            objNiver
                                                                .nomeFuncionario,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                color: Estilo()
                                                                    .secon,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 6,
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Text(
                                                      "Empresa: ",
                                                    ),
                                                    Container(
                                                        child: Container(
                                                            width: width * 0.3,
                                                            child:
                                                                // filterNivers[index]
                                                                //             .empresa ==
                                                                //         null
                                                                //     ?
                                                                Text(
                                                              objNiver.empresa,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                  color: Estilo()
                                                                      .prima,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            )
                                                            //     :
                                                            // Text(
                                                            //   filterNivers[index]
                                                            //       .empresa,
                                                            //         overflow: TextOverflow
                                                            //             .ellipsis,
                                                            //         style: TextStyle(
                                                            //             fontStyle:
                                                            //                 FontStyle
                                                            //                     .italic,
                                                            //             color: Colors
                                                            //                 .deepPurple),
                                                            //       ),
                                                            ))
                                                  ],
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Text(
                                                      "Cargo: ",
                                                    ),
                                                    Container(
                                                        child: Container(
                                                      width: width * 0.1,
                                                      child: Text(
                                                        objNiver.cargo,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            fontStyle: FontStyle
                                                                .italic,
                                                            color:
                                                                Estilo().prima,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ))
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
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
        ));
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
    setState(() {
      regNiver.clear();
    });
    NiverBloc().getAllAniversarios(context, mes, true).then((map2) {
      setState(() {
        nivers = map2;
        regNiver = nivers.response.ttAniversariantes.ttAniversariantes2;
      });
    });
  }
}
