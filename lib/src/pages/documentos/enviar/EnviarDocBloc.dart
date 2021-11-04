import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gpmobile/src/pages/documentos/enviar/Base64Model.dart';
import 'package:gpmobile/src/util/AlertDialogTemplate.dart';
import 'package:gpmobile/src/util/GenericLogsModel.dart';
import 'package:gpmobile/src/util/TokenModel.dart';
import 'package:gpmobile/src/util/TokenServices.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'EnviarDocService.dart';

class EnviarDocBloc extends BlocBase {
  Future<GenericLogsModel> postArquivos(
      BuildContext context,
      String descDocto,
      Base64Model arqBase64,
      String nomeExtensaoArquivo,
      bool barraStatus) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _usuario = prefs.getString('nomecolaborador');
    GenericLogsModel retModel = new GenericLogsModel();
    //
    String sistema = "DATASUL";
    String modulo = "APP_DP";
    String programa = "ARQUIVOS";
    String rotina = "ARQUIVOS_REG_INT";
    String usuario = _usuario;
    String chrDescDocto = descDocto;
    String chrNomeExtensaoArquivo = nomeExtensaoArquivo;
    //
    TokenModel token;
    Base64Model _tabelaArquivos;

    ProgressDialog progressDialog3 = new AlertDialogTemplate()
        .showProgressDialog(context, "Enviando arquivo: $descDocto");
    if (barraStatus == true) {
      await progressDialog3.show();
    }

    await new TokenServices().getToken().then((map) async {
      token = map;

      if (token == null) {
        progressDialog3.hide();
        AlertDialogTemplate()
            .showAlertDialogSimples(context, "Atencao", "Erro ao buscar token");
        return null;
      } else {
        await new EnviarDocService()
            .postServiceDoc(
                context,
                token.response.token,
                sistema,
                modulo,
                programa,
                rotina,
                usuario,
                chrDescDocto,
                chrNomeExtensaoArquivo,
                arqBase64)
            .then((map) async {
          retModel = map;

          // if (retModel == null) {
          //   //Caso retorne null
          //   if (barraStatus == true) {
          //     progressDialog3.hide();
          //     await AlertDialogTemplate().showAlertDialogSimples(
          //         context,
          //         "Atencao",
          //         "Erro ao enviar arquivo! \nerro:" +
          //             _tabelaArquivos.request.lchrArquivoBase64);
          //   }
          // } else {
          //   if (retModel.response.pIntCodErro == 0) {
          //     progressDialog3.hide();
          //     await AlertDialogTemplate().showAlertDialogSimples(
          //         context,
          //         "$chrDescDocto",
          //         "Enviado com sucesso!...");
          //     return retModel;
          //   } else {
          //     progressDialog3.hide();
          //     await AlertDialogTemplate().showAlertDialogSimples(
          //         context, "Erro", retModel.response.pChrDescErro);

          //     return retModel;
          //   }
          // }

          progressDialog3.hide();

          ///*[Caso null]
          if (retModel == null) {
            if (barraStatus == true) {
              await AlertDialogTemplate().showAlertDialogSimples(
                  context, "Atencão", "Erro ao enviar arquivo!");
            }
          } else if (retModel.response.pIntCodErro == 0) {
            ///*[Caso == 0]
            await AlertDialogTemplate().showAlertDialogSimples(
                context, "$chrDescDocto", "Enviado com sucesso!...");

            ///*[Caso erro!]
          } else {
            await AlertDialogTemplate().showAlertDialogSimples(
                context, "Atencão", "${retModel.response.pChrDescErro}");
          }

          ///*
        });
      }
    });
    progressDialog3.hide();
    return retModel;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
