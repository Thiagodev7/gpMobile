//https://javiercbk.github.io/json_to_dart/    Exemplo Json: {"usuario":"123", "senha":"123"}

class TokenModel {
  Response response;

  TokenModel({this.response});

  TokenModel.fromJson(Map<dynamic, dynamic> json) {
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    if (this.response != null) {
      data['response'] = this.response.toJson();
    }
    return data;
  }
}

class Response {
  String token;
  String codMensagem;
  String descMensagem;

  Response({this.token, this.codMensagem, this.descMensagem});

  Response.fromJson(Map<dynamic, dynamic> json) {
    token = json['token'];
    codMensagem = json['codMensagem'];
    descMensagem = json['descMensagem'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['token'] = this.token;
    data['codMensagem'] = this.codMensagem;
    data['descMensagem'] = this.descMensagem;
    return data;
  }
}
