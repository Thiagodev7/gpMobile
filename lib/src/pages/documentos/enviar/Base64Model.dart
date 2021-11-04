// import 'dart:convert';

class Base64Model {
  Request request;

  Base64Model({this.request});

  Base64Model.fromJson(Map<String, dynamic> json) {
    request =
        json['request'] != null ? new Request.fromJson(json['request']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.request != null) {
      data['request'] = this.request.toJson();
    }
    return data;
  }
}

class Request {
  String lchrArquivoBase64;

  Request({this.lchrArquivoBase64});

  Request.fromJson(Map<String, dynamic> json) {
    lchrArquivoBase64 = json['lchrArquivoBase64'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lchrArquivoBase64'] = this.lchrArquivoBase64;
    return data;
  }
}
