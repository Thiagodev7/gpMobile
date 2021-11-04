// import 'package:flutter/material.dart';
// import 'package:gpmobile/src/pages/mensagens/model/StatusMensaModel.dart';
//
//
// class ProductCard extends StatelessWidget {
//   final StatusModel productDetails;
//
//   ProductCard({@required this.productDetails});
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: (){
//         Navigator.push(context, MaterialPageRoute(builder: (_) => Container()));
//       },
//       child: Padding(
//         padding: EdgeInsets.all(8),
//         child: Card(
//           elevation: 5,
//           child: Container(
//             height: MediaQuery
//                 .of(context)
//                 .size
//                 .height * 0.45,
//             width: MediaQuery
//                 .of(context)
//                 .size
//                 .width * 0.9,
//             child: Column(
//               children: <Widget>[
//                 Hero(
//                   tag: productDetails.id,
//                   child: Image.asset(
//                     '${productDetails.titulo}',
//                     height: MediaQuery
//                         .of(context)
//                         .size
//                         .height *
//                         0.35,
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.all(16),
//                   child: Row(
//                     mainAxisAlignment:
//                     MainAxisAlignment.spaceBetween,
//                     children: <Widget>[
//                       Text(
//                         productDetails.mensagem,
//                         style: TextStyle(
//                             fontWeight: FontWeight.w900,
//                             fontSize: 22,
//                             fontStyle: FontStyle.italic),
//                       ),
//                       Text(
//                         '${productDetails.data} \$',
//                         style: TextStyle(
//                             fontWeight: FontWeight.w900,
//                             fontSize: 22,
//                             fontStyle: FontStyle.italic,
//                             color: Colors.orangeAccent),
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
