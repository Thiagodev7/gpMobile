// import 'dart:convert';
// import 'package:flutter/material.dart';
//
// import 'package:gpmobile/src/util/AlertDialogTemplate.dart';
// import 'package:gpmobile/src/util/BuscaUrl.dart';
// import 'package:gpmobile/src/util/GenericLogsModel.dart';
// import 'package:http/http.dart' as http;
//
// /// Veja também:
// ///    [TIPO OPERACAO]
// ///  * [1] create.
// ///  * [2] update.
// ///  * [3] delete 1 por vez.
// ///  * [4] deleteAll.
// ///
// ///
// class EnviarMensaService {
//   Future<GenericLogsModel> postEnviarMensa(
//     BuildContext context,
//     String token,
//     String chrSistema,
//     String chrModulo,
//     String chrPrograma,
//     String chrRotina,
//     String chrUsuario,
//     int intOperacao,
//     int intSequencia,
//     String chrTexto,
//   ) async {
//     try {
//       final response = await http.post(
//         await new BuscaUrl().url("enviarMensa") +
//             token +
//             "&chrSistema=" +
//             chrSistema +
//             "&chrModulo=" +
//             chrModulo +
//             "&chrPrograma=" +
//             chrPrograma +
//             "&chrRotina=" +
//             chrRotina +
//             "&chrUsuario=" +
//             chrUsuario +
//             "&intOperacao=" +
//             intOperacao.toString() +
//             "&intSequencia=" +
//             intSequencia.toString(),
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//         },
//         body: jsonEncode({
//           'request': {'chrTexto': chrTexto}
//         }),
//       );
//
//       if (response.statusCode == 200) {
//         var descodeJson = jsonDecode(response.body);
//         GenericLogsModel _enviarMensagem =
//             GenericLogsModel.fromJson(descodeJson);
//         return _enviarMensagem;
//       } else {
//         await new AlertDialogTemplate().showAlertDialogSimples(
//             context,
//             "Atenção",
//             "Error ao enviar Mensagem! \n" +
//                 "Código Erro: " +
//                 response.statusCode.toString());
//         return null;
//       }
//     } catch (e) {
//       await new AlertDialogTemplate().showAlertDialogSimples(
//         context,
//         "Atenção",
//         "Error ao enviar Mensagem! \n" + e.toString(),
//       );
//       return null;
//     }
//   }
// }
