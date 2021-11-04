import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gpmobile/src/util/AlertDialogTemplate.dart';
import 'package:gpmobile/src/util/BuscaUrl.dart';
import 'package:http/http.dart' as http;
import 'model/BcoHorasModel.dart';

class BcoHorasService {
  var _bcoHoras;

  Future<BcoHorasModel> getBcoHoras(
    BuildContext context,
    String token,
    String empresa,
    String matricula,
    String cpfcolaborador,
  ) async {
    try {
      final response = await http.get(await new BuscaUrl().url("bcoHoras") +
          token +
          "&empresa=" +
          empresa +
          "&matricula=" +
          matricula +
          "&cpfcolaborador" +
          cpfcolaborador);
      if (response.statusCode == 200) {
        // var descodeJson = jsonDecode(response.body);
        var descodeJson = jsonDecode(utf8.decode(response.bodyBytes));
        _bcoHoras = BcoHorasModel.fromJson(descodeJson);
        return _bcoHoras;
      } else {
        await new AlertDialogTemplate().showAlertDialogSimples(
            context,
            "Error",
            "Error ao buscar o Banco de Horas! \n" +
                "Código Erro: " +
                response.statusCode.toString());
        return null;
      }
    } catch (e) {
      await new AlertDialogTemplate().showAlertDialogSimples(context, "Error",
          "Error ao buscar o Banco de Horas! \n " + e.toString());
      return null;
    }
  }
}
