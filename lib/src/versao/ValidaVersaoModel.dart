class ValidaVersaoModel {
  Response response;

  ValidaVersaoModel({this.response});

  ValidaVersaoModel.fromJson(Map<String, dynamic> json) {
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
  String pChar;
  int pInt;
  dynamic pDec;
  String pDate;
  bool pLog;

  Response(
      {this.pIntCodErro,
      this.pChrDescErro,
      this.pChar,
      this.pInt,
      this.pDec,
      this.pDate,
      this.pLog});

  Response.fromJson(Map<String, dynamic> json) {
    pIntCodErro = json['pIntCodErro'];
    pChrDescErro = json['pChrDescErro'];
    pChar = json['pChar'];
    pInt = json['pInt'];
    pDec = json['pDec'];
    pDate = json['pDate'];
    pLog = json['pLog'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pIntCodErro'] = this.pIntCodErro;
    data['pChrDescErro'] = this.pChrDescErro;
    data['pChar'] = this.pChar;
    data['pInt'] = this.pInt;
    data['pDec'] = this.pDec;
    data['pDate'] = this.pDate;
    data['pLog'] = this.pLog;
    return data;
  }
}
