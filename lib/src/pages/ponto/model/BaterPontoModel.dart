class BaterPontoModel {
  Response response;

  BaterPontoModel({this.response});

  BaterPontoModel.fromJson(Map<String, dynamic> json) {
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
  TtRetornoErro ttRetornoErro;

  Response({this.pIntCodErro, this.pChrDescErro, this.ttRetornoErro});

  Response.fromJson(Map<String, dynamic> json) {
    pIntCodErro = json['pIntCodErro'];
    pChrDescErro = json['pChrDescErro'];
    ttRetornoErro = json['ttRetornoErro'] != null
        ? new TtRetornoErro.fromJson(json['ttRetornoErro'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pIntCodErro'] = this.pIntCodErro;
    data['pChrDescErro'] = this.pChrDescErro;
    if (this.ttRetornoErro != null) {
      data['ttRetornoErro'] = this.ttRetornoErro.toJson();
    }
    return data;
  }
}

class TtRetornoErro {
  List<TtRetornoErro2> ttRetornoErro;

  TtRetornoErro({this.ttRetornoErro});

  TtRetornoErro.fromJson(Map<String, dynamic> json) {
    if (json['ttRetornoErro'] != null) {
      ttRetornoErro = new List<TtRetornoErro2>();
      json['ttRetornoErro'].forEach((v) {
        ttRetornoErro.add(new TtRetornoErro2.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.ttRetornoErro != null) {
      data['ttRetornoErro'] =
          this.ttRetornoErro.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TtRetornoErro2 {
  int numErro;
  String desErro;
  bool logErro;
  int horaUltimaBatidaEmSegundos;
  bool inicioIntervalo;

  TtRetornoErro2(
      {this.numErro,
      this.desErro,
      this.logErro,
      this.horaUltimaBatidaEmSegundos,
      this.inicioIntervalo});

  TtRetornoErro2.fromJson(Map<String, dynamic> json) {
    numErro = json['numErro'];
    desErro = json['desErro'];
    logErro = json['logErro'];
    horaUltimaBatidaEmSegundos = json['horaUltimaBatidaEmSegundos'];
    inicioIntervalo = json['inicioIntervalo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['numErro'] = this.numErro;
    data['desErro'] = this.desErro;
    data['logErro'] = this.logErro;
    data['horaUltimaBatidaEmSegundos'] = this.horaUltimaBatidaEmSegundos;
    data['inicioIntervalo'] = this.inicioIntervalo;
    return data;
  }
}
