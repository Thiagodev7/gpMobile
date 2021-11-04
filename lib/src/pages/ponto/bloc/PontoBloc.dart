import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:gpmobile/src/pages/ponto/model/PontoAssinaturaModel.dart';
import 'package:gpmobile/src/pages/ponto/PontoServices.dart';
import 'package:gpmobile/src/util/AlertDialogTemplate.dart';
import 'package:gpmobile/src/util/TokenModel.dart';
import 'package:gpmobile/src/util/TokenServices.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/PontoModel.dart';

class PontoBloc extends BlocBase {
  //validando assinatura...
  Future<PontoAssinaturaModel> blocPontoAssinar(
      BuildContext context, String mesRef, String anoRef, int assinar) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String pempresa = prefs.getString('empresa');
    String pmatricula = prefs.getString('matricula');
    TokenModel token;
    PontoAssinaturaModel _pointAssigned;
    ProgressDialog progressDialog2 = new AlertDialogTemplate()
        .showProgressDialog(context, "Validando assinatura do ponto...");
    if (assinar != null) {
      await progressDialog2.hide();
    }

    // await progressDialog2.show();

    await new TokenServices().getToken().then((map) async {
      token = map;

      if (token == null) {
        // progressDialog2.hide();
        AlertDialogTemplate()
            .showAlertDialogSimples(context, "Erro", "Erro ao buscar token");
        return null;
      } else {
        // return print('dados enviados, ok!!!');

        await new PontoService()
            .postPointAssinar(context, token.response.token, pmatricula,
                pempresa, mesRef, anoRef, assinar)
            .then((map) async {
          _pointAssigned = map;
          // progressDialog2.hide();
          if (_pointAssigned == null ||
              _pointAssigned.response.pIntCodErro != 0) {
            //Caso não encontre usuário no datasul

            if (assinar == 1) {
              //CASO-RETORNE=1
              await AlertDialogTemplate().showAlertDialogSimples(
                  context,
                  "Erro",
                  "Ponto assinado com sucesso! " +
                      _pointAssigned.response.pChrDescErro);
            }
          } else {
            return _pointAssigned;
          }
        });
      }
    });
    return _pointAssigned;
  }

  //apos validar assinatura..

  Future<PontoModel> getPontoPeriodo(BuildContext context, String pintMes,
      String pintAno, bool barraStatus) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String pchrEmpresa = prefs.getString('empresa');
    String pintMatricula = prefs.getString('matricula');
    TokenModel token;
    PontoModel _ponto;
    ProgressDialog progressDialog = new AlertDialogTemplate()
        .showProgressDialog(context, "Buscando seu ponto...");
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
        await new PontoService()
            .getPonto(context, token.response.token, pchrEmpresa, pintMatricula,
                pintMes, pintAno)
            .then((map) async {
          _ponto = map;
          // progressDialog.hide();
          if (_ponto == null || _ponto.response.pIntCodErro != 0) {
            //Caso não encontre usuário no datasul
            progressDialog.hide();
            if (barraStatus == true) {
              await AlertDialogTemplate().showAlertDialogSimples(
                  context,
                  "Erro",
                  "Ponto nao encontrado! " + _ponto.response.pChrDescErro);
            }
            return null;
          } else {
            return _ponto;
          }
        });
        progressDialog.hide();
      }
    });
    // await progressDialog.hide();
    return _ponto;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
