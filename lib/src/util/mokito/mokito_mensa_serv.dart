import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gpmobile/src/util/AlertDialogTemplate.dart';
import 'package:gpmobile/src/util/BuscaUrl.dart';
import 'package:gpmobile/src/util/GenericLogsModel.dart';
import 'package:http/http.dart' as http;


/// * [supostoerro] na linha 50...

class MokitoMensaService {
  GenericLogsModel _tabelaMensagens = new GenericLogsModel();

  Future<GenericLogsModel> getMensaService(
      BuildContext context,
      String token,
      //
      String chrSistema,
      String chrModulo,
      String chrPrograma,
      String chrRotina,
      int intTipoRetonoRegistros,
      String dtIniFiltro,
      String dtFimFiltro,
      // int  intSequencia
      ) async {
    try {
      final response = await http.get(await new BuscaUrl().url("receberMensa") +
          token +
          "&chrSistema=" +
          chrSistema +
          "&chrModulo=" +
          chrModulo +
          "&chrPrograma=" +
          chrPrograma +
          "&chrRotina=" +
          chrRotina +
          "&intTipoRetonoRegistros=" +
          intTipoRetonoRegistros.toString() +
          "&dtIniFiltro=" +
          dtIniFiltro +
          "&dtFimFiltro=" +
          dtFimFiltro
        // +
        // "&intSequencia=" +
        // intSequencia.toString()
      );

      if (response.statusCode == 200) {
        // var descodeJson = jsonDecode(utf8.decode(response.bodyBytes));
        var descodeJson = jsonDecode(response.body);
        if (descodeJson != null) {
          _tabelaMensagens = GenericLogsModel.fromJson(descodeJson);
          // ProgressDialog progressDialog = new AlertDialogTemplate()
          // .showProgressDialog(context, "Carregando tabela de arquivos...");
        }
        return _tabelaMensagens;
      } else {
        await new AlertDialogTemplate().showAlertDialogSimples(
            context,
            "Atencao",
            "Error ao buscar tabela de mensagens! \n" +
                "Código Erro: " +
                response.statusCode.toString());
        return null;
      }
    } catch (e) {
      await new AlertDialogTemplate().showAlertDialogSimples(context, "Atencao",
          "Error ao buscar tabela de mensagens!! \n " + e.toString());
      return null;
    }
  }
}
