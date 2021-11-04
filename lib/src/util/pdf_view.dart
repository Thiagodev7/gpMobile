import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PdfViwerWidget extends StatefulWidget {
  const PdfViwerWidget({Key key}) : super(key: key);

  @override
  _PdfViwerWidgetState createState() => _PdfViwerWidgetState();
}

class _PdfViwerWidgetState extends State<PdfViwerWidget> {
  
  void _viewFile() async {
    final _url =
        'https://www.kindacode.com/wp-content/uploads/2021/07/test.pdf';
    if (await canLaunch(_url)) {
      await launch(_url);
    } else {
      print('Something went wrong');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kindacode.com'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('View PDF'),
          onPressed: _viewFile,
        ),
      ),
    );
  }
}
