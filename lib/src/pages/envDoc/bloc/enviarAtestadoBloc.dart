import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:gpmobile/src/pages/envDoc/model/enviarAtestadoModel.dart';
import 'package:gpmobile/src/pages/envDoc/service/enviarAtestadoService.dart';
import 'package:gpmobile/src/util/AlertDialogTemplate.dart';
import 'package:gpmobile/src/util/TokenModel.dart';
import 'package:gpmobile/src/util/TokenServices.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EnviarAtestadoBloc extends BlocBase {
  ///////////////////////
  Future<EnviarAtestadoModel> getEnvAtestado(
      {BuildContext context,
      bool barraStatus,
      String hospital,
      String medico,
      String crmcro,
      String inicioAfastamento,
      String fimAfastamento,
      String justificativa,
      String cid,
      String arquivo}) async {
    //
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String empresa = prefs.getString('empresa');
    String usuario = prefs.getString('usuario');
    String matricula = prefs.getString('matricula');

    //

    //
    TokenModel token;
    EnviarAtestadoModel enviarAtestadoModel;

    ProgressDialog progressDialog = new AlertDialogTemplate()
        .showProgressDialog(context, "Carregando Atestado...");
    if (barraStatus == true) {
      await progressDialog.show();
    }

    await new TokenServices().getToken().then((map) async {
      token = map;

      if (token == null) {
        progressDialog.hide();
        AlertDialogTemplate()
            .showAlertDialogSimples(context, "Atencao", "Erro ao buscar token");

        return null;
      } else {
        await new EnviarAtestadoService()
            .postListAtest(
                context,
                token.response.token,
                empresa,
                usuario,
                matricula,
                hospital,
                medico,
                crmcro,
                inicioAfastamento,
                fimAfastamento,
                justificativa,
                cid,
                arquivo)
            .then((map) async {
          enviarAtestadoModel = map;

          progressDialog.hide();

          ///*[Caso null]
          if (enviarAtestadoModel == null) {
            if (barraStatus == true) {
              await AlertDialogTemplate().showAlertDialogSimples(
                  context, "Atencão", "Tabela de de arquivos nao encontrado!");
            }
          } else if (enviarAtestadoModel.success == true) {
            ///*[Caso == 0]
            return enviarAtestadoModel;

            ///*[Caso erro!]
          } else {
            await AlertDialogTemplate().showAlertDialogSimples(
                context, "Atencão", "${enviarAtestadoModel.errorMessage}");
          }
        });
      }
    });
    return enviarAtestadoModel;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
