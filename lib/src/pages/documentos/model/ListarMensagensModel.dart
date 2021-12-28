class MensagensModel {
  Response response;

  MensagensModel({this.response});

  MensagensModel.fromJson(Map<String, dynamic> json) {
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
  TtMensagens ttMensagens;

  Response({this.pIntCodErro, this.pChrDescErro, this.ttMensagens});

  Response.fromJson(Map<String, dynamic> json) {
    pIntCodErro = json['pIntCodErro'];
    pChrDescErro = json['pChrDescErro'];
    ttMensagens = json['ttMensagens'] != null
        ? new TtMensagens.fromJson(json['ttMensagens'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pIntCodErro'] = this.pIntCodErro;
    data['pChrDescErro'] = this.pChrDescErro;
    if (this.ttMensagens != null) {
      data['ttMensagens'] = this.ttMensagens.toJson();
    }
    return data;
  }
}

class TtMensagens {
  List<TtMensagens2> ttMensagens2;

  TtMensagens({this.ttMensagens2});

  TtMensagens.fromJson(Map<String, dynamic> json) {
    if (json['ttMensagens'] != null) {
      ttMensagens2 = new List<TtMensagens2>();
      json['ttMensagens'].forEach((v) {
        ttMensagens2.add(new TtMensagens2.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.ttMensagens2 != null) {
      data['ttMensagens'] = this.ttMensagens2.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TtMensagens2 {
  int codDocumento;
  String categoria;
  String titulo;
  bool requerCiencia;
  String empresa;
  String descricao;
  String pathArquivo;
  String arquivoBase64;
  bool documentoLido;
  bool documentoAssinado;
  String dataCriacao;
  String horaCriacao;
  String tipoDocumento;

  TtMensagens2(
      {this.codDocumento,
      this.categoria,
      this.titulo,
      this.requerCiencia,
      this.empresa,
      this.descricao,
      this.pathArquivo,
      this.arquivoBase64,
      this.documentoLido,
      this.documentoAssinado,
      this.dataCriacao,
      this.horaCriacao,
      this.tipoDocumento});

  TtMensagens2.fromJson(Map<String, dynamic> json) {
    codDocumento = json['codDocumento'];
    categoria = json['categoria'];
    titulo = json['titulo'];
    requerCiencia = json['requerCiencia'];
    empresa = json['empresa'];
    descricao = json['descricao'];
    pathArquivo = json['pathArquivo'];
    arquivoBase64 = json['arquivoBase64'];
    documentoLido = json['documentoLido'];
    documentoAssinado = json['documentoAssinado'];
    dataCriacao = json['dataCriacao'];
    horaCriacao = json['horaCriacao'];
    tipoDocumento = json['tipoDocumento'];
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
    data['documentoLido'] = this.documentoLido;
    data['documentoAssinado'] = this.documentoAssinado;
    data['dataCrtiacap'] = dataCriacao;
    data['horaCriacao'] = horaCriacao;
    data['tipoDocumento'] = tipoDocumento;
    return data;
  }
}
