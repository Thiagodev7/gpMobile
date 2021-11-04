class PontoModel {
  Response response;

  PontoModel({this.response});

  PontoModel.fromJson(Map<String, dynamic> json) {
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
  TtPonto ttPonto;

  Response({this.pIntCodErro, this.pChrDescErro, this.ttPonto});

  Response.fromJson(Map<String, dynamic> json) {
    pIntCodErro = json['pIntCodErro'];
    pChrDescErro = json['pChrDescErro'];
    ttPonto =
        json['ttPonto'] != null ? new TtPonto.fromJson(json['ttPonto']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pIntCodErro'] = this.pIntCodErro;
    data['pChrDescErro'] = this.pChrDescErro;
    if (this.ttPonto != null) {
      data['ttPonto'] = this.ttPonto.toJson();
    }
    return data;
  }
}

class TtPonto {
  List<TtPonto2> ttPonto2;

  TtPonto({this.ttPonto2});

  TtPonto.fromJson(Map<String, dynamic> json) {
    if (json['ttPonto'] != null) {
      // ignore: deprecated_member_use
      ttPonto2 = new List<TtPonto2>();
      json['ttPonto'].forEach((v) {
        ttPonto2.add(new TtPonto2.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.ttPonto2 != null) {
      data['ttPonto'] = this.ttPonto2.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TtPonto2 {
  String empresa;
  String estab;
  int codFunc;
  String datMarcacao;
  String horaIni;
  String horaAlmIni;
  String horaAlmFim;
  String horaFim;
  String obs;

  TtPonto2(
      {this.empresa,
      this.estab,
      this.codFunc,
      this.datMarcacao,
      this.horaIni,
      this.horaAlmIni,
      this.horaAlmFim,
      this.horaFim,
      this.obs});

  TtPonto2.fromJson(Map<String, dynamic> json) {
    empresa = json['empresa'];
    estab = json['estab'];
    codFunc = json['codFunc'];
    datMarcacao = json['datMarcacao'];
    horaIni = json['horaIni'];
    horaAlmIni = json['horaAlmIni'];
    horaAlmFim = json['horaAlmFim'];
    horaFim = json['horaFim'];
    obs = json['obs'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empresa'] = this.empresa;
    data['estab'] = this.estab;
    data['codFunc'] = this.codFunc;
    data['datMarcacao'] = this.datMarcacao;
    data['horaIni'] = this.horaIni;
    data['horaAlmIni'] = this.horaAlmIni;
    data['horaAlmFim'] = this.horaAlmFim;
    data['horaFim'] = this.horaFim;
    data['obs'] = this.obs;
    return data;
  }
}
