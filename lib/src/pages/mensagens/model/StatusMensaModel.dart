// // import 'package:stacked/stacked.dart';
//
// import 'package:stacked/stacked.dart';
//
// class StatusModel extends BaseViewModel {
//   int id;
//   String data;
//   String titulo;
//   String mensagem;
//   int sequencia;
//   String matriculasView;
//   bool lido;
//   bool aceite;
//
//   StatusModel({
//     this.id,
//     this.data,
//     this.titulo,
//     this.mensagem,
//     this.sequencia,
//     this.lido,
//     this.aceite,
//   });
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['data'] = this.data;
//     data['titulo'] = this.titulo;
//     data['mensagem'] = this.mensagem;
//     data['sequencia'] = this.sequencia;
//     data['matriculasView'] = this.matriculasView;
//     data['lido'] = this.lido;
//     data['aceite'] = this.aceite;
//     return data;
//   }
//
//   StatusModel.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     data = json['data'];
//     titulo = json['titulo'];
//     mensagem = json['mensagem'];
//     sequencia = json['sequencia'];
//     matriculasView = json['matriculasView'];
//     lido = json['lido'];
//     aceite = json['aceite'];
//   }
// ////////////////////db Sqflite///////////////////////////////////
//   Map<String, dynamic> toMap() {
//     //Importante! conversao para salvar no banco
//     final map = <String, dynamic>{
//       "id": id,
//       "data": data,
//       "titulo": titulo,
//       "mensagem": mensagem,
//       "sequencia": sequencia,
//       "matriculasView": matriculasView,
//       "lido": lido,
//       "aceite": aceite,
//     };
//     return map;
//   }
//
//   StatusModel.fromMap(Map<String, dynamic> map) {
//     //Importante! conversao para buscar do banco
//     id = map['id'];
//     data = map['data'];
//     titulo = map['titulo'];
//     mensagem = map['mensagem'];
//     sequencia = map['sequencia'];
//     matriculasView = map['matriculasView'];
//     lido = map['lido'];
//     aceite = map['aceite'];
//   }
//
//   @override
//   String toString() {
//     return "StatusModel => (id: $id,data: $data, titulo: $titulo, mensagem: $mensagem, sequencia: $sequencia,matriculasView: $matriculasView, lido: $lido, aceite: $aceite)";
//   }
//
//   void updateTile(String value) {
//     titulo = value;
//     notifyListeners();
//   }
// }
