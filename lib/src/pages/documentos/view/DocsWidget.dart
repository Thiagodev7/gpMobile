import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/conditional_switch.dart';
import 'package:gpmobile/src/pages/documentos/bloc/ListarDocBloc.dart';
import 'package:gpmobile/src/util/AlertDialogTemplate.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:responsive_builder/responsive_builder.dart';

class DocsWidget extends StatefulWidget {
  String origemClick = "";
  bool signature;
  int index;

  DocsWidget({this.index, this.signature, Key key}) : super(key: key);

  @override
  _DocsWidgetState createState() => _DocsWidgetState();
}

class _DocsWidgetState extends State<DocsWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKeyDocsWidgetWidget =
      GlobalKey<ScaffoldState>();
  bool releaseButton = false;
  String documentofile = "";
  String title = "";
  bool requerCiencia = false;
  bool checkbox = false;
  bool docAssinado = false;
  String tipoDoc = '';
  final snackBar = SnackBar(
    content: const Text('Confirmado! Voce Assinou o Documento!'),
  );

  ///////////////////////////////////////////////////////////
  @override
  void initState() {
    super.initState();
  }

  void _value1Changed(bool value) => setState(() => checkbox = value);

  Future<String> getFutureDados() async {
    bool cienciaConfirmada = widget.signature == true ? false : true;
    await LisartDocsBloc()
        .getListDocs(
            context: context,
            operacao: 2,
            cienciaConfirmada: false,
            codDocumento: widget.index)
        .then((value) => {
              documentofile =
                  value.response.ttRetorno.ttRetorno2[0].arquivoBase64,
              title = value.response.ttRetorno.ttRetorno2[0].titulo,
              requerCiencia =
                  value.response.ttRetorno.ttRetorno2[0].requerCiencia,
              docAssinado =
                  value.response.ttRetorno.ttRetorno2[0].documentoAssinado,
              tipoDoc = value.response.ttRetorno.ttRetorno2[0].tipoDocumento,
            });
    return documentofile;
  }

  Widget openDoc() {
    if (tipoDoc == "PDF") {
      return PdfViewer.openData(base64.decode(documentofile));
    } else {
      return Image.memory(base64.decode(documentofile));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
          color: Color(0xff501d2c),
          // decoration: AppGradients.gradient,
          child: FutureBuilder(
              future: getFutureDados(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ScreenTypeLayout(
                    breakpoints: ScreenBreakpoints(
                        desktop: 899, tablet: 730, watch: 279),
                    mobile: OrientationLayoutBuilder(
                      portrait: (context) => _docsWidgetMobile(),
                      landscape: (context) => _docsWidgetMobile(),
                    ),
                    tablet: _buildWeb(context),
                    desktop: _buildWeb(context),
                    // orig: widget.origemClick,
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              })),
      endDrawer: ConditionalSwitch.single<String>(
        context: context,
        valueBuilder: (BuildContext context) => widget.origemClick,
        caseBuilders: {
          'viewDoc': (BuildContext context) => _docsWidgetMobile()
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

  Scaffold _docsWidgetMobile() {
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: openDoc(),
        bottomNavigationBar: requerCiencia == true && docAssinado == false
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Checkbox(
                      value: checkbox,
                      onChanged: _value1Changed,
                      activeColor: Colors.red,
                    ),
                    Text(
                      'Li e concordo com os termos e condições.',
                      style: TextStyle(color: Colors.white),
                    ),
                    ElevatedButton(
                      onPressed: checkbox == true
                          ? () async {
                              await AlertDialogTemplate()
                                  .ShowDialogSenhaDoc(
                                      context,
                                      'Assinar Documento',
                                      'Preencha com sua Senha',
                                      'Senha')
                                  .then((value) {
                                if (value == ConfirmAction.OK) {
                                  LisartDocsBloc().getListDocs(
                                      context: context,
                                      codDocumento: widget.index,
                                      cienciaConfirmada: true,
                                      operacao: 3);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                  Navigator.of(context).pop();
                                }
                                ;
                              });
                            }
                          : null,
                      child: Text('Assinar'),
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side:
                                        BorderSide(color: Colors.transparent))),
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) =>
                                    Color(0xFFC42224)),
                      ),
                    ),
                  ],
                ),
              )
            : null);
  }

  Widget _buildWeb(context) {
    var decoded = base64.decode(documentofile);
    double width = MediaQuery.of(context).size.width * 0.8;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.transparent,

        //[APPBAR]
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  centerTitle: true,
                  title: Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              ];
            },
            body: openDoc(),
          ),
        ),
        bottomNavigationBar: requerCiencia == true && docAssinado == false
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Checkbox(
                      value: checkbox,
                      onChanged: _value1Changed,
                      activeColor: Colors.red,
                    ),
                    Text(
                      'Li e concordo com os termos e condições.',
                      style: TextStyle(color: Colors.white),
                    ),
                    ElevatedButton(
                      onPressed: checkbox == true
                          ? () async {
                              await AlertDialogTemplate()
                                  .ShowDialogSenhaDoc(
                                      context,
                                      'Assinar Documento',
                                      'Preencha com sua Senha',
                                      'Senha')
                                  .then((value) {
                                if (value == ConfirmAction.OK) {
                                  LisartDocsBloc().getListDocs(
                                      context: context,
                                      codDocumento: widget.index,
                                      cienciaConfirmada: true,
                                      operacao: 3);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                  Navigator.of(context).pop();
                                }
                                ;
                              });
                            }
                          : null,
                      child: Text('Assinar'),
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side:
                                        BorderSide(color: Colors.transparent))),
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) =>
                                    Color(0xFFC42224)),
                      ),
                    ),
                  ],
                ),
              )
            : null);
  }
}
