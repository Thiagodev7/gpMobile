import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//https://androidkt.com/flutter-alertdialog-example/
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gpmobile/src/pages/configuracoes/view/ConfigWidget.dart';
import 'package:gpmobile/src/pages/login/entrar/EntrarWidget.dart';
import 'package:gpmobile/src/pages/ponto/model/PontoAssinaturaModel.dart';
import 'package:gpmobile/src/pages/ponto/bloc/PontoBloc.dart';
import 'package:gpmobile/src/util/Estilo.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

//https://www.youtube.com/watch?v=58_IM0OTU2M

NumberFormat f = new NumberFormat("00");

//************************************* INI CONTRA CHEQUE *********************************
DateTime contraChequeDataAtual = DateTime.now().day >= 25
    ? new DateTime.now()
    : DateTime(
        DateTime.now().year, DateTime.now().month - 1, DateTime.now().day);
DateTime contraChequeDataAtualMais1 =
    DateTime(contraChequeDataAtual.year, contraChequeDataAtual.month + 1, 1);
DateTime contraChequeDataAtualMenos1 =
    DateTime(contraChequeDataAtual.year, contraChequeDataAtual.month - 1, 1);
DateTime contraChequeDataAtualMenos2 =
    DateTime(contraChequeDataAtual.year, contraChequeDataAtual.month - 2, 1);
DateTime contraChequeDataAtualMenos3 =
    DateTime(contraChequeDataAtual.year, contraChequeDataAtual.month - 3, 1);
DateTime contraChequeDataAtualMenos4 =
    DateTime(contraChequeDataAtual.year, contraChequeDataAtual.month - 4, 1);
DateTime contraChequeDataAtualMenos5 =
    DateTime(contraChequeDataAtual.year, contraChequeDataAtual.month - 5, 1);
DateTime contraChequeDataAtualMenos6 =
    DateTime(contraChequeDataAtual.year, contraChequeDataAtual.month - 6, 1);
DateTime contraChequeDataAtualMenos7 =
    DateTime(contraChequeDataAtual.year, contraChequeDataAtual.month - 7, 1);

String contraChequePeriodoAtualGeral =
    f.format(contraChequeDataAtual.day).toString() +
        "/" +
        f.format(contraChequeDataAtual.month).toString() +
        "/" +
        contraChequeDataAtual.year.toString();
String contraChequePeriodoAtualMais1 =
    f.format(contraChequeDataAtualMais1.month).toString() +
        "/" +
        contraChequeDataAtualMenos1.year.toString();
String contraChequePeriodoAtual =
    f.format(contraChequeDataAtual.month).toString() +
        "/" +
        contraChequeDataAtual.year.toString();
String contraChequePeriodoAtualMenos1 =
    f.format(contraChequeDataAtualMenos1.month).toString() +
        "/" +
        contraChequeDataAtualMenos1.year.toString();
String contraChequePeriodoAtualMenos2 =
    f.format(contraChequeDataAtualMenos2.month).toString() +
        "/" +
        contraChequeDataAtualMenos2.year.toString();
String contraChequePeriodoAtualMenos3 =
    f.format(contraChequeDataAtualMenos3.month).toString() +
        "/" +
        contraChequeDataAtualMenos3.year.toString();
String contraChequePeriodoAtualMenos4 =
    f.format(contraChequeDataAtualMenos4.month).toString() +
        "/" +
        contraChequeDataAtualMenos4.year.toString();
String contraChequePeriodoAtualMenos5 =
    f.format(contraChequeDataAtualMenos5.month).toString() +
        "/" +
        contraChequeDataAtualMenos5.year.toString();

final List<PeriodoItem> listaTxtDatasContraCheque = [
  PeriodoItem(
    title: "$contraChequePeriodoAtual",
  ),
  PeriodoItem(
    title: "$contraChequePeriodoAtualMenos1",
  ),
  PeriodoItem(
    title: "$contraChequePeriodoAtualMenos2",
  ),
  PeriodoItem(
    title: "$contraChequePeriodoAtualMenos3",
  ),
  PeriodoItem(
    title: "$contraChequePeriodoAtualMenos4",
  ),
];

//************************************* FIM CONTRA CHEQUE *********************************

//************************************* INI PONTO *****************************************
DateTime pontoDataAtual = DateTime.now().day >= 16
    ? DateTime(
        DateTime.now().year, DateTime.now().month + 1, DateTime.now().day)
    : DateTime.now();
// DateTime pontoDataAtualMais1  = DateTime(pontoDataAtual.year, pontoDataAtual.month + 1, 1);
DateTime pontoDataAtualMenos1 =
    DateTime(pontoDataAtual.year, pontoDataAtual.month - 1, 1);
DateTime pontoDataAtualMenos2 =
    DateTime(pontoDataAtual.year, pontoDataAtual.month - 2, 1);
DateTime pontoDataAtualMenos3 =
    DateTime(pontoDataAtual.year, pontoDataAtual.month - 3, 1);
DateTime pontoDataAtualMenos4 =
    DateTime(pontoDataAtual.year, pontoDataAtual.month - 4, 1);
DateTime pontoDataAtualMenos5 =
    DateTime(pontoDataAtual.year, pontoDataAtual.month - 5, 1);
DateTime pontoDataAtualMenos6 =
    DateTime(pontoDataAtual.year, pontoDataAtual.month - 6, 1);
DateTime pontoDataAtualMenos7 =
    DateTime(pontoDataAtual.year, pontoDataAtual.month - 7, 1);

String pontoPeriodoAtualGeral = f.format(pontoDataAtual.day).toString() +
    "/" +
    f.format(pontoDataAtual.month).toString() +
    "/" +
    pontoDataAtual.year.toString();
// String pontoPeriodoAtualMais1  = f.format(pontoDataAtualMais1.month).toString()  + "/" + pontoDataAtualMenos1.year.toString();
String pontoPeriodoAtual = f.format(pontoDataAtual.month).toString() +
    "/" +
    pontoDataAtual.year.toString();
String pontoPeriodoAtualMenos1 =
    f.format(pontoDataAtualMenos1.month).toString() +
        "/" +
        pontoDataAtualMenos1.year.toString();
String pontoPeriodoAtualMenos2 =
    f.format(pontoDataAtualMenos2.month).toString() +
        "/" +
        pontoDataAtualMenos2.year.toString();
String pontoPeriodoAtualMenos3 =
    f.format(pontoDataAtualMenos3.month).toString() +
        "/" +
        pontoDataAtualMenos3.year.toString();
String pontoPeriodoAtualMenos4 =
    f.format(pontoDataAtualMenos4.month).toString() +
        "/" +
        pontoDataAtualMenos4.year.toString();
String pontoPeriodoAtualMenos5 =
    f.format(pontoDataAtualMenos5.month).toString() +
        "/" +
        pontoDataAtualMenos5.year.toString();

final List<PeriodoItem> listaTxtDatasPonto = [
  // PeriodoItem(
  //   title: "$periodoAtualMais1",
  // ),
  PeriodoItem(
    title: "$pontoPeriodoAtual",
  ),
  PeriodoItem(
    title: "$pontoPeriodoAtualMenos1",
  ),
  PeriodoItem(
    title: "$pontoPeriodoAtualMenos2",
  ),
  PeriodoItem(
    title: "$pontoPeriodoAtualMenos3",
  ),
  PeriodoItem(
    title: "$pontoPeriodoAtualMenos4",
  ),
];

//************************************* FIM PONTO *****************************************

enum ConfirmAction { CANCELAR, OK }
enum ConfirmActionHome { CANCELAR, SAIR }

class AlertDialogTemplate extends State<StatefulWidget>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return null;
  }

//GERAL
  ProgressDialog showProgressDialog(BuildContext context, String mensagem) {
    ProgressDialog progressDialog = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);

    progressDialog.style(
        message: mensagem,
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: SpinKitRipple(
          // color: Color(0xff9E71EB),
          color: Color(0xFFC42224),
          size: 70.0,
          controller: AnimationController(
              vsync: this, duration: const Duration(milliseconds: 1200)),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w600));

    return progressDialog;
  }

  Future<void> showAlertDialogSimples(
      BuildContext context, String titulo, String mensagem) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        final corBackground = Colors.white70.withOpacity(1);
        return AlertDialog(
          backgroundColor: corBackground,
          title: Text(
            titulo,
            style: TextStyle(fontSize: 15),
          ),
          content: Text(
            mensagem,
            style: TextStyle(fontSize: 12),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
              color: Theme.of(context).backgroundColor,
            ),
          ],
        );
      },
    );
  }

//25/08/2021
  Future<void> showAlertDialogTrocarSenha(
      BuildContext context, String titulo, String mensagem) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        final corBackground = Colors.white70.withOpacity(1);
        return AlertDialog(
          backgroundColor: corBackground,
          title: Text(
            titulo,
            style: TextStyle(fontSize: 15),
          ),
          content: Text(
            mensagem,
            style: TextStyle(fontSize: 12),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
              color: Theme.of(context).backgroundColor,
            ),
          ],
        );
      },
    );
  }

//
  // Future<void> showAlertDialogSenhaRecuperada(
  //     BuildContext context, String titulo, String mensagem, String type) {
  //   int _notificacao = 1; // int _notificacao = 1;
  //   int _acaoRecuperSenha = 2; // int _acaoRecuperSenha = 2;
  //   //chamar bloc passando parametros
  //   enviarEmail() async {
  //     await new RecuperarSenhaBloc()
  //         .blocRecPorEmail(context, _notificacao, _acaoRecuperSenha, '', true);
  //   }

  //   enviarSMS() async {
  //     // await new EntrarBloc().validarUsuario(
  //     //     context, usuarioController.text, senhaCtrl.text, acao, true);
  //   }
  //   // abrirGmail() async {

  //   //   final Uri params = Uri(
  //   //     scheme: 'mailto',
  //   //     path: 'tarcisio.word@gmail.com',
  //   //     query:
  //   //         'subject=Recuperacao de senha&body=sua senha é: ${minhaSenha.toString()}',
  //   //   );
  //   //   String url = params.toString();
  //   //   if (await canLaunch(url)) {
  //   //     await launch(url);
  //   //   } else {
  //   //     print('Could not launch $url');
  //   //   }
  //   // }

  //   // enviarSms() async {
  //   //   var url = "sms:62997004940?body= sua senha é: ${minhaSenha.toString()}";
  //   //   if (await canLaunch(url)) {
  //   //     await launch(url);
  //   //   } else {
  //   //     throw 'Could not launch $url';
  //   //   }
  //   // }

  //   return showDialog<void>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       final corBackground = Colors.white70.withOpacity(1);
  //       return AlertDialog(
  //         backgroundColor: corBackground,
  //         title: Text(
  //           titulo,
  //           style: TextStyle(fontSize: 15),
  //         ),
  //         content: Text(
  //           mensagem,
  //           style: TextStyle(fontSize: 12),
  //         ),
  //         actions: <Widget>[
  //           FlatButton(
  //             child: Text('OK'),
  //             onPressed: () {
  //               switch (type) {
  //                 //type ? email : sms
  //                 case "email":
  //                   Navigator.of(context).pop(enviarEmail());
  //                   break;
  //                 case "sms":
  //                   Navigator.of(context).pop(enviarSMS());
  //                   break;
  //                 default:
  //               }

  //               // Navigator.of(context)
  //               //     .pop(Share.share('verifique a caixa de email...'));
  //             },
  //             color: Theme.of(context).backgroundColor,
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  ////////////////////////////////////////////////////////////////////////////
  //TELA ENVIAR-MENSAGENS
  Future<void> showAlertDialogSimplesEnviarMensa(
      BuildContext context, String titulo, String mensagem) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        final corTitulo = Color(0xff757575);
        final corBackground = Colors.white70.withOpacity(1);
        return AlertDialog(
          backgroundColor: corBackground,
          title: Text(
            titulo,
            style: TextStyle(fontSize: 15, color: corTitulo),
          ),
          content: Text(
            mensagem,
            style: TextStyle(fontSize: 15, color: corTitulo),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.white.withOpacity(0.15)),
              ),
            )
          ],
        );
      },
    );
  }

  ////////////////////////////////////////////////////////////////////////////

//TELA HOME
  Future<ConfirmActionHome> showAlertDialogLogoff(BuildContext context,
      String titulo, String subtitulo, String plataforma) async {
    return showDialog<ConfirmActionHome>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!

      builder: (BuildContext context) {
        // int dropdownValue = DynamicTheme.of(context).themeId;
        final corBackground = Colors.white70.withOpacity(1);
        return AlertDialog(
          backgroundColor: corBackground,
          title: Text(
            titulo,
            style: TextStyle(fontSize: 15),
          ),
          content: Text(
            subtitulo,
            style: TextStyle(fontSize: 15),
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text(
                'CANCELAR',
                style: TextStyle(fontSize: 12),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: const Text(
                'SAIR',
                style: TextStyle(fontSize: 12),
              ),
              onPressed: () {
                // Navigator.of(context).pushAndRemoveUntil(
                //     MaterialPageRoute(builder: (context) => EntrarWidget()),
                //     (Route<dynamic> route) => false);

                ///[new] 27/08
                switch (plataforma) {
                  case "mob":
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => EntrarWidget()),
                        (Route<dynamic> route) => false);
                    break;
                  case "web":
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => EntrarWidget()),
                        (Route<dynamic> route) => false);
                    break;
                  default:
                }
              },
            )
          ],
        );
      },
    );
  }

  //TELA FERIAS
  Future<void> showAlertDialogFerias(
      BuildContext context, String titulo, String mensagem) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        final corBackground = Colors.white70.withOpacity(1);
        return AlertDialog(
          // buttonPadding: EdgeInsets.fromLTRB(24, 24, 24, 50),
          contentPadding: EdgeInsets.fromLTRB(24, 24, 24, 50),
          backgroundColor: corBackground,
          title: Text(
            titulo,
            style: TextStyle(fontSize: 15),
          ),
          content: Text(
            mensagem,
            style: TextStyle(fontSize: 12),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
              color: Theme.of(context).backgroundColor,
            ),
          ],
        );
      },
    );
  }

//TELA-PONTO ()
  Future<ProgressDialog> showProgressDialogPonto(
      BuildContext context, String mensagem) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String dateAdmission = prefs.getString('dataAdmissao');

    ProgressDialog progressDialog = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);

    progressDialog.style(
        message: mensagem,
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: SpinKitRipple(
          color: Color(0xff9E71EB),
          size: 70.0,
          controller: AnimationController(
              vsync: this, duration: const Duration(milliseconds: 1200)),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w600));

    return progressDialog;
  }

//TELA PONTO
  Future<void> showAlertDialogFloating(
      BuildContext context, String titulo, String mensagem) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            titulo,
            style: TextStyle(fontSize: 15),
          ),
          content: Text(
            mensagem,
            style: TextStyle(fontSize: 12),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
              color: Estilo().appbar,
            ),
          ],
        );
      },
    );
  }

  //TELA PONTO
  Future<ConfirmAction> showAlertDialogConfirmReg(
      BuildContext context,
      String titulo,
      String descController,
      String pmes,
      String pano,
      int plogAssinado) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String senhaAtual = prefs.getString('senha');
    String mes = pmes;
    String ano = pano;
    int logAssinado = plogAssinado;
    final crtlAssinatura = new TextEditingController();
    String senhaInformada = crtlAssinatura.text;
    String campoVazio = 'Campo não pode ser vazio!';
    String campoSenhaErrada = 'Senha incorreta!';

    ///[metodos]

    dynamic validarAssinaturaPonto(value) {
      if (value.isEmpty) {
        return campoVazio;
      } else if (value != senhaAtual) {
        return campoSenhaErrada;
      }
      return null;
    }

    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Form(
          key: _formKey,
          child: AlertDialog(
            title: Text(titulo),
            content: new Row(
              children: <Widget>[
                new Expanded(
                  child: new TextFormField(
                    controller: crtlAssinatura,
                    obscureText: true,
                    //keyboardType: TextInputType.number,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: descController,
                      labelStyle: TextStyle(color: AppColors.black),
                      fillColor: Color(0xFFDBEDFF),
                      focusedBorder: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                        borderSide: new BorderSide(color: AppColors.black),
                      ),
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                        borderSide: new BorderSide(color: AppColors.black),
                      ),
                    ),
                    onChanged: (value) {
                      senhaInformada = value;
                    },
                    validator: (value) => validarAssinaturaPonto(value),
                  ),
                )
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Cancelar',
                  style: TextStyle(
                    color: AppColors.black,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) => Color(0xFFC42224)),
                  ),
                  child: Text(
                    'Ok',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      //forca validacao de matricula!!
                      if (senhaInformada == senhaAtual) {
                        await PontoBloc()
                            .blocPontoAssinar(context, mes, ano, logAssinado)
                            .then(
                          (blocRetorno) async {
                            PontoAssinaturaModel pontoAssinaturaModel =
                                blocRetorno;
                            if (blocRetorno.response != null &&
                                blocRetorno.response.plogAssinado == 1) {
                              Navigator.of(context).pop(ConfirmAction.OK);
                              return ConfirmAction.OK;
                            }
                          },
                        );
                        // return true;
                      }
                      // else {
                      //   return AlertDialogTemplate().showAlertDialogSimples(
                      //       context, "Matrícula errada!", "matricula informada$matriculaInformada");
                      // }

                    }
                  }),
            ],
          ),
        );
      },
    );
  }

  //TELA PONTO, TELA CONTRA-CHEQUE
  Future<String> showAlertDialogPeriodListContraCheque(
      BuildContext context, String titulo, String mes, String ano) async {
    return showDialog<String>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          //
          final corBackground = Colors.white70.withOpacity(1);
          final corTitulo = Color(0xff212121);
          PeriodoItem _selected;
          int indice;
          String perid = "$mes/$ano";

          if (perid == contraChequePeriodoAtualMais1) {
            indice = 0;
          }
          if (perid == contraChequePeriodoAtual) {
            indice = 0;
          }
          if (perid == contraChequePeriodoAtualMenos1) {
            indice = 1;
          }
          if (perid == contraChequePeriodoAtualMenos2) {
            indice = 2;
          }
          if (perid == contraChequePeriodoAtualMenos3) {
            indice = 3;
          }
          if (perid == contraChequePeriodoAtualMenos4) {
            indice = 4;
          }

          switch (indice) {
            // case 0:
            //   _selected = listaTxtDatas[0];
            //   break;
            case 0:
              _selected = listaTxtDatasContraCheque[0];
              break;
            case 1:
              _selected = listaTxtDatasContraCheque[1];
              break;
            case 2:
              _selected = listaTxtDatasContraCheque[2];
              break;
            case 3:
              _selected = listaTxtDatasContraCheque[3];
              break;
            case 4:
              _selected = listaTxtDatasContraCheque[4];
              break;
            default:
          }
          return SimpleDialog(
            backgroundColor: corBackground,
            title: Text(
              titulo,
              style: TextStyle(
                fontSize: 20.0,
                color: corTitulo,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: [
              CheckData(
                items: listaTxtDatasContraCheque,
                selected: _selected,
                origem: "contraCheque",
                style: GroupStyle(
                    activeColor: Colors.red,
                    checkPosition: ListTileControlAffinity.leading,
                    titleAlign: TextAlign.left,
                    titleStyle: TextStyle(fontSize: 12)),
                onSelected: (item) {
                  //_selected = item;
                  print(item.title);
                  // if (item.title == listaTxtDatas.toString()) pos = index;
                  //print(item.title);
                },
              ),
            ],
          );
        });
  }

  //TELA PONTO, TELA CONTRA-CHEQUE
  Future<String> showAlertDialogPeriodListPonto(
      BuildContext context, String titulo, String mes, String ano) async {
    return showDialog<String>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          //
          final corBackground = Colors.white70.withOpacity(1);
          final corTitulo = Color(0xff212121);
          PeriodoItem _selected;
          int indice;
          String perid = "$mes/$ano";

          // if (perid == pontoPeriodoAtualMais1) {
          //   indice = 0;
          // }
          if (perid == pontoPeriodoAtual) {
            indice = 0;
          }
          if (perid == pontoPeriodoAtualMenos1) {
            indice = 1;
          }
          if (perid == pontoPeriodoAtualMenos2) {
            indice = 2;
          }
          if (perid == pontoPeriodoAtualMenos3) {
            indice = 3;
          }
          if (perid == pontoPeriodoAtualMenos4) {
            indice = 4;
          }

          switch (indice) {
            case 0:
              _selected = listaTxtDatasPonto[0];
              break;
            case 1:
              _selected = listaTxtDatasPonto[1];
              break;
            case 2:
              _selected = listaTxtDatasPonto[2];
              break;
            case 3:
              _selected = listaTxtDatasPonto[3];
              break;
            case 4:
              _selected = listaTxtDatasPonto[4];
              break;
            default:
          }
          return SimpleDialog(
            backgroundColor: corBackground,
            title: Text(
              titulo,
              style: TextStyle(
                fontSize: 20.0,
                color: corTitulo,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: [
              CheckData(
                items: listaTxtDatasPonto,
                selected: _selected,
                origem: "ponto",
                style: GroupStyle(
                    activeColor: Colors.red,
                    checkPosition: ListTileControlAffinity.leading,
                    titleAlign: TextAlign.left,
                    titleStyle: TextStyle(fontSize: 12)),
                onSelected: (item) {
                  //_selected = item;
                  print(item.title);
                  // if (item.title == listaTxtDatas.toString()) pos = index;
                  //print(item.title);
                },
              ),
            ],
          );
        });
  }

  //TELA CONTRA-CHEQUE
  Future<ConfirmAction> showAlertDialogPDF(
      BuildContext context, String titulo, String mensagem) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        final corBackground = Colors.white70.withOpacity(1);
        return AlertDialog(
          backgroundColor: corBackground,
          title: Text(
            titulo,
            style: TextStyle(fontSize: 15),
          ),
          content: Text(
            mensagem,
            style: TextStyle(fontSize: 15),
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text(
                'CANCELAR',
                style: TextStyle(fontSize: 12),
              ),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.CANCELAR);
              },
            ),
            FlatButton(
              child: const Text(
                'OK',
                style: TextStyle(fontSize: 12),
              ),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.OK);
              },
            )
          ],
        );
      },
    );
  }

  //TELA CONTRA-CHEQUE ref(https://medium.com/flutter-community/make-text-styling-more-effective-with-richtext-widget-b0e0cb4771ef)
  Future<ConfirmAction> showAlertDialogAssPonto(
      BuildContext context, String titulo, String subA, String subB) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white70.withOpacity(0.9),
          title: Text(
            titulo,
            style: TextStyle(color: Color(0xff757575), fontSize: 18),
          ),
          content: Container(
              // color: Colors.black,
              // padding: EdgeInsets.all(10),
              constraints: BoxConstraints.expand(width: 100, height: 80),
              child: Center(
                  child: RichText(
                text: TextSpan(
                    text: subA,
                    style: TextStyle(
                      // color: Theme.of(context).accentColor,
                      color: Colors.green,

                      fontSize: 18,
                      // fontWeight: FontWeight.bold
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: subB,
                          style: TextStyle(
                            color: Color(0xff757575),
                            fontSize: 18,
                            // fontWeight: FontWeight.bold
                          )),
                    ]),
              ))),
          actions: <Widget>[
            FlatButton(
              child: const Text(
                'CANCELAR',
                style: TextStyle(
                  color: Color(0xff757575),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.CANCELAR);
              },
            ),
            FlatButton(
              child: const Text(
                'OK',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.OK);
              },
              // color: Theme.of(context).textTheme.subtitle1.backgroundColor,
              color: Color(0xff757575),
            )
          ],
        );
      },
    );
  }

//TELA ABOUT
  Future<ConfirmActionHome> showAlertDialogLogoffAbout(
      BuildContext context, String titulo, String subtitulo) async {
    return showDialog<ConfirmActionHome>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!

      builder: (BuildContext context) {
        final corBackground = Colors.white70.withOpacity(1);
        return AlertDialog(
          backgroundColor: corBackground,
          title: Text(
            titulo,
            style: TextStyle(fontSize: 15),
          ),
          content: Text(
            subtitulo,
            style: TextStyle(fontSize: 15),
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text(
                'CANCELAR',
                style: TextStyle(fontSize: 12),
              ),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => ConfigWidget()),
                    (Route<dynamic> route) => false);
              },
            ),
            FlatButton(
              child: const Text(
                'SAIR',
                style: TextStyle(fontSize: 12),
              ),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => EntrarWidget()),
                    (Route<dynamic> route) => false);
              },
            )
          ],
        );
      },
    );
  }

  //TELA VIEW_MENSA
  Future<ConfirmAction> showAlertDialogAceiteTermoMensa(
    BuildContext context,
    String titulo,
    String subTitulo,
    String descController,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String senhaAtual = prefs.getString('senha');
    final crtlAssinatura = new TextEditingController();
    String matriculaInformada = crtlAssinatura.text;
    String campoVazio = 'Campo não pode ser vazio!';
    String campoSenhaErrada = 'Senha incorreta!';

    ///[metodos]

    dynamic validarCampoSenhaMensa(value) {
      if (value.isEmpty) {
        return campoVazio;
      } else if (value != senhaAtual) {
        return campoSenhaErrada;
      }

      return null;
    }

    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Form(
          key: _formKey,
          child: AlertDialog(
            title: Column(
              children: [
                Text(titulo, style: TextStyle(color: Color(0xFFC42224))),
                SizedBox(height: 10),
                Text(subTitulo),
              ],
            ),
            content: new TextFormField(
              controller: crtlAssinatura,
              keyboardType: TextInputType.multiline,
              obscureText: true,
              autofocus: true,
              decoration: InputDecoration(
                labelText: descController,
                labelStyle: TextStyle(color: AppColors.black),
                fillColor: Color(0xFFDBEDFF),
                focusedBorder: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                  borderSide: new BorderSide(color: AppColors.black),
                ),
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                  borderSide: new BorderSide(color: AppColors.black),
                ),
              ),
              onChanged: (value) {
                matriculaInformada = value;
              },
              validator: (value) => validarCampoSenhaMensa(value),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Cancelar',
                  style: TextStyle(
                    color: AppColors.black,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) => Color(0xFFC42224)),
                  ),
                  child: Text(
                    'Ok',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      //forca validacao de matricula!!
                      if (_formKey.currentState.validate() == true) {
                        Navigator.of(context).pop(ConfirmAction.OK);
                        return ConfirmAction.OK;
                      }
                    }
                  }),
            ],
          ),
        );
      },
    );
  }
}

///*[item]
class PeriodoItem {
  bool selected;
  String title;
  Widget child;
  VoidCallback onPressed;

  PeriodoItem({this.selected = false, this.title, this.child, this.onPressed});
}

///*[Items]
class CheckData extends StatefulWidget {
  final List<PeriodoItem> items;
  final PeriodoItem selected;
  final Function(PeriodoItem) onSelected;
  final GroupStyle style;
  final String origem;

  const CheckData(
      {Key key,
      @required this.items,
      @required this.onSelected,
      this.style,
      this.selected,
      this.origem})
      : super(key: key);

  @override
  _CheckDataState createState() => _CheckDataState();
}

class _CheckDataState extends State<CheckData> {
  PeriodoItem _selected;
  GroupStyle _groupStyle;

  @override
  void initState() {
    setState(() {
      _selected = widget?.selected ?? null;
    });

    setState(() {
      _groupStyle = widget.style ?? GroupStyle();
      // pos == 3 ? Colors.red : Colors.black
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color color;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: widget.items.map((item) {
        final pos = widget.items.indexOf(item);
        return RadioListTile(
            key: Key('$pos${item.title}'),
            title: Text(
              item.title,
              style: TextStyle(
                color: color,
              ),
            ),
            dense: true,
            activeColor: _groupStyle.activeColor ??
                Theme.of(context).toggleableActiveColor,
            groupValue: widget.items.indexOf(_selected),
            value: pos,
            onChanged: (var index) => setState(() {
                  _selected = item;
                  widget.onSelected(item);
                  switch (pos) {
                    // case 0:
                    //   Navigator.pop(context, periodoAtualMais1);
                    //   break;
                    case 0:
                      Navigator.pop(
                          context,
                          widget.origem == "contraCheque"
                              ? contraChequePeriodoAtual
                              : pontoPeriodoAtual);
                      color = Colors.red;
                      break;
                    case 1:
                      Navigator.pop(
                          context,
                          widget.origem == "contraCheque"
                              ? contraChequePeriodoAtualMenos1
                              : pontoPeriodoAtualMenos1);
                      color = Colors.red;
                      break;
                    case 2:
                      Navigator.pop(
                          context,
                          widget.origem == "contraCheque"
                              ? contraChequePeriodoAtualMenos2
                              : pontoPeriodoAtualMenos2);
                      color = Colors.red;
                      break;
                    case 3:
                      Navigator.pop(
                          context,
                          widget.origem == "contraCheque"
                              ? contraChequePeriodoAtualMenos3
                              : pontoPeriodoAtualMenos3);
                      color = Colors.red;
                      break;
                    case 4:
                      Navigator.pop(
                          context,
                          widget.origem == "contraCheque"
                              ? contraChequePeriodoAtualMenos4
                              : pontoPeriodoAtualMenos4);
                      color = Colors.red;
                      break;
                    default:
                      Navigator.pop(
                          context,
                          widget.origem == "contraCheque"
                              ? contraChequePeriodoAtual
                              : pontoPeriodoAtual);
                  }
                }));
      }).toList(),
    );
  }
}

class GroupStyle {
  Color activeColor;
  TextStyle titleStyle;
  TextAlign titleAlign;
  TextStyle subTitleStyle;
  TextAlign subTitleAlign;
  ListTileControlAffinity checkPosition;

  _titleStyle({double fontSize}) =>
      TextStyle(height: 1.3, fontSize: fontSize, fontWeight: FontWeight.w500);

  GroupStyle(
      {this.activeColor,
      this.titleStyle,
      this.titleAlign = TextAlign.left,
      this.subTitleStyle,
      this.subTitleAlign = TextAlign.left,
      this.checkPosition = ListTileControlAffinity.leading}) {
    if (titleStyle == null) {
      titleStyle = _titleStyle(fontSize: 16);
    }
    if (subTitleStyle == null) {
      subTitleStyle = _titleStyle(fontSize: 12);
    }
  }
}
