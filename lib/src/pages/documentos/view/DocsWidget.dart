import 'dart:convert';

import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gpmobile/src/util/Estilo.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:pdf_render/pdf_render.dart';

class DocsWidget extends StatefulWidget {
  var file;
  DocsWidget({this.file, Key key}) : super(key: key);

  @override
  _DocsWidgetState createState() => _DocsWidgetState();
}

class _DocsWidgetState extends State<DocsWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKeyDocsWidgetWidget =
      GlobalKey<ScaffoldState>();
  bool releaseButton = false;

  @override
  void initState() {
    super.initState();
  }

  ReleaseButton() {
    releaseButton = true;
  }

  ///////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKeyDocsWidgetWidget,
      body: Container(
        decoration: AppGradients.gradient,
        child: ScreenTypeLayout(
          breakpoints: ScreenBreakpoints(desktop: 899, tablet: 730, watch: 279),
          mobile: OrientationLayoutBuilder(
            portrait: (context) => _docsWidgetMobile(),
            landscape: (context) => _docsWidgetMobile(),
          ),
          //  tablet: _buildWeb(),
          // desktop: _buildWeb(),
        ),
      ),
    );
  }

  Scaffold _docsWidgetMobile() {
    var decoded = base64.decode(widget.file);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Documentos',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      bottomNavigationBar: ElevatedButton(
          onPressed: () {
            releaseButton ? print('funfou') : print('nao funfou');
          },
          child: Text('Assinar')),
      body: PdfViewer.openData(
        decoded,
        params: PdfViewerParams(
          onInteractionEnd: : ReleaseButton(),
        ),
      ),

      // ElevatedButton(onPressed: null, child: Text('Assinar'))
    );
  }
}
