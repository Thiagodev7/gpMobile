import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gpmobile/src/pages/envDoc/model/receberListaAtestadoModel.dart';
import 'package:gpmobile/src/util/AlertDialogTemplate.dart';
import 'package:gpmobile/src/util/BuscaUrl.dart';

import 'package:http/http.dart' as http;

class ReceberListaAtestadoService {
  var _tabelaAniversarios;

  Future<ReceberListaAtestadoModel> getList(
      BuildContext context, String matricula, String empresa) async {
    try {
      final response = await http.get(await new BuscaUrl().url(
              "http://pc205:4040/fusion-i7/services/WorkflowRest/atestados/") +
          empresa +
          "&intMes=" +
          matricula);

      if (response.statusCode == 200) {
        // var descodeJson = jsonDecode(response.body);
        var descodeJson = jsonDecode(utf8.decode(response.bodyBytes));
        _tabelaAniversarios = ReceberListaAtestadoModel.fromJson(descodeJson);
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
