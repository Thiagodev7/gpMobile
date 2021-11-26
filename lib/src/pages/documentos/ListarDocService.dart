import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gpmobile/src/util/AlertDialogTemplate.dart';
import 'package:gpmobile/src/util/BuscaUrl.dart';
import 'package:gpmobile/src/util/GenericLogsModel.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:validadores/ValidarCPF.dart';

class VizualizarDocService {
  GenericLogsModel _tabelaArquivos = new GenericLogsModel();

  Future<GenericLogsModel> getServicePdf(
      BuildContext context,
      String token,
      String chrSistema,
      String chrModulo,
      String chrPrograma,
      String chrRotina,
      int intTipoRetonoRegistros,
      String chrUsuario,
      String chrTexto,
      String dtIniFiltro,
      String dtFimFiltro) async {
    try {
      final response = await http.get(
        await new BuscaUrl().url("receberArq") +
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
            "&chrUsuario=" +
            chrUsuario +
            "&chrTexto=" +
            chrTexto +
            "&dtIniFiltro=" +
            dtIniFiltro +
            "&dtFimFiltro=" +
            dtFimFiltro,
        // headers: {"Accept-Charset": "utf-8"},
      );

      if (response.statusCode == 200) {
        // var descodeJson = jsonDecode(response.body);
        var descodeJson = jsonDecode(utf8.decode(response.bodyBytes));
        _tabelaArquivos = GenericLogsModel.fromJson(descodeJson);
        // ProgressDialog progressDialog = new AlertDialogTemplate()
        // .showProgressDialog(context, "Carregando tabela de arquivos...");
        if (response.statusCode == 200) {
          // await progressDialog.show();
        }
        return _tabelaArquivos;
      } else {
        await new AlertDialogTemplate().showAlertDialogSimples(
            context,
            "Atencao",
            "Error ao buscar tabela de arquivos! \n" +
                "Código Erro: " +
                response.statusCode.toString());
        return null;
      }
    } catch (e) {
      await new AlertDialogTemplate().showAlertDialogSimples(context, "Atencao",
          "Error ao buscar tabela de arquivos!! \n " + e.toString());
      return null;
    }
  }
}
