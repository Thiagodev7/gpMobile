import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:gpmobile/src/pages/login/entrar/EntrarModel.dart';

import 'package:gpmobile/src/util/AlertDialogTemplate.dart';
import 'package:gpmobile/src/util/TokenModel.dart';
import 'package:gpmobile/src/util/TokenServices.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'TrocarSenhaServices.dart';

class TrocarSenhaBloc extends BlocBase {
  blocTrocaDeSenha(BuildContext context, String blocNovaSenha,
      int blocNotificar, int blocTrocarSenha, bool blocBarraStatus) async {
    ///[VARIAVEIS]
    TokenModel token;
    LoginModel _trocaSenhaModel;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _usuarioPrefs = prefs.getString('usuario');

    ProgressDialog progressDialog2 = new AlertDialogTemplate()
        .showProgressDialog(context, "Registrando solicitação, aguarde...");
    if (blocBarraStatus == true) {
      await progressDialog2.show();
    }

    await new TokenServices().getToken().then((map) async {
      token = map;

      if (token == null) {
        progressDialog2.hide();
        AlertDialogTemplate()
            .showAlertDialogSimples(context, "Atencão", "Erro ao buscar token");
      } else {
        await new TrocarSenhaServices()
            .postTrocaDeSenha(
          context,
          token.response.token,
          _usuarioPrefs,
          blocNovaSenha,
          blocNotificar,
          blocTrocarSenha
        )
            .then((map) async {
          _trocaSenhaModel = map;
          progressDialog2.hide();

          // if (_trocaSenhaModel == null ||
          //     _trocaSenhaModel.response.pIntCodErro != 0) {
          //   //Caso não encontre usuário no datasul
          //   progressDialog2.hide();

          //   if (blocBarraStatus == true) {
          //     await AlertDialogTemplate().showAlertDialogSimples(
          //         context, "Atencão", "Usuário ou senha inválido");
          //   }
          //   //Caso encontre, armazena dados storage Local
          // } else {
          //   progressDialog2.hide();
          //   await AlertDialogTemplate().showAlertDialogTrocarSenha(
          //       context, "Atencão", "Troca de senha realizada com sucesso!.");
          // }

          ///*[Caso null]
          if (_trocaSenhaModel == null) {
            if (blocBarraStatus == true) {
              await AlertDialogTemplate().showAlertDialogSimples(
                  context, "Atencão", "Usuário ou senha inválido");
            }
          } else if (_trocaSenhaModel.response.pIntCodErro == 0) {
            ///*[Caso == 0]
            if (blocBarraStatus == true) {
              return await AlertDialogTemplate().showAlertDialogSimples(context,
                  "Atencão", "${_trocaSenhaModel.response.pChrDescErro}");
            }

            ///*[Caso erro!]
          } else {
            await AlertDialogTemplate().showAlertDialogSimples(context,
                "Atencão", "${_trocaSenhaModel.response.pChrDescErro}");
          }
        });
      }
    });
    // progressDialog2.hide();
    Navigator.of(context).pop();
    return _trocaSenhaModel;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
