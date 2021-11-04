class FeriasModel {
  Response response;

  FeriasModel({this.response});

  FeriasModel.fromJson(Map<String, dynamic> json) {
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
  TtFerias ttFerias;

  Response({this.pIntCodErro, this.pChrDescErro, this.ttFerias});

  Response.fromJson(Map<String, dynamic> json) {
    pIntCodErro = json['pIntCodErro'];
    pChrDescErro = json['pChrDescErro'];
    ttFerias = json['ttFerias'] != null
        ? new TtFerias.fromJson(json['ttFerias'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pIntCodErro'] = this.pIntCodErro;
    data['pChrDescErro'] = this.pChrDescErro;
    if (this.ttFerias != null) {
      data['ttFerias'] = this.ttFerias.toJson();
    }
    return data;
  }
}

class TtFerias {
  List<TtFerias2> ttFerias2;

  TtFerias({this.ttFerias2});

  TtFerias.fromJson(Map<String, dynamic> json) {
    if (json['tt-Ferias'] != null) {
      // ignore: deprecated_member_use
      ttFerias2 = new List<TtFerias2>();
      json['tt-Ferias'].forEach((v) {
        ttFerias2.add(new TtFerias2.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.ttFerias2 != null) {
      data['tt-Ferias'] = this.ttFerias2.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TtFerias2 {
  String periodoI;
  String periodoF;
  String concessaoI;
  String concessaoF;
  int mesFerias;
  int anoFerias;
  int diasAGozar;
  int abono;
  bool executadas;

  TtFerias2(
      {this.periodoI,
      this.periodoF,
      this.concessaoI,
      this.concessaoF,
      this.mesFerias,
      this.anoFerias,
      this.diasAGozar,
      this.abono,
      this.executadas});

  TtFerias2.fromJson(Map<String, dynamic> json) {
    periodoI = json['PeriodoI'];
    periodoF = json['PeriodoF'];
    concessaoI = json['ConcessaoI'];
    concessaoF = json['ConcessaoF'];
    mesFerias = json['MesFerias'];
    anoFerias = json['AnoFerias'];
    diasAGozar = json['DiasAGozar'];
    abono = json['Abono'];
    executadas = json['Executadas'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PeriodoI'] = this.periodoI;
    data['PeriodoF'] = this.periodoF;
    data['ConcessaoI'] = this.concessaoI;
    data['ConcessaoF'] = this.concessaoF;
    data['MesFerias'] = this.mesFerias;
    data['AnoFerias'] = this.anoFerias;
    data['DiasAGozar'] = this.diasAGozar;
    data['Abono'] = this.abono;
    data['Executadas'] = this.executadas;
    return data;
  }
}
