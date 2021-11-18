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

    return data;
  }
}

class TtRetornoErro {
  List<Null> ttRetornoErro;

  TtRetornoErro({this.ttRetornoErro});

  TtRetornoErro.fromJson(Map<String, dynamic> json) {
    if (json['ttRetornoErro'] != null) {
      ttRetornoErro = new List<Null>();
      json['ttRetornoErro'].forEach((v) {
        //ttRetornoErro.add(new Null.fromJson(v));
      });
    }
  }
}
