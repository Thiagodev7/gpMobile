class SugestoesModel {
  Response response;

  SugestoesModel({this.response});

  SugestoesModel.fromJson(Map<String, dynamic> json) {
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
  TtRetSugestoes ttRetSugestoes;

  Response({this.pIntCodErro, this.pChrDescErro, this.ttRetSugestoes});

  Response.fromJson(Map<String, dynamic> json) {
    pIntCodErro = json['pIntCodErro'];
    pChrDescErro = json['pChrDescErro'];
    ttRetSugestoes = json['ttRetSugestoes'] != null
        ? new TtRetSugestoes.fromJson(json['ttRetSugestoes'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pIntCodErro'] = this.pIntCodErro;
    data['pChrDescErro'] = this.pChrDescErro;
    if (this.ttRetSugestoes != null) {
      data['ttRetSugestoes'] = this.ttRetSugestoes.toJson();
    }
    return data;
  }
}

class TtRetSugestoes {
  List<TtRetSugestoes2> ttRetSugestoes2;

  TtRetSugestoes({this.ttRetSugestoes2});

  TtRetSugestoes.fromJson(Map<String, dynamic> json) {
    if (json['tt-retSugestoes'] != null) {
      ttRetSugestoes2 = <TtRetSugestoes2>[];
      json['tt-retSugestoes'].forEach((v) {
        ttRetSugestoes2.add(new TtRetSugestoes2.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.ttRetSugestoes2 != null) {
      data['tt-retSugestoes'] =
          this.ttRetSugestoes2.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TtRetSugestoes2 {
  String cpf;
  int matricula;
  String dataCriacao;
  String horaCriacao;
  String sugestao;

  TtRetSugestoes2(
      {this.cpf,
      this.matricula,
      this.dataCriacao,
      this.horaCriacao,
      this.sugestao});

  TtRetSugestoes2.fromJson(Map<String, dynamic> json) {
    cpf = json['cpf'];
    matricula = json['matricula'];
    dataCriacao = json['dataCriacao'];
    horaCriacao = json['horaCriacao'];
    sugestao = json['sugestao'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cpf'] = this.cpf;
    data['matricula'] = this.matricula;
    data['dataCriacao'] = this.dataCriacao;
    data['horaCriacao'] = this.horaCriacao;
    data['sugestao'] = this.sugestao;
    return data;
  }
}
