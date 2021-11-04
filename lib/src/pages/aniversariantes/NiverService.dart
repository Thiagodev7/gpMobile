import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gpmobile/src/util/AlertDialogTemplate.dart';
import 'package:gpmobile/src/util/BuscaUrl.dart';
import 'package:http/http.dart' as http;

import 'model/NiverModel.dart';

class NiverService {
  var _tabelaAniversarios;

  Future<NiverModel> getPeriodoAtual(
      BuildContext context, String token, String mes) async {
    try {
      final response = await http.get(
          await new BuscaUrl().url("aniversariantes") +
              token +
              "&intMes=" +
              mes);

      if (response.statusCode == 200) {
        // var descodeJson = jsonDecode(response.body);
        var descodeJson = jsonDecode(utf8.decode(response.bodyBytes));
        _tabelaAniversarios = NiverModel.fromJson(descodeJson);
        return _tabelaAniversarios;
      } else {
        await new AlertDialogTemplate().showAlertDialogSimples(
            context,
            "Atencao",
            "Error ao buscar tabela de aniversariantes! \n" +
                "Código Erro: " +
                response.statusCode.toString());
        return null;
      }
    } catch (e) {
      await new AlertDialogTemplate().showAlertDialogSimples(context, "Atencao",
          "Error ao buscar tabela de aniversariantes! \n " + e.toString());
      return null;
    }
  }
}
