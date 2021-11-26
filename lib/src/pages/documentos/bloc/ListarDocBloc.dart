import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gpmobile/src/util/AlertDialogTemplate.dart';
import 'package:gpmobile/src/util/GenericLogsModel.dart';
import 'package:gpmobile/src/util/TokenModel.dart';
import 'package:gpmobile/src/util/TokenServices.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ListarDocService.dart';

class VizualizarDocBloc extends BlocBase {
  ///////////////////////
  Future<GenericLogsModel> getBlocPdf(
      BuildContext context, bool barraStatus) async {
    //
    String sistema = "DATASUL";
    String modulo = "APP_DP";
    String programa = "ARQUIVOS";
    String rotina = "ARQUIVOS_REG_INT";
    int intTipoRetonoRegistros = 2;
    String usuario = "";
    String chrTexto = "";
    String dtIniFiltro = "01/01/2021";
    String dtFimFiltro = "01/12/9999";
    //
    TokenModel token;
    GenericLogsModel _arquivosRecebidos;

    ProgressDialog progressDialog = new AlertDialogTemplate()
        .showProgressDialog(context, "Carregando Tabela de Pdf...");
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
        await new VizualizarDocService()
            .getServicePdf(
                context,
                token.response.token,
                sistema,
                modulo,
                programa,
                rotina,
                intTipoRetonoRegistros,
                usuario,
                chrTexto,
                dtIniFiltro,
                dtFimFiltro)
            .then((map) async {
          _arquivosRecebidos = map;

          // if (_arquivosRecebidos.response == null ||
          //     _arquivosRecebidos.response.pIntCodErro != 0 &&
          //         _arquivosRecebidos.response.pIntCodErro != 2) {
          //   //Caso não encontre usuário no datasul
          //   progressDialog.hide();
          //   if (barraStatus == true) {
          //     await AlertDialogTemplate().showAlertDialogSimples(
          //         context,
          //         "Atencao",
          //         "Tabela de de arquivos nao encontrado! \nerro:" +
          //             _arquivosRecebidos.response.pChrDescErro);
          //   }
          //   return null;
          // } else {
          //   return _arquivosRecebidos;
          // }

          progressDialog.hide();

          ///*[Caso null]
          if (_arquivosRecebidos == null) {
            if (barraStatus == true) {
              await AlertDialogTemplate().showAlertDialogSimples(
                  context, "Atencão", "Tabela de de arquivos nao encontrado!");
            }
          } else if (_arquivosRecebidos.response.pIntCodErro == 0) {
            ///*[Caso == 0]
            return _arquivosRecebidos;

            ///*[Caso erro!]
          } else {
            await AlertDialogTemplate().showAlertDialogSimples(context,
                "Atencão", "${_arquivosRecebidos.response.pChrDescErro}");
          }

          ///*
        });
        // progressDialog.hide();
      }
    });
    return _arquivosRecebidos;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
