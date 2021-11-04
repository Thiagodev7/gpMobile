import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gpmobile/src/pages/ponto/model/PontoAssinaturaModel.dart';
import 'package:gpmobile/src/pages/ponto/model/PontoModel.dart';
import 'package:gpmobile/src/util/AlertDialogTemplate.dart';
import 'package:gpmobile/src/util/BuscaUrl.dart';
import 'package:http/http.dart' as http;

class PontoService {
  var _ponto;
  var _pontoAssinar;
  //METODO PRINCIPAL
  Future<PontoModel> getPonto(
    BuildContext context,
    String token,
    String empresa,
    String matricula,
    String mes,
    String ano,
  ) async {
    try {
      final response = await http
          .get(await new BuscaUrl().url("ponto") +
              token +
              "&pchrEmpresa=" +
              empresa +
              "&pintAno=" +
              ano +
              "&pintMes=" +
              mes +
              "&pintMatricula=" +
              matricula)
          .timeout(
            Duration(seconds: 10),
          );

      if (response.statusCode == 200) {
        // var descodeJson = jsonDecode(response.body);
        var descodeJson = jsonDecode(utf8.decode(response.bodyBytes));
        _ponto = PontoModel.fromJson(descodeJson);
        return _ponto;
      } else {
        await new AlertDialogTemplate().showAlertDialogSimples(
            context,
            "Error",
            "Error ao buscar o Ponto! \n" +
                "Código Erro: " +
                response.statusCode.toString());
        return null;
      }
    } catch (e) {
      await new AlertDialogTemplate().showAlertDialogSimples(
          context, "Error", "Error ao buscar o Ponto! \n " + e.toString());
      return null;
    }
  }

  //METODO POST ASSINATURA
  //assinar = 1 naoAssinar = 0
  Future<PontoAssinaturaModel> postPointAssinar(
      BuildContext context,
      String token,
      String matricula,
      String empresa,
      String mesRef,
      String anoRef,
      int pAssinar) async {
    try {
      final response = await http.post(
          await new BuscaUrl().url("pontoAssinar") +
              token +
              "&pmatricula=" +
              matricula +
              "&pempresa=" +
              empresa +
              "&pmesref=" +
              mesRef +
              "&panoref=" +
              anoRef +
              "&passinar=" +
              pAssinar.toString());

      if (response.statusCode == 200) {
        var descodeJson = jsonDecode(response.body);
        _pontoAssinar = PontoAssinaturaModel.fromJson(descodeJson);
        return _pontoAssinar;
      } else {
        await new AlertDialogTemplate().showAlertDialogSimples(context, "Error",
            "Error ao buscar a Assinatura! \n" + "Código Erro: "
            // response.statusCode.toString()
            );
        return null;
      }
    } catch (e) {
      await new AlertDialogTemplate().showAlertDialogSimples(
          context, "Error", "Error ao buscar o Assinatura! \n " + e.toString());
      return null;
    }
  }
}
