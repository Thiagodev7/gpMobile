import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gpmobile/src/pages/contraCheque/ContraChequeService.dart';
import 'package:gpmobile/src/util/AlertDialogTemplate.dart';
import 'package:gpmobile/src/util/TokenModel.dart';
import 'package:gpmobile/src/util/TokenServices.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/ContraChequeModel.dart';

class ContraChequeBloc extends BlocBase {
  Future<ContraChequeModel> getContraChequePeriodo(
      BuildContext context, String mes, String ano, bool barraStatus) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String empresa = prefs.getString('empresa');
    String matricula = prefs.getString('matricula');
    TokenModel token;
    ContraChequeModel _contraCheque;
    ProgressDialog progressDialog = new AlertDialogTemplate()
        .showProgressDialog(context, "Buscando contra-cheque...");
    if (barraStatus == true) {
      await progressDialog.show();
    }

    await new TokenServices().getToken().then((map) async {
      token = map;

      if (token == null) {
        progressDialog.hide();
        AlertDialogTemplate()
            .showAlertDialogSimples(context, "Erro", "Erro ao buscar token");
        return null;
      } else {
        await new ContraChequeService()
            .getContraCheque(
                context, token.response.token, empresa, matricula, mes, ano)
            .then((map) async {
          _contraCheque = map;

          // if (_contraCheque == null ||
          //     _contraCheque.response.pIntCodErro != 0) {
          //   //Caso não encontre usuário no datasul
          //   progressDialog.hide();
          //   if (barraStatus == true) {
          //     await AlertDialogTemplate().showAlertDialogSimples(
          //         context,
          //         "Erro",
          //         "Contra-Cheque nao encontrado! " +
          //             _contraCheque.response.pChrDescErro);
          //   }
          //   return null;
          // } else {
          //   return _contraCheque;
          // }
          progressDialog.hide();

          ///*[Caso null]
          if (_contraCheque == null) {
            if (barraStatus == true) {
              await AlertDialogTemplate().showAlertDialogSimples(
                  context, "Atencão", "Usuário ou senha inválido");
            }
          } else if (_contraCheque.response.pIntCodErro == 0) {
            ///*[Caso == 0]
            if (barraStatus == true) {
              return;
            }

            ///*[Caso erro!]
          } else {
            await AlertDialogTemplate().showAlertDialogSimples(
                context, "Atencão", "${_contraCheque.response.pChrDescErro}");
          }

          ///*
        });
        // await progressDialog.hide();
      }
    });
    return _contraCheque;
  }

  // ignore: missing_return
  Future<String> getContraChequePDF(
      BuildContext context, String mes, String ano, bool barraStatus) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String empresa = prefs.getString('empresa');
    String matricula = prefs.getString('matricula');

    ProgressDialog progressDialog =
        new AlertDialogTemplate().showProgressDialog(context, "Gerando pdf...");
    if (barraStatus == true) {
      await progressDialog.show();
    }

    await new ContraChequeService()
        .getContraChequePDF(context, empresa, matricula, mes, ano)
        .then((map) async {
      if (map != null) {
        print("pdf.....");
        return map;
      } else {
        return null;
      }
    });
    await progressDialog.hide();

    // return _contraCheque;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
