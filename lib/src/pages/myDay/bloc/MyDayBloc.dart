import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gpmobile/src/util/AlertDialogTemplate.dart';
import 'package:gpmobile/src/util/TokenModel.dart';
import 'package:gpmobile/src/util/TokenServices.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/MyDayModel.dart';
import '../MyDayService.dart';

class MyDayBloc extends BlocBase {
  Future<MyDayModel> getMyDays(
      BuildContext context, String obs, bool barraStatus) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String pchrEmpresa = prefs.getString('empresa');
    String pchrmatricula = prefs.getString('matricula');
    TokenModel token;
    MyDayModel userMyDay;
    ProgressDialog progressDialog = new AlertDialogTemplate()
        .showProgressDialog(context, "Buscando meu dia...");
    if (barraStatus == true) {
      await progressDialog.show();
    }

    await new TokenServices().getToken().then((map) async {
      token = map;

      if (token == null) {
        progressDialog.hide();
        AlertDialogTemplate()
            .showAlertDialogSimples(context, "Atencao", "Erro ao buscar token");
        progressDialog.hide();
        return null;
      } else {
        await new MyDayService()
            .getMeuDia(
                context, token.response.token, pchrEmpresa, pchrmatricula, obs)
            .then((map) async {
          userMyDay = map;
          //se erro
          if (userMyDay.response == null ||
              userMyDay.response.pIntCodErro != 0) {
            //Caso não encontre usuário no datasul
            await progressDialog.hide();
            if (barraStatus == true) {
              await AlertDialogTemplate().showAlertDialogSimples(
                  context,
                  "Atencao",
                  "Tabela nao encontrada! " + userMyDay.response.pChrDescErro);
            }
            return null;
          } else {
            return userMyDay;
          }
        });
        await progressDialog.hide();
      }
    });
    return userMyDay;
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }
}
