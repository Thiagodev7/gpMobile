// import 'package:flutter/material.dart';
// import 'package:flutter_conditional_rendering/conditional_switch.dart';
// import 'package:gpmobile/src/mokito/mokito_mensa_bloc.dart';
// import 'package:gpmobile/src/pages/mensagens/enviar_mensagens/EnviarMensaBloc.dart';
// import 'package:gpmobile/src/pages/mensagens/model/StatusMensaModel.dart';
// import 'package:gpmobile/src/util/Estilo.dart';
// import 'package:responsive_builder/responsive_builder.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:math';

// import 'PageHeroWidget.dart';

// class DetailsMensaWidget extends StatefulWidget {
//   DetailsMensaWidget(this.objMensa, this.objMensaDetails);
//   HeroType objMensa;
//   final StatusModel objMensaDetails;
//   GlobalKey<ScaffoldState> _scaffoldKeyDetailsMensaWidget;
//   List<StatusModel> listaFinal2 = [];
//   //
//   StatusModel objDetailsEndDrawer;
//   int indexPage;
//   int count = 0;
//   String origemClick = "";
//   Random random = Random();
//   //
//   @override
//   _DetailsMensaWidgetState createState() => _DetailsMensaWidgetState();
// }

// class _DetailsMensaWidgetState extends State<DetailsMensaWidget> {
//   @override
//   void initState() {
//     widget._scaffoldKeyDetailsMensaWidget = widget.key;
//     //atuliza status
//     new EnviarMensaBloc().postEnviarMensagem(
//         context,
//         widget.objMensaDetails.titulo,
//         widget.objMensaDetails.mensagem,
//         widget.objMensaDetails.data,
//         2,
//         widget.objMensaDetails.sequencia,
//         widget.objMensaDetails,
//         true);
//     super.initState();
//     //listar mensagens
//     SharedPreferences.getInstance().then((prefs) {
//       ListaMensaBloc().getMessageBack(context, true).then((map2) {
//         List<StatusModel> listaMapeada = map2;
//         setState(() {
//           if (map2 != null) {
//             widget.listaFinal2 = listaMapeada;
//             for (StatusModel mensagem in widget.listaFinal2) {
//               for (String matricula in mensagem.matriculasView.split(",")) {
//                 if (matricula == prefs.getString('matricula')) {
//                   mensagem.lido = true;
//                 }
//               }
//             }
//           }
//         });
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: widget._scaffoldKeyDetailsMensaWidget,
//       body: Container(
//         decoration: AppGradients.gradient,
//         child: ScreenTypeLayout(
//           breakpoints: ScreenBreakpoints(desktop: 899, tablet: 730, watch: 279),
//           mobile: OrientationLayoutBuilder(
//             portrait: (context) => DetailsMensaWidgetMobile(
//                 context: context, widget: widget, list: widget.listaFinal2),
//             landscape: (context) =>
//                 DetailsMensaWidgetMobile(context: context, widget: widget),
//           ),
//           tablet: DetailsMensaWidgetWeb(context: context, widget: widget),
//           desktop: DetailsMensaWidgetWeb(context: context, widget: widget),
//         ),
//       ),
//       endDrawer: ConditionalSwitch.single<String>(
//         context: context,
//         valueBuilder: (BuildContext context) => widget.origemClick,
//         caseBuilders: {
//           'detailsMensa': (BuildContext context) => new DetailsMensaWidget(
//               widget.objMensa, widget.objDetailsEndDrawer),
//         },
//         fallbackBuilder: (BuildContext context) {
//           return Card(
//             color: Colors.white,
//             child: Row(
//               children: <Widget>[
//                 IconButton(
//                   onPressed: () {
//                     // setState(() {
//                     widget.count = widget.count - 1;
//                     Navigator.of(context).pop();
//                     // });
//                   },
//                   icon: Icon(Icons.close, size: 60, color: Colors.red),
//                 ),
//                 const SizedBox(
//                   width: 10.0,
//                 ),
//                 const Text(
//                   'tela TESTE vazia!!!',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//       //bloqueia acesso ao Drawer no mobile and web
//       endDrawerEnableOpenDragGesture: false,
//     );
//   }
// }

// class DetailsMensaWidgetMobile extends StatelessWidget {
//   const DetailsMensaWidgetMobile({
//     Key key,
//     @required this.widget,
//     @required this.context,
//     this.list,
//   }) : super(key: key);

//   final DetailsMensaWidget widget;
//   final BuildContext context;
//   final List list;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,

//       ///*[APPBAR]
//       body: NestedScrollView(
//         headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
//           return <Widget>[
//             SliverAppBar(
//               // iconTheme: IconThemeData.fallback(),
//               backgroundColor: Colors.transparent.withOpacity(0.2),
//               expandedHeight: 300.0,
//               floating: true,
//               // pinned: true,

//               flexibleSpace: FlexibleSpaceBar(
//                 title: Text(
//                   '${widget.objMensaDetails.titulo}',
//                   style: TextStyle(
//                     fontSize: 25,
//                     color: Colors.white,
//                   ),
//                 ),
//                 background: Stack(
//                   children: [
//                     Center(
//                         child: Icon(
//                       Icons.message,
//                       size: 50,
//                       color: Colors.white,
//                     )),
//                     // Container(
//                     //   width: MediaQuery.of(context).size.width,
//                     //   height: double.infinity,
//                     //   child: Image.asset(
//                     //     imageLogoMessage,
//                     //     scale: 4.0,
//                     //     centerSlice: new Rect.fromLTRB(1.0, 1.0, 150.0, 70.0),
//                     //     fit: BoxFit.fill,
//                     //   ),
//                     // ),
//                     Container(
//                       // decoration: BoxDecoration(
//                       //   gradient: Colors.transparent,
//                       // ),
//                       color: Colors.transparent,
//                       width: MediaQuery.of(context).size.width,
//                       padding: EdgeInsets.only(top: 30, bottom: 10),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           // Text(
//                           //   "World",
//                           //   style: TextStyle(
//                           //       color: Colors.white,
//                           //       fontSize: 25,
//                           //       fontFamily: "Sigmar"),
//                           // ),
//                           Padding(
//                             padding:
//                                 const EdgeInsets.symmetric(horizontal: 10.0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: [
//                                 // Container(
//                                 //   height: 45,
//                                 //   decoration:
//                                 //       BoxDecoration(shape: BoxShape.circle),
//                                 //   child: ClipRRect(
//                                 //     borderRadius: BorderRadius.circular(100),
//                                 //     child: Image.asset(
//                                 //       imageLogoLogin,
//                                 //       fit: BoxFit.cover,
//                                 //     ),
//                                 //   ),
//                                 // ),
//                                 // Text(
//                                 //   "12:00 hours ago",
//                                 //   style: TextStyle(
//                                 //     color: Colors.white,
//                                 //   ),
//                                 // )
//                               ],
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

//         ///*[BODY]
//         body: Container(
//           decoration: AppGradients.gradient,
//           width: MediaQuery.of(context).size.width,
//           height: 300,
//           padding: EdgeInsets.all(20),
//           child: ListView(
//             children: [
//               Text(
//                 "${widget.objMensaDetails.mensagem}",
//                 style: TextStyle(
//                   fontWeight: FontWeight.w700,
//                   fontSize: 24,
//                   color: AppColors.txtSemFundo,
//                 ),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               Text(
//                 " ${widget.objMensaDetails.data}",
//                 style: TextStyle(
//                   fontSize: 18,
//                   color: AppColors.txtSemFundo,
//                 ),
//               ),
//               SizedBox(
//                 height: 20,
//               ),

//               ///*[lista horizontal]
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(
//                   "Veja outras mensagens:",
//                   style: TextStyle(
//                     fontWeight: FontWeight.w700,
//                     fontSize: 24,
//                     color: AppColors.txtSemFundo,
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 20,
//               ),

//               Container(
//                 height: MediaQuery.of(context).size.height * 0.24,
//                 child: ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: list.length,
//                   scrollDirection: Axis.horizontal,
//                   itemBuilder: (ctx, i) {
//                     StatusModel objMensaDetails = list[i];
//                     return GestureDetector(
//                       onTap: () {
//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(
//                             builder: (ctx) => DetailsMensaWidget(
//                                 widget.objMensa, widget.objDetailsEndDrawer),
//                           ),
//                         );
//                       },
//                       child: Stack(
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: objMensaDetails.lido == false
//                                 ? Icon(
//                                     Icons.messenger,
//                                     color: Colors.greenAccent[400],
//                                   )
//                                 : Icon(Icons.messenger),
//                           ),
//                           Container(
//                             margin: EdgeInsets.all(5),
//                             width: MediaQuery.of(context).size.width * 0.36,
//                             decoration: BoxDecoration(
//                               color: AppColors.primary.withOpacity(0.55),
//                               // image: DecorationImage(
//                               //   image: AssetImage(imageLogoMessage),
//                               //   fit: BoxFit.fill,
//                               // ),
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: Container(
//                               height: double.infinity,
//                               width: double.infinity,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10),
//                                 gradient: LinearGradient(
//                                   colors: [
//                                     Colors.transparent,
//                                     Colors.black.withOpacity(0.9)
//                                   ],
//                                   begin: Alignment.topCenter,
//                                   stops: [0.5, 1],
//                                   end: Alignment.bottomCenter,
//                                 ),
//                               ),
//                               padding: EdgeInsets.all(10),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Spacer(),
//                                   Text(
//                                     objMensaDetails.mensagem,
//                                     maxLines: 2,
//                                     overflow: TextOverflow.fade,
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     height: 5,
//                                   ),
//                                   Text(
//                                     "${objMensaDetails.data}",
//                                     style: TextStyle(
//                                       color: Colors.white.withOpacity(0.5),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class DetailsMensaWidgetWeb extends StatelessWidget {
//   DetailsMensaWidgetWeb({
//     Key key,
//     @required this.widget,
//     this.context,
//     this.list,
//     this.onPressed,
//   }) : super(key: key);

//   final DetailsMensaWidget widget;
//   final VoidCallback onPressed;
//   final BuildContext context;
//   final List list;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,

//       ///*[APPBAR]
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: NestedScrollView(
//           headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
//             return <Widget>[
//               SliverAppBar(
//                 // iconTheme: IconThemeData.fallback(),
//                 backgroundColor: Colors.transparent,
//                 expandedHeight: 200.0,
//                 floating: true,
//                 // pinned: true,

//                 flexibleSpace: FlexibleSpaceBar(
//                   title: Text(
//                     '${widget.objMensaDetails.titulo}',
//                     style: TextStyle(
//                       fontSize: 20,
//                       color: Colors.white,
//                     ),
//                   ),
//                   background: Stack(
//                     children: [
//                       Center(
//                           child: Icon(
//                         Icons.message,
//                         size: 40,
//                         color: Colors.white,
//                       )),
//                       // Container(
//                       //   width: MediaQuery.of(context).size.width,
//                       //   height: double.infinity,
//                       //   child: Image.asset(
//                       //     imageLogoMessage,
//                       //     scale: 4.0,
//                       //     centerSlice: new Rect.fromLTRB(1.0, 1.0, 150.0, 70.0),
//                       //     fit: BoxFit.fill,
//                       //   ),
//                       // ),
//                       Container(
//                         // decoration: BoxDecoration(
//                         //   gradient: Colors.transparent,
//                         // ),
//                         color: Colors.transparent,
//                         width: MediaQuery.of(context).size.width,
//                         padding: EdgeInsets.only(top: 30, bottom: 10),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             // Text(
//                             //   "World",
//                             //   style: TextStyle(
//                             //       color: Colors.white,
//                             //       fontSize: 25,
//                             //       fontFamily: "Sigmar"),
//                             // ),
//                             Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 10.0),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: [
//                                   // Container(
//                                   //   height: 45,
//                                   //   decoration:
//                                   //       BoxDecoration(shape: BoxShape.circle),
//                                   //   child: ClipRRect(
//                                   //     borderRadius: BorderRadius.circular(100),
//                                   //     child: Image.asset(
//                                   //       imageLogoLogin,
//                                   //       fit: BoxFit.cover,
//                                   //     ),
//                                   //   ),
//                                   // ),
//                                   // Text(
//                                   //   "12:00 hours ago",
//                                   //   style: TextStyle(
//                                   //     color: Colors.white,
//                                   //   ),
//                                   // )
//                                 ],
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               )
//             ];
//           },

//           ///*[BODY]
//           body: Container(
//             decoration: AppGradients.gradient,
//             width: MediaQuery.of(context).size.width,
//             height: 300,
//             padding: EdgeInsets.all(20),
//             child: ListView(
//               children: [
//                 Text(
//                   "${widget.objMensaDetails.mensagem}",
//                   style: TextStyle(
//                     fontWeight: FontWeight.w700,
//                     fontSize: 24,
//                     color: AppColors.txtSemFundo,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Text(
//                   " ${widget.objMensaDetails.data}",
//                   style: TextStyle(
//                     fontSize: 18,
//                     color: AppColors.txtSemFundo,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),

//                 ///*[lista horizontal]
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(
//                     "Veja outras mensagens:",
//                     style: TextStyle(
//                       fontWeight: FontWeight.w700,
//                       fontSize: 24,
//                       color: AppColors.txtSemFundo,
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Container(
//                   height: MediaQuery.of(context).size.height * 0.2,
//                   child: ListView.builder(
//                     shrinkWrap: true,
//                     itemCount: list.length,
//                     scrollDirection: Axis.horizontal,
//                     itemBuilder: (ctx, i) {
//                       StatusModel objMensaDetails = list[i];
//                       return GestureDetector(
//                         onTap: () {
//                           _metthodDetailsMensaWeb(list[i], i);
//                         },
//                         child: Stack(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: objMensaDetails.lido == false
//                                   ? Icon(
//                                       Icons.messenger,
//                                       color: Colors.greenAccent[400],
//                                     )
//                                   : Icon(Icons.messenger),
//                             ),
//                             Container(
//                               margin: EdgeInsets.all(5),
//                               width: MediaQuery.of(context).size.width * 0.36,
//                               decoration: BoxDecoration(
//                                 color: AppColors.primary.withOpacity(0.55),
//                                 // image: DecorationImage(
//                                 //   image: AssetImage(imageLogoMessage),
//                                 //   fit: BoxFit.fill,
//                                 // ),
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               child: Container(
//                                 height: double.infinity,
//                                 width: double.infinity,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(10),
//                                   gradient: LinearGradient(
//                                     colors: [
//                                       Colors.transparent,
//                                       Colors.black.withOpacity(0.9)
//                                     ],
//                                     begin: Alignment.topCenter,
//                                     stops: [0.5, 1],
//                                     end: Alignment.bottomCenter,
//                                   ),
//                                 ),
//                                 padding: EdgeInsets.all(10),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Spacer(),
//                                     Text(
//                                       objMensaDetails.mensagem,
//                                       maxLines: 2,
//                                       overflow: TextOverflow.fade,
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 5,
//                                     ),
//                                     Text(
//                                       "${objMensaDetails.data}",
//                                       style: TextStyle(
//                                         color: Colors.white.withOpacity(0.5),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   //METODOS COMPARTILHADOS
//   Future<int> _openEndDrawer(i) async {
//     widget.indexPage = i;
//     widget._scaffoldKeyDetailsMensaWidget.currentState.openEndDrawer();
//   }

//   closeEndDrawer() {
//     // setState(() {
//     widget.count = widget.count - 1;
//     Navigator.of(context).pop();
//     // });
//   }

//   void _metthodDetailsMensaWeb(objMensa, pageIndex) {
//     String tituloViewMensa = objMensa.titulo;
//     String mensgViewMensa = objMensa.mensagem;
//     String dataViewMensa = objMensa.data;
//     int sequenciaViewMensa = objMensa.sequencia;
//     bool lidoViewMensa = objMensa.lido = true; //objMensa.lido true == lido!
//     //
//     //atualiza status datasul

//     EnviarMensaBloc()
//         .postEnviarMensagem(context, tituloViewMensa, mensgViewMensa,
//             dataViewMensa, 2, sequenciaViewMensa, objMensa, lidoViewMensa)
//         .then((map) async {
//       // setState(() {
//       widget.origemClick = "detailsMensa";
//       widget.objDetailsEndDrawer = objMensa;
//       _openEndDrawer(pageIndex);
//       // });
//     });

//     // });
//   }
// }
