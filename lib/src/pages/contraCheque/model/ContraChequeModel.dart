class ContraChequeModel {
  Response response;

  ContraChequeModel({this.response});

  ContraChequeModel.fromJson(Map<String, dynamic> json) {
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
  dynamic salarioBase;
  dynamic fgtsMes;
  TtMov ttMov;

  Response(
      {this.pIntCodErro,
      this.pChrDescErro,
      this.salarioBase,
      this.fgtsMes,
      this.ttMov});

  Response.fromJson(Map<String, dynamic> json) {
    pIntCodErro = json['pIntCodErro'];
    pChrDescErro = json['pChrDescErro'];
    salarioBase = json['salarioBase'];
    fgtsMes = json['fgtsMes'];
    ttMov = json['ttMov'] != null ? new TtMov.fromJson(json['ttMov']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pIntCodErro'] = this.pIntCodErro;
    data['pChrDescErro'] = this.pChrDescErro;
    data['salarioBase'] = this.salarioBase;
    data['fgtsMes'] = this.fgtsMes;
    if (this.ttMov != null) {
      data['ttMov'] = this.ttMov.toJson();
    }
    return data;
  }
}

class TtMov {
  List<TtMov2> ttMov2;

  TtMov({this.ttMov2});

  TtMov.fromJson(Map<String, dynamic> json) {
    if (json['ttMov'] != null) {
      // ignore: deprecated_member_use
      ttMov2 = new List<TtMov2>();
      json['ttMov'].forEach((v) {
        ttMov2.add(new TtMov2.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.ttMov2 != null) {
      data['ttMov'] = this.ttMov2.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

//usar variaveis do tipo=dynamic por causa da api_progress!!!
class TtMov2 {
  dynamic func;
  String evento;
  String descEvento;
  dynamic valor;
  dynamic qtdHoras;
  dynamic ageFunc;
  dynamic ctaFunc;
  String digCtaFunc;
  dynamic valHoras;
  dynamic sinal;

  TtMov2(
      {this.func,
      this.evento,
      this.descEvento,
      this.valor,
      this.qtdHoras,
      this.ageFunc,
      this.ctaFunc,
      this.digCtaFunc,
      this.valHoras,
      this.sinal});

  TtMov2.fromJson(Map<String, dynamic> json) {
    func = json['func'];
    evento = json['evento'];
    descEvento = json['descEvento'];
    valor = json['valor'];
    qtdHoras = json['qtdHoras'];
    ageFunc = json['ageFunc'];
    ctaFunc = json['ctaFunc'];
    digCtaFunc = json['digCtaFunc'];
    valHoras = json['valHoras'];
    sinal = json['sinal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['func'] = this.func;
    data['evento'] = this.evento;
    data['descEvento'] = this.descEvento;
    data['valor'] = this.valor;
    data['qtdHoras'] = this.qtdHoras;
    data['ageFunc'] = this.ageFunc;
    data['ctaFunc'] = this.ctaFunc;
    data['digCtaFunc'] = this.digCtaFunc;
    data['valHoras'] = this.valHoras;
    data['sinal'] = this.sinal;
    return data;
  }
}
