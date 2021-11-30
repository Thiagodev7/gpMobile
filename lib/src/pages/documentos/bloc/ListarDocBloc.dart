import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gpmobile/src/pages/documentos/model/ListarDocModel.dart';
import 'package:gpmobile/src/util/AlertDialogTemplate.dart';
import 'package:gpmobile/src/util/GenericLogsModel.dart';
import 'package:gpmobile/src/util/TokenModel.dart';
import 'package:gpmobile/src/util/TokenServices.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ListarDocService.dart';

class LisartDocsBloc extends BlocBase {
  ///////////////////////
  Future<ListarDocModel> getListDocs(
      {BuildContext context,
      int codDocumento,
      bool cienciaConfirmada,
      int operacao,
      bool barraStatus}) async {
    //
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String empresa = prefs.getString('empresa');
    String usuario = prefs.getString('usuario');
    String matricula = prefs.getString('matricula');
    String ip;

    String plataforma;

    //

    //
    TokenModel token;
    ListarDocModel listarDocModel;

    ProgressDialog progressDialog = new AlertDialogTemplate()
        .showProgressDialog(context, "Carregando Lista de Documentos...");
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
        await new ListarDocService()
            .postListDocs(context, token.response.token, codDocumento, empresa,
                usuario, matricula, ip, operacao, plataforma, cienciaConfirmada)
            .then((map) async {
          listarDocModel = map;

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
          if (listarDocModel == null) {
            if (barraStatus == true) {
              await AlertDialogTemplate().showAlertDialogSimples(
                  context, "Atencão", "Tabela de de arquivos nao encontrado!");
            }
          } else if (listarDocModel.response.pIntCodErro == 0) {
            ///*[Caso == 0]
            return listarDocModel;

            ///*[Caso erro!]
          } else {
            await AlertDialogTemplate().showAlertDialogSimples(
                context, "Atencão", "${listarDocModel.response.pChrDescErro}");
          }

          ///*
        });
        // progressDialog.hide();
      }
    });
    return listarDocModel;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
