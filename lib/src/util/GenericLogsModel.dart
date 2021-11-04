class GenericLogsModel {
  Response response;

  GenericLogsModel({this.response});

  GenericLogsModel.fromJson(Map<String, dynamic> json) {
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
  TtLog ttLog;

  Response({this.pIntCodErro, this.pChrDescErro, this.ttLog});

  Response.fromJson(Map<String, dynamic> json) {
    pIntCodErro = json['pIntCodErro'];
    pChrDescErro = json['pChrDescErro'];
    ttLog = json['ttLog'] != null ? new TtLog.fromJson(json['ttLog']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pIntCodErro'] = this.pIntCodErro;
    data['pChrDescErro'] = this.pChrDescErro;
    if (this.ttLog != null) {
      data['ttLog'] = this.ttLog.toJson();
    }
    return data;
  }
}

class TtLog {
  List<TtLog2> ttLog2;

  TtLog({this.ttLog2});

  TtLog.fromJson(Map<String, dynamic> json) {
    if (json['tt-Log'] != null) {
      ttLog2 = <TtLog2>[];
      json['tt-Log'].forEach((v) {
        ttLog2.add(new TtLog2.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.ttLog2 != null) {
      data['tt-Log'] = this.ttLog2.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TtLog2 {
  int intDiasUltimoLog;
  bool logMesmoMesAno;
  String chrSistema;
  String chrModulo;
  String chrPrograma;
  String chrRotina;
  int intTipoRetonoRegistros;
  String dtIniFiltro;
  String  dtFimFiltro;
  String chrUsuario;
  String chrTexto;

  int intSequencia;

  String dtData;
  String chrHora;

  TtLog2(
      {this.intDiasUltimoLog,
        this.logMesmoMesAno,
        this.chrSistema,
        this.chrModulo,
        this.chrPrograma,
        this.chrRotina,
        this.intTipoRetonoRegistros,
        this.chrUsuario,
        this.chrTexto,


        this. intSequencia,

        this.dtIniFiltro,
        this.dtFimFiltro,
        this.dtData,
        this.chrHora});

  TtLog2.fromJson(Map<String, dynamic> json) {
    intDiasUltimoLog = json['intDiasUltimoLog'];
    logMesmoMesAno = json['logMesmoMesAno'];
    chrSistema = json['chrSistema'];
    chrModulo = json['chrModulo'];
    chrPrograma = json['chrPrograma'];
    chrRotina = json['chrRotina'];
    intTipoRetonoRegistros = json['intTipoRetonoRegistros'];
    chrUsuario = json['chrUsuario'];
    chrTexto = json['chrTexto'];

    intSequencia = json['intSequencia'];

    dtIniFiltro = json['dtIniFiltro'];
    dtFimFiltro = json['dtFimFiltro'];
    dtData = json['dtData'];
    chrHora = json['chrHora'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intDiasUltimoLog'] = this.intDiasUltimoLog;
    data['logMesmoMesAno'] = this.logMesmoMesAno;
    data['chrSistema'] = this.chrSistema;
    data['chrModulo'] = this.chrModulo;
    data['chrPrograma'] = this.chrPrograma;
    data['chrRotina'] = this.chrRotina;
    data['intTipoRetonoRegistros'] = this.intTipoRetonoRegistros;
    data['chrUsuario'] = this.chrUsuario;
    data['chrTexto'] = this.chrTexto;

    data['intSequencia'] = this.intSequencia;

    data['dtIniFiltro'] = this.dtIniFiltro;
    data['dtFimFiltro'] = this.dtFimFiltro;
    data['dtData'] = this.dtData;
    data['chrHora'] = this.chrHora;
    return data;
  }
}
