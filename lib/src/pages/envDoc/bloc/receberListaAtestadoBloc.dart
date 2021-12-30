import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:gpmobile/src/pages/envDoc/model/receberListaAtestadoModel.dart';
import 'package:gpmobile/src/pages/envDoc/service/receberListaAtestadoService.dart';
import 'package:gpmobile/src/util/AlertDialogTemplate.dart';
import 'package:gpmobile/src/util/TokenModel.dart';
import 'package:gpmobile/src/util/TokenServices.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReceberListaAtestadoBloc extends BlocBase {
  Future<ReceberListaAtestadoModel> getAllAniversarios(
      BuildContext context, bool barraStatus) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String empresa = prefs.getString('empresa');
    String matricula = prefs.getString('matricula');
    TokenModel token;
    ReceberListaAtestadoModel _listaAtestados;
    ProgressDialog progressDialog = new AlertDialogTemplate()
        .showProgressDialog(context, "Buscando Lista de atestados...");
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
        await new ReceberListaAtestadoService()
            .getList(context, matricula, empresa)
            .then((map) async {
          _listaAtestados = map;

          progressDialog.hide();

          ///*[Caso null]
          if (_listaAtestados == null) {
            if (barraStatus == true) {
              await AlertDialogTemplate().showAlertDialogSimples(
                  context, "Atencão", "Lista de atestados nao encontrada!");
            }
          } else if (_listaAtestados.codErro == 0) {
            ///*[Caso == 0]
            return _listaAtestados;

            ///*[Caso erro!]
          } else {
            await AlertDialogTemplate().showAlertDialogSimples(
                context, "Atencão", "${_listaAtestados.codErro}");
          }

          ///*
        });
        // progressDialog.hide();
      }
    });
    return _listaAtestados;
  }
}
