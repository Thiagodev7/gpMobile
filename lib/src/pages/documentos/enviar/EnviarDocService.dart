import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gpmobile/src/pages/documentos/enviar/Base64Model.dart';
import 'package:gpmobile/src/util/AlertDialogTemplate.dart';
import 'package:gpmobile/src/util/BuscaUrl.dart';
import 'package:gpmobile/src/util/GenericLogsModel.dart';
import 'package:http/http.dart' as http;

class EnviarDocService {
  // GenericLogsModel _tabelaArquivos = new GenericLogsModel();

///////////////////////////////////////////////////////////////////////////////
  Future<GenericLogsModel> postServiceDoc(
      BuildContext context,
      String token,
      String chrSistema,
      String chrModulo,
      String chrPrograma,
      String chrRotina,
      String chrUsuario,
      String chrDescDocto,
      String chrNomeExtensaoArquivo,
      Base64Model arqBase64) async {
    try {
      final response = await http.post(
        await new BuscaUrl().url("enviarArq") +
            token +
            "&chrSistema=" +
            chrSistema +
            "&chrModulo=" +
            chrModulo +
            "&chrPrograma=" +
            chrPrograma +
            "&chrRotina=" +
            chrRotina +
            "&chrUsuario=" +
            chrUsuario +
            "&chrDescDocto=" +
            chrDescDocto +
            "&chrNomeExtensaoArquivo=" +
            chrNomeExtensaoArquivo,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(arqBase64),
      );

      if (response.statusCode == 200) {
        var ret = jsonDecode(response.body);
        GenericLogsModel descodeJson = GenericLogsModel.fromJson(ret);
        return descodeJson;
      } else {
        await new AlertDialogTemplate().showAlertDialogSimples(
            context,
            "Atencao",
            "Error ao enviar arquivo! \n" +
                "Código Erro: " +
                response.statusCode.toString());
        return null;
      }
    } catch (e) {
      await new AlertDialogTemplate().showAlertDialogSimples(
        context,
        "Atencao",
        "Error ao enviar arquivo! \n " + e.toString(),
      );
      return null;
    }
  }
}
