import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gpmobile/src/pages/contraCheque/model/ContraChequeModel.dart';
import 'package:gpmobile/src/util/AlertDialogTemplate.dart';
import 'package:gpmobile/src/util/BuscaUrl.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ContraChequeService {
  var _contraCheque;

  Future<ContraChequeModel> getContraCheque(BuildContext context, String token,
      String empresa, String matricula, String mes, String ano) async {
    try {
      final response = await http
          .get(await new BuscaUrl().url("contraCheque") +
              token +
              "&empresa=" +
              empresa +
              "&matricula=" +
              matricula +
              "&mes=" +
              mes +
              "&ano=" +
              ano)
          .timeout(Duration(seconds: 30));

      if (response.statusCode == 200) {
        // var descodeJson = jsonDecode(response.body);
        var descodeJson = jsonDecode(utf8.decode(response.bodyBytes));
        _contraCheque = ContraChequeModel.fromJson(descodeJson);
        return _contraCheque;
      } else {
        await new AlertDialogTemplate().showAlertDialogSimples(
            context,
            "Error",
            "Error ao buscar o Contra-Cheque! \n" +
                "Código Erro: " +
                response.statusCode.toString());
        return null;
      }
    } catch (e) {
      await new AlertDialogTemplate().showAlertDialogSimples(context, "Error",
          "Error ao buscar o Contra-Cheque! \n " + e.toString());
      return null;
    }
  }

  Future<File> getContraChequePDF(BuildContext context, String empresa,
      String matricula, String mes, String ano) async {
    Completer<File> completer = Completer();
    try {
      final response = await http.get(
          await new BuscaUrl().url("contraChequePDF") +
              "chrempresa=" +
              empresa +
              "&matricula=" +
              matricula +
              "&intmes=" +
              mes +
              "&intano=" +
              ano);

      if (response.statusCode == 200) {
        var pdfBytes = response.bodyBytes;
        String dir = (await getApplicationDocumentsDirectory()).path;
        String filename = 'contraChequePdf' + mes + ano;
        File file = new File('$dir/$filename' + '.pdf');
        // _pdf = ContraChequeModel.fromJson(descodeJson);
        await file.writeAsBytes(pdfBytes, flush: true);
        completer.complete(file);
        return completer.future;
      } else {
        await new AlertDialogTemplate().showAlertDialogSimples(
            context,
            "Error",
            "Error ao gerar PDF! \n" +
                "Código Erro: " +
                response.statusCode.toString());
        return null;
      }
    } catch (e) {
      await new AlertDialogTemplate().showAlertDialogSimples(
          context, "Error", "Error ao gerar PDF! \n " + e.toString());
      return null;
    }
  }
}
