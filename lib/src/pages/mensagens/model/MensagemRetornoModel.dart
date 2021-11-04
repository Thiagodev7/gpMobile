import 'package:intl/intl.dart';

class MensagemRetornoModel {
  Response response;

  MensagemRetornoModel({this.response});

  MensagemRetornoModel.fromJson(Map<String, dynamic> json) {
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
  DsMensagens dsMensagens;

  Response({this.pIntCodErro, this.pChrDescErro, this.dsMensagens});

  Response.fromJson(Map<String, dynamic> json) {
    pIntCodErro = json['pIntCodErro'];
    pChrDescErro = json['pChrDescErro'];
    dsMensagens = json['dsMensagens'] != null
        ? new DsMensagens.fromJson(json['dsMensagens'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pIntCodErro'] = this.pIntCodErro;
    data['pChrDescErro'] = this.pChrDescErro;
    if (this.dsMensagens != null) {
      data['dsMensagens'] = this.dsMensagens.toJson();
    }
    return data;
  }
}

class DsMensagens {
  DsMensagens2 dsMensagens2;

  DsMensagens({this.dsMensagens2});

  DsMensagens.fromJson(Map<String, dynamic> json) {
    dsMensagens2 = json['dsMensagens'] != null
        ? new DsMensagens2.fromJson(json['dsMensagens'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.dsMensagens2 != null) {
      data['dsMensagens'] = this.dsMensagens2.toJson();
    }
    return data;
  }
}

class DsMensagens2 {
  List<TtMensagens> ttMensagens;

  DsMensagens2({this.ttMensagens});

  DsMensagens2.fromJson(Map<String, dynamic> json) {
    if (json['ttMensagens'] != null) {
      ttMensagens = new List<TtMensagens>();
      json['ttMensagens'].forEach((v) {
        ttMensagens.add(new TtMensagens.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.ttMensagens != null) {
      data['ttMensagens'] = this.ttMensagens.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TtMensagens {
  String titulo;
  String mensagem;
  String dataCriacao;
  String horaCriacao;
  String usuarioCriacao;
  String plataforma;
  bool requerCiencia;
  bool ativa;
  String categoria;
  String hashtag;
  String usuariosDestino;
  int codMensagem;
  int operacao;
  String usuarioRequi;
  List<TtMensVisu> ttMensVisu;

  TtMensagens(
      {this.titulo,
        this.mensagem,
        this.dataCriacao,
        this.horaCriacao,
        this.usuarioCriacao,
        this.plataforma,
        this.requerCiencia,
        this.ativa,
        this.categoria,
        this.hashtag,
        this.usuariosDestino,
        this.codMensagem,
        this.operacao,
        this.usuarioRequi,
        this.ttMensVisu});

  DateFormat f = new DateFormat('dd/MM/yy', 'pt');
  TtMensagens.fromJson(Map<String, dynamic> json) {
    titulo = json['titulo'];
    mensagem = json['mensagem'];
    dataCriacao = f.format(DateTime.parse(json['dataCriacao'])).toString();
    horaCriacao = json['horaCriacao'];
    usuarioCriacao = json['usuarioCriacao'];
    plataforma = json['plataforma'];
    requerCiencia = json['requerCiencia'];
    ativa = json['ativa'];
    categoria = json['categoria'];
    hashtag = json['hashtag'];
    usuariosDestino = json['usuariosDestino'];
    codMensagem = json['codMensagem'];
    operacao = json['operacao'];
    usuarioRequi = json['usuarioRequi'];
    if (json['ttMensVisu'] != null) {
      ttMensVisu = new List<TtMensVisu>();
      json['ttMensVisu'].forEach((v) {
        ttMensVisu.add(new TtMensVisu.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['titulo'] = this.titulo;
    data['mensagem'] = this.mensagem;
    data['dataCriacao'] = this.dataCriacao;
    data['horaCriacao'] = this.horaCriacao;
    data['usuarioCriacao'] = this.usuarioCriacao;
    data['plataforma'] = this.plataforma;
    data['requerCiencia'] = this.requerCiencia;
    data['ativa'] = this.ativa;
    data['categoria'] = this.categoria;
    data['hashtag'] = this.hashtag;
    data['usuariosDestino'] = this.usuariosDestino;
    data['codMensagem'] = this.codMensagem;
    data['operacao'] = this.operacao;
    data['usuarioRequi'] = this.usuarioRequi;
    if (this.ttMensVisu != null) {
      data['ttMensVisu'] = this.ttMensVisu.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TtMensVisu {
  String dataVisu;
  String horaVisu;
  String usuarioVisu;
  String plataforma;
  bool cienciaConfirmada;
  String ipDispositivo;
  int codMensagem;

  TtMensVisu(
      {this.dataVisu,
        this.horaVisu,
        this.usuarioVisu,
        this.plataforma,
        this.cienciaConfirmada,
        this.ipDispositivo,
        this.codMensagem});

  DateFormat f = new DateFormat('dd/MM/yy', 'pt');
  TtMensVisu.fromJson(Map<String, dynamic> json) {
    dataVisu = f.format(DateTime.parse(json['dataVisu'])).toString();
    horaVisu = json['horaVisu'];
    usuarioVisu = json['usuarioVisu'];
    plataforma = json['plataforma'];
    cienciaConfirmada = json['cienciaConfirmada'];
    ipDispositivo = json['ipDispositivo'];
    codMensagem = json['codMensagem'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dataVisu'] = this.dataVisu;
    data['horaVisu'] = this.horaVisu;
    data['usuarioVisu'] = this.usuarioVisu;
    data['plataforma'] = this.plataforma;
    data['cienciaConfirmada'] = this.cienciaConfirmada;
    data['ipDispositivo'] = this.ipDispositivo;
    data['codMensagem'] = this.codMensagem;
    return data;
  }
}
