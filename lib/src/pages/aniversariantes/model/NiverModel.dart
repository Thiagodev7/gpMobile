class NiverModel {
  Response response;

  NiverModel({this.response});

  NiverModel.fromJson(Map<String, dynamic> json) {
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.response != null) {
      data['response'] = this.response.toJson();
    }
    return data;
  }
}

class Response {
  int pIntCodErro;
  String pChrDescErro;
  TtAniversariantes ttAniversariantes;

  Response({this.pIntCodErro, this.pChrDescErro, this.ttAniversariantes});

  Response.fromJson(Map<String, dynamic> json) {
    pIntCodErro = json['pIntCodErro'];
    pChrDescErro = json['pChrDescErro'];
    ttAniversariantes = json['ttAniversariantes'] != null
        ? new TtAniversariantes.fromJson(json['ttAniversariantes'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pIntCodErro'] = this.pIntCodErro;
    data['pChrDescErro'] = this.pChrDescErro;
    if (this.ttAniversariantes != null) {
      data['ttAniversariantes'] = this.ttAniversariantes.toJson();
    }
    return data;
  }
}

class TtAniversariantes {
  List<TtAniversariantes2> ttAniversariantes2;

  TtAniversariantes({this.ttAniversariantes2});

  TtAniversariantes.fromJson(Map<String, dynamic> json) {
    if (json['tt-aniversariantes'] != null) {
      // ignore: deprecated_member_use
      ttAniversariantes2 = new List<TtAniversariantes2>();
      json['tt-aniversariantes'].forEach((v) {
        ttAniversariantes2.add(new TtAniversariantes2.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.ttAniversariantes2 != null) {
      data['tt-aniversariantes'] =
          this.ttAniversariantes2.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TtAniversariantes2 {
  int diaNascimento;
  String nomeFuncionario;
  String cargo;
  String empresa;

  TtAniversariantes2(
      {this.diaNascimento, this.nomeFuncionario, this.cargo, this.empresa});

  TtAniversariantes2.fromJson(Map<String, dynamic> json) {
    diaNascimento = json['diaNascimento'];
    nomeFuncionario = json['nomeFuncionario'];
    cargo = json['cargo'];
    empresa = json['empresa'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['diaNascimento'] = this.diaNascimento;
    data['nomeFuncionario'] = this.nomeFuncionario;
    data['cargo'] = this.cargo;
    data['empresa'] = this.empresa;
    return data;
  }
}
