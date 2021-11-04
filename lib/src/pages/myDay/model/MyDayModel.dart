class MyDayModel {
  Response response;

  MyDayModel({this.response});

  MyDayModel.fromJson(Map<String, dynamic> json) {
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
  TtMeudia ttMeudia;

  Response({this.pIntCodErro, this.pChrDescErro, this.ttMeudia});

  Response.fromJson(Map<String, dynamic> json) {
    pIntCodErro = json['pIntCodErro'];
    pChrDescErro = json['pChrDescErro'];
    ttMeudia = json['ttMeudia'] != null
        ? new TtMeudia.fromJson(json['ttMeudia'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pIntCodErro'] = this.pIntCodErro;
    data['pChrDescErro'] = this.pChrDescErro;
    if (this.ttMeudia != null) {
      data['ttMeudia'] = this.ttMeudia.toJson();
    }
    return data;
  }
}

class TtMeudia {
  List<TtMeudia2> ttMeudia2;

  TtMeudia({this.ttMeudia2});

  TtMeudia.fromJson(Map<String, dynamic> json) {
    if (json['tt-meudia'] != null) {
      // ignore: deprecated_member_use
      ttMeudia2 = new List<TtMeudia2>();
      json['tt-meudia'].forEach((v) {
        ttMeudia2.add(new TtMeudia2.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.ttMeudia2 != null) {
      data['tt-meudia'] =
          this.ttMeudia2.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TtMeudia2 {
  String matricula;
  String nome;
  String empresa;
  int ano;
  String dataAniv;
  String observacao;
  String periodoIni;
  String periodoFim;

  TtMeudia2(
      {this.matricula,
        this.nome,
        this.empresa,
        this.ano,
        this.dataAniv,
        this.observacao,
        this.periodoIni,
        this.periodoFim});

  TtMeudia2.fromJson(Map<String, dynamic> json) {
    matricula = json['matricula'];
    nome = json['nome'];
    empresa = json['empresa'];
    ano = json['ano'];
    dataAniv = json['dataAniv'];
    observacao = json['observacao'];
    periodoIni = json['periodoIni'];
    periodoFim = json['periodoFim'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['matricula'] = this.matricula;
    data['nome'] = this.nome;
    data['empresa'] = this.empresa;
    data['ano'] = this.ano;
    data['dataAniv'] = this.dataAniv;
    data['observacao'] = this.observacao;
    data['periodoIni'] = this.periodoIni;
    data['periodoFim'] = this.periodoFim;
    return data;
  }
}
