// import 'package:flutter/material.dart';
// import 'package:gpmobile/src/pages/mensagens/model/MensagemEnvioModel.dart';
// import 'package:gpmobile/src/util/mokito/models/chat_model.dart';
// import 'package:gpmobile/src/util/mokito/mokito_mensa_bloc.dart';
// import 'package:gpmobile/src/pages/mensagens/model/StatusMensaModel.dart';
// import 'package:gpmobile/src/util/images.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:gpmobile/src/util/AlertDialogTemplate.dart';
//
// class ChatScreen extends StatefulWidget {
//   @override
//   ChatScreenState createState() => ChatScreenState();
// }
//
// class ChatScreenState extends State<ChatScreen> {
//   ListaMensaBloc listaMensaBloc = ListaMensaBloc();
//   List<StatusModel> listaGlobal;
//   List<StatusModel> listaFinal;
//   List<StatusModel> listaFinal2;
//
//   @override
//   void initState() {
//     super.initState();
//     //inicializar lista
//     listaGlobal = new List();
//     listaFinal = new List();
//     listaFinal2 = new List();
//     //filtrar lista
//     SharedPreferences.getInstance().then((prefs) {
//       listaMensaBloc.getMessageBack(context, true).then((map1) {
//         // StatusModelMok().list().then((map1) {
//         setState(() {
//           if (map1 != null) {
//             listaGlobal = map1;
//
//             if (map1 != null && map1.length > 0) {
//               for (TtMensagens2 indexList in listaGlobal) {
//                 for (String matricula in indexList.matriculasView.split(",")) {
//                   if (matricula == prefs.getString('matricula'))
//                     indexList.lido = true;
//                 }
//                 setState(() {
//                   listaFinal.add(indexList);
//                 });
//               }
//             } else {
//               for (StatusModel mensBack1 in listaGlobal) {
//                 setState(() {
//                   listaFinal.add(mensBack1);
//                 });
//               }
//             }
//             setState(() {
//               listaFinal2.clear();
//               listaFinal2
//                   .addAll(listaFinal.where((element) => element.lido == false));
//             });
//           }
//         });
//       }); //ms
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery.of(context).size.width;
//     double height = MediaQuery.of(context).size.width;
//     return Container(
//       child: Expanded(
//         child: listaFinal2.isEmpty
//             ? Center(
//                 child: Image.asset(
//                   imageLogoGrupoHorizontal,
//                   width: width * 0.5,
//                   height: height * 0.5,
//                   filterQuality: FilterQuality.high,
//                 ),
//               )
//             : Card(
//                 child: ListView.builder(
//                   shrinkWrap: true,
//                   physics: ScrollPhysics(),
//                   itemCount: listaFinal2.length,
//                   itemBuilder: (BuildContext context, int i) {
//                     final objMensa = listaFinal2[i];
//                     return ListTile(
//                       //ACAO ABRIR MENSAGEM
//                       onTap: () {
//                         listaMensaBloc.actionOpenMsg(
//                             context, listaFinal2[i], true);
//                       },
//                       leading: new CircleAvatar(
//                         foregroundColor: Theme.of(context).primaryColor,
//                         backgroundColor: Colors.grey,
//                         backgroundImage:
//                             new NetworkImage(dummyData[i].avatarUrl),
//                       ),
//                       title: new Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: <Widget>[
//                           new Text(
//                             objMensa.titulo,
//                             style: new TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           new Text(
//                             objMensa.data.split(' ').first ==
//                                     periodoAtualGeral.toString() //true == horas
//                                 ? objMensa.data
//                                     .split(' ')
//                                     .last
//                                     .substring(0, 5) //horas
//                                 : objMensa.data.split(' ').first, //dias
//                             style: TextStyle(
//                               fontWeight: objMensa.lido == false
//                                   ? FontWeight.bold
//                                   : FontWeight.normal,
//                               color:
//                                   objMensa.lido == false ? null : Colors.grey,
//                               fontSize: 12,
//                             ),
//                           ),
//                         ],
//                       ),
//                       subtitle: new Container(
//                         padding: const EdgeInsets.only(top: 5.0),
//                         child: new Text(
//                           listaFinal2[i].mensagem,
//                           style:
//                               new TextStyle(color: Colors.grey, fontSize: 15.0),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//       ),
//     );
//   }
// }
