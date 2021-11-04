import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:gpmobile/src/pages/documentos/enviar/Base64Model.dart'
    as Base64Model;
import 'package:gpmobile/src/util/Estilo.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_io/prefer_universal/io.dart';

import 'EnviarDocBloc.dart';

class EnviarDocWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppGradients.gradient,
        child: CardEnviarDocWidget(),
      ),
    );
  }
}

class CardEnviarDocWidget extends StatefulWidget {
  @override
  _CardEnviarDocWidgetState createState() => new _CardEnviarDocWidgetState();
}

//https://github.com/TanishSawant/FlutterFilePicker/blob/master/lib/src/file_picker_example.dart
class _CardEnviarDocWidgetState extends State<CardEnviarDocWidget> {
  //
  TextEditingController _crtlTituloDoc = new TextEditingController();
  TextEditingController _crtlDecricaoDoc = new TextEditingController();
  //
  String _txtAppBarDoc = "Novo Documento";

  ///
  String labelTituloDoc = 'Título do documento';
  String _labelFileName = 'documento selecionado';
  String _txtFileName = 'Selecione um documento...';
  // String _path = '...';
  bool _loadingPath;
  // FileType _pickingType;
  String campoEstaVazio = 'Preenchimento obrigatorio...';
  //
  bool campoVazio;
  // var _arqBase64;
  final _formKeyEnviarDocWidget = GlobalKey<FormState>();
  //
  var encodedFile;
  var decodedFile;
  //
  @override
  void initState() {
    super.initState();
    //initPDF();
    setState(() {
      _loadingPath = false;
      campoVazio = false;
    });
  }

  ///*[PRINCIPAL]
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: _appBar(),
      body: Center(
        child: Form(
          key: _formKeyEnviarDocWidget,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            children: <Widget>[
              txtTituloEnviarDoc(context),
              SizedBox(height: 20.0),
              descricao(context),
              SizedBox(height: 8.0),
              botaoEnviarDoc(context),
              SizedBox(height: 8.0),
            ],
          ),
        ),
      ),
    );
  }

  ///*[COMPONENTES]
  Widget _appBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: Text(
        _txtAppBarDoc,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget txtTituloEnviarDoc(BuildContext context) {
    return Container(
      child: TextFormField(
        validator: (value) => validarCampoDoc(value),
        controller: _crtlTituloDoc,
        style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.red),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusColor: Colors.grey,
          labelText: labelTituloDoc,
          icon: Icon(Icons.text_fields_rounded, size: 30, color: Colors.grey),
          labelStyle: TextStyle(
              height: 2,
              fontSize: 16.0,
              color: Colors.grey,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold),
          filled: true,
          fillColor: Estilo().fillColor,
          errorStyle: TextStyle(
              height: 1,
              fontSize: 16.0,
              color: Colors.orangeAccent,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold),
        ),
        cursorColor: Colors.grey,
        maxLines: 1,
        maxLength: 25,
      ),
    );
  }

  //
  Widget descricao(BuildContext context) {
    return Container(
      child: TextFormField(
        validator: (value) => validarCampoDoc(value),
        onTap: () => _selectFile(),
        controller: _crtlDecricaoDoc,
        maxLines: 2,
        showCursor: false,
        decoration: InputDecoration(
          prefixStyle: TextStyle(
              // color: Theme.of(context).backgroundColor,
              ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
              width: 1,
              color: Colors.grey,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          // labelText: _labelFileName,
          // labelStyle: TextStyle(
          //     height: 2,
          //     fontSize: 16.0,
          //     color: Colors.grey,
          //     fontStyle: FontStyle.italic,
          //     fontWeight: FontWeight.bold),
          icon: Icon(Icons.upload_sharp, size: 30, color: Colors.grey),
          hintText: _txtFileName, //descricao
          hintStyle: TextStyle(
              height: 2,
              fontSize: 16.0,
              color: Colors.grey,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold),
          filled: true,
          fillColor: Estilo().fillColor,
          errorStyle: TextStyle(
              height: 1,
              fontSize: 16.0,
              color: Colors.orangeAccent,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold),
        ),
        // enabled: false,
      ),
    );
  }

  Widget botaoEnviarDoc(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      //align buttoms to the right
      children: <Widget>[
        Container(
          child: MaterialButton(
            onPressed: onPressedSalvarDoc,
            highlightColor: Colors.lightBlueAccent,
            highlightElevation: 8,
            elevation: 18,
            shape: StadiumBorder(),
            child: Text(
              "Salvar",
              style: TextStyle(
                color: Estilo().branca,
              ),
            ),
            color: Theme.of(context).backgroundColor,
            enableFeedback: true,
          ),
        )
      ],
    );
  }

  ///*[METODOS]
  dynamic validarCampoDoc(value) {
    if (value.isEmpty) {
      return campoEstaVazio;
    }
    return null;
  }

  Future<void> _selectFile() async {
    //selecionar o arq
    FilePickerResult selectFile =
        await FilePicker.platform.pickFiles(withData: true);
    //mostrar na tela
    PlatformFile file;
    if (selectFile != null) {
      file = selectFile.files.first;
      _txtFileName = file.name;
    } else {
      _txtFileName = 'Arquivo não encontrado!';
    }
    //add a uma lista de inteiros
    //   _file = selectFile.files.single;
    List<int> updatedContent = file.bytes;
    //realizar o encode
    encodedFile = base64.encode(updatedContent);
    setState(() {
      return _crtlDecricaoDoc.text = _txtFileName;
    });
  }

  onPressedSalvarDoc() async {
    //se campos preenchidos...
    if (_formKeyEnviarDocWidget.currentState.validate()) {
      //salvar dados
      if (encodedFile != null) {
        String _arqBase64 = encodedFile;
        print("***ARQ***${_arqBase64.codeUnits}");

        Base64Model.Base64Model image64 = new Base64Model.Base64Model(
            request: new Base64Model.Request(lchrArquivoBase64: _arqBase64));
        if (_arqBase64 != null) {
          setState(() {
            EnviarDocBloc().postArquivos(
                context, _crtlTituloDoc.text, image64, _txtFileName, true);
            _crtlTituloDoc.clear();
            _crtlDecricaoDoc.clear();
            _txtFileName = null;
          });
        } else {
          print("ERROR");
        }
      }
    }
  }
}
