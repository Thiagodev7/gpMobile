import 'dart:convert';

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
            portrait: (context) => _docsWidgetMobile(widget.file),
            landscape: (context) => _docsWidgetMobile(widget.file),
          ),
          //  tablet: _buildWeb(),
          // desktop: _buildWeb(),
        ),
      ),
    );
  }
}

Widget _docsWidgetMobile(file) {
  var decoded = base64.decode(file);
  return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Questionário',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: PdfViewer.openData(decoded));
}
