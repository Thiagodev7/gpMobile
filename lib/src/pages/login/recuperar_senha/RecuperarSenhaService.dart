import 'dart:convert';

//import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:gpmobile/src/pages/login/entrar/model/EntrarModel.dart';
import 'package:gpmobile/src/util/AlertDialogTemplate.dart';
import 'package:gpmobile/src/util/BuscaUrl.dart';
import 'package:gpmobile/src/util/GetIp.dart';

import 'package:http/http.dart' as http;
import 'package:universal_platform/universal_platform.dart';

class RecuperarSenhaServices {
  var _userGrou;
  String ip;

  Future<LoginModel> postRecuperarSenha(BuildContext context, String token,
      String usuario, int acaoNotificar, int acaoRecuperarSenha) async {
    try {
      await GetIp().getIp().then((map) async {
        if (map == null) {
          ip = "";
        } else {
          ip = map;
        }
      });

      final response = await http.post(
        await new BuscaUrl().url("login") + token,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'request': {
            'ttParam': {
              'ttParam': [
                {
                  'usuario': usuario, //cpf
                  'notificar': acaoNotificar, //1
                  'acao': acaoRecuperarSenha, //2
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
        _userGrou = LoginModel.fromJson(descodeJson);
        return _userGrou;
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

  ///[SMS]
  Future<LoginModel> postRecuperarPorSms(BuildContext context, String token,
      String usuario, int notificar, int acaoRecuperarSenha) async {
    try {
      final response = await http.post(
        await new BuscaUrl().url("login") + token,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'request': {
            'ttParam': {
              'ttParam': [
                {
                  'usuario': usuario, //cpf
                  'notificar': notificar, //1
                  'acao': acaoRecuperarSenha //2
                }
              ]
            }
          }
        }),
      );

      if (response.statusCode == 200) {
        var descodeJson = jsonDecode(utf8.decode(response.bodyBytes));
        _userGrou = LoginModel.fromJson(descodeJson);
        return _userGrou;
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
