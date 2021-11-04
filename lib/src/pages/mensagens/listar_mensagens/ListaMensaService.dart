import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gpmobile/src/pages/mensagens/model/MensagemEnvioModel.dart';
import 'package:gpmobile/src/pages/mensagens/model/MensagemRetornoModel.dart';
import 'package:gpmobile/src/util/AlertDialogTemplate.dart';
import 'package:gpmobile/src/util/BuscaUrl.dart';
import 'package:http/http.dart' as http;

/// * [supostoerro] na linha 50...

class VisualizarMensaService {
  MensagemRetornoModel _tabelaMensagens = new MensagemRetornoModel();

  Future<MensagemRetornoModel> getMensaService(
    BuildContext context,
    String token,
    MensagemEnvioModel parametrosMensagemEnvio
  ) async {
    try {
      final response = await http.post(await new BuscaUrl().url("enviarRecebeMensa") + token,
          headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(parametrosMensagemEnvio),

      ); //Busca mensagens

      print(jsonEncode(parametrosMensagemEnvio));

      if (response.statusCode == 200) {
        // var descodeJson = jsonDecode(response.body));
        var descodeJson = jsonDecode(utf8.decode(response.bodyBytes));
        if (descodeJson != null) {
          _tabelaMensagens = MensagemRetornoModel.fromJson(descodeJson);
          // ProgressDialog progressDialog = new AlertDialogTemplate()
          // .showProgressDialog(context, "Carregando tabela de arquivos...");
        }
        return _tabelaMensagens;
      } else {
        retornaMensagem(context, parametrosMensagemEnvio.request.ttMensagens.ttMensagens2.first.operacao, response.statusCode.toString());
        return null;
      }
    } catch (e) {
      retornaMensagem(context, parametrosMensagemEnvio.request.ttMensagens.ttMensagens2.first.operacao, e.toString());
      return null;
    }
  }

  Future<void> retornaMensagem(context, int codOeracao, String erro) async {
    switch(codOeracao){
      case 1 : {
        await new AlertDialogTemplate().showAlertDialogSimples(
            context,
            "Atencao",
            "Error ao gravar mensagem! \n" +
                "Código Erro: " +
                erro);
      }
      break;
      case 2: {
        await new AlertDialogTemplate().showAlertDialogSimples(
            context,
            "Atencao",
            "Error ao atualizar status de mensagem! \n" +
                "Código Erro: " +
                erro);
      }
      break;
      case 3 : {
        await new AlertDialogTemplate().showAlertDialogSimples(
            context,
            "Atencao",
            "Error ao buscar tabela de mensagens! \n" +
                "Código Erro: " +
                erro);
      }
      break;
      case 4 : {
        await new AlertDialogTemplate().showAlertDialogSimples(
            context,
            "Atencao",
            "Error ao buscar tabela de mensagens! \n" +
                "Código Erro: " +
                erro);
      }
      break;
    }
  }

}
