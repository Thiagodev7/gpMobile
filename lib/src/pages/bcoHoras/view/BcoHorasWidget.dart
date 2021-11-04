import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:gpmobile/src/pages/bcoHoras/bloc/BcoHorasBloc.dart';
import 'package:gpmobile/src/util/Estilo.dart';
import 'package:responsive_builder/responsive_builder.dart';

class BcoHorasWidget extends StatefulWidget {
  @override
  _BcoHorasWidgetState createState() => _BcoHorasWidgetState();
}

class _BcoHorasWidgetState extends State<BcoHorasWidget> {
  String bcoPositivo = "00:00";
  String bcoNegativo = "00:00";
  String bcoSaldo = "00:00";
  @override
  void initState() {
    super.initState();

    BcoHorasBloc().getBancoHoras(context, true).then((map) {
      setState(() {
        var _bcoHoras = map.response.ttBancoHoras.ttBancoHoras2[0];

        if (_bcoHoras != null &&
            _bcoHoras.horasPositivas != "" &&
            _bcoHoras.horasNegativas != "" &&
            _bcoHoras.totalSaldoHoras != "") {
          bcoPositivo = _bcoHoras.horasPositivas;
          bcoNegativo = _bcoHoras.horasNegativas;
          bcoSaldo = _bcoHoras.totalSaldoHoras;
        } else {
          bcoPositivo = "00:00";
          bcoNegativo = "00:00";
          bcoSaldo = "00:00";
        }
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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.transparent.withOpacity(0.3),
      // backgroundColor: theme.backgroundColor,
      body: Container(
        color: Colors.transparent,
        // decoration: AppGradients.gradient,
        child: ScreenTypeLayout(
          breakpoints:
              ScreenBreakpoints(desktop: 1200, tablet: 730, watch: 280),
          mobile: OrientationLayoutBuilder(
            portrait: (context) => bcoHorasWidgetMobile(),
          ),
          tablet: bcoHorasWidgetWeb(),
          desktop: bcoHorasWidgetWeb(),
        ),
      ),
    );
  }
///////////////////////////////////////////////////////////////////////////////////////

  Widget bcoHorasWidgetMobile() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.width;
    // final theme = Theme.of(context);

    final cardImage = new Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      alignment: Alignment.topCenter,
      child: Image.asset(
        'images/imageBancoHoras.png',
        width: width * 0.5,
        height: height * 0.3,
        // width: 2,
        // height: 2,
      ),
    );
    final cardPositivo = new Expanded(
      child: Card(
        color: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          side: BorderSide(
            color: Estilo().prima,
          ),
        ),
        elevation: 5,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: width * 0.02,
              height: height * 0.19,
              decoration: BoxDecoration(
                color: Estilo().prima,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                  topLeft: Radius.circular(5),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Center(
                      child: Text(
                        "Positivo",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                    ),
                  ),
                  Center(
                      child: Container(
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                    child: Text(
                      bcoPositivo.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.green),
                    ),
                  )),
                ],
              ),
            )
          ],
        ),
      ),
    );
    final cardNegativo = Expanded(
      child: Card(
        color: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          side: BorderSide(
            color: Estilo().prima,
          ),
        ),
        elevation: 5,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: width * 0.02,
              height: height * 0.19,
              decoration: BoxDecoration(
                color: Estilo().prima,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                  topLeft: Radius.circular(5),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Center(
                      child: Text(
                        "Negativo",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                    ),
                  ),
                  Center(
                      child: Container(
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                    child: Text(
                      bcoNegativo.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.red),
                    ),
                  )),
                ],
              ),
            )
          ],
        ),
      ),
    );
    final cardSaldo = new Column(
      children: [
        Container(
            width: width * 1,
            height: height * 0.3,
            child: Card(
              color: Theme.of(context).cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                side: BorderSide(
                  color: Estilo().prima,
                ),
              ),
              elevation: 5,
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  width: width * 0.02,
                  height: height * 0.3,
                  decoration: BoxDecoration(
                    color: Estilo().prima,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      topLeft: Radius.circular(5),
                    ),
                  ),
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      // padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                      child: Text(
                        "Saldo",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                            fontSize: 20),
                      ),
                    ),
                    Container(
                      // padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                      child: Text(
                        bcoSaldo.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 35,
                            color: Colors.blueAccent),
                      ),
                    ),
                  ],
                ))
              ]),
            )),
      ],
    );
    return Container(
      decoration: AppGradients.gradient,
      child: Scaffold(
          backgroundColor: Estilo().backgroundBancoHoras,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            centerTitle: true,
            title: Center(
              child: Text(
                "Banco Horas",
              ),
            ),
          ),
          body: Container(
            // decoration: AppGradients.gradient,
            child: Center(
              child: Column(children: [
                cardImage,
                SizedBox(height: 48.0),
                new Row(
                  children: [cardPositivo, cardNegativo],
                ),
                cardSaldo
              ]),
            ),
          )),
    );
  }

  Widget bcoHorasWidgetWeb() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);

    final cardImage = new Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      alignment: Alignment.topCenter,
      child: Image.asset(
        'images/imageBancoHoras.png',
        width: width * 0.2,
        height: height * 0.4,
        filterQuality: FilterQuality.high,
        // width: 2,
        // height: 2,
      ),
    );
    //////
    final cardPositivo = Container(
      width: width * 0.15,
      height: height * 0.11,
      child: Card(
        color: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          side: BorderSide(
            color: Estilo().prima,
          ),
        ),
        elevation: 5,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: width * 0.01,
              height: height * 2,
              decoration: BoxDecoration(
                color: Estilo().prima,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                  topLeft: Radius.circular(5),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Center(
                      child: Text(
                        "Positivo",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                    ),
                  ),
                  Center(
                      child: Container(
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                    child: Text(
                      bcoPositivo.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.green),
                    ),
                  )),
                ],
              ),
            )
          ],
        ),
      ),
    );
    final cardNegativo = Container(
      width: width * 0.15,
      height: height * 0.11,
      child: Card(
        color: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          side: BorderSide(
            color: Estilo().prima,
          ),
        ),
        elevation: 5,
        child: Row(
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: width * 0.01,
              height: height * 2,
              decoration: BoxDecoration(
                color: Estilo().prima,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                  topLeft: Radius.circular(5),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Center(
                      child: Text(
                        "Negativo",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                    ),
                  ),
                  Center(
                      child: Container(
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                    child: Text(
                      bcoNegativo.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.red),
                    ),
                  )),
                ],
              ),
            )
          ],
        ),
      ),
    );
    final cardSaldo = new Column(
      children: [
        Container(
            width: width * 0.3,
            height: height * 0.12,
            child: Card(
              color: Theme.of(context).cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                side: BorderSide(
                  color: Estilo().prima,
                ),
              ),
              elevation: 5,
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  width: width * 0.01,
                  height: height * 2,
                  decoration: BoxDecoration(
                    color: Estilo().prima,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      topLeft: Radius.circular(5),
                    ),
                  ),
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      // padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                      child: Text(
                        "Saldo",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                            fontSize: 20),
                      ),
                    ),
                    Container(
                      // padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                      child: Text(
                        bcoSaldo.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 35,
                            color: Colors.blueAccent),
                      ),
                    ),
                  ],
                ))
              ]),
            )),
      ],
    );
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          elevation: 0,
          centerTitle: true,
          title: Center(
            child: Text(
              "Banco Horas",
            ),
          ),
        ),
        body: SingleChildScrollView(
          // scrollDirection: Axis.horizontal,
          // width: width * 0.4,
          // height: height * 0.4,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            cardImage,
            Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  cardPositivo,
                  cardNegativo,
                ]),
                cardSaldo
              ],
            ),
          ]),
        ));
  }
}
