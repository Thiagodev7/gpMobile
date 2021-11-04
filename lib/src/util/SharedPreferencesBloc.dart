import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesBloc {
  Future<String> buscaParametro(String nomeParam) async {
    SharedPreferences prefs = await SharedPreferences
        .getInstance(); //SharedPreferences serve para guardar pequenas informações
    return prefs.getString(nomeParam);
  }

  Future<bool> buscaParametroBool(String tipoParam) async {
    SharedPreferences prefs = await SharedPreferences
        .getInstance(); //SharedPreferences serve para guardar pequenas informações
    return prefs.getBool(tipoParam);
  }

  gravaParametro(
      String nomeParam, String valorParam, bool tipoParam, String tipo) async {
    SharedPreferences prefs = await SharedPreferences
        .getInstance(); //SharedPreferences serve para guardar pequenas informações
    if (tipo == "string") {
      prefs.setString(nomeParam, valorParam);
    }

    if (tipo == "int") {
      prefs.setInt(nomeParam, int.parse(valorParam));
    }

    if (tipo == "boolean") {
      prefs.setBool(nomeParam, tipoParam);
    }
  }
}
