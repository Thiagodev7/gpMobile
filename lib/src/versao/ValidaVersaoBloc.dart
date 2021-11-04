import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gpmobile/src/util/AlertDialogTemplate.dart';
import 'package:gpmobile/src/util/TokenModel.dart';
import 'package:gpmobile/src/util/TokenServices.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'ValidaVersaoModel.dart';
import 'ValidaVersaoService.dart';

class ValidaVersaoBloc extends BlocBase {
/////////Verificar Versao do APP//////////
  Future<dynamic> getUltimaVersaoLiberada(
      BuildContext context, bool barraStatus) async {
    TokenModel token;
    ValidaVersaoModel validaVersaoModel;

    // ProgressDialog progressDialog = new AlertDialogTemplate()
    //     .showProgressDialog(context, "Verificando versao...");
    // if (barraStatus == true) {
    //   await progressDialog.show();
    // }

    await new TokenServices().getToken().then((map) async {
      token = map;

      if (token == null) {
        // progressDialog.hide();
        AlertDialogTemplate()
            .showAlertDialogSimples(context, "Atencao", "Erro ao buscar token");
        // progressDialog.hide();
        return null;
      } else {
        await new ValidaVersaoService()
            .getVersaoService(context, token.response.token)
            .then((map) async {
          validaVersaoModel = map;
          //   //se erro
          //   if (validaVersaoModel.response == null ||
          //       validaVersaoModel.response.pIntCodErro != 0) {
          //     //Caso não encontre usuário no datasul
          //     // await progressDialog.hide();
          //     if (barraStatus == true) {
          //       // await AlertDialogTemplate().showAlertDialogSimples(
          //       //     context,
          //       //     "Atencao",
          //       //     "Erro ao buscar versao no webservice! \n" +
          //       //         validaVersaoModel.response.pChrDescErro);
          //       print("Erro ao buscar versao no webservice! \n" +
          //           validaVersaoModel.response.pChrDescErro);
          //     }
          //     return null;
          //   } else {
          //     return validaVersaoModel.response.pDec;
          //   }
          ///*
          // await progressDialog.hide();

          ///*[Caso null]
          if (validaVersaoModel == null) {
            if (barraStatus == true) {
              await AlertDialogTemplate().showAlertDialogSimples(
                  context, "Atencão", "Erro ao buscar versao no webservice!");
            }
          } else if (validaVersaoModel.response.pIntCodErro == 0) {
            ///*[Caso == 0]
            return validaVersaoModel.response.pDec;

            ///*[Caso erro!]
          } else {
            await AlertDialogTemplate().showAlertDialogSimples(context,
                "Atencão", "${validaVersaoModel.response.pChrDescErro}");
          }

          ///*
        });
      }
    });
    return validaVersaoModel.response.pDec;
  }

  static double getVersaoAppDp() {
    return 1.1;
  }
}
