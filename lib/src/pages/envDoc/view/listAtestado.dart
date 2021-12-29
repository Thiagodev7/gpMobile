import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/conditional_switch.dart';
import 'package:gpmobile/src/pages/envDoc/view/envAtestado.dart';
import 'package:gpmobile/src/util/Estilo.dart';
import 'package:responsive_builder/responsive_builder.dart';

class EnviarDocs extends StatefulWidget {
  EnviarDocs({Key key}) : super(key: key);

  @override
  _EnviarDocsState createState() => _EnviarDocsState();
}

class _EnviarDocsState extends State<EnviarDocs> {
  final GlobalKey<ScaffoldState> _scaffoldKeyEnviarDocsWidget =
      GlobalKey<ScaffoldState>();

  int index;

  int count = 0;
  String origemClick = "";

  ///////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      key: _scaffoldKeyEnviarDocsWidget,
      body: Container(
        color: Color(0xff501d2c),
        child: ScreenTypeLayout(
          breakpoints: ScreenBreakpoints(desktop: 899, tablet: 730, watch: 279),
          mobile: OrientationLayoutBuilder(
            portrait: (context) => _enviarDocsWidgetMobile(context),
            landscape: (context) => _enviarDocsWidgetMobile(context),
          ),
          tablet: _enviarDocsWeb(context),
          desktop: _enviarDocsWeb(context),
        ),
      ),
      endDrawer: ConditionalSwitch.single<String>(
        context: context,
        valueBuilder: (BuildContext context) => origemClick,
        caseBuilders: {
          'viewAtstado': (BuildContext context) => EnviarAtestado()
        },
        fallbackBuilder: (BuildContext context) {
          return Card(
            color: Colors.white,
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    // setState(() {
                    // widget.count = widget.count - 1;
                    Navigator.of(context).pop();
                    // });
                  },
                  icon: Icon(Icons.close, size: 60, color: Colors.red),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                const Text(
                  'tela TESTE vazia!!!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _enviarDocsWidgetMobile(context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Enviar Documento',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: ListView(
        children: [
          Card(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EnviarAtestado()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Enviar atestado Medico'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _enviarDocsWeb(context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Enviar Documento',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: ListView(
        children: [
          Card(
            child: GestureDetector(
              onTap: () => _visualizaDocWeb(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Enviar atestado Medico'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _visualizaDocWeb() {
    setState(() {
      origemClick = "viewAtstado";
      _openEndDrawer();
    });
  }

  //METODOS COMPARTILHADOS
  Future<int> _openEndDrawer() async {
    // index = i;
    _scaffoldKeyEnviarDocsWidget.currentState.openEndDrawer();
  }

  void closeEndDrawer() {
    setState(() {
      count = count - 1;
      Navigator.of(context).pop();
    });
  }
}
