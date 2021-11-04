class BcoHorasModel {
  Response response;

  BcoHorasModel({this.response});

  BcoHorasModel.fromJson(Map<String, dynamic> json) {
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
  TtBancoHoras ttBancoHoras;

  Response({this.pIntCodErro, this.pChrDescErro, this.ttBancoHoras});

  Response.fromJson(Map<String, dynamic> json) {
    pIntCodErro = json['pIntCodErro'];
    pChrDescErro = json['pChrDescErro'];
    ttBancoHoras = json['ttBancoHoras'] != null
        ? new TtBancoHoras.fromJson(json['ttBancoHoras'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pIntCodErro'] = this.pIntCodErro;
    data['pChrDescErro'] = this.pChrDescErro;
    if (this.ttBancoHoras != null) {
      data['ttBancoHoras'] = this.ttBancoHoras.toJson();
    }
    return data;
  }
}

class TtBancoHoras {
  List<TtBancoHoras2> ttBancoHoras2;

  TtBancoHoras({this.ttBancoHoras2});

  TtBancoHoras.fromJson(Map<String, dynamic> json) {
    if (json['tt-bancoHoras'] != null) {
      // ignore: deprecated_member_use
      ttBancoHoras2 = new List<TtBancoHoras2>();
      json['tt-bancoHoras'].forEach((v) {
        ttBancoHoras2.add(new TtBancoHoras2.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.ttBancoHoras2 != null) {
      data['tt-bancoHoras'] =
          this.ttBancoHoras2.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TtBancoHoras2 {
  String horasPositivas;
  String horasNegativas;
  String totalSaldoHoras;

  TtBancoHoras2(
      {this.horasPositivas, this.horasNegativas, this.totalSaldoHoras});

  TtBancoHoras2.fromJson(Map<String, dynamic> json) {
    horasPositivas = json['horasPositivas'];
    horasNegativas = json['horasNegativas'];
    totalSaldoHoras = json['TotalSaldoHoras'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['horasPositivas'] = this.horasPositivas;
    data['horasNegativas'] = this.horasNegativas;
    data['TotalSaldoHoras'] = this.totalSaldoHoras;
    return data;
  }
}
