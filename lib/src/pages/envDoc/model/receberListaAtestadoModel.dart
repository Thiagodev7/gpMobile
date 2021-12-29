class ReceberListaAtestadoModel {
  int codErro;
  String descErro;
  List<Processos> processos;

  ReceberListaAtestadoModel({this.codErro, this.descErro, this.processos});

  ReceberListaAtestadoModel.fromJson(Map<String, dynamic> json) {
    codErro = json['codErro'];
    descErro = json['descErro'];
    if (json['processos'] != null) {
      processos = new List<Processos>();
      json['processos'].forEach((v) {
        processos.add(new Processos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['codErro'] = this.codErro;
    data['descErro'] = this.descErro;
    if (this.processos != null) {
      data['processos'] = this.processos.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Processos {
  bool sesmtStatus;
  String processState;
  String sesmtDataAnalise;
  String sesmtAnalista;
  String dataSolicitacao;
  String colaborador;
  String fimAfastamento;
  String processCode;
  String medico;
  String justificativa;
  String nomeArquivo;
  String matricula;
  String inicioAfastamento;
  String empresa;
  String hospital;
  String processNeoId;
  String crm;
  String cid;

  Processos(
      {this.sesmtStatus,
      this.processState,
      this.sesmtDataAnalise,
      this.sesmtAnalista,
      this.dataSolicitacao,
      this.colaborador,
      this.fimAfastamento,
      this.processCode,
      this.medico,
      this.justificativa,
      this.nomeArquivo,
      this.matricula,
      this.inicioAfastamento,
      this.empresa,
      this.hospital,
      this.processNeoId,
      this.crm,
      this.cid});

  Processos.fromJson(Map<String, dynamic> json) {
    sesmtStatus = json['sesmtStatus'];
    processState = json['processState'];
    sesmtDataAnalise = json['sesmtDataAnalise'];
    sesmtAnalista = json['sesmtAnalista'];
    dataSolicitacao = json['dataSolicitacao'];
    colaborador = json['colaborador'];
    fimAfastamento = json['fimAfastamento'];
    processCode = json['processCode'];
    medico = json['medico'];
    justificativa = json['justificativa'];
    nomeArquivo = json['nomeArquivo'];
    matricula = json['matricula'];
    inicioAfastamento = json['inicioAfastamento'];
    empresa = json['empresa'];
    hospital = json['hospital'];
    processNeoId = json['processNeoId'];
    crm = json['crm'];
    cid = json['cid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sesmtStatus'] = this.sesmtStatus;
    data['processState'] = this.processState;
    data['sesmtDataAnalise'] = this.sesmtDataAnalise;
    data['sesmtAnalista'] = this.sesmtAnalista;
    data['dataSolicitacao'] = this.dataSolicitacao;
    data['colaborador'] = this.colaborador;
    data['fimAfastamento'] = this.fimAfastamento;
    data['processCode'] = this.processCode;
    data['medico'] = this.medico;
    data['justificativa'] = this.justificativa;
    data['nomeArquivo'] = this.nomeArquivo;
    data['matricula'] = this.matricula;
    data['inicioAfastamento'] = this.inicioAfastamento;
    data['empresa'] = this.empresa;
    data['hospital'] = this.hospital;
    data['processNeoId'] = this.processNeoId;
    data['crm'] = this.crm;
    data['cid'] = this.cid;
    return data;
  }
}
