import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gpmobile/src/util/AlertDialogTemplate.dart';
import 'package:gpmobile/src/util/BuscaUrl.dart';
import 'package:http/http.dart' as http;

import 'ValidaVersaoModel.dart';

class ValidaVersaoService {
  var validaVersaoModel;

  Future<ValidaVersaoModel> getVersaoService(
      BuildContext context, String token) async {
    try {
      final response = await http.get(await new BuscaUrl().url("versionApp") +
          token +
          '&pchrAplicativo=APP_DP&pchrSistema=APP_DP&pchrModulo=DP&pchrPrograma=APP_DP&pchrChave=VERSAO_APP_DP');

      if (response.statusCode == 200) {
        var descodeJson = jsonDecode(response.body);
        validaVersaoModel = ValidaVersaoModel.fromJson(descodeJson);
        return validaVersaoModel;
      } else {
        await new AlertDialogTemplate().showAlertDialogSimples(
            context,
            "Atencao",
            "Erro ao buscar versao no webservice! \n" +
                "Código Erro: " +
                response.statusCode.toString());
        return null;
      }
    } catch (e) {
      await new AlertDialogTemplate().showAlertDialogSimples(context, "Atencao",
          "Erro ao buscar versao no webservice! \n " + e.toString());
      print(e.toString());
      return null;
    }
  }
}
