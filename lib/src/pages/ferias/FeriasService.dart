import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gpmobile/src/pages/ferias/model/FeriasModel.dart';
import 'package:gpmobile/src/util/AlertDialogTemplate.dart';
import 'package:gpmobile/src/util/BuscaUrl.dart';
import 'package:http/http.dart' as http;

class FeriasService {
  var _ferias;

  Future<FeriasModel> getFerias(
    BuildContext context,
    String token,
    String empresa,
    String matricula,
  ) async {
    try {
      final response = await http.get(await new BuscaUrl().url("ferias") +
          token +
          "&matricula=" +
          matricula +
          "&empresa=" +
          empresa);

      if (response.statusCode == 200) {
        // var descodeJson = jsonDecode(response.body);
        var descodeJson = jsonDecode(utf8.decode(response.bodyBytes));
        _ferias = FeriasModel.fromJson(descodeJson);
        return _ferias;
      } else {
        await new AlertDialogTemplate().showAlertDialogSimples(
            context,
            "Error",
            "Error ao buscar ferias! \n" +
                "Código Erro: " +
                response.statusCode.toString());
        return null;
      }
    } catch (e) {
      await new AlertDialogTemplate().showAlertDialogSimples(
          context, "Error", "Error ao buscar ferias! \n " + e.toString());
      return null;
    }
  }
}
