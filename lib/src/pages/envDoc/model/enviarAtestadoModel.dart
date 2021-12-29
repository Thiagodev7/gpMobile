class EnviarAtestadoModel {
  String code;
  bool success;
  String process;
  String errorMessage;
  int neoId;

  EnviarAtestadoModel(
      {this.code, this.success, this.process, this.errorMessage, this.neoId});

  EnviarAtestadoModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    success = json['success'];
    process = json['process '];
    errorMessage = json['errorMessage'];
    neoId = json['neoId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['success'] = this.success;
    data['process '] = this.process;
    data['errorMessage'] = this.errorMessage;
    data['neoId'] = this.neoId;
    return data;
  }
}
