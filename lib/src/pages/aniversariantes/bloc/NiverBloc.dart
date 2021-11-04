import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gpmobile/src/util/AlertDialogTemplate.dart';
import 'package:gpmobile/src/util/TokenModel.dart';
import 'package:gpmobile/src/util/TokenServices.dart';
import 'package:progress_dialog/progress_dialog.dart';
import '../model/NiverModel.dart';
import '../NiverService.dart';

class NiverBloc extends BlocBase {
  Future<NiverModel> getAllAniversarios(
      BuildContext context, String mes, bool barraStatus) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String empresa = prefs.getString('empresa');
    // String matricula = prefs.getString('matricula');
    TokenModel token;
    NiverModel _tabelaAniversarios;
    ProgressDialog progressDialog = new AlertDialogTemplate()
        .showProgressDialog(context, "Buscando aniversariantes...");
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
        await new NiverService()
            .getPeriodoAtual(context, token.response.token, mes)
            .then((map) async {
          _tabelaAniversarios = map;

          // if (_tabelaAniversarios.response == null ||
          //     _tabelaAniversarios.response.pIntCodErro != 0) {
          //   //Caso não encontre usuário no datasul
          //   progressDialog.hide();
          //   if (barraStatus == true) {
          //     await AlertDialogTemplate().showAlertDialogSimples(
          //         context,
          //         "Atencao",
          //         "Tabela nao encontrada! " +
          //             _tabelaAniversarios.response.pChrDescErro);
          //   }
          //   return null;
          // } else {
          //   return _tabelaAniversarios;
          // }
          ///*
          progressDialog.hide();

          ///*[Caso null]
          if (_tabelaAniversarios == null) {
            if (barraStatus == true) {
              await AlertDialogTemplate().showAlertDialogSimples(
                  context, "Atencão", "Lista aniversariantes nao encontrada!");
            }
          } else if (_tabelaAniversarios.response.pIntCodErro == 0) {
            ///*[Caso == 0]
            return _tabelaAniversarios;

            ///*[Caso erro!]
          } else {
            await AlertDialogTemplate().showAlertDialogSimples(context,
                "Atencão", "${_tabelaAniversarios.response.pChrDescErro}");
          }

          ///*
        });
        // progressDialog.hide();
      }
    });
    return _tabelaAniversarios;
  }

  String getNomeMes(String mes) {
    String _nomeMes;
    switch (mes) {
      case "1":
        _nomeMes = "Janeiro";
        break;
      case "2":
        _nomeMes = "Fevereiro";
        break;
      case "3":
        _nomeMes = "Março";
        break;
      case "4":
        _nomeMes = "Abril";
        break;
      case "5":
        _nomeMes = "Maio";
        break;
      case "6":
        _nomeMes = "Junho";
        break;
      case "7":
        _nomeMes = "Julho";
        break;
      case "8":
        _nomeMes = "Agosto";
        break;
      case "9":
        _nomeMes = "Setembro";
        break;
      case "10":
        _nomeMes = "Outubro";
        break;
      case "11":
        _nomeMes = "Novembro";
        break;
      case "12":
        _nomeMes = "Dezembro";
        break;
      default:
        _nomeMes = "Mes nao encontrado!";
        break;
    }
    return _nomeMes;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
