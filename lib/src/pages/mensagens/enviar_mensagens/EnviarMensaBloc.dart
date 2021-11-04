// import 'dart:async';
//
// import 'package:bloc_pattern/bloc_pattern.dart';
// import 'package:flutter/material.dart';
// import 'package:gpmobile/src/pages/mensagens/model/StatusMensaModel.dart';
// import 'package:gpmobile/src/pages/mensagens/vizualizar_mensagens/PageHeroWidget.dart';
// import 'package:gpmobile/src/util/AlertDialogTemplate.dart';
// import 'package:gpmobile/src/util/GenericLogsModel.dart';
// import 'package:gpmobile/src/util/TokenModel.dart';
// import 'package:gpmobile/src/util/TokenServices.dart';
// import 'package:progress_dialog/progress_dialog.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'EnviarMensaService.dart';
//
// /// Veja também:
// ///    [TIPO OPERACAO]
// ///  * [1] create.
// ///  * [2] update.
// ///  * [3] delete 1 por vez.
// ///  * [4] deleteAll.
// ///
// /// * [GenericLogsModel],[_enviarMensagem], é o retorno do service.
// ///
// /// * [matricula], valor recebido via SharedPrefs via LoginBloc.
// ///
// /// * [objMensa.matriculasView], recebe o valor da matricula.
// ///
// /// * [token] variavel token recebe valor via map.
// ///
// /// * [listMatriculas] Listar matricula de quem leu a mensagem.
// ///
// /// * [mensagLidaPeloUsuario], inicia, [FALSE], por default.
// ///
// class EnviarMensaBloc extends BlocBase {
//   Future<void> postEnviarMensagem(
//     BuildContext context,
//     String titulo,
//     String descricao,
//     String data,
//     int operacao,
//     int sequencia,
//     StatusModel objMensa,
//     bool barraStatus,
//   ) async {
//     /// *[VARIAVEIS]
//     TokenModel token;
//     GenericLogsModel _enviarMensagem;
//     ProgressDialog progressDialog2 = new AlertDialogTemplate()
//         .showProgressDialog(context, "Enviando mensagem...");
//     //
//     String chrSistema = "DATASUL";
//     String chrModulo = "APP_DP";
//     String chrPrograma = "MENSAGERIA";
//     String chrRotina = "ENVIAR MENSAGEM";
//     String chrUsuario = "";
//     String chrTexto = "";
//     int intOperacao = operacao;
//     int intSequencia = sequencia;
//     bool mensagemJaLidaAnteriormente = false;
//     //
//     SharedPreferences.getInstance().then(
//       (prefs) {
//         String getMatriculaLocal = prefs.getString('matricula');
//         String getNome = prefs.getString('nomecolaborador');
//         String getEmpresa = prefs.getString('empresa');
//         chrUsuario = getMatriculaLocal + "*-*" + getNome + "*-*" + getEmpresa;
//         //  tem objeto? sim!
//         if (objMensa != null) {
//           //  tem matriculas? sim!
//           if (objMensa.matriculasView != null &&
//               objMensa.matriculasView != "") {
//             //quebrando a matricula com split(",")
//             dynamic quebrado = objMensa.matriculasView.split(",");
//             //percorrer cada index!
//             for (String matriculaBack in quebrado) {
//               if (matriculaBack == getMatriculaLocal) {
//                 //true
//                 mensagemJaLidaAnteriormente = true;
//               } else {
//                 mensagemJaLidaAnteriormente = false;
//               }
//             }
//
//             ///  usuario ja leu? * [sim]
//             if (mensagemJaLidaAnteriormente == true) {
//               chrTexto = titulo +
//                   "*-*" +
//                   descricao +
//                   "*-*" +
//                   data +
//                   "*-*" +
//                   objMensa.matriculasView;
//             }
//
//             ///  usuario ja leu? * [nao]
//             else {
//               chrTexto = titulo +
//                   "*-*" +
//                   descricao +
//                   "*-*" +
//                   data +
//                   "*-*" +
//                   objMensa.matriculasView +
//                   "," +
//                   getMatriculaLocal;
//             }
//             //  tem matriculas? nao!
//           } else {
//             chrTexto = titulo +
//                 "*-*" +
//                 descricao +
//                 "*-*" +
//                 data +
//                 "*-*" +
//                 getMatriculaLocal;
//           }
//           //  tem objeto? nao!
//         } else {
//           return chrTexto = titulo + "*-*" + descricao + "*-*" + data + "*-*";
//         }
//         //
//       },
//     );
//     //
//
//     if (barraStatus == true) {
//       // Future.delayed(Duration(microseconds: 1000)).then((value) {
//
//       // });
//
//       await new TokenServices().getToken().then((map) async {
//         //pegar token
//         token = map;
//
//         if (token == null) {
//           //validar token
//           progressDialog2.hide();
//           AlertDialogTemplate()
//               .showAlertDialogSimples(context, "Erro", "Erro ao buscar token");
//           return null;
//         } else {
//           //tem token? [SIM]
//           // progressDialog2.show();
//           await new EnviarMensaService()
//               //enviando dados para o service...
//               .postEnviarMensa(
//                   context,
//                   token.response.token,
//                   chrSistema,
//                   chrModulo,
//                   chrPrograma,
//                   chrRotina,
//                   chrUsuario,
//                   intOperacao,
//                   intSequencia,
//                   chrTexto)
//               .then((map) async {
//             _enviarMensagem = map;
//
//             // if (_enviarMensagem == null) {
//             //   //Caso retorne null
//             //   if (barraStatus == false) {
//             //     progressDialog2.hide();
//             //     await AlertDialogTemplate().showAlertDialogSimples(
//             //         context,
//             //         "Atencao",
//             //         "Erro ao enviar arquivo! \nerro:" +
//             //             _enviarMensagem.response.pChrDescErro);
//             //   }
//             // }
//             progressDialog2.hide();
//
//             ///*[Caso null]
//             if (_enviarMensagem == null) {
//               if (barraStatus == true) {
//                 await AlertDialogTemplate().showAlertDialogSimples(
//                     context, "Atencão", "Usuário ou senha inválido");
//               }
//             } else if (_enviarMensagem.response.pIntCodErro == 0) {
//               ///*[Caso == 0]
//               return _enviarMensagem;
//
//               ///*[Caso erro!]
//             } else {
//               await AlertDialogTemplate().showAlertDialogSimples(context,
//                   "Atencão", "${_enviarMensagem.response.pChrDescErro}");
//             }
//
//             ///*
//           });
//         }
//       });
//       progressDialog2.hide();
//       return _enviarMensagem;
//     }
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
// }
