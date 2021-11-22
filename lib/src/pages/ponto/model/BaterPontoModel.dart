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
  int numErro;
  String desErro;
  bool logErro;
  int horaUltimaBatidaEmSegundos;

  TtRetornoErro(
      {this.numErro,
      this.desErro,
      this.logErro,
      this.horaUltimaBatidaEmSegundos});

  TtRetornoErro.fromJson(Map<String, dynamic> json) {
    numErro = json['numErro'];
    desErro = json['desErro'];
    logErro = json['logErro'];
    horaUltimaBatidaEmSegundos = json['horaUltimaBatidaEmSegundos'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['numErro'] = this.numErro;
    data['desErro'] = this.desErro;
    data['logErro'] = this.logErro;
    data['horaUltimaBatidaEmSegundos'] = this.horaUltimaBatidaEmSegundos;
    return data;
  }
}
