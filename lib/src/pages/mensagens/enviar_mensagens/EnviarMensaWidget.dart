// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
// import 'package:gpmobile/src/pages/mensagens/model/StatusMensaModel.dart';
//
// import 'package:gpmobile/src/util/AlertDialogTemplate.dart';
// import 'package:gpmobile/src/util/Estilo.dart';
// import 'package:intl/intl.dart';
// import 'package:responsive_builder/responsive_builder.dart';
// import 'dart:ui';
// import 'EnviarMensaBloc.dart';
//
// class EnviarMensaWidget extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _EnviarMensaWidgetState();
//   }
// }
//
// /// {@template custom_rect_tween}
// /// Linear RectTween with a [Curves.easeOut] curve.
// ///
// /// Less dramatic that the regular [RectTween] used in [Hero] animations.
// /// {@endtemplate}
// class CustomRectTween extends RectTween {
//   /// {@macro custom_rect_tween}
//   CustomRectTween({
//     @required Rect begin,
//     @required Rect end,
//   }) : super(begin: begin, end: end);
//
//   @override
//   Rect lerp(double t) {
//     final elasticCurveValue = Curves.easeOut.transform(t);
//     return Rect.fromLTRB(
//       lerpDouble(begin.left, end.left, elasticCurveValue),
//       lerpDouble(begin.top, end.top, elasticCurveValue),
//       lerpDouble(begin.right, end.right, elasticCurveValue),
//       lerpDouble(begin.bottom, end.bottom, elasticCurveValue),
//     );
//   }
// }
//
// class _EnviarMensaWidgetState extends State<EnviarMensaWidget> {
//   //
//   String txtAppBarEnviarMensa = "Nova Mensagem";
//   String labelTextTitle = "Título da mensagem aqui...";
//   String labelTextDescription = "Descrição Mensagem ...";
//   String retDescricaoCampoVazio = 'Campo não pode ser vazio!...';
//   String txtHabBtn = "Solicitar assinatura?";
//   String txtBtnEnviar = "Salvar";
//   //
//   final GlobalKey<ScaffoldState> _chaveEnviarMensa = GlobalKey<ScaffoldState>();
//   final GlobalKey<ScaffoldState> _chaveEnviarMensaWeb =
//       GlobalKey<ScaffoldState>();
//   final _formKeyEnviarMensaMob = GlobalKey<FormState>();
//   final _formKeyEnviarMensaWeb = GlobalKey<FormState>();
//   //
//   TextEditingController _tituloController = new TextEditingController();
//   TextEditingController _descricaoController = new TextEditingController();
//   dynamic dataFormatada =
//       DateFormat('dd/MM/yyyy kk:mm:ss').format(DateTime.now());
//
//   bool switchHabilitado = true;
//   bool campoVazio;
//   bool isVisible = true;
//   StatusModel objMensa;
//   Future<void> chamarBotao() async {
//     setState(() {
//       isVisible = !isVisible;
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     isVisible = false;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _chaveEnviarMensa,
//       body: Container(
//         decoration: AppGradients.gradient,
//         child: ScreenTypeLayout(
//           breakpoints: ScreenBreakpoints(
//             desktop: 899,
//             tablet: 730,
//             watch: 279,
//           ),
//           mobile: OrientationLayoutBuilder(
//             portrait: (context) => _enviarMensaWidgetMobile(),
//             landscape: (context) => _enviarMensaWidgetMobile(),
//           ),
//           tablet: _enviarMensaWidgetWeb(context),
//           desktop: _enviarMensaWidgetWeb(context),
//         ),
//       ),
//     );
//   }
//
//   ///*[MOBILE]
//   Widget _enviarMensaWidgetMobile() {
//     double height = MediaQuery.of(context).size.height;
//     double width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       // key: _formKeyEnviarMensaMob,
//       backgroundColor: Colors.transparent,
//
//       ///*[APPBAR]
//       body: NestedScrollView(
//         headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
//           return <Widget>[
//             SliverAppBar(
//               backgroundColor: Colors.transparent.withOpacity(0.2),
//               expandedHeight: 200.0,
//               floating: true,
//               flexibleSpace: FlexibleSpaceBar(
//                 title: textFormFieldEnviarTitle(context),
//                 background: Stack(
//                   children: [
//                     Container(
//                       color: Colors.transparent,
//                       width: MediaQuery.of(context).size.width,
//                       padding: EdgeInsets.only(top: 30, bottom: 10),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Padding(
//                             padding:
//                                 const EdgeInsets.symmetric(horizontal: 10.0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: [],
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             )
//           ];
//         },
//         body: Container(
//           decoration: AppGradients.gradient,
//           width: MediaQuery.of(context).size.width,
//           height: 300,
//           padding: EdgeInsets.all(20),
//           child: Form(
//             key: _formKeyEnviarMensaMob,
//             child: ListView(
//               // child: Column(
//               children: [
//                 ///*[corpo da mensagem]
//                 textFormFieldEnviarDescription(context),
//                 SizedBox(
//                   height: 20,
//                 ),
//
//                 ///*[btnHabCiencia + btnSalvar]
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     habCiencia(context),
//                     btnEnviarMensa(context, "mob")
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   ///*[WEB]
//   Widget _enviarMensaWidgetWeb(context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         title: Text(txtAppBarEnviarMensa),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: Form(
//           key: _formKeyEnviarMensaWeb,
//           child: ListView(
//             shrinkWrap: true,
//             padding: EdgeInsets.only(left: 24.0, right: 24.0),
//             children: <Widget>[
//               textFormFieldEnviarTitle(context),
//               SizedBox(height: 18.0),
//               textFormFieldEnviarDescription(context),
//               SizedBox(height: 8.0),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   habCiencia(context),
//                   btnEnviarMensa(context, "web"),
//                 ],
//               ),
//               SizedBox(height: 8.0),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   ///*[WIDGETS]
//   Widget textFormFieldEnviarTitle(BuildContext context) {
//     return Container(
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: TextFormField(
//           controller: _tituloController,
//           validator: (value) {
//             if (_tituloController.value.text == null ||
//                 _tituloController.value.text == "") {
//               return retDescricaoCampoVazio;
//             }
//             return null;
//           },
//           decoration: InputDecoration(
//             contentPadding:
//                 const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
//             focusColor: Colors.white,
//             filled: true,
//             fillColor: Color(0xFFe7edeb).withOpacity(.15),
//             //
//             counterStyle: TextStyle(
//                 height: 1,
//                 fontSize: 10.0,
//                 color: Colors.grey,
//                 fontStyle: FontStyle.italic,
//                 fontWeight: FontWeight.bold),
//             //
//             hintText: labelTextTitle,
//             hintStyle: TextStyle(
//                 height: 0.5,
//                 fontSize: 16.0,
//                 color: Colors.grey,
//                 fontStyle: FontStyle.italic,
//                 fontWeight: FontWeight.bold),
//             //
//             errorStyle: TextStyle(
//                 height: 1,
//                 fontSize: 16.0,
//                 color: Colors.orangeAccent,
//                 fontStyle: FontStyle.italic,
//                 fontWeight: FontWeight.bold),
//             //
//             border: new OutlineInputBorder(
//               borderRadius: new BorderRadius.circular(5.0),
//               borderSide: new BorderSide(),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderSide: const BorderSide(color: Colors.white, width: 0.5),
//               borderRadius: BorderRadius.circular(5.0),
//             ),
//           ),
//           style: TextStyle(
//               color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
//           cursorColor: Colors.white,
//           maxLines: 1,
//           maxLength: 65,
//         ),
//       ),
//     );
//   }
//
//   Widget textFormFieldEnviarTitleWeb(BuildContext context) {
//     return new Padding(
//       padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
//       child: Container(
//         child: TextFormField(
//           validator: (value) {
//             if (_tituloController.value.text == null ||
//                 _tituloController.value.text == "") {
//               return retDescricaoCampoVazio;
//             }
//             return null;
//           },
//           style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
//           decoration: InputDecoration(
//             border: OutlineInputBorder(
//               borderSide: BorderSide(width: 2, color: Colors.red),
//               borderRadius: BorderRadius.circular(10.0),
//             ),
//             focusColor: Colors.grey,
//             labelText: labelTextTitle,
//             icon: Icon(Icons.text_fields_rounded, size: 30, color: Colors.grey),
//             labelStyle: TextStyle(
//                 height: 2,
//                 fontSize: 16.0,
//                 color: Colors.grey,
//                 fontStyle: FontStyle.italic,
//                 fontWeight: FontWeight.bold),
//             filled: true,
//             fillColor: Colors.white,
//             errorStyle: TextStyle(
//                 height: 1,
//                 fontSize: 16.0,
//                 color: Colors.orangeAccent,
//                 fontStyle: FontStyle.italic,
//                 fontWeight: FontWeight.bold),
//           ),
//           controller: _tituloController,
//           cursorColor: Colors.grey,
//           maxLines: 1,
//           maxLength: 25,
//           toolbarOptions: ToolbarOptions(
//               copy: true, cut: true, paste: true, selectAll: true),
//         ),
//       ),
//     );
//   }
//
//   Widget textFormFieldEnviarDescription(BuildContext context) {
//     return Container(
//       child: TextFormField(
//         controller: _descricaoController,
//         // The validator receives the text that the user has entered.
//         validator: (value) {
//           if (_descricaoController.value.text == null ||
//               _descricaoController.value.text == "") {
//             return retDescricaoCampoVazio;
//           }
//           return null;
//         },
//
//         decoration: InputDecoration(
//           contentPadding:
//               const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
//           filled: true,
//           fillColor: Color(0xFFe7edeb).withOpacity(.15),
//           //
//           labelStyle: TextStyle(
//               height: 1,
//               fontSize: 16.0,
//               color: Colors.grey,
//               fontStyle: FontStyle.italic,
//               fontWeight: FontWeight.bold),
//           //
//           errorStyle: TextStyle(
//               height: 1,
//               fontSize: 16.0,
//               color: Colors.orangeAccent,
//               fontStyle: FontStyle.italic,
//               fontWeight: FontWeight.bold),
//           //
//           border: new OutlineInputBorder(
//             borderRadius: new BorderRadius.circular(5.0),
//             borderSide: new BorderSide(),
//           ),
//           //
//           focusedBorder: OutlineInputBorder(
//             borderSide: const BorderSide(color: Colors.white, width: 0.5),
//             borderRadius: BorderRadius.circular(5.0),
//           ),
//         ),
//         style: TextStyle(
//             fontWeight: FontWeight.w700,
//             fontSize: 24,
//             color: AppColors.txtSemFundo),
//         cursorColor: Colors.white,
//         minLines: 4,
//         maxLines: 25,
//         autocorrect: false,
//         toolbarOptions:
//             ToolbarOptions(copy: true, cut: true, paste: true, selectAll: true),
//       ),
//     );
//   }
//
//   Widget txtEnviarDescriptionWeb(BuildContext context) {
//     return new Padding(
//       padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
//       child: Container(
//         child: TextFormField(
//           // The validator receives the text that the user has entered.
//           validator: (value) {
//             if (_descricaoController.value.text == null ||
//                 _descricaoController.value.text == "") {
//               return retDescricaoCampoVazio;
//             }
//             return null;
//           },
//           controller: _descricaoController,
//           minLines: 4,
//           maxLines: 15,
//           autocorrect: false,
//           decoration: InputDecoration(
//             labelText: labelTextDescription,
//             icon: Icon(Icons.description, size: 30, color: Colors.grey),
//             labelStyle: TextStyle(
//                 height: 2,
//                 fontSize: 16.0,
//                 color: Colors.grey,
//                 fontStyle: FontStyle.italic,
//                 fontWeight: FontWeight.bold),
//             filled: true,
//             fillColor: Colors.white,
//             errorStyle: TextStyle(
//                 height: 1,
//                 fontSize: 16.0,
//                 color: Colors.orangeAccent,
//                 fontStyle: FontStyle.italic,
//                 fontWeight: FontWeight.bold),
//             border: new OutlineInputBorder(
//               borderRadius: new BorderRadius.circular(10.0),
//               borderSide: new BorderSide(),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget habCiencia(BuildContext context) {
//     double height = MediaQuery.of(context).size.height;
//     double width = MediaQuery.of(context).size.width;
//     final theme = Theme.of(context);
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: <Widget>[
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text(
//             txtHabBtn,
//             style: TextStyle(
//               fontWeight: FontWeight.w700,
//               fontSize: 14,
//               color: AppColors.txtSemFundo,
//             ),
//           ),
//         ),
//         Column(
//           children: [
//             Container(
//               alignment: Alignment.centerRight,
//               child: ConditionalSwitch.single<String>(
//                 context: context,
//                 valueBuilder: (context) => "A",
//                 caseBuilders: {
//                   'A': (context) => new Switch(
//                         activeTrackColor: Colors.orange[200],
//                         activeColor: Colors.orange,
//                         value: switchHabilitado,
//                         onChanged: (value) async {},
//                       ),
//                   'B': (BuildContext context) => Text('B!'),
//                 },
//                 fallbackBuilder: (BuildContext context) => Text('None'),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget btnEnviarMensa(BuildContext context, plataforma) {
//     return new Row(
//       mainAxisAlignment: MainAxisAlignment.end,
//       //align buttoms to the right
//       children: <Widget>[
//         Container(
//           child: MaterialButton(
//             onPressed: () => onPressedSalvarMensa(),
//             highlightColor: Colors.lightBlueAccent,
//             highlightElevation: 8,
//             elevation: 18,
//             shape: StadiumBorder(),
//             child: Text(
//               txtBtnEnviar,
//               style: TextStyle(
//                 color: Estilo().branca,
//               ),
//             ),
//             color: Theme.of(context).backgroundColor,
//             enableFeedback: true,
//           ),
//         )
//       ],
//     );
//   }
//
//   ///* [METODOS]
//   onPressedSalvarMensa() async {
//     if (_formKeyEnviarMensaMob.currentState.validate()) {
//       //salvar dados
//       return await new EnviarMensaBloc()
//           .postEnviarMensagem(context, _tituloController.text,
//               _descricaoController.text, dataFormatada, 1, 0, null, true)
//           .then((value) {
//         AlertDialogTemplate().showAlertDialogSimplesEnviarMensa(
//             context, "", "Mensagem enviada com sucesso!");
//         _tituloController.clear();
//         _descricaoController.clear();
//       });
//     }
//     if (_formKeyEnviarMensaWeb.currentState.validate()) {
//       //salvar dados
//       return await new EnviarMensaBloc()
//           .postEnviarMensagem(context, _tituloController.text,
//               _descricaoController.text, dataFormatada, 1, 0, null, true)
//           .then((value) {
//         AlertDialogTemplate().showAlertDialogSimplesEnviarMensa(
//             context, "", "Mensagem enviada com sucesso!");
//         _tituloController.clear();
//         _descricaoController.clear();
//       });
//     }
//   }
//
//   String validaCampos(value) {
//     if (_tituloController.value.text == null ||
//         _tituloController.value.text == "" &&
//             _descricaoController.value.text == null ||
//         _descricaoController.value.text == "") {
//       return retDescricaoCampoVazio;
//     }
//     return null;
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
// }
