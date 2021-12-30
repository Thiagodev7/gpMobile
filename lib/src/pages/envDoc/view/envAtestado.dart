import 'dart:convert';
import 'dart:io';
import 'package:camera_camera/camera_camera.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:gpmobile/src/pages/envDoc/bloc/enviarAtestadoBloc.dart';
import 'package:intl/intl.dart';

class EnviarAtestado extends StatefulWidget {
  const EnviarAtestado({Key key}) : super(key: key);

  @override
  _EnviarAtestadoState createState() => _EnviarAtestadoState();
}

class _EnviarAtestadoState extends State<EnviarAtestado> {
  File photos;

  var hospitalController = new TextEditingController();
  var medicoController = new TextEditingController();
  var crmCroController = new TextEditingController();
  var inicioController = new TextEditingController();
  var fimController = new TextEditingController();
  var motivoController = new TextEditingController();
  var cidController = new TextEditingController();

  String img64;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff501d2c),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text("ATESTADO MEDICO"),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                TextFormFildAtestado("Hospital:", Icons.local_hospital_outlined,
                    hospitalController),
                TextFormFildAtestado("Medico:", Icons.medical_services_rounded,
                    medicoController),
                TextFormFildAtestado("CRM ou CRO do medico:",
                    Icons.person_search_sharp, crmCroController),
                BasicDateTimeField('Data Inicial de Afastamento:',
                    Icons.calendar_today, inicioController),
                BasicDateTimeField('Data Final de Afastamento:',
                    Icons.calendar_today, fimController),
                TextFormFildAtestado(
                    "Motivo da ausencia:", Icons.line_style, motivoController),
                TextFormFildAtestado("CID:", Icons.book, cidController),
                cardCamera(context),
              ],
            )),
        floatingActionButton: ElevatedButton(
          onPressed: () => EnviarAtestadoBloc().getEnvAtestado(
            arquivo: img64,
            barraStatus: true,
            cid: cidController.text,
            context: context,
            crmcro: crmCroController.text,
            fimAfastamento: fimController.text,
            hospital: hospitalController.text,
            inicioAfastamento: inicioController.text,
            justificativa: motivoController.text,
            medico: medicoController.text,
          ),
          child: Text('Enviar'),
        ));
  }

  GestureDetector cardCamera(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => CameraCamera(
                      onFile: (file) {
                        photos = file;
                        Navigator.pop(context);
                        setState(() {});
                      },
                    )));
        final bytes = File(photos.path).readAsBytesSync();
        img64 = base64Encode(bytes);
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 20, right: 250),
        child: Container(
          height: 200,

          decoration: BoxDecoration(
            border: Border.all(width: 3.0, color: Colors.white),
            borderRadius: BorderRadius.all(
              Radius.circular(5.0), //                 <--- border radius here
            ),
          ), //             <--- BoxDecoration here
          child: photos == null
              ? Icon(
                  Icons.add,
                  size: 50,
                  color: Colors.white,
                )
              : Image.file(
                  photos,
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }

  TextFormField TextFormFildAtestado(
      String text, IconData icon, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      cursorColor: Colors.white,
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
      maxLength: 20,
      decoration: InputDecoration(
        icon: Icon(
          icon,
          color: Colors.white,
        ),
        labelText: text,
        labelStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}

class BasicDateTimeField extends StatelessWidget {
  TextEditingController controller;
  String text;
  IconData icon;
  BasicDateTimeField(this.text, this.icon, this.controller);
  final format = DateFormat("yyyy-MM-dd HH:mm");
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      DateTimeField(
        controller: controller,
        cursorColor: Colors.white,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: Colors.white,
          ),
          labelText: text,
          labelStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
        format: format,
        maxLength: 20,
        onShowPicker: (context, currentValue) async {
          final date = await showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100));
          if (date != null) {
            final time = await showTimePicker(
              context: context,
              initialTime:
                  TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
            );
            return DateTimeField.combine(date, time);
          } else {
            return currentValue;
          }
        },
      ),
    ]);
  }
}
