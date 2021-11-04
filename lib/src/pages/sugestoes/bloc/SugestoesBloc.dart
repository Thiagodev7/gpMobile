import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:gpmobile/src/pages/sugestoes/model/SugestoesModel.dart';
import 'package:gpmobile/src/util/AlertDialogTemplate.dart';
import 'package:gpmobile/src/util/GenericLogsModel.dart';
import 'package:gpmobile/src/util/TokenModel.dart';
import 'package:gpmobile/src/util/TokenServices.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../SugestoesService.dart';

/// Veja também:
///    [TIPO OPERACAO]
///  * [1] create.
///  * [2] fetch.
///
/// * [GenericLogsModel],[_sugestoesModel], é o retorno do service.
///
/// * [matricula], valor recebido via SharedPrefs via LoginBloc.
///
/// * [objMensa.matriculasView], recebe o valor da matricula.
///
/// * [token] variavel token recebe valor via map.
///
/// * [listMatriculas] Listar matricula de quem leu a mensagem.
///
/// * [mensagLidaPeloUsuario], inicia, [FALSE], por default.
///
class SugestoesBloc extends BlocBase {
  Future<SugestoesModel> blocSugestoes(
    BuildContext context,
    String blocSugestao,
    String blocPlataforma,
    int blocOperacao,
    bool barraStatus,
  ) async {
    /// *[VARIAVEIS]
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _blocCPF = prefs.getString('usuario');
    TokenModel token;
    SugestoesModel _sugestoesModel;
    List<SugestoesModel> listaMensBack = [];
    ProgressDialog progressDialog2 = new AlertDialogTemplate()
        .showProgressDialog(context, "Enviando sugestao...");
    //

    if (barraStatus == true) {
      await new TokenServices().getToken().then((mapToken) async {
        //pegar token
        token = mapToken;

        if (token == null) {
          //validar token
          progressDialog2.hide();
          AlertDialogTemplate()
              .showAlertDialogSimples(context, "Erro", "Erro ao buscar token");
          return null;
        } else {
          await new SugestoesService()
              .postSugestoes(
            context,
            token.response.token,
            _blocCPF,
            blocSugestao,
            blocPlataforma,
            blocOperacao,
          )
              .then((retornoDoPost) async {
            _sugestoesModel = retornoDoPost;
            if (_sugestoesModel != null) {
              //Caso retorne null
              if (barraStatus == false) {
                progressDialog2.hide();
                await AlertDialogTemplate().showAlertDialogSimples(
                    context,
                    "Atencao",
                    "Erro ao enviar arquivo! \nerro:" +
                        _sugestoesModel.response.pChrDescErro);
              }
              return null;
            }
            progressDialog2.hide();
          });
        }
      });
    }
    return _sugestoesModel;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
