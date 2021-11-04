class LoginModel {
  Response response;

  LoginModel({this.response});

  LoginModel.fromJson(Map<String, dynamic> json) {
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
  TtUsuario ttUsuario;

  Response({this.pIntCodErro, this.pChrDescErro, this.ttUsuario});

  Response.fromJson(Map<String, dynamic> json) {
    pIntCodErro = json['pIntCodErro'];
    pChrDescErro = json['pChrDescErro'];
    ttUsuario = json['ttUsuario'] != null
        ? new TtUsuario.fromJson(json['ttUsuario'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pIntCodErro'] = this.pIntCodErro;
    data['pChrDescErro'] = this.pChrDescErro;
    if (this.ttUsuario != null) {
      data['ttUsuario'] = this.ttUsuario.toJson();
    }
    return data;
  }
}

class TtUsuario {
  List<TtUsuario2> ttUsuario;

  TtUsuario({this.ttUsuario});

  TtUsuario.fromJson(Map<String, dynamic> json) {
    if (json['ttUsuario'] != null) {
      // ignore: deprecated_member_use
      ttUsuario = new List<TtUsuario2>();
      json['ttUsuario'].forEach((v) {
        ttUsuario.add(new TtUsuario2.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.ttUsuario != null) {
      data['ttUsuario'] = this.ttUsuario.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TtUsuario2 {
  String usuario; //alterado int para String
  String nome;
  String senha;
  String codEmpresa;
  String nomeEmpresa;
  int matriculaFunc;
  String cargo;
  String dataAdmissao;
  bool userAdmin;
  //add 3 variaceis
  int num_ddd;
  int num_telefone;
  String email;

  TtUsuario2(
      {this.usuario,
      this.nome,
      this.senha,
      this.codEmpresa,
      this.nomeEmpresa,
      this.matriculaFunc,
      this.cargo,
      this.dataAdmissao,
      this.userAdmin,
      //
      this.num_ddd,
      this.num_telefone,
      this.email});

  TtUsuario2.fromJson(Map<String, dynamic> json) {
    usuario = json['usuario'];
    nome = json['nome'];
    senha = json['senha'];
    codEmpresa = json['codEmpresa'];
    nomeEmpresa = json['nomeEmpresa'];
    matriculaFunc = json['matriculaFunc'];
    cargo = json['cargo'];
    dataAdmissao = json['dataAdmissao'];
    userAdmin = json['userAdmin'];
    //
    num_ddd = json['num_ddd'];
    num_telefone = json['num_telefone'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['usuario'] = this.usuario;
    data['nome'] = this.nome;
    data['senha'] = this.senha;
    data['codEmpresa'] = this.codEmpresa;
    data['nomeEmpresa'] = this.nomeEmpresa;
    data['matriculaFunc'] = this.matriculaFunc;
    data['cargo'] = this.cargo;
    data['dataAdmissao'] = this.dataAdmissao;
    data['userAdmin'] = this.userAdmin;
    //
    data['num_ddd'] = this.num_ddd;
    data['num_telefone'] = this.num_telefone;
    data['email'] = this.email;
    //
    return data;
  }

  @override
  String toString() {
    return "Usuario:" + this.usuario + "Senha:" + this.senha;
  }
}
