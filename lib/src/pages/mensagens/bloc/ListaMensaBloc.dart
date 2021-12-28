import 'dart:async';
import 'dart:core';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gpmobile/src/pages/mensagens/model/MensagemRetornoModel.dart';
import 'package:gpmobile/src/util/AlertDialogTemplate.dart';
import 'package:gpmobile/src/util/TokenModel.dart';
import 'package:gpmobile/src/util/TokenServices.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/ListaMensaService.dart';

class ListaMensaBloc extends BlocBase {
  /////////////////////////////////////////////////////////////////////
  Future<MensagemRetornoModel> getMessageBack(
      {BuildContext context,
      int codDocumento,
      bool cienciaConfirmada,
      int operacao,
      bool barraStatus}) async {
    /// *[VARIAVEIS]
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String empresa = prefs.getString('empresa');
    String usuario = prefs.getString('usuario');
    String matricula = prefs.getString('matricula');
    String ip;
    TokenModel token;

    String plataforma;

    MensagemRetornoModel blocMensagens;

    ProgressDialog progressDialog = new AlertDialogTemplate()
        .showProgressDialog(context, "Carregando Mensagens...");
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
        await new VisualizarMensaService()
            .getMensaService(
                context,
                token.response.token,
                codDocumento,
                empresa,
                usuario,
                matricula,
                ip,
                operacao,
                plataforma,
                cienciaConfirmada)
            .then((map) async {
          blocMensagens = map;

          progressDialog.hide();

          ///*[Caso null]
          if (blocMensagens == null) {
            if (barraStatus == true) {
              await AlertDialogTemplate().showAlertDialogSimples(
                  context, "Atencão", "Tabela de de arquivos nao encontrado!");
            }
          } else if (blocMensagens.response.pIntCodErro == 0) {
            ///*[Caso == 0]
            return blocMensagens;

            ///*[Caso erro!]
          } else {
            await AlertDialogTemplate().showAlertDialogSimples(
                context, "Atencão", "${blocMensagens.response.pChrDescErro}");
          }
        });
      }
    });
    return blocMensagens;
  }
}
