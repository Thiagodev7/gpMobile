import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:gpmobile/src/pages/ferias/model/FeriasModel.dart';
import 'package:gpmobile/src/pages/ferias/FeriasService.dart';
import 'package:gpmobile/src/util/AlertDialogTemplate.dart';
import 'package:gpmobile/src/util/TokenModel.dart';
import 'package:gpmobile/src/util/TokenServices.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeriasBloc extends BlocBase {
  Future<FeriasModel> getFerias(BuildContext context, bool barraStatus) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String pchrEmpresa = prefs.getString('empresa');
    String pintMatricula = prefs.getString('matricula');
    TokenModel token;
    FeriasModel _ferias;
    ProgressDialog progressDialog = new AlertDialogTemplate()
        .showProgressDialog(context, "Buscando registro de férias...");
    if (barraStatus == true) {
      await progressDialog.show();
    }

    await new TokenServices().getToken().then((map) async {
      token = map;

      if (token == null) {
        progressDialog.hide();
        AlertDialogTemplate()
            .showAlertDialogSimples(context, "Atenção", "Erro ao buscar token");
        progressDialog.hide();
        return null;
      } else {
        await new FeriasService()
            .getFerias(
                context, token.response.token, pchrEmpresa, pintMatricula)
            .then((map) async {
          _ferias = map;
          if (_ferias == null || _ferias.response.pIntCodErro != 0) {
            //Caso não encontre usuário no datasul
            progressDialog.hide();
            if (barraStatus == true) {
              await AlertDialogTemplate().showAlertDialogFerias(
                  context,
                  "Atenção",
                  "Ferias nao encontrada! \n" + _ferias.response.pChrDescErro);
            }
            return null;
          } else {
            return _ferias;
          }
        });
        progressDialog.hide();
      }
    });
    return _ferias;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
