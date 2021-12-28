// import 'dart:io';
// import 'package:camera_camera/camera_camera.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_search_bar/flutter_search_bar.dart';

// import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
// import 'package:intl/intl.dart';

// class EnviarAtestado extends StatefulWidget {
//   const EnviarAtestado({Key key}) : super(key: key);

//   @override
//   _EnviarAtestadoState createState() => _EnviarAtestadoState();
// }

// class _EnviarAtestadoState extends State<EnviarAtestado> {
//   final photos = <File>[];

//   void openCamera() {
//     Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (_) => CameraCamera(
//                   onFile: (file) {
//                     photos.add(file);
//                     Navigator.pop(context);
//                     setState(() {});
//                   },
//                 )));
//   }

//   @override
//   Widget build(BuildContext context) {
//     final format = DateFormat("yyyy-MM-dd HH:mm");
//     final size = MediaQuery.of(context).size;
//     return Scaffold(
//         backgroundColor: Color(0xff501d2c),
//         appBar: AppBar(
//           backgroundColor: Colors.transparent,
//           title: Text("ATESTADO MEDICO"),
//         ),
//         body: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: ListView(
//               children: [
//                 TextFormFildAtestado(
//                     "Hospital:", Icons.local_hospital_outlined),
//                 BasicDateTimeField(),
//                 TextFormFildAtestado("Data", Icons.calendar_today),
//                 TextFormFildAtestado("Hora", Icons.timelapse),
//                 TextFormFildAtestado("Medico", Icons.medical_services_rounded),
//                 TextFormFildAtestado(
//                     "CRM ou CRO do medico:", Icons.person_search_sharp),
//                 TextFormFildAtestado("Motivo da ausencia", Icons.line_style),
//                 TextFormFildAtestado(
//                     "Periodo de Afastamento:", Icons.personal_injury_rounded),
//                 GridView.builder(
//                     scrollDirection: Axis.vertical,
//                     shrinkWrap: true,
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 2),
//                     itemCount: photos.length,
//                     itemBuilder: (_, index) {
//                       return Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Container(
//                           width: size.width,
//                           child: Image.file(
//                             photos[0],
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       );
//                     })
//               ],
//             )),
//         floatingActionButton: FloatingActionButton(
//           onPressed: openCamera,
//           child: Icon(Icons.camera_alt),
//         ));
//   }

//   TextFormField TextFormFildAtestado(String text, IconData icon) {
//     return TextFormField(
//       cursorColor: Colors.white,
//       style: TextStyle(
//         color: Colors.white,
//         fontSize: 16,
//       ),
//       maxLength: 20,
//       decoration: InputDecoration(
//         icon: Icon(
//           icon,
//           color: Colors.white,
//         ),
//         labelText: text,
//         labelStyle: TextStyle(
//           color: Colors.white,
//           fontSize: 20,
//         ),
//         enabledBorder: UnderlineInputBorder(
//           borderSide: BorderSide(color: Colors.white),
//         ),
//       ),
//     );
//   }
// }

// class BasicDateTimeField extends StatelessWidget {
//   final format = DateFormat("yyyy-MM-dd HH:mm");
//   @override
//   Widget build(BuildContext context) {
//     return Column(children: <Widget>[
//       DateTimeField(
//         cursorColor: Colors.white,
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: 16,
//         ),
//         decoration: InputDecoration(
//           icon: Icon(
//             Icons.ac_unit_outlined,
//             color: Colors.white,
//           ),
//           labelText: 'DAta e Hora da Consulta',
//           labelStyle: TextStyle(
//             color: Colors.white,
//             fontSize: 20,
//           ),
//           enabledBorder: UnderlineInputBorder(
//             borderSide: BorderSide(color: Colors.white),
//           ),
//         ),
//         format: format,
//         maxLength: 20,
//         onShowPicker: (context, currentValue) async {
//           final date = await showDatePicker(
//               context: context,
//               firstDate: DateTime(1900),
//               initialDate: currentValue ?? DateTime.now(),
//               lastDate: DateTime(2100));
//           if (date != null) {
//             final time = await showTimePicker(
//               context: context,
//               initialTime:
//                   TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
//             );
//             return DateTimeField.combine(date, time);
//           } else {
//             return currentValue;
//           }
//         },
//       ),
//     ]);
//   }
// }
