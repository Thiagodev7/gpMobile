import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gpmobile/src/pages/mensagens/model/MensagemRetornoModel.dart';
import 'package:gpmobile/src/util/AlertDialogTemplate.dart';
import 'package:gpmobile/src/util/BuscaUrl.dart';
import 'package:http/http.dart' as http;

/// * [supostoerro] na linha 50...

class VisualizarMensaService {
  Future<MensagemRetornoModel> getMensaService(
    BuildContext context,
    String token,
    int codMensagem,
    String empresa,
    String usuario,
    String matricula,
    String ip,
    int operacao,
    String plataforma,
    bool cienciaConfirmada,
  ) async {
    try {
      final response = await http.post(
        await new BuscaUrl().url("enviarRecebeMensa") + token,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "request": {
            "ttParametros": {
              "ttParametros": [
                {
                  "codMensagem": codMensagem,
                  "empresa": empresa,
                  "usuario": usuario,
                  "matricula": matricula,
                  "ip": "",
                  "operacao": operacao,
                  "plataforma": "",
                  "cienciaConfirmada": cienciaConfirmada
                }
              ]
            }
          }
        }),
      );
      if (response.statusCode == 200) {
        // var descodeJson = jsonDecode(response.body);
        var descodeJson = jsonDecode(utf8.decode(response.bodyBytes));
        MensagemRetornoModel _listardoc =
            MensagemRetornoModel.fromJson(descodeJson);
        return _listardoc;
      } else {
        if (operacao == 1) {
          await new AlertDialogTemplate().showAlertDialogSimples(
              context,
              "Atenção",
              "Error ao receber lista de documentos! \n" +
                  "Código Erro: " +
                  response.statusCode.toString());
        } else {
          await new AlertDialogTemplate().showAlertDialogSimples(
              context,
              "Atenção",
              "Error ao buscar Documeto! \n" +
                  "Código Erro: " +
                  response.statusCode.toString());
        }

        return null;
      }
    } catch (e) {
      if (operacao == 1) {
        await new AlertDialogTemplate().showAlertDialogSimples(
            context,
            "Atenção",
            "Error ao receber lista de documentos! \n" + e.toString());
      } else {
        await new AlertDialogTemplate().showAlertDialogSimples(
            context, "Atenção", "Error ao buscar Documeto! \n" + e.toString());
      }

      return null;
    }
  }
}
