// import 'package:flutter/cupertino.dart';
// import 'package:gpmobile/src/pages/home/HomeWidget.dart';
// import 'package:gpmobile/src/pages/mensagens/model/StatusMensaModel.dart';
//
// class MensagensRepository extends ChangeNotifier {
//   List<StatusModel> _lista = [];
//
//   // HomeWidget<StatusModel> get lista => HomeWigdet(_lista);
//
//   saveAll(List<StatusModel> statusModel) {
//     statusModel.forEach((status) {
//       if (!_lista.contains(status)) _lista.add(status);
//     });
//     notifyListeners();
//   }
//
//   remove(StatusModel status) {
//     _lista.remove(status);
//     notifyListeners();
//   }
// }