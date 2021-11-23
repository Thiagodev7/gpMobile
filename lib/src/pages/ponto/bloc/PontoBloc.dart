import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:gpmobile/src/pages/ponto/model/BaterPontoModel.dart';
import 'package:gpmobile/src/pages/ponto/model/PontoAssinaturaModel.dart';
import 'package:gpmobile/src/pages/ponto/service/PontoServices.dart';
import 'package:gpmobile/src/util/AlertDialogTemplate.dart';
import 'package:gpmobile/src/util/GetIp.dart';
import 'package:gpmobile/src/util/Globals.dart';
import 'package:gpmobile/src/util/TokenModel.dart';
import 'package:gpmobile/src/util/TokenServices.dart';
import 'package:gpmobile/src/util/notifica%C3%A7%C3%B5es/notific.dart';
import 'package:path/path.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/PontoModel.dart';

class PontoBloc extends BlocBase {
  bool ver;
  BaterPontoModel baterPontoModel;

  //validando assinatura...
  Future<PontoAssinaturaModel> blocPontoAssinar(
      BuildContext context, String mesRef, String anoRef, int assinar) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String pempresa = prefs.getString('empresa');
    String pmatricula = prefs.getString('matricula');
    bool baterPonto = prefs.getBool('permitirBaterPonto');
    TokenModel token;

    PontoAssinaturaModel _pointAssigned;
    ProgressDialog progressDialog2 = new AlertDialogTemplate()
        .showProgressDialog(context, "Validando assinatura do ponto...");
    if (assinar != null) {
      await progressDialog2.hide();
    }

    // await progressDialog2.show();

    await new TokenServices().getToken().then((map) async {
      token = map;

      if (token == null) {
        // progressDialog2.hide();
        AlertDialogTemplate()
            .showAlertDialogSimples(context, "Erro", "Erro ao buscar token");
        return null;
      } else {
        // return print('dados enviados, ok!!!');

        await new PontoService()
            .postPointAssinar(context, token.response.token, pmatricula,
                pempresa, mesRef, anoRef, assinar)
            .then((map) async {
          _pointAssigned = map;
          // progressDialog2.hide();
          if (_pointAssigned == null ||
              _pointAssigned.response.pIntCodErro != 0) {
            //Caso não encontre usuário no datasul

            if (assinar == 1) {
              //CASO-RETORNE=1
              await AlertDialogTemplate().showAlertDialogSimples(
                  context,
                  "Erro",
                  "Ponto assinado com sucesso! " +
                      _pointAssigned.response.pChrDescErro);
            }
          } else {
            return _pointAssigned;
          }
        });
      }
    });
    return _pointAssigned;
  }

  //verificação se pode bater o ponto ou nao pelo app..
  Future<bool> getPermiteBaterPonto() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool res = prefs.getBool('permiteBaterPonto');
    await verificacaoIP();
    if (res) {
      bool permit = true;
      return permit;
    } else {
      bool permit = false;
      return permit;
    }
  }

  //Bater o ponto..

  Future<BaterPontoModel> blocBaterPonto(
      BuildContext context, bool barraStatus, int operacao) async {
    /// *[VARIAVEIS]
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String empresa = prefs.getString('empresa');
    String matricula = prefs.getString('matricula');
    final snackBar = SnackBar(
      content: const Text('Confirmado! Voce Bateu o ponto!'),
    );
    TokenModel token;
    ProgressDialog progressDialog2 =
        new AlertDialogTemplate().showProgressDialog(context, "Aguarde...");
    //

    if (barraStatus == true) {
      await new TokenServices().getToken().then((mapToken) async {
        //pegar token
        token = mapToken;
        if (token == null) {
          //validar token
          await progressDialog2.hide();
          AlertDialogTemplate()
              .showAlertDialogSimples(context, "Erro", "Erro ao buscar token");
          return null;
        } else {
          await progressDialog2.hide();
          await new PontoService()
              .postBaterPonto(context, token.response.token, matricula, empresa,
                  entradaSaida, operacao, intervalo)
              .then((retornoDoPost) async {
            baterPontoModel = retornoDoPost;

            if (baterPontoModel == null ||
                baterPontoModel.response.pIntCodErro != 0) {
              await progressDialog2.hide();
              await AlertDialogTemplate().showAlertDialogSimples(
                  context,
                  "Atencao",
                  "Erro ao Bater o Ponto! \nerro:" +
                      baterPontoModel.response.pChrDescErro);
              return null;
            } else {
              await progressDialog2.hide();
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              intervalo ? Notific().showNotificationWithChronometer() : null;
              intervalo ? Notific().showNotificationWithShedule() : null;
            }
          });
        }
      });
    }
    return baterPontoModel;
  }

  //retorno time

  Future<BaterPontoModel> retornoTime(
      BuildContext context, bool barraStatus, int operacao) async {
    /// *[VARIAVEIS]
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String empresa = prefs.getString('empresa');
    String matricula = prefs.getString('matricula');

    TokenModel token;
    //

    if (barraStatus == true) {
      await new TokenServices().getToken().then((mapToken) async {
        //pegar token
        token = mapToken;
        if (token == null) {
          //validar token
          AlertDialogTemplate()
              .showAlertDialogSimples(context, "Erro", "Erro ao buscar token");
          return null;
        } else {
          await new PontoService()
              .postBaterPonto(context, token.response.token, matricula, empresa,
                  entradaSaida, operacao, intervalo)
              .then((retornoDoPost) async {
            baterPontoModel = retornoDoPost;

            if (baterPontoModel != null) {
              //Caso retorne null
              if (barraStatus == false) {
                await AlertDialogTemplate().showAlertDialogSimples(
                    context,
                    "Atencao",
                    "Erro ao Bater o Ponto! \nerro:" +
                        baterPontoModel.response.pChrDescErro);
              }
              return null;
            }
          });
        }
      });
    }
    return baterPontoModel;
  }

  //apos validar assinatura..

  Future<PontoModel> getPontoPeriodo(BuildContext context, String pintMes,
      String pintAno, bool barraStatus) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String pchrEmpresa = prefs.getString('empresa');
    String pintMatricula = prefs.getString('matricula');
    TokenModel token;
    PontoModel _ponto;
    ProgressDialog progressDialog = new AlertDialogTemplate()
        .showProgressDialog(context, "Buscando seu ponto...");
    if (barraStatus == true) {
      await progressDialog.show();
    }

    await new TokenServices().getToken().then((map) async {
      token = map;

      if (token == null) {
        progressDialog.hide();
        AlertDialogTemplate()
            .showAlertDialogSimples(context, "Erro", "Erro ao buscar token");
        progressDialog.hide();
        return null;
      } else {
        await new PontoService()
            .getPonto(context, token.response.token, pchrEmpresa, pintMatricula,
                pintMes, pintAno)
            .then((map) async {
          _ponto = map;
          // progressDialog.hide();
          if (_ponto == null || _ponto.response.pIntCodErro != 0) {
            //Caso não encontre usuário no datasul
            progressDialog.hide();
            if (barraStatus == true) {
              await AlertDialogTemplate().showAlertDialogSimples(
                  context,
                  "Erro",
                  "Ponto nao encontrado! " + _ponto.response.pChrDescErro);
            }
            return null;
          } else {
            return _ponto;
          }
        });
        progressDialog.hide();
      }
    });
    // await progressDialog.hide();
    return _ponto;
  }

  verificacaoIP() async {
    String ip;
    String ips;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await GetIp().getIp().then((map) async {
      if (map == null) {
        ip = "";
      } else {
        ip = map;
      }
    });
    ips = prefs.getString('ipsLiberadosConexoesInternas');
    int value = ips.indexOf(ip);

    if (value == -1) {
      ver = false;
      return ver;
    } else {
      ver = true;
      return ver;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
