import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:gpmobile/src/pages/bcoHoras/model/BcoHorasModel.dart';
import 'package:gpmobile/src/pages/bcoHoras/BcoHorasServices.dart';
import 'package:gpmobile/src/util/AlertDialogTemplate.dart';
import 'package:gpmobile/src/util/TokenModel.dart';
import 'package:gpmobile/src/util/TokenServices.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BcoHorasBloc extends BlocBase {
  Future<BcoHorasModel> getBancoHoras(
      BuildContext context, bool barraStatus) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String pchrEmpresa = prefs.getString('empresa');
    String pintMatricula = prefs.getString('matricula');
    String cpfColaborador = prefs.getString('usuario');

    TokenModel token;
    BcoHorasModel _bcoHoras;
    ProgressDialog progressDialog = new AlertDialogTemplate()
        .showProgressDialog(context, "Buscando seu Banco de Horas...");
    if (barraStatus == true) {
      await progressDialog.show();
    }

    await new TokenServices().getToken().then((map) async {
      token = map;

      if (token == null) {
        progressDialog.hide();
        AlertDialogTemplate()
            .showAlertDialogSimples(context, "Erro", "Erro ao buscar token");
        progressDialog.hide();
        return null;
      } else {
        await new BcoHorasService()
            .getBcoHoras(context, token.response.token, pchrEmpresa,
                pintMatricula, cpfColaborador)
            .then((map) async {
          _bcoHoras = map;

          // if (_bcoHoras == null || _bcoHoras.response.pIntCodErro != 0) {
          //   //Caso não encontre usuário no datasul
          //   progressDialog.hide();
          //   if (barraStatus == true) {
          //     await AlertDialogTemplate().showAlertDialogSimples(
          //         context,
          //         "Atencao",
          //         "Banco de Horas nao encontrado!\n" +
          //             _bcoHoras.response.pChrDescErro);
          //   }
          //   return null;
          // } else {
          //   return _bcoHoras;
          // }
          progressDialog.hide();

          ///*[Caso null]
          if (_bcoHoras == null) {
            if (barraStatus == true) {
              await AlertDialogTemplate().showAlertDialogSimples(
                  context, "Atencão", "Banco de Horas nao encontrado!");
            }
          } else if (_bcoHoras.response.pIntCodErro == 0) {
            ///*[Caso == 0]
            return _bcoHoras;

            ///*[Caso erro!]
          } else {
            await AlertDialogTemplate().showAlertDialogSimples(
                context, "Atencão", "${_bcoHoras.response.pChrDescErro}");
          }

          ///*
        });
      }
    });
    return _bcoHoras;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
