import 'dart:convert';

//import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:gpmobile/src/pages/login/entrar/EntrarModel.dart';
import 'package:gpmobile/src/util/AlertDialogTemplate.dart';
import 'package:gpmobile/src/util/BuscaUrl.dart';
import 'package:gpmobile/src/util/GetIp.dart';

import 'package:http/http.dart' as http;
import 'package:universal_platform/universal_platform.dart';

class TrocarSenhaServices {
  var _trocarServices;
  String ip;

  Future<LoginModel> postTrocaDeSenha(
    BuildContext context,
    String token,
    String postUsuario,
    String postNovaSenha,
    int postNotificar,
    int postTrocarSenha
  ) async {
    try {

      await GetIp().getIp().then((map) async {
        if (map == null) {
          ip = "";
        }
        else{
          ip = map;
        }
      });

      final response = await http.post(
        await new BuscaUrl().url("login") + token,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "request": {
            "ttParam": {
              "ttParam": [
                {
                  "usuario": postUsuario,
                  "senhaNova": postNovaSenha,
                  "notificar": postNotificar,
                  "acao": postTrocarSenha,
                  'plataforma': UniversalPlatform.isWeb == true ? "web" : "mob",
                  'IP': ip
                }
              ]
            }
          }
        }),
      );
      if (response.statusCode == 200) {
        var descodeJson = jsonDecode(response.body);
        _trocarServices = LoginModel.fromJson(descodeJson);
        return _trocarServices;
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
}
