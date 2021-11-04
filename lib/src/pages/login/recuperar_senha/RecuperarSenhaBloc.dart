import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:gpmobile/src/pages/login/entrar/EntrarModel.dart';

import 'package:gpmobile/src/util/AlertDialogTemplate.dart';
import 'package:gpmobile/src/util/TokenModel.dart';
import 'package:gpmobile/src/util/TokenServices.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'RecuperarSenhaService.dart';

class RecuperarSenhaBloc extends BlocBase {
  blocRecSenha(BuildContext context, int acaoNotificar, int acaoRecuperarSenha,
      String tipo, String usuario, bool barraStatus) async {
    TokenModel token;
    LoginModel blocRecSenhaModel;
    // LoginModel userGroupSms;
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String _usuarioPrefs = prefs.getString('usuario');
    // List<StatusModel> list = [];

    ProgressDialog progressDialog = new AlertDialogTemplate()
        .showProgressDialog(context, "Recuperando senha do usuário...");
    if (barraStatus == true) {
      await progressDialog.show();
    }

    await new TokenServices().getToken().then((map) async {
      token = map;

      if (token == null) {
        progressDialog.hide();
        AlertDialogTemplate()
            .showAlertDialogSimples(context, "Atencão", "Erro ao buscar token");
      } else {
        await new RecuperarSenhaServices()
            .postRecuperarSenha(context, token.response.token, usuario,
                acaoNotificar, acaoRecuperarSenha)
            .then((map) async {
          blocRecSenhaModel = map;

          ///*
          progressDialog.hide();

          ///*[Caso null]
          if (blocRecSenhaModel == null) {
            if (barraStatus == true) {
              await AlertDialogTemplate().showAlertDialogSimples(
                  context, "Atencão", "Usuário ou senha inválido");
            }
          } else if (blocRecSenhaModel.response.pIntCodErro == 0) {
            ///*[Caso == 0]
            if (barraStatus == true) {
              return await AlertDialogTemplate().showAlertDialogSimples(context,
                  "Atencão", "${blocRecSenhaModel.response.pChrDescErro}");
            }

            ///*[Caso erro!]
          } else {
            await AlertDialogTemplate().showAlertDialogSimples(context,
                "Atencão", "${blocRecSenhaModel.response.pChrDescErro}");
          }

          ///*
        });
      }
      Navigator.of(context).pop();
    });
  }

  Future<LoginModel> blocConsultarCPF(BuildContext context, String ususario,
      int acaoConsultar, bool barraStatus, String plataforma) async {
    TokenModel token;
    LoginModel blocConsultarCPFModel;

    ProgressDialog progressDialog = new AlertDialogTemplate()
        .showProgressDialog(context, "Aguarde, validando usuário...");
    if (barraStatus == true) {
      await progressDialog.show();
    }

    await new TokenServices().getToken().then((map) async {
      token = map;

      if (token == null) {
        progressDialog.hide();
        AlertDialogTemplate()
            .showAlertDialogSimples(context, "Atencão", "Erro ao buscar token");
      } else {
        await new RecuperarSenhaServices()
            .postRecuperarSenha(
                context, token.response.token, ususario, 0, acaoConsultar)
            .then((map) async {
          blocConsultarCPFModel = map;
          if (blocConsultarCPFModel == null ||
              blocConsultarCPFModel.response.pIntCodErro != 0) {
            //Caso não encontre usuário no datasul
            progressDialog.hide();
            if (barraStatus == true) {
              await AlertDialogTemplate().showAlertDialogSimples(
                  context, "Atencão", "Usuário inválido");
            }
            //Caso encontre, armazena dados storage Local
          }
        });
      }
      //fechar popup e voltar para tela login 26/08/21
      progressDialog.hide();
      // Navigator.of(context).pop();
    });
    return blocConsultarCPFModel;
  }
}
