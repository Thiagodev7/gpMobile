// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:gpmobile/src/pages/envDoc/view/envAtestado.dart';
// import 'package:gpmobile/src/util/Estilo.dart';
// import 'package:responsive_builder/responsive_builder.dart';

// class EnviarDocs extends StatefulWidget {
//   const EnviarDocs({Key key}) : super(key: key);

//   @override
//   _EnviarDocsState createState() => _EnviarDocsState();
// }

// class _EnviarDocsState extends State<EnviarDocs> {
//   final GlobalKey<ScaffoldState> _scaffoldKeyEnviarDocsWidget =
//       GlobalKey<ScaffoldState>();

//   ///////////////////////////////////////////////////////////
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       key: _scaffoldKeyEnviarDocsWidget,
//       body: Container(
//         color: Color(0xff501d2c),
//         child: ScreenTypeLayout(
//           breakpoints: ScreenBreakpoints(desktop: 899, tablet: 730, watch: 279),
//           mobile: OrientationLayoutBuilder(
//             portrait: (context) => _enviarDocsWidgetMobile(context),
//             landscape: (context) => _enviarDocsWidgetMobile(context),
//           ),
//           //  tablet: _buildWeb(),
//           // desktop: _buildWeb(),
//         ),
//       ),
//     );
//   }
// }

// Widget _enviarDocsWidgetMobile(context) {
//   return Scaffold(
//     backgroundColor: Colors.transparent,
//     appBar: AppBar(
//       backgroundColor: Colors.transparent,
//       elevation: 0,
//       centerTitle: true,
//       title: Text(
//         'Enviar Documento',
//         style: TextStyle(
//           color: Colors.white,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//     ),
//     body: ListView(
//       children: [
//         Card(
//           child: GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => EnviarAtestado()),
//               );
//             },
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text('Enviar atestado Medico'),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }
