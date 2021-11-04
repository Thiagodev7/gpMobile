import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/conditional_switch.dart';

import 'package:gpmobile/src/pages/contraCheque/bloc/ContraChequeBloc.dart';
import 'package:gpmobile/src/pages/contraCheque/model/ContraChequeModel.dart';
import 'dart:math' as math;

import 'package:expandable/expandable.dart';
import 'package:gpmobile/src/pages/ponto/bloc/PontoBloc.dart';
import 'package:gpmobile/src/pages/ponto/page/PontoWidget.dart';
import 'package:gpmobile/src/util/AlertDialogTemplate.dart';
import 'package:gpmobile/src/util/AtualizarPorTimer.dart';
import 'package:gpmobile/src/util/BuscaUrl.dart';
import 'package:gpmobile/src/util/Estilo.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_io/io.dart';
import 'package:url_launcher/url_launcher.dart';

class ContraChequeWidget extends StatefulWidget {
  @override
  _ContraChequeWidgetState createState() => _ContraChequeWidgetState();
}

class _ContraChequeWidgetState extends State<ContraChequeWidget> {
  String appBarTitleHolerite = "Contra-Cheque";
  // ignore: deprecated_member_use
  List<TtMov2> _liquidoPagar = new List();

  // ignore: deprecated_member_use
  List<TtMov2> _eventosPositivos = new List();

  // ignore: deprecated_member_use
  List<TtMov2> _eventosNegativos = new List();

  // ignore: deprecated_member_use
  List<TtMov2> _eventosOutros = new List();

  final GlobalKey<ScaffoldState> _scaffoldKeyContraChequeWidget =
      GlobalKey<ScaffoldState>();
  final _atualizaPorTempo = AtualizarPorTimer(milisegundos: 500);
  ContraChequeModel _movtoContraCheque = new ContraChequeModel();
  dynamic totalPositivo = 0.0;
  dynamic totalNegativo = 0.0;
  String retPeriodo;
  //
  int indexPage;
  int count = 0;
  int pageUp = 0;
  String origemClick = "";
  Random random = Random();

  String cmes = DateTime.now().day >= 25
      ? new DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .month
          .toString()
          .padLeft(2, '0')
      : new DateTime(
              DateTime.now().year, DateTime.now().month - 1, DateTime.now().day)
          .month
          .toString()
          .padLeft(2, '0');

  String cano = DateTime.now().day >= 25
      ? new DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .year
          .toString()
      : new DateTime(
              DateTime.now().year, DateTime.now().month - 1, DateTime.now().day)
          .year
          .toString();
  //initState
  @override
  void initState() {
    super.initState();
    _atualizaPorTempo.run(() {
      //se ponto != assinado ? PontoWidget : ContraChequeBloc
      PontoBloc().blocPontoAssinar(context, cmes, cano, 0).then((map2) async {
        if (map2 != null && map2.response.plogAssinado == 0) {
          AlertDialogTemplate()
              .showAlertDialogAssPonto(context, "Atenção", "Ponto",
                  " nao assinado !\nFavor assinar ponto para liberar seu contra-cheque!")
              .then((map) async {
            if (map == ConfirmAction.OK) {
              setState(() {
                // pageUp = random.nextInt(100);
                origemClick = "viewPonto";
                openEndDrawer();
              });
            }
          });
        } else {
          await new ContraChequeBloc()
              .getContraChequePeriodo(context, cmes, cano, true)
              .then((map) {
            setState(() {
              _movtoContraCheque = map;

              for (var ttMov2 in _movtoContraCheque.response.ttMov.ttMov2) {
                if (ttMov2.sinal == 1) {
                  _eventosPositivos.add(ttMov2);
                  totalPositivo = totalPositivo + ttMov2.valor;
                } else if (ttMov2.sinal == 2) {
                  _eventosNegativos.add(ttMov2);
                  totalNegativo = totalNegativo + (ttMov2.valor * (-1));
                } else if (ttMov2.evento == "531") {
                  _eventosOutros.add(ttMov2);
                } else if (ttMov2.evento == "900") {
                  _liquidoPagar.add(ttMov2);
                }
              }
            });
          });
        }
      });
    });
  }

  @override
  void dispose() {
    // _scaffoldKeyContraChequeWidget.currentState.dispose();
    super.dispose();
  }

/////////////////////////////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKeyContraChequeWidget,
      backgroundColor: Colors.transparent.withOpacity(0.3),
      body: Container(
        // decoration: AppGradients.gradient,
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (Platform.isAndroid || Platform.isIOS) {
              return contraChequeWidgetMobile();
            } else {
              return contraChequeWidgetWeb();
            }
          },
        ),
      ),
      // endDrawer: new PontoWidget(cmes, cano),
      endDrawer: ConditionalSwitch.single<String>(
          context: context,
          valueBuilder: (BuildContext context) => origemClick,
          caseBuilders: {
            'viewPonto': (BuildContext context) => new PontoWidget(cmes, cano),
          },
          fallbackBuilder: (BuildContext context) {
            return Card(
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: closeEndDrawer,
                    icon: Icon(Icons.close, size: 40, color: Colors.red),
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

//WIDGETS
  Widget appBar(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.transparent,
        leading: BackButton(),
        elevation: 0,
        title: Text(
          appBarTitleHolerite,
          style: TextStyle(color: new Estilo().textCor),
        ),
        centerTitle: true,
        actions: [
          Row(children: [
            IconButton(
              icon: Icon(
                Icons.picture_as_pdf,
                size: 30,
              ),
              color: new Estilo().iconsCor,
              onPressed: () => AlertDialogTemplate()
                  .showAlertDialogPDF(context, "Gerar Pdf", "Confirma?")
                  .then((map) async {
                if (map == ConfirmAction.OK) {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  String empresa = prefs.getString('empresa');
                  String matricula = prefs.getString('matricula');
                  var url = await BuscaUrl().url('contraChequePDF') +
                      'matricula=' +
                      matricula +
                      '&mes=' +
                      cmes +
                      '&ano=' +
                      cano +
                      '&empresa=' +
                      empresa;

                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    AlertDialogTemplate().showAlertDialogSimples(
                        context, "Alerta", 'URL não encontrada $url');
                  }
                }
              }),
            ),
          ]),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.date_range,
                  size: 30,
                ),
                color: new Estilo().iconsCor,
                splashColor: new Estilo().splashCor,
                splashRadius: 20,
                onPressed: () => AlertDialogTemplate()
                    .showAlertDialogPeriodListContraCheque(
                        context, "Selecione um Periodo", cmes, cano)
                    .then((map) async {
                  retPeriodo = map;

                  cmes = retPeriodo.substring(0, 2);
                  cano = retPeriodo.substring(3, 7);

                  //2º Se periodo != assinado ? PontoWidget : ContraChequeBloc
                  PontoBloc()
                      .blocPontoAssinar(context, cmes, cano, 0)
                      .then((map2) async {
                    if (map2 != null && map2.response.plogAssinado == 0) {
                      AlertDialogTemplate()
                          .showAlertDialogAssPonto(context, "Atenção", "Ponto",
                              " nao assinado para o periodo selecionado!\nFavor assinar ponto para liberar seu contra-cheque!")
                          .then((map) async {
                        if (map == ConfirmAction.OK) {
                          pageUp = random.nextInt(100);
                          setState(() {
                            origemClick = "viewPonto";
                            openEndDrawer();
                          });
                        }
                      });
                    } else {
                      await new ContraChequeBloc()
                          .getContraChequePeriodo(context, cmes, cano, true)
                          .then((map) {
                        setState(() {
                          _movtoContraCheque = map;
                          totalPositivo = 0.0;
                          totalNegativo = 0.0;
// ignore: deprecated_member_use
                          _liquidoPagar = new List();
                          // ignore: deprecated_member_use
                          _eventosPositivos = new List();
                          // ignore: deprecated_member_use
                          _eventosNegativos = new List();
                          // ignore: deprecated_member_use
                          _eventosOutros = new List();

                          for (var ttMov2
                              in _movtoContraCheque.response.ttMov.ttMov2) {
                            if (ttMov2.sinal == 1) {
                              _eventosPositivos.add(ttMov2);
                              totalPositivo = totalPositivo + ttMov2.valor;
                            } else if (ttMov2.sinal == 2) {
                              _eventosNegativos.add(ttMov2);
                              totalNegativo =
                                  totalNegativo + (ttMov2.valor * (-1));
                            } else if (ttMov2.evento == "531") {
                              _eventosOutros.add(ttMov2);
                            } else if (ttMov2.evento == "900") {
                              _liquidoPagar.add(ttMov2);
                            }
                          }
                        });
                      });
                    }
                  });
                }),
              ),
            ],
          ),
        ]);
  }

  Widget appBarWeb(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Text(
          appBarTitleHolerite,
          style: TextStyle(color: new Estilo().textCor),
        ),
        centerTitle: true,
        actions: [
          Row(children: [
            IconButton(
              icon: Icon(
                Icons.picture_as_pdf,
                size: 30,
              ),
              color: new Estilo().iconsCor,
              onPressed: () => AlertDialogTemplate()
                  .showAlertDialogPDF(context, "Gerar Pdf", "Confirma?")
                  .then((map) async {
                if (map == ConfirmAction.OK) {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  String empresa = prefs.getString('empresa');
                  String matricula = prefs.getString('matricula');
                  var url = await BuscaUrl().url('contraChequePDF') +
                      'matricula=' +
                      matricula +
                      '&mes=' +
                      cmes +
                      '&ano=' +
                      cano +
                      '&empresa=' +
                      empresa;

                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    AlertDialogTemplate().showAlertDialogSimples(
                        context, "Alerta", 'URL não encontrada $url');
                  }
                }
              }),
            ),
          ]),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.date_range,
                  size: 30,
                ),
                color: new Estilo().iconsCor,
                splashColor: new Estilo().splashCor,
                splashRadius: 20,
                onPressed: () => AlertDialogTemplate()
                    .showAlertDialogPeriodListContraCheque(
                        context, "Selecione um Periodo", cmes, cano)
                    .then((map) async {
                  retPeriodo = map;

                  cmes = retPeriodo.substring(0, 2);
                  cano = retPeriodo.substring(3, 7);

                  //2º Se periodo != assinado ? PontoWidget : ContraChequeBloc
                  PontoBloc()
                      .blocPontoAssinar(context, cmes, cano, 0)
                      .then((map2) async {
                    if (map2 != null && map2.response.plogAssinado == 0) {
                      AlertDialogTemplate()
                          .showAlertDialogAssPonto(context, "Atenção", "Ponto",
                              " nao assinado para o periodo selecionado!\nFavor assinar ponto para liberar seu contra-cheque!")
                          .then((map) async {
                        if (map == ConfirmAction.OK) {
                          pageUp = random.nextInt(100);
                          setState(() {
                            origemClick = "viewPonto";
                            openEndDrawer();
                          });
                        }
                      });
                    } else {
                      await new ContraChequeBloc()
                          .getContraChequePeriodo(context, cmes, cano, true)
                          .then((map) {
                        setState(() {
                          _movtoContraCheque = map;
                          totalPositivo = 0.0;
                          totalNegativo = 0.0;
// ignore: deprecated_member_use
                          _liquidoPagar = new List();
                          // ignore: deprecated_member_use
                          _eventosPositivos = new List();
                          // ignore: deprecated_member_use
                          _eventosNegativos = new List();
                          // ignore: deprecated_member_use
                          _eventosOutros = new List();

                          for (var ttMov2
                              in _movtoContraCheque.response.ttMov.ttMov2) {
                            if (ttMov2.sinal == 1) {
                              _eventosPositivos.add(ttMov2);
                              totalPositivo = totalPositivo + ttMov2.valor;
                            } else if (ttMov2.sinal == 2) {
                              _eventosNegativos.add(ttMov2);
                              totalNegativo =
                                  totalNegativo + (ttMov2.valor * (-1));
                            } else if (ttMov2.evento == "531") {
                              _eventosOutros.add(ttMov2);
                            } else if (ttMov2.evento == "900") {
                              _liquidoPagar.add(ttMov2);
                            }
                          }
                        });
                      });
                    }
                  });
                }),
              ),
            ],
          ),
        ]);
  }

  Widget contraChequeWidgetMobile() {
    return Container(
      decoration: AppGradients.gradient,
      child: Scaffold(
        backgroundColor: Estilo().backgroundContraCheque,
        appBar: appBar(context),
        body: ExpandableTheme(
          data: const ExpandableThemeData(
            useInkWell: true,
          ),
          child: ListView(
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            children: <Widget>[
              Panel(_liquidoPagar, cmes, cano),
              Card1(_eventosPositivos, totalPositivo),
              Card2(_eventosNegativos, totalNegativo),
              Card3(_eventosOutros),
            ],
          ),
        ),
      ),
    );
  }
///////////////////////////////////////////////////

  Widget contraChequeWidgetWeb() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: appBarWeb(context),
      body: Center(
        child: Container(
          // decoration: AppGradients.gradient,
          color: Colors.transparent,
          width: 800,
          child: ExpandableTheme(
            data: const ExpandableThemeData(
              useInkWell: true,
            ),
            child: ListView(
              physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              children: <Widget>[
                Panel(_liquidoPagar, cmes, cano),
                Card1(_eventosPositivos, totalPositivo),
                Card2(_eventosNegativos, totalNegativo),
                Card3(_eventosOutros),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void openEndDrawer() {
    // indexPage = i;
    _scaffoldKeyContraChequeWidget.currentState.openEndDrawer();
  }

  ///*[metodos]
  void closeEndDrawer() {
    setState(() {
      count = count - 1;
      Navigator.of(context).pop();
    });
  }
}

////////////////////////////////class//////////////////////////////////////

// ignore: must_be_immutable
class Panel extends StatelessWidget {
  // ignore: deprecated_member_use
  List<TtMov2> _liquidoPagar2 = new List();
  var f = new NumberFormat("###,###.00#", "pt_BR");
  String _vLiquido = "R\$ 0,00";
  String ano2;
  String mes2;
  String nomePeriodo;

  Panel(List<TtMov2> _liquidoPagar, String mes, String ano) {
    _liquidoPagar2 = _liquidoPagar;
    ano2 = ano;

    switch (mes) {
      case "01":
        nomePeriodo = "Janeiro";
        break;
      case "02":
        nomePeriodo = "Fevereiro";
        break;
      case "03":
        nomePeriodo = "Marco";
        break;
      case "04":
        nomePeriodo = "Abril";
        break;
      case "05":
        nomePeriodo = "Maio";
        break;
      case "06":
        nomePeriodo = "Junho";
        break;
      case "07":
        nomePeriodo = "Julho";
        break;
      case "08":
        nomePeriodo = "Agosto";
        break;
      case "09":
        nomePeriodo = "Setembro";
        break;
      case "10":
        nomePeriodo = "Outubro";
        break;
      case "11":
        nomePeriodo = "Novembro";
        break;
      case "12":
        nomePeriodo = "Dezembro";
        break;
      default:
        nomePeriodo = "Contra-cheque indisponivel!";
        break;
    }

    if (ano2 != "") {
      nomePeriodo = nomePeriodo + "/" + ano2;
    } else {
      print(nomePeriodo);
    }

    for (var evLiquido in _liquidoPagar2) {
      _vLiquido = "R\$ " + f.format(evLiquido.valor).toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      alignment: Alignment.center,
      constraints: new BoxConstraints.expand(
        height: 150.0,
      ),
      decoration: new BoxDecoration(
        // color: Estilo().ref,
        color: Colors.transparent,
      ),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
                child: Card(
                  color: new ThemeHolerite().primaColor,
                  elevation: 10,
                  child: Container(
                    // decoration: AppGradients.gradient,
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: Text(
                      "REF.: " + nomePeriodo,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: new ThemeHolerite().titleColorBlack,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
            child: Text(
              _vLiquido,
              style: TextStyle(
                color: new Estilo().textCor,
                fontSize: 35.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Text(
              'Salário Líquido',
              style: TextStyle(
                  color: new Estilo().textCor,
                  fontSize: 19.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
// ignore: must_be_immutable
class Card1 extends StatelessWidget {
  // ignore: deprecated_member_use
  List<TtMov2> _eventosPositivos2 = new List();
  var f1 = new NumberFormat('###,##0.00#', 'pt_BR');
  dynamic totalPositivo1 = 0.0;

  Card1(List<TtMov2> _eventosPositivos, dynamic totalPositivo) {
    _eventosPositivos2 = _eventosPositivos;
    totalPositivo1 = totalPositivo;
  }

  @override
  Widget build(BuildContext context) {
    buildItem(String codEvento, String descEvento, String valEvento) {
      return Padding(
          padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(child: Text(codEvento)),
                SizedBox(width: 10),
                Expanded(
                    child: Text(descEvento, overflow: TextOverflow.ellipsis)),
                Container(
                    child: Text(valEvento,
                        style: TextStyle(
                          fontSize: 15.0,
                          // color: Colors.green[500],
                          color: new Estilo().eventPositiv,
                          fontWeight: FontWeight.w400,
                        ))),
              ]));
    }

    buildList() {
      return Column(
        children: <Widget>[
          for (var i in _eventosPositivos2)
            buildItem(i.evento, i.descEvento, f1.format(i.valor).toString()),
        ],
      );
    }

    return ExpandableNotifier(
        child: Padding(
      padding: const EdgeInsets.all(10),
      child: ScrollOnExpand(
        child: Card(
          color: new ThemeHolerite().primaColor,
          elevation: new Estilo().isElevation(),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: <Widget>[
              new ExpandablePanel(
                collapsed: Container(),
                theme: const ExpandableThemeData(
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToExpand: true,
                  tapBodyToCollapse: true,
                  hasIcon: false,
                ),
                header: Container(
                  // color: new ThemeHolerite().primaColor,
                  // decoration: AppGradients.gradient,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        ExpandableIcon(
                          theme: const ExpandableThemeData(
                            expandIcon: Icons.arrow_right,
                            collapseIcon: Icons.arrow_drop_down,
                            iconColor: Colors.black,
                            iconSize: 28.0,
                            iconRotationAngle: math.pi / 2,
                            iconPadding: EdgeInsets.only(right: 5),
                            hasIcon: false,
                          ),
                        ),
                        Expanded(
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Eventos Positivos",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color:
                                          new ThemeHolerite().titleColorBlack,
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    "R\$ " +
                                        f1.format(totalPositivo1).toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        // ignore: deprecated_member_use
                                        .bodyText1
                                        .copyWith(
                                          fontSize: 18,
                                          color:
                                              new ThemeHolerite().valorPositivo,
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // expanded: null,
                expanded: Container(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                    child: buildList()),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

////////////////////////////////////////////////////////////////////////////////
///// ignore: must_be_immutable
class Card2 extends StatelessWidget {
  // ignore: deprecated_member_use
  List<TtMov2> _eventosNegativos2 = new List();
  var f2 = new NumberFormat('###,##0.00#', 'pt_BR');
  dynamic totalNegativo1 = 0.0;

  Card2(List<TtMov2> _eventosNegativos, dynamic totalNegativo) {
    _eventosNegativos2 = _eventosNegativos;
    totalNegativo1 = totalNegativo;
  }

  @override
  Widget build(BuildContext context) {
    buildItem(String codEvento, String descEvento, String valEvento) {
      return Padding(
          padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(child: Text(codEvento)),
                SizedBox(width: 10),
                Expanded(
                    child: Text(descEvento, overflow: TextOverflow.ellipsis)),
                Container(
                    child: Text(valEvento,
                        style: TextStyle(
                          fontSize: 15.0,
                          color: new Estilo().eventNegativ,
                          fontWeight: FontWeight.w400,
                        ))),
              ]));
    }

    buildList() {
      return Column(
        children: <Widget>[
          for (var i in _eventosNegativos2)
            buildItem(
                i.evento, i.descEvento, f2.format(i.valor * -1).toString()),
        ],
      );
    }

    return ExpandableNotifier(
        child: Padding(
      padding: const EdgeInsets.all(10),
      child: ScrollOnExpand(
        child: Card(
          color: new ThemeHolerite().primaColor,
          elevation: new Estilo().isElevation(),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: <Widget>[
              ExpandablePanel(
                theme: const ExpandableThemeData(
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToExpand: true,
                  tapBodyToCollapse: true,
                  hasIcon: false,
                ),
                header: Container(
                  // decoration: AppGradients.gradient,
                  // color: new Estilo().expandButtonCor,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        ExpandableIcon(
                          theme: const ExpandableThemeData(
                            expandIcon: Icons.arrow_right,
                            collapseIcon: Icons.arrow_drop_down,
                            iconColor: Colors.black,
                            iconSize: 28.0,
                            iconRotationAngle: math.pi / 2,
                            iconPadding: EdgeInsets.only(right: 5),
                            hasIcon: false,
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Eventos Negativos",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color:
                                          new ThemeHolerite().titleColorBlack,
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    "R\$ " +
                                        f2.format(totalNegativo1).toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        // ignore: deprecated_member_use
                                        .bodyText1
                                        .copyWith(
                                          fontSize: 18,
                                          color:
                                              new ThemeHolerite().valorNegativo,
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                expanded: Container(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                  child: buildList(),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

////////////////////////////////////////////////////////////////////////////////

// ignore: must_be_immutable
class Card3 extends StatelessWidget {
  // ignore: deprecated_member_use
  List<TtMov2> _eventosOutros2 = new List();
  var f3 = new NumberFormat('###,##0.00#', 'pt_BR');

  Card3(List<TtMov2> _eventosOutros) {
    _eventosOutros2 = _eventosOutros;
  }

  @override
  Widget build(BuildContext context) {
    buildItem(String codEvento, String descEvento, String valEvento) {
      return Padding(
          padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(child: Text(codEvento)),
                SizedBox(width: 10),
                Expanded(
                    child: Text(descEvento, overflow: TextOverflow.ellipsis)),
                Container(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    alignment: Alignment.centerRight,
                    child: Text(valEvento,
                        style: TextStyle(
                          fontSize: 15.0,
                          color: new Estilo().eventOutros,
                          fontWeight: FontWeight.w400,
                        ))),
              ]));
    }

    buildList() {
      return Column(
        children: <Widget>[
          for (var i in _eventosOutros2)
            buildItem(i.evento, i.descEvento, f3.format(i.valor).toString()),
        ],
      );
    }

    return ExpandableNotifier(
        child: Padding(
      padding: const EdgeInsets.all(10),
      child: ScrollOnExpand(
        child: Card(
          color: new ThemeHolerite().primaColor,
          elevation: new Estilo().isElevation(),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: <Widget>[
              ExpandablePanel(
                theme: const ExpandableThemeData(
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToExpand: true,
                  tapBodyToCollapse: true,
                  hasIcon: false,
                ),
                header: Container(
                  // decoration: Colors.transparent,
                  // decoration: AppGradients.gradient,
                  // color: new Estilo().expandButtonCor,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(children: [
                      ExpandableIcon(
                        theme: const ExpandableThemeData(
                          expandIcon: Icons.arrow_right,
                          collapseIcon: Icons.arrow_drop_down,
                          iconColor: Colors.black,
                          iconSize: 28.0,
                          iconRotationAngle: math.pi / 2,
                          iconPadding: EdgeInsets.only(right: 5),
                          hasIcon: false,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Row(
                            children: [
                              Text(
                                "Outros",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: new ThemeHolerite().titleColorBlack,
                                ),
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          100, 10, 0, 0),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ]),
                  ),
                ),
                expanded: buildList(),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
