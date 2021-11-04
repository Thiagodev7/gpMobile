import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_conditional_rendering/conditional_switch.dart';

import 'package:gpmobile/src/pages/login/entrar/EntrarModel.dart';
import 'package:gpmobile/src/util/Estilo.dart';
import 'package:gpmobile/src/util/constants.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:gpmobile/src/util/images.dart';

import 'RecuperarSenhaBloc.dart';

class RecuperarSenhaWidget extends StatefulWidget {
  final LoginModel objDadosUsuario;

  RecuperarSenhaWidget(
    this.objDadosUsuario,
  );

  @override
  _RecuperarSenhaWidgetState createState() => _RecuperarSenhaWidgetState();
}

class _RecuperarSenhaWidgetState extends State<RecuperarSenhaWidget> {
//VARIAVEIS

  final GlobalKey<ScaffoldState> _scaffoldKeyRecuperarSenhaWidget =
      GlobalKey<ScaffoldState>();
  final isWebMobile = (defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.android);

  bool statusVersao = true; //VERIFICAR STATUS DA VERSAO
  bool camposBloq = true; //BLOQUEAR CAMPOS
  bool userSalvo = false; //VALIDAR OS DADOS
  String h1 = 'Escolha como recuperar senha!';
  String h2 =
      'Caso as informações estejam desatualizadas, favor contatar o Departamento Pessoal!';
  //
  int indexPage;
  int count = 0;
  String origemDoClick = "";
  Random random = Random();
  //
  var _emailOculto = "EMAIL";
  var _telefoneOculto = "TELEFONE";
  String email = "";
  String usuario = "";

  //INICIO
  @override
  void initState() {
    super.initState();
    email = widget.objDadosUsuario.response.ttUsuario.ttUsuario[0].email;
    usuario = widget.objDadosUsuario.response.ttUsuario.ttUsuario[0].usuario;
    Timer(
      Duration(seconds: 1),
      () => setState(() {
        _telefoneOculto = widget
            .objDadosUsuario.response.ttUsuario.ttUsuario[0].num_telefone
            .toString()
            .replaceRange(0, 5, '****-');

        // HomeBloc().getEmailColaborador().then((map) async {
        //   email = map;

        String left = email.split("@")[0];
        var right = email.split("@")[1];
        var tamanho = left.length;
        var metade = (tamanho / 2).round().toInt();
        var subString = left.substring(0, metade);
        _emailOculto = '$subString*****@$right';
        // _emailOculto = email.replaceRange(5, 4, '*****');
        // });
      }),
    );
    //split de email e telefone in
  }

//PRINCIPAL
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final erroEndDrawer = new TextButton(
        onPressed: _closeEndDrawer,
        child: Text(
          'Erro: Favor contactar o departameto de tecnologia!!!',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ));
    //BODY
    return Scaffold(
      key: _scaffoldKeyRecuperarSenhaWidget,
      backgroundColor: theme.backgroundColor,
      body: Container(
        decoration: AppGradients.gradient,
        child: ScreenTypeLayout(
          breakpoints: ScreenBreakpoints(
            desktop: 900,
            tablet: 499,
            watch: 250,
          ), //desktop: 900, tablet: 650, watch: 250
          mobile: OrientationLayoutBuilder(
            portrait: (context) => recuperarSenhaWidgetMobile(context),
            landscape: (context) => recuperarSenhaWidgetMobile(context),
          ),
          tablet: recuperarSenhaWidgetWeb(context),
          desktop: recuperarSenhaWidgetWeb(context),
        ),
      ),
      endDrawer: ConditionalSwitch.single<String>(
          context: context,
          valueBuilder: (BuildContext context) => origemDoClick,
          caseBuilders: {
            // 'entrarWidget': (BuildContext context) => new EntrarWidget(),
            // 'registrarWidget': (BuildContext context) => new RegistrarWidget(),
            // 'registrarWidget': (BuildContext context) => new Container(),
          },
          fallbackBuilder: (BuildContext context) {
            return Card(
              color: AppColors.chartSecondary,
              child: erroEndDrawer,
            );
          }),
      endDrawerEnableOpenDragGesture: false,
    );
  }

//MOBILE
  Widget recuperarSenhaWidgetMobile(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: Container(
          decoration: AppGradients.gradient,
          child: Center(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              children: <Widget>[
                // btnBack(context),
                // SizedBox(height: height * 0.2), //48
                logoTop(context),
                SizedBox(height: height * 0.1), //48
                txtIntro(context),
                //
                txtAviso(context),
                SizedBox(height: height * 0.01), //48
                //btnEntrar
                btnEmail(context),
                //btnRegistrar
                btnSMS(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

// //TABLET
//   Widget EsqueceuSenhaWidgetTablet(BuildContext context) {
//     double height = MediaQuery.of(context).size.height;
//     double width = MediaQuery.of(context).size.width;
//     return Center(
//       child: ListView(
//         shrinkWrap: true,
//         padding: EdgeInsets.only(left: 24.0, right: 24.0),
//         children: <Widget>[
//           logoTop(context),
//           SizedBox(height: height * 0.1), //48
//           matricula(context),
//           SizedBox(height: height * 0.01), //8
//           password(context),
//           SizedBox(width: width * 3, height: height * 0.01), //8
//           salvarDados(context),
//           SizedBox(height: height * 0.01), //24
//           btnEntrar(context),
//         ],
//       ),
//     );
//   }

  //WEB
  Widget recuperarSenhaWidgetWeb(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: 320,
              maxWidth: 768,
              // minHeight: double.infinity,
              // maxHeight: double.infinity,
            ),
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              children: <Widget>[
                // SizedBox(height: height * 0.1), //4
                // btnBackWeb(context),
                logoTop(context),
                SizedBox(height: height * 0.1), //48
                txtIntro(context),
                //
                txtAviso(context),
                SizedBox(height: height * 0.01), //48
                //btnEntrar
                btnEmail(context),
                //btnRegistrar
                btnSMS(context),
                SizedBox(height: height * 0.01), //24
                // txtAndroid(context),
                // qrCode(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //WIDGETS

  Widget btnBack(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Row(
        children: [
          Icon(
            Icons.arrow_back,
            color: AppColors.chartSecondary,
          ),
        ],
      ),
    );
  }

  Widget btnBackWeb(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop(LOGIN);
      },
      child: Row(
        children: [
          Icon(
            Icons.arrow_back,
            color: AppColors.chartSecondary,
          ),
        ],
      ),
    );
  }

  Widget logoTop(BuildContext context) {
    return new Center(
      child: Image.asset(
        imageLogoLogin,
        scale: 4.9,
        fit: BoxFit.fill,
      ),
    );
  }

  Widget txtIntro(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Container(
        child: Column(
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                // text: h1,
                style: TextStyle(color: AppColors.chartSecondary, fontSize: 36),
                children: <TextSpan>[
                  TextSpan(
                    text: h1,
                    style: TextStyle(
                        color: AppColors.chartSecondary, fontSize: 26),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget txtAviso(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Container(
        child: Column(
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                // text: h1,
                style: TextStyle(color: AppColors.chartSecondary, fontSize: 36),
                children: <TextSpan>[
                  TextSpan(
                    text: h2,
                    style: TextStyle(
                        color: AppColors.chartSecondary, fontSize: 16),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget btnEmail(BuildContext context) {
    String _tagEmail = 'E-mail';
    int intNotificar = 1;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Container(
        // customBorderRadius: BorderRadius.all(Radius.circular(40)),
        // color: theme.backgroundColor,
        child: MaterialButton(
          onPressed: () => _sendRecuperacao(_tagEmail, intNotificar),
          // onPressed: () => splitEmail(),
          color: Estilo().backgroundBtnRecuperarEmailTelefone,
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0),
          ),
          // elevation: 5,
          height: 50,
          child: Text(
            _emailOculto, //Fulano.sobrenome@empresa.com.br
            style: TextStyle(
              // color: theme.textTheme.headline1.color,
              fontSize: 15,
              color: Colors.white70,
            ),
          ),
        ),
      ),
    );
  }

  Widget btnSMS(BuildContext context) {
    String _tipoSMS = 'Mensagem de texto SMS';
    int intNotificar = 2;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Container(
        child: MaterialButton(
          onPressed: () => _sendRecuperacao(_tipoSMS, intNotificar),
          color: Estilo().backgroundBtnRecuperarEmailTelefone,
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0),
          ),
          // elevation: 5,
          height: 50,
          child: Text(
            _telefoneOculto,
            style: TextStyle(
              // color: theme.textTheme.headline1.color,
              fontSize: 20,
              color: Colors.white70,
            ),
          ),
        ),
      ),
    );
  }

  Widget logoBotton(BuildContext context) {
    return new Center(
      child: Image.asset(
        imageLogoGrupoHorizontal,
        scale: 3.9,
        fit: BoxFit.fill,
      ),
    );
  }

  Widget txtAndroid(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Container(
        // customBorderRadius: BorderRadius.all(Radius.circular(40)),
        // color: theme.backgroundColor,
        child: Column(
          children: [
            Text(
              'Disponível para Android',
              style: TextStyle(
                // color: theme.textTheme.headline1.color,
                fontSize: 25,
                color: Colors.white70,
              ),
            ),
            // Icon(
            //   Icons.android,
            //   color: Estilo().branca,
            //   size: 50,
            // ),
          ],
        ),
      ),
    );
  }

  Widget qrCode(BuildContext context) {
    return Center(
      child: Container(
        width: 200,
        height: 200,
        // child: Image.asset(
        //   imageQRCode,
        // ),
        child: Image.asset(imageQRCode),
        decoration: BoxDecoration(
          color: Estilo().branca,
          // border: Border.all(width: 3.0),
          borderRadius: BorderRadius.all(
              Radius.circular(5.0) //                 <--- border radius here
              ),
        ),
      ),
    );
  }

  // Widget qrCode(BuildContext context) {
  //   return new Center(
  //     child: Image.network(
  //       imageQRCode,
  //       scale: 3.9,
  //       fit: BoxFit.fill,
  //     ),
  //   );
  // }
  Widget copyright(BuildContext context) {
    return new Column(
      children: [
        Text(
          'Copyright ©2020, All Rights Reserved.',
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 12.0,
            // color: Theme.of(context).accentColor
          ),
        ),
        Text(
          'Powered by Grupo H. Egídio',
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 12.0,
            // color: Theme.of(context).accentColor),
          ),
        ),
      ],
    );
  }

  Widget logoWeb(BuildContext context) {
    return new Hero(
      tag: 'login',
      child: Column(
        children: [
          Text(
            'GP WEB',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 30,
            ),
          )
        ],
      ),
    );
  }

  ///*[METODOS]
  ///perguntar lucas sobre logica
  _sendRecuperacao(String tipo, int intNotificar) {
    int _acaoRecuperSenha = 2; // int _acaoRecuperSenha = 2;
    RecuperarSenhaBloc().blocRecSenha(
        context, intNotificar, _acaoRecuperSenha, tipo, usuario, true);
  }

  void _closeEndDrawer() {
    setState(() {
      count = count - 1;
      Navigator.of(context).pop();
    });
  }
}
