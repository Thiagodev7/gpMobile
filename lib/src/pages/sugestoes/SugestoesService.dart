import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:gpmobile/src/util/AlertDialogTemplate.dart';
import 'package:gpmobile/src/util/BuscaUrl.dart';
import 'package:http/http.dart' as http;

import 'model/SugestoesModel.dart';

/// Veja também:
///  * [TIPO OPERACAO]
///  * [1] create.
///  * [2] select/consultar.
///
///
class SugestoesService {
  Future<SugestoesModel> postSugestoes(
    BuildContext context,
    String token,
    String _postCPF,
    String postSugestao,
    String postPlataforma,
    int postOperacao,
  ) async {
    try {
      final response = await http.post(
        await new BuscaUrl().url("enviarSugestoes") + token,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "request": {
            "ttParametros": {
              "tt-Parametros": [
                {
                  "cpf": _postCPF,
                  "sugestao": postSugestao,
                  "origem": postPlataforma,
                  "operacao": postOperacao
                }
              ]
            }
          }
        }),
      );

      if (response.statusCode == 200) {
        // var descodeJson = jsonDecode(response.body);
        var descodeJson = jsonDecode(utf8.decode(response.bodyBytes));
        SugestoesModel _enviarMensagem = SugestoesModel.fromJson(descodeJson);
        return _enviarMensagem;
      } else {
        if (postOperacao == 1) {
          await new AlertDialogTemplate().showAlertDialogSimples(
              context,
              "Atenção",
              "Error ao enviar Sugestao! \n" +
                  "Código Erro: " +
                  response.statusCode.toString());
        } else {
          await new AlertDialogTemplate().showAlertDialogSimples(
              context,
              "Atenção",
              "Error ao buscar sugestões! \n" +
                  "Código Erro: " +
                  response.statusCode.toString());
        }

        return null;
      }
    } catch (e) {
      if (postOperacao == 1) {
        await new AlertDialogTemplate().showAlertDialogSimples(
            context, "Atenção", "Error ao enviar sugestao! \n" + e.toString());
      } else {
        await new AlertDialogTemplate().showAlertDialogSimples(
            context, "Atenção", "Error ao buscar sugestões! \n" + e.toString());
      }

      return null;
    }
  }
}
