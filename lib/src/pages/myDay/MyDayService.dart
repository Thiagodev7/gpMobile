import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gpmobile/src/util/AlertDialogTemplate.dart';
import 'package:gpmobile/src/util/BuscaUrl.dart';
import 'package:http/http.dart' as http;

import 'model/MyDayModel.dart';

class MyDayService {
  var _tableMeuDia;

  Future<MyDayModel> getMeuDia(BuildContext context, String token,
      String empresa, String matricula, String obs) async {
    try {
      final response = await http
          .get(await new BuscaUrl().url("myDay") +
              token +
              "&pchrEmpresa=" +
              empresa +
              "&pchrMatricula=" +
              matricula +
              "&plogDetalkObs=" +
              obs)
          .timeout(Duration(seconds: 20));

      if (response.statusCode == 200) {
        // var descodeJson = jsonDecode(response.body);
        var descodeJson = jsonDecode(utf8.decode(response.bodyBytes));
        _tableMeuDia = MyDayModel.fromJson(descodeJson);
        return _tableMeuDia;
      } else {
        await new AlertDialogTemplate().showAlertDialogSimples(
            context,
            "Atencao",
            "Error ao buscar tabela meu dia! \n" +
                "Código Erro: " +
                response.statusCode.toString());
        return null;
      }
    } catch (e) {
      await new AlertDialogTemplate().showAlertDialogSimples(context, "Atencao",
          "Error ao buscar tabela meu dia! \n " + e.toString());
      return null;
    }
  }
}
