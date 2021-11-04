import 'dart:convert';

//import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:gpmobile/src/pages/login/entrar/EntrarModel.dart';
import 'package:gpmobile/src/util/AlertDialogTemplate.dart';
import 'package:gpmobile/src/util/BuscaUrl.dart';
import 'package:gpmobile/src/util/GetIp.dart';

import 'package:http/http.dart' as http;

class LoginServices {
  var _userGrou;
  String ip;

  Future<LoginModel> postUser(

      ///[usuario = cpf] + [senha = data nasc dd/mm/yy+5primeirosdigitoscpf]
      BuildContext context,
      String token,
      String usuario,
      String senhaAtual,
      int acaoLogin,
      String plataforma) async {
//???

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
          'request': {
            'ttParam': {
              'ttParam': [
                {
                  'usuario': usuario,
                  'senhaAtual': senhaAtual,
                  'acao': acaoLogin,
                  'plataforma': plataforma,
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
}
