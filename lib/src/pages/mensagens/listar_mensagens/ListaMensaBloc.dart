import 'dart:async';
import 'dart:core';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gpmobile/src/pages/mensagens/model/MensagemEnvioModel.dart' as MensagemEnvioModel;
import 'package:gpmobile/src/pages/mensagens/model/MensagemRetornoModel.dart' as MensagemRetornoModel;
import 'package:gpmobile/src/pages/mensagens/vizualizar_mensagens/PageHeroWidget.dart';
import 'package:gpmobile/src/pages/mensagens/vizualizar_mensagens/VisualizaMensaWidget.dart';
import 'package:gpmobile/src/util/AlertDialogTemplate.dart';
import 'package:gpmobile/src/util/TokenModel.dart';
import 'package:gpmobile/src/util/TokenServices.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ListaMensaService.dart';

class ListaMensaBloc extends BlocBase {
  /////////////////////////////////////////////////////////////////////
  Future<MensagemRetornoModel.MensagemRetornoModel> getMessageBack(BuildContext context, bool barraStatus) async {
    /// *[VARIAVEIS]
    TokenModel token;
    MensagemRetornoModel.MensagemRetornoModel _blocMensagens;

    MensagemEnvioModel.TtMensagens2 ttMensagens2 = MensagemEnvioModel.TtMensagens2();
    MensagemEnvioModel.TtMensVisu2 ttMensVisu2 = new MensagemEnvioModel.TtMensVisu2();
    ttMensagens2.operacao = 3; // 3 = Busca todas as mensagens

    ProgressDialog progressDialog = new AlertDialogTemplate()
        .showProgressDialog(context, "Carregando tabela de mensagens!");

    if (barraStatus == true) {

      await new TokenServices().getToken().then((map) async {
        token = map;

        if (token == null) {
          progressDialog.hide();
          AlertDialogTemplate().showAlertDialogSimples(
              context, "Atencao", "Erro ao buscar token!");
          return null;
        } else {
         await new ListaMensaBloc().retornaObjetoComParametrosDeBusca(ttMensagens2, ttMensVisu2).then((value) async => {
                await new VisualizarMensaService().getMensaService(context, token.response.token, value).then((map) async {
                      _blocMensagens = map;
                      progressDialog.hide();

                      ///*[Caso null]
                      if (_blocMensagens == null) {
                        if (barraStatus == true) {
                          await AlertDialogTemplate().showAlertDialogSimples(
                              context,
                              "Atencão",
                              "Erro ao buscar Tabela de mensagens!" +
                                  _blocMensagens.response.pChrDescErro);
                        }
                      }
                      else if (_blocMensagens.response.pIntCodErro != 0) {
                        await AlertDialogTemplate().showAlertDialogSimples(
                            context,
                            "Atencão",
                            "${_blocMensagens.response.pChrDescErro}");
                      }
                    }),
                  });

          progressDialog.hide();
        }
      });
    }
    return _blocMensagens;
  }

  Future<MensagemRetornoModel.MensagemRetornoModel> gravaStatusDeMensagemComoLida(BuildContext context, bool barraStatus, MensagemEnvioModel.TtMensagens2 ttMensagens2, MensagemEnvioModel.TtMensVisu2 ttMensVisu2 ) async {
    /// *[VARIAVEIS]
    TokenModel token;
    MensagemRetornoModel.MensagemRetornoModel _blocMensagens;

    ProgressDialog progressDialog = new AlertDialogTemplate().showProgressDialog(context, "Atualizando status de mensagem!");

    if (barraStatus == true) {
      await new TokenServices().getToken().then((map) async {
        token = map;

        if (token == null) {
          progressDialog.hide();
          AlertDialogTemplate().showAlertDialogSimples(
              context, "Atencao", "Erro ao buscar token!");
          return null;
        } else {
          await new ListaMensaBloc().retornaObjetoComParametrosDeBusca(ttMensagens2, ttMensVisu2).then((value) async => {
            await new VisualizarMensaService().getMensaService(context, token.response.token, value).then((map) async {
              _blocMensagens = map;
              progressDialog.hide();

              ///*[Caso null]
              if (_blocMensagens == null) {
                if (barraStatus == true) {
                  await AlertDialogTemplate().showAlertDialogSimples(
                      context,
                      "Atencão",
                      "Erro ao atualizar status de mensagem!" +
                          _blocMensagens.response.pChrDescErro);
                }
              }
              else if (_blocMensagens.response.pIntCodErro != 0) {
                await AlertDialogTemplate().showAlertDialogSimples(
                    context,
                    "Atencão",
                    "${_blocMensagens.response.pChrDescErro}");
              }
            }),
          });

          progressDialog.hide();
        }
      });
    }
    return _blocMensagens;
  }

  // ////////////////////////////////////////////////////////////////////////////////////////////
  // Future<List<String>> getListaMensaLida(
  //     BuildContext context, bool barraStatus) async {
  //   List<String> listMenBanco = [];
  //   final prefs = await SharedPreferences.getInstance();
  //   listMenBanco = prefs.getStringList('listaMensagensLidas') ?? [];
  //   return listMenBanco;
  // }
  //
  // ////////////////////////////////////////////////////////////////////////////////////////////

  // update 05/08
  Future<bool> actionOpenMsg(
      BuildContext context, MensagemRetornoModel.TtMensagens objMensa, _barraStatus, List<MensagemRetornoModel.TtMensagens> listOutrasMensagens) async {
    if (_barraStatus == true) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => new VisualizaMensaWidget(
              HeroType(
                  data: objMensa.dataCriacao,
                  titulo: objMensa.titulo,
                  mensagem: objMensa.mensagem),
                  objMensa,
                  listOutrasMensagens),
        ),
      );
    }
    return _barraStatus;
  }

  // Future<List<TtMensagens2>> atualizaListaDeMensagens(context) async {
  //   List<StatusModel> listaGlobalAtualiza;
  //   List<StatusModel> listaFinal = new List();
  //   List<StatusModel> listaFinal2 = new List();
  //   SharedPreferences.getInstance().then((prefs) {
  //     ListaMensaBloc().getMessageBack(context, true).then((map1) {
  //       // StatusModelMok().list().then((map1) {
  //       // setState(() {
  //       if (map1 != null) {
  //         listaGlobalAtualiza = map1;
  //
  //         if (map1 != null && map1.length > 0) {
  //           for (StatusModel indexList in listaGlobalAtualiza) {
  //             for (String matricula in indexList.matriculasView.split(",")) {
  //               if (matricula == prefs.getString('matricula'))
  //                 indexList.lido = true;
  //             }
  //             // setState(() {
  //             listaFinal.add(indexList);
  //             // });
  //           }
  //         } else {
  //           for (StatusModel mensBack1 in listaGlobalAtualiza) {
  //             // setState(() {
  //             listaFinal.add(mensBack1);
  //             // });
  //           }
  //         }
  //         // setState(() {
  //         listaFinal2.clear();
  //         ListaMensaBloc().addListener(() {
  //           listaFinal2
  //               .addAll(listaFinal.where((element) => element.lido == false));
  //         });
  //         // listaFinal2
  //         //     .addAll(listaFinal.where((element) => element.lido == false));
  //         // });
  //       }
  //       // });
  //       return listaFinal2;
  //     });
  //   });
  // }

  // Future<void> atualizarStatus(context) async {
  //   print('mensagem da listMensaBloc');
  //   List<StatusModel> listaFinal = [];
  //   SharedPreferences.getInstance().then((prefs) {
  //     ListaMensaBloc().getMessageBack(context, true).then((map1) {
  //       if (map1 != null) {
  //         listaFinal = map1;
  //         // if (map1 != null) {
  //         for (StatusModel mensagem in listaFinal) {
  //           for (String matricula in mensagem.matriculasView.split(",")) {
  //             if (matricula == prefs.getString('matricula')) {
  //               mensagem.lido = true;
  //             }
  //           }
  //         }
  //         // }
  //       }
  //     });
  //   });
  // }

  // Future<void> atualizarStatusWeb(context) {
  //   List<StatusModel> listaFinal = [];
  //   print("Atualizando tela de mensagens!!!");
  //   SharedPreferences.getInstance().then((prefs) {
  //     ListaMensaBloc().getMessageBack(context, true).then((map1) {
  //       if (map1 != null) {
  //         listaFinal = map1;
  //         if (map1 != null) {
  //           for (StatusModel mensagem in listaFinal) {
  //             for (String matricula in mensagem.matriculasView.split(",")) {
  //               if (matricula == prefs.getString('matricula')) {
  //                 mensagem.lido = true;
  //               }
  //             }
  //           }
  //         }
  //       }
  //     });
  //   });
  // }

  Future<MensagemRetornoModel.MensagemRetornoModel> refreshList(context) async {
      await ListaMensaBloc().getMessageBack(context, true).then((mapRefList) {
        if (mapRefList == null) {
           AlertDialogTemplate().showAlertDialogSimples(
              context,
              "Erro",
              "Erro ao buscar lista de mensagens, verifique conexão com internet!");

        } else if (mapRefList.response.pIntCodErro != 0) {

          AlertDialogTemplate().showAlertDialogSimples(context,
              "Erro", "${mapRefList.response.pChrDescErro}");
        }
        return mapRefList;
      });

  }

  Future<MensagemEnvioModel.MensagemEnvioModel> retornaObjetoComParametrosDeBusca(MensagemEnvioModel.TtMensagens2 ttMensagens2, MensagemEnvioModel.TtMensVisu2 ttMensVisu2) async{

    MensagemEnvioModel.MensagemEnvioModel mensagemEnvioModel = new MensagemEnvioModel.MensagemEnvioModel();
    mensagemEnvioModel.request = new MensagemEnvioModel.Request();
    mensagemEnvioModel.request.ttMensagens = new MensagemEnvioModel.TtMensagens();
    mensagemEnvioModel.request.ttMensagens.ttMensagens2 = new List();
    mensagemEnvioModel.request.ttMensVisu = new MensagemEnvioModel.TtMensVisu();
    mensagemEnvioModel.request.ttMensVisu.ttMensVisu2 = new List();

    SharedPreferences.getInstance().then((prefs) {
      ttMensagens2.usuariosDestino = prefs.getString("usuario");
      ttMensagens2.usuarioRequi = prefs.getString("usuario");
      ttMensagens2.dataCriacao = DateFormat('dd/MM/yy').format(DateTime.now()).toString();
      mensagemEnvioModel.request.ttMensagens.ttMensagens2.add(ttMensagens2);

      ttMensVisu2.usuarioVisu = prefs.getString("usuario");
      ttMensVisu2.dataVisu = DateFormat('dd/MM/yy').format(DateTime.now()).toString();
      mensagemEnvioModel.request.ttMensVisu.ttMensVisu2.add(ttMensVisu2);
    });
    return mensagemEnvioModel;

  }

  @override
  void dispose() {
    super.dispose();
  }
}
