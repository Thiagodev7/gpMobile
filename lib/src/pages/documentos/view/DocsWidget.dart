import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:responsive_builder/responsive_builder.dart';

class DocsWidget extends StatefulWidget {
  var file;
  String title = 'Documentos';
  String origemClick = "";
  DocsWidget({this.file, this.title, Key key}) : super(key: key);

  @override
  _DocsWidgetState createState() => _DocsWidgetState();
}

class _DocsWidgetState extends State<DocsWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKeyDocsWidgetWidget =
      GlobalKey<ScaffoldState>();
  bool releaseButton = false;

  ///////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        color: Color(0xff501d2c),
        // decoration: AppGradients.gradient,
        child: ScreenTypeLayout(
          breakpoints: ScreenBreakpoints(desktop: 899, tablet: 730, watch: 279),
          mobile: OrientationLayoutBuilder(
            portrait: (context) => _docsWidgetMobile(),
            landscape: (context) => _docsWidgetMobile(),
          ),
          tablet: _buildWeb(context),
          desktop: _buildWeb(context),
          // orig: widget.origemClick,
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
          widget.title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: PdfViewer.openData(
        decoded,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ElevatedButton(
          onPressed: () {
            releaseButton ? print('funfou') : print('nao funfou');
          },
          child: Text('Assinar'),
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.transparent))),
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) => Color(0xFFC42224)),
          ),
        ),
      ),
    );
  }

  Widget _buildWeb(context) {
    var decoded = base64.decode(widget.file);
    double width = MediaQuery.of(context).size.width * 0.8;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.transparent,

      //[APPBAR]
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                title: Text(
                  widget.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            ];
          },
          body: PdfViewer.openData(
            decoded,
          ),
        ),
      ),
    );
  }
}
