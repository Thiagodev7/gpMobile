import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gpmobile/src/pages/ponto/model/PontoAssinaturaModel.dart';
import 'package:gpmobile/src/pages/ponto/model/PontoModel.dart';
import 'package:gpmobile/src/util/AlertDialogTemplate.dart';
import 'package:gpmobile/src/util/BuscaUrl.dart';
import 'package:gpmobile/src/util/GetIp.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_platform/universal_platform.dart';

import '../model/BaterPontoModel.dart';

class PontoService {
  var _ponto;
  var _pontoAssinar;
  String ip;
  var _baterPonto;
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

  Future<BaterPontoModel> postBaterPonto(
      BuildContext context,
      String token,
      String matricula,
      String empresa,
      String entrSaida,
      int operacao,
      bool inicioIntervalo) async {
    try {
      await GetIp().getIp().then((map) async {
        if (map == null) {
          ip = "";
        } else {
          ip = map;
        }
      });

      var currDt = DateTime.now();
      var f = NumberFormat("00");
      int aa = currDt.year;
      String mm = f.format(currDt.month);
      String dd = f.format(currDt.day);
      String hr = f.format(currDt.hour);
      String mn = f.format(currDt.minute);
      //currDt.minute;
      final response = await http.post(
        await new BuscaUrl().url("pontoBater") + token,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'request': {
            'ttBatidasJson': {
              'ttBatidasJson': [
                {
                  "cdnEmpresa": "1",
                  "cdnEstab": "1",
                  "cdnFuncionario": 4766,
                  "datMarcacPtoeletBatida": "28/06/2021",
                  "numHorarMarcacPtoelet": "18:00",
                  "idiMarcacPtoeletEntrSaida": entrSaida,
                  "cdnMotivMarcac": 992,
                  "operacao": operacao,
                  "ipPublicoRegPonto": "1",
                  "inicioIntervalo": inicioIntervalo,
                }
              ]
            }
          }
        }),
      );

      if (response.statusCode == 200) {
        var descodeJson = jsonDecode(response.body);
        _baterPonto = BaterPontoModel.fromJson(descodeJson);

        return _baterPonto;
      } else {
        await new AlertDialogTemplate().showAlertDialogSimples(
            context,
            "Error",
            "Error ao buscar usuario! \n" +
                "Código Erro: " +
                response.statusCode.toString());
        return null;
      }
    } catch (e) {
      await new AlertDialogTemplate().showAlertDialogSimples(
          context, "Error", "Error ao buscar usuario! \n " + e.toString());
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
