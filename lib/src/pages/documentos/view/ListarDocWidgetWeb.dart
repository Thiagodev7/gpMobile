// //https://github.com/iang12/flutter_url_launcher_example/blob/master/lib/main.dart

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:gpmobile/src/pages/documentos/view/ListaDocNovosWidgets.dart';
// import 'package:gpmobile/src/pages/documentos/view/ListarDocLidasWidget.dart';
// import 'package:gpmobile/src/pages/mensagens/listar_mensagens/ListaMensaLidas.dart';
// import 'package:gpmobile/src/pages/mensagens/listar_mensagens/ListaMensaNovas.dart';

// ///*[referencia tabbar] https://medium.com/flutterworld/flutter-tabbar-and-tricks-4f36e06025a4
// import 'package:gpmobile/src/pages/mensagens/model/MensagemEnvioModel.dart';
// import 'package:gpmobile/src/util/Estilo.dart';
// import 'package:responsive_builder/responsive_builder.dart';

// class ListaDocWidgetWeb extends StatefulWidget {
//   @override
//   _ListaDocWidgetWebState createState() => _ListaDocWidgetWebState();
// }

// class _ListaDocWidgetWebState extends State<ListaDocWidgetWeb>
//     with SingleTickerProviderStateMixin {
//   //
//   final GlobalKey<ScaffoldState> _scaffoldKeyListaDocWidgetWeb =
//       GlobalKey<ScaffoldState>();
//   int indexPage;
//   int count = 0;
//   TtMensagens2 objDocEndDrawer;
//   TabController _tabController;
//   //
//   // List<Widget> tabBarList = [
//   //   Tab(text: "NOVOS DOCUMENTOS"),
//   //   // Tab(text: "DOCUMENTOS LIDAS"),
//   // ];

//   List<Widget> childrens = <Widget>[
//     new ListaDocNovos(),
//     // new ListaDocLidasWidget(),
//   ];
//   //
//   @override
//   void initState() {
//     _tabController = TabController(
//       initialIndex: 0,
//       // length: tabBarList.length,
//       vsync: this,
//     );
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _tabController.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       key: _scaffoldKeyListaDocWidgetWeb,
//       body: Container(
//         color: Colors.transparent.withOpacity(0.2),
//         //decoration: AppGradients.gradient,
//         child: ScreenTypeLayout(
//           breakpoints: ScreenBreakpoints(desktop: 899, tablet: 730, watch: 279),
//           mobile: OrientationLayoutBuilder(
//             portrait: (context) => _buildWeb(),
//             landscape: (context) => _buildWeb(),
//           ),
//           tablet: _buildWeb(),
//           desktop: _buildWeb(),
//         ),
//       ),
//     );
//   }

//   ///*WEB
//   Widget _buildWeb() {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         automaticallyImplyLeading: false,
//         title: Text("DOCUMENTOS"),
//         centerTitle: true,
//         elevation: 0.7,
//         // bottom: TabBar(
//         //   controller: _tabController,
//         //   indicatorColor: Colors.white,
//         //   tabs: tabBarList,
//         //),
//       ),
//       body: TabBarView(
//           physics: NeverScrollableScrollPhysics(),
//           controller: _tabController,
//           children: childrens),
//     );
//   }
// }
