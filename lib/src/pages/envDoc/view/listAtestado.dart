import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/conditional_switch.dart';
import 'package:gpmobile/src/pages/envDoc/bloc/receberListaAtestadoBloc.dart';
import 'package:gpmobile/src/pages/envDoc/model/enviarAtestadoModel.dart';
import 'package:gpmobile/src/pages/envDoc/model/receberListaAtestadoModel.dart';
import 'package:gpmobile/src/pages/envDoc/view/envAtestado.dart';
import 'package:responsive_builder/responsive_builder.dart';

class EnviarDocs extends StatefulWidget {
  EnviarDocs({Key key}) : super(key: key);

  @override
  _EnviarDocsState createState() => _EnviarDocsState();
}

class _EnviarDocsState extends State<EnviarDocs> {
  final GlobalKey<ScaffoldState> _scaffoldKeyEnviarDocsWidget =
      GlobalKey<ScaffoldState>();

  List<Processos> listAtestados = [];

  int index;

  int count = 0;
  String origemClick = "";

  @override
  void initState() {
    super.initState();
    ReceberListaAtestadoBloc().getAllAniversarios(context, true).then((value) {
      listAtestados = value.processos;
    });
  }

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
          'Atestados',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EnviarAtestado()),
                );
              },
              icon: Icon(Icons.add))
        ],
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
          'Atestados',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(onPressed: () => _visualizaDocWeb(), icon: Icon(Icons.add))
        ],
      ),
      body: ListView.builder(
          itemCount: listAtestados.length, //passa o tamanho da lista
          itemBuilder: (BuildContext ctxt, int index) {
            //como será mostrado os dados na tela
            var objNiver = listAtestados[
                index]; //variavel recebe cada indice do array(objeto)
            return Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              color: Color(0xA4B82222),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: AlignmentDirectional(-0.7, 0),
                            child: Text(
                              'Atestado Solicitado',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(0, 0),
                            child: IconButton(
                              // borderColor: Colors.transparent,
                              // borderRadius: 30,
                              // borderWidth: 1,
                              // buttonSize: 60,
                              icon: Icon(
                                Icons.keyboard_control_rounded,
                                color: Color(0xFFFAF7F7),
                                size: 30,
                              ),
                              onPressed: () {
                                print('IconButton pressed ...');
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(-0.9, 0),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                        child: Text(
                          'Motivo de Afastamento ',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Color(0xFFD2D3D5),
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(-0.7, 0),
                      child: Text(
                        'Afastamento Temporario por doença',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Align(
                              alignment: AlignmentDirectional(-0.9, 0),
                              child: Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                                child: Text(
                                  'Inicio',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Color(0xFFD2D3D5),
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(-1, 0),
                              child: Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                                child: Text(
                                  '10/08/2021',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Align(
                              alignment: AlignmentDirectional(-0.9, 0),
                              child: Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                                child: Text(
                                  'Fim',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Color(0xFFD2D3D5),
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(-1, 0),
                              child: Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                                child: Text(
                                  '20/08/2021',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                              child: Text(
                                'Status:',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                  fontSize: 25,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      25, 0, 0, 0),
                                  child: Icon(
                                    Icons.access_time,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      5, 0, 0, 0),
                                  child: Text(
                                    'Aguardando....',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
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
