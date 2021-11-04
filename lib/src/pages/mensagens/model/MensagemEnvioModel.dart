import 'package:stacked/stacked.dart';

class MensagemEnvioModel extends BaseViewModel{
  Request request;

  MensagemEnvioModel({this.request});

  MensagemEnvioModel.fromJson(Map<String, dynamic> json) {
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
  TtMensagens ttMensagens;
  TtMensVisu ttMensVisu;

  Request({this.ttMensagens, this.ttMensVisu});

  Request.fromJson(Map<String, dynamic> json) {
    ttMensagens = json['ttMensagens'] != null
        ? new TtMensagens.fromJson(json['ttMensagens'])
        : null;
    ttMensVisu = json['ttMensVisu'] != null
        ? new TtMensVisu.fromJson(json['ttMensVisu'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.ttMensagens != null) {
      data['ttMensagens'] = this.ttMensagens.toJson();
    }
    if (this.ttMensVisu != null) {
      data['ttMensVisu'] = this.ttMensVisu.toJson();
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

  TtMensagens2(
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
        this.usuarioRequi});

  TtMensagens2.fromJson(Map<String, dynamic> json) {
    titulo = json['titulo'];
    mensagem = json['mensagem'];
    dataCriacao = json['dataCriacao'];
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
    return data;
  }
}

class TtMensVisu {
  List<TtMensVisu2> ttMensVisu2;

  TtMensVisu({this.ttMensVisu2});

  TtMensVisu.fromJson(Map<String, dynamic> json) {
    if (json['ttMensVisu'] != null) {
      ttMensVisu2 = new List<TtMensVisu2>();
      json['ttMensVisu'].forEach((v) {
        ttMensVisu2.add(new TtMensVisu2.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.ttMensVisu2 != null) {
      data['ttMensVisu'] = this.ttMensVisu2.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TtMensVisu2 {
  String dataVisu;
  String horaVisu;
  String usuarioVisu;
  String plataforma;
  bool cienciaConfirmada;
  String ipDispositivo;
  int codMensagem;

  TtMensVisu2(
      {this.dataVisu,
        this.horaVisu,
        this.usuarioVisu,
        this.plataforma,
        this.cienciaConfirmada,
        this.ipDispositivo,
        this.codMensagem});

  TtMensVisu2.fromJson(Map<String, dynamic> json) {
    dataVisu = json['dataVisu'];
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
