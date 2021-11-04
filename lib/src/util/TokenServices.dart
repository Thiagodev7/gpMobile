import 'dart:convert';

import 'package:gpmobile/src/util/BuscaUrl.dart';
import 'package:gpmobile/src/util/TokenModel.dart';

import 'package:http/http.dart' as http;

//https://www.youtube.com/watch?v=MY7uLubvXPY

class TokenServices {
  var _token;

  Future<TokenModel> getToken() async {
    try {
      final response = await http.get(await new BuscaUrl().url("token"));
      if (response.statusCode == 200) {
        var descodeJson = jsonDecode(response.body);
        // descodeJson.forEach((item) => listaToken.add(TokenModel.fromJson(item)));
        _token = TokenModel.fromJson(descodeJson);
        // print(" ...token recebido... ");
        //return _token;

        if (_token.response.codMensagem == "0") {
          return _token;
        } else {
          return null;
        }
      } else {
        print("Error ao buscar Token");
        return null;
      }
    } catch (e) {
      print("Error ao buscar Token");
      return null;
    }
  }
}
