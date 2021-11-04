// //https://github.com/idrcorner/Flutter-CRUD-phpMyAdmin/blob/master/lib/editdata.dart
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:gpmobile/src/pages/mensagens/enviar_mensagens/EnviarMensaBloc.dart';
// import 'package:gpmobile/src/pages/mensagens/listar_mensagens/ListaMensaWidget.dart';
// import 'package:gpmobile/src/pages/mensagens/model/StatusMensaModel.dart';
// import 'package:gpmobile/src/util/AlertDialogTemplate.dart';
// import 'package:gpmobile/src/util/Estilo.dart';
// import 'package:intl/intl.dart';
// import 'package:responsive_builder/responsive_builder.dart';
//
// import '../vizualizar_mensagens/PageHeroWidget.dart';
//
// class EditarMensaWidget extends StatefulWidget {
//   // final objMensa objMensa;
//   final StatusModel objMensa;
//
//   EditarMensaWidget(this.objMensa) : super();
//
//   @override
//   _EditarMensaWidgetState createState() => _EditarMensaWidgetState();
// }
//
// class _EditarMensaWidgetState extends State<EditarMensaWidget> {
//   //
//   // objMensa _objMensa;
//   StatusModel _objMensa;
//   double _screenWidth;
//   double _screenHeight;
//   TextEditingController controllerTitle;
//   TextEditingController controllerSubtitle;
//   TextEditingController controllerData;
//   int sequencia;
//   dynamic dataFormatada =
//       DateFormat('dd/MM/yyyy kk:mm:ss').format(DateTime.now());
//   //
//   @override
//   void initState() {
//     super.initState();
//     setState(() {
//       _objMensa = widget.objMensa;
//     });
//     controllerTitle = new TextEditingController(text: widget.objMensa.titulo);
//     controllerSubtitle =
//         new TextEditingController(text: widget.objMensa.mensagem);
//     controllerData = new TextEditingController(text: widget.objMensa.data);
//     sequencia = widget.objMensa.sequencia;
//   }
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     _screenWidth = MediaQuery.of(context).size.width;
//     _screenHeight = MediaQuery.of(context).size.height;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     //
//     final theme = Theme.of(context);
//     double width = MediaQuery.of(context).size.width;
//     double height = MediaQuery.of(context).size.height;
//     return Scaffold(
//       body: Container(
//         decoration: AppGradients.gradient,
//         child: ScreenTypeLayout(
//             breakpoints:
//                 ScreenBreakpoints(desktop: 899, tablet: 730, watch: 279),
//             mobile: OrientationLayoutBuilder(
//               portrait: (context) => EditarMensaWidgetMobile(),
//               landscape: (context) => EditarMensaWidgetMobile(),
//             ),
//             tablet: Center(
//                 child: Container(width: 730, child: EditarMensaWidgetWeb())),
//             desktop: Center(
//                 child: Container(width: 730, child: EditarMensaWidgetWeb()))),
//       ),
//     );
//   }
//
//   Widget EditarMensaWidgetMobile() {
//     //
//     final theme = Theme.of(context);
//     double width = MediaQuery.of(context).size.width;
//     double height = MediaQuery.of(context).size.height;
//     //
//     final btnVoltar = new IconButton(
//       onPressed: () {
//         return Navigator.pop(context);
//       },
//       icon: Icon(Icons.arrow_back_rounded),
//     );
//     //
//     final btnAppBarSave = new IconButton(
//       onPressed: () {
//         _sendNewData();
//       },
//       highlightColor: Colors.lightBlueAccent,
//       icon: Icon(
//         Icons.save,
//         color: AppColors.white,
//         size: 30,
//       ),
//     );
//     //
//     final iconEditMensa = Container(
//       alignment: Alignment.center,
//       child: Icon(
//         Icons.messenger,
//         color: theme.selectedRowColor.withOpacity(0.8),
//         size: 50,
//       ),
//     );
//     //
//     final txtEditTitle = Container(
//       width: 250,
//       height: 30, //web = 60
//       child: Center(
//         child: TextField(
//           controller: controllerTitle,
//           cursorColor: AppColors.grey,
//           maxLines: 1,
//           maxLength: 30,
//           style: TextStyle(color: AppColors.txtSemFundo),
//         ),
//       ),
//     );
//     //
//     final btnEditDataHora = new Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text(
//           '${_objMensa.data}',
//           style: TextStyle(fontSize: 12, color: Colors.white),
//         ),
//       ],
//     );
// //
//     final txtEditDescription = new Expanded(
//       child: Container(
//         width: width * 0.9,
//         height: height * 0.1,
//         alignment: Alignment.center,
//         child: ListView(
//           children: [
//             TextFormField(
//               controller: controllerSubtitle,
//               minLines: 4,
//               maxLines: 25,
//               decoration: new InputDecoration(
//                 filled: true,
//                 fillColor: Colors.white,
//                 // icon: Icon(Icons.description, size: 30, color: Colors.grey),
//                 // hintText: "Descrição Mensagem",
//                 // labelText: "Descrição Mensagem"
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//     //
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         leading: btnVoltar,
//         actions: [btnAppBarSave],
//       ),
//       body: DefaultTextStyle(
//         style: theme.textTheme.headline4, //ajuste tamanho do titulo
//         textAlign: TextAlign.left, //ajuste justificado do titulo
//         child: SafeArea(
//           minimum: EdgeInsets.fromLTRB(0, 10, 0, 0),
//           child: LayoutBuilder(
//             builder:
//                 (BuildContext context, BoxConstraints viewportConstraints) {
//               return SingleChildScrollView(
//                 child: ConstrainedBox(
//                   constraints: BoxConstraints(
//                     minHeight: viewportConstraints.maxHeight,
//                   ),
//                   child: IntrinsicHeight(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: <Widget>[
//                         iconEditMensa,
//                         SizedBox(height: 30.0),
//                         txtEditTitle,
//                         SizedBox(height: 8.0),
//                         txtEditDescription,
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
//
// //
//   EditarMensaWidgetTablet() {}
//   //
//   EditarMensaWidgetWeb() {
//     //
//     final theme = Theme.of(context);
//     double width = MediaQuery.of(context).size.width;
//     double height = MediaQuery.of(context).size.height;
//     //
//     final btnVoltar = new IconButton(
//       onPressed: () {
//         return Navigator.pop(context);
//       },
//       icon: Icon(Icons.arrow_back_rounded),
//     );
//     //
//     final btnAppBarSave = new IconButton(
//       onPressed: () {
//         _sendNewData();
//       },
//       highlightColor: Colors.lightBlueAccent,
//       icon: Icon(
//         Icons.save,
//         color: AppColors.white,
//         size: 30,
//       ),
//     );
//     //
//     final iconEditMensa = Container(
//       alignment: Alignment.center,
//       child: Icon(
//         Icons.messenger,
//         color: theme.selectedRowColor.withOpacity(0.8),
//         size: 50,
//       ),
//     );
//     //
//     final txtEditTitle = Container(
//       width: 225,
//       height: 60,
//       child: Center(
//         child: TextField(
//           controller: controllerTitle,
//           cursorColor: AppColors.grey,
//           maxLines: 1,
//           maxLength: 30,
//           style: TextStyle(color: AppColors.txtSemFundo),
//         ),
//       ),
//     );
//     //
//     final btnEditDataHora = new Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text(
//           '${_objMensa.data}',
//           style: TextStyle(fontSize: 12, color: Colors.white),
//         ),
//       ],
//     );
// //
//     final txtEditDescription = new Expanded(
//       child: Container(
//         width: width * 0.9,
//         height: height * 0.1,
//         alignment: Alignment.center,
//         child: ListView(
//           children: [
//             TextFormField(
//               controller: controllerSubtitle,
//               minLines: 4,
//               maxLines: 25,
//               decoration: new InputDecoration(
//                 filled: true,
//                 fillColor: Colors.white,
//                 // icon: Icon(Icons.description, size: 30, color: Colors.grey),
//                 // hintText: "Descrição Mensagem",
//                 // labelText: "Descrição Mensagem"
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//     //
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         leading: btnVoltar,
//         actions: [btnAppBarSave],
//       ),
//       body: Center(
//         child: Container(
//           width: 730,
//           child: DefaultTextStyle(
//             style: theme.textTheme.headline4, //ajuste tamanho do titulo
//             textAlign: TextAlign.left, //ajuste justificado do titulo
//             child: SafeArea(
//               minimum: EdgeInsets.fromLTRB(0, 10, 0, 0),
//               child: LayoutBuilder(
//                 builder:
//                     (BuildContext context, BoxConstraints viewportConstraints) {
//                   return SingleChildScrollView(
//                     child: ConstrainedBox(
//                       constraints: BoxConstraints(
//                         minHeight: viewportConstraints.maxHeight,
//                       ),
//                       child: IntrinsicHeight(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: <Widget>[
//                             iconEditMensa,
//                             SizedBox(height: 18.0),
//                             txtEditTitle,
//                             SizedBox(height: 18.0),
//                             txtEditDescription,
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//           //
//         ),
//       ),
//     );
//   }
//
//   void _sendNewData() async {
//     await new EnviarMensaBloc().postEnviarMensagem(
//         context,
//         controllerTitle.text,
//         controllerSubtitle.text,
//         dataFormatada,
//         2,
//         sequencia,
//         null,
//         true);
//
//     await AlertDialogTemplate().showAlertDialogSimplesEnviarMensa(
//         context, "", "Mensagem editada com sucesso!");
//   }
// }
