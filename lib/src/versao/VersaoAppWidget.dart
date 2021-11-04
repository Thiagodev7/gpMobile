import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:gpmobile/src/util/Estilo.dart';
import 'package:gpmobile/src/versao/ValidaVersaoBloc.dart';
import 'package:intl/intl.dart';

class VersaoAppWidget extends StatefulWidget {
  @override
  _VersaoAppWidgetState createState() => _VersaoAppWidgetState();
}
///*[variaveis globais]
bool someCondition;
int indexPage;
int count = 0;
double v;
var f = new NumberFormat("###.0#", "en_US");
String valorVersao = f.format(ValidaVersaoBloc.getVersaoAppDp());


final GlobalKey<ScaffoldState> _scaffoldKeyVersaoAppWidget =
GlobalKey<ScaffoldState>();
//ENDDRAWER
Future<void> _openEndDrawer() async {
  // indexPage = i;
  _scaffoldKeyVersaoAppWidget.currentState.openEndDrawer();
}

// void closeEndDrawer() {
//   setState(() {
//     count = count - 1;
//     Navigator.of(context).pop();
//   });
// }

class _VersaoAppWidgetState extends State<VersaoAppWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Estilo().backgroundTelaViewVersao,
      key: _scaffoldKeyVersaoAppWidget,
      body: SafeArea(
        child: Container(

          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 768) {
                return CardVersaoAppWidgetMobile();
              } else {
                return CardVersaoAppWidgetWeb();
              }
            },
          ),
        ),
      ),
      endDrawer: Conditional.single(
        context: context,
        conditionBuilder: (BuildContext context) => someCondition == true,
        widgetBuilder: (BuildContext context) => Text('The condition is true!'),
        fallbackBuilder: (BuildContext context) =>
            Text('The condition is false!'),
      ),
      endDrawerEnableOpenDragGesture: false,
    );
  }
}

/// This is the stateless widget that the main application instantiates.
class CardVersaoAppWidgetMobile extends StatelessWidget {
  CardVersaoAppWidgetMobile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String _title = 'Informacoes desse App';
    //new

    //
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      decoration: AppGradients.gradient,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          //
          centerTitle: true,
          title: const Text(_title),
        ),
        body: Center(
          child: Container(
            width: width * 0.75,
            height: height * 0.4,
            child: Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: ListTile(
                      leading: Icon(Icons.verified_user_sharp),
                      title: Text('GP MOBILE',
                          style: TextStyle(
                            fontSize: 25,
                          )),
                      subtitle: Text('Aplicativo Gestão De Pessoas'),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextButton(
                            child: Text(
                                'VERSAO: ' +
                                    valorVersao,
                                style: TextStyle(
                                  fontSize: 25,
                                )),
                            onPressed: () => someCondition = true,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Text(
                          'Copyright ©2020, All Rights Reserved.',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 12.0,
                            // color: Theme.of(context).accentColor
                          ),
                        ),
                        Text(
                          'Powered by Grupo H. Egídio',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 12.0,
                            // color: Theme.of(context).accentColor),
                          ),
                        ),
                      ],
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
}

class CardVersaoAppWidgetWeb extends StatelessWidget {
  CardVersaoAppWidgetWeb({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String _title = 'Informacoes desse App';

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          //
          centerTitle: true,
          title: const Text(_title)),
      body: Center(
        child: Container(
          width: width * 0.6,
          height: height * 0.4,
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: ListTile(
                    leading: Icon(Icons.verified_user_sharp),
                    title: Text('GP MOBILE',
                        style: TextStyle(
                          fontSize: 25,
                        )),
                    subtitle: Text('Aplicativo Gestão De Pessoas'),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextButton(
                          child: Text(
                              'VERSAO: ' +
                                  valorVersao,
                              style: TextStyle(
                                fontSize: 25,
                              )),
                          onPressed: () => someCondition = true,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Text(
                        'Copyright ©2020, All Rights Reserved.',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 12.0,
                          // color: Theme.of(context).accentColor
                        ),
                      ),
                      Text(
                        'Powered by Grupo H. Egídio',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 12.0,
                          // color: Theme.of(context).accentColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
