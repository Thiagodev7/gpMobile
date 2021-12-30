import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gpmobile/src/pages/envDoc/model/enviarAtestadoModel.dart';
import 'package:gpmobile/src/util/AlertDialogTemplate.dart';
import 'package:gpmobile/src/util/BuscaUrl.dart';

import 'package:http/http.dart' as http;

class EnviarAtestadoService {
  Future<EnviarAtestadoModel> postListAtest(
    BuildContext context,
    String token,
    String empresa,
    String usuario,
    String matricula,
    String hospital,
    String medico,
    String crmcro,
    String inicioAfastamento,
    String fimAfastamento,
    String justificativa,
    String cid,
    String arquivo,
  ) async {
    try {
      final response = await http.post(
        'http://pc205:4040/fusion-i7/services/WorkflowRest/abrirSolicitacao',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "requester": "adm",
          "processName": "EAM",
          "eformCode": "EAMFormularioPrincipal",
          "eformInformation": [
            {
              "dataType": 8,
              "fieldName": "Empresa",
              "fieldValueList": [
                {"dataType": 1, "fieldName": "EmpresaEMS2", "fieldValue": "01"}
              ]
            },
            {"fieldName": "Matricula", "dataType": 1, "fieldValue": "5015"},
            {
              "fieldName": "Colaborador",
              "dataType": 1,
              "fieldValue": "Thiago Ribeiro dos Santos"
            },
            {
              "fieldName": "InicioAfastamento",
              "dataType": 4,
              "fieldValue": "10/04/2021 10:45:10"
            },
            {
              "fieldName": "FimDoAfastamento",
              "dataType": 4,
              "fieldValue": "10/04/2021 12:00:00"
            },
            {
              "fieldName": "Justificativa",
              "dataType": 1,
              "fieldValue": "Tive que sair 1h mais cedo para ir ao dentista."
            },
            {
              "fieldName": "TipoDeCadastro",
              "dataType": 8,
              "fieldValueList": [
                {"fieldName": "Codigo", "dataType": 3, "fieldValue": "6"}
              ]
            },
            {
              "fieldName": "Anexo",
              "dataType": 10,
              "fieldValueList": [
                {"fieldName": "Usuario", "dataType": 6, "fieldValue": "adm"},
                {
                  "fieldName": "TipoDeArquivo",
                  "dataType": 8,
                  "fieldValueList": [
                    {"fieldName": "Codigo", "dataType": 1, "fieldValue": "48"}
                  ]
                },
                {
                  "fieldName": "Arquivo",
                  "fileName": "{YYMMDD}_{Matricula}_{CID}.pdf",
                  "dataType": 11,
                  "fieldValue": "adsçlkfjaçlsdf..."
                }
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        // var descodeJson = jsonDecode(response.body);
        var descodeJson = jsonDecode(utf8.decode(response.bodyBytes));
        EnviarAtestadoModel _listardoc =
            EnviarAtestadoModel.fromJson(descodeJson);
        return _listardoc;
      } else {
        await new AlertDialogTemplate().showAlertDialogSimples(
            context,
            "Atenção",
            "Erro ao enviar atestado! \n" +
                "Código Erro: " +
                response.statusCode.toString());

        return null;
      }
    } catch (e) {
      await new AlertDialogTemplate().showAlertDialogSimples(
          context, "Atenção", "Error ao enviar atestado \n" + e.toString());
    }

    return null;
  }
}
