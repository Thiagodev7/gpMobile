import 'package:flutter/cupertino.dart';

class ListNotific {
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
  IconData icon1;
  IconData icon2;
  String tipo;

  ListNotific(
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
      this.icon1,
      this.tipo,
      this.icon2,
      this.tipoDocumento});
}
