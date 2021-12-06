class ListarDocModel {
  Response response;

  ListarDocModel({this.response});

  ListarDocModel.fromJson(Map<String, dynamic> json) {
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
  TtRetorno ttRetorno;

  Response({this.pIntCodErro, this.pChrDescErro, this.ttRetorno});

  Response.fromJson(Map<String, dynamic> json) {
    pIntCodErro = json['pIntCodErro'];
    pChrDescErro = json['pChrDescErro'];
    ttRetorno = json['ttRetorno'] != null
        ? new TtRetorno.fromJson(json['ttRetorno'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pIntCodErro'] = this.pIntCodErro;
    data['pChrDescErro'] = this.pChrDescErro;
    if (this.ttRetorno != null) {
      data['ttRetorno'] = this.ttRetorno.toJson();
    }
    return data;
  }
}

class TtRetorno {
  List<TtRetorno2> ttRetorno2;

  TtRetorno({this.ttRetorno2});

  TtRetorno.fromJson(Map<String, dynamic> json) {
    if (json['ttRetorno'] != null) {
      ttRetorno2 = new List<TtRetorno2>();
      json['ttRetorno'].forEach((v) {
        ttRetorno2.add(new TtRetorno2.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.ttRetorno2 != null) {
      data['ttRetorno'] = this.ttRetorno2.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TtRetorno2 {
  int codDocumento;
  String categoria;
  String titulo;
  bool requerCiencia;
  String empresa;
  String descricao;
  String pathArquivo;
  String arquivoBase64;

  TtRetorno2(
      {this.codDocumento,
      this.categoria,
      this.titulo,
      this.requerCiencia,
      this.empresa,
      this.descricao,
      this.pathArquivo,
      this.arquivoBase64});

  TtRetorno2.fromJson(Map<String, dynamic> json) {
    codDocumento = json['codDocumento'];
    categoria = json['categoria'];
    titulo = json['titulo'];
    requerCiencia = json['requerCiencia'];
    empresa = json['empresa'];
    descricao = json['descricao'];
    pathArquivo = json['pathArquivo'];
    arquivoBase64 = json['arquivoBase64'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['codDocumento'] = this.codDocumento;
    data['categoria'] = this.categoria;
    data['titulo'] = this.titulo;
    data['requerCiencia'] = this.requerCiencia;
    data['empresa'] = this.empresa;
    data['descricao'] = this.descricao;
    data['pathArquivo'] = this.pathArquivo;
    data['arquivoBase64'] = this.arquivoBase64;
    return data;
  }
}
