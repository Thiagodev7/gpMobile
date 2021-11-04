//https://medium.com/codechai/the-mvp-architecture-pattern-in-flutter-with-simple-demo-65ab3282c54b

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gpmobile/src/pages/login/entrar/EntrarWidget.dart';

import 'package:gpmobile/src/util/AlertDialogTemplate.dart';
import 'package:gpmobile/src/util/Estilo.dart';
import 'package:gpmobile/src/util/SharedPreferencesBloc.dart';
import 'package:gpmobile/src/util/constants.dart';
import 'package:gradient_input_border/gradient_input_border.dart';
import 'package:gradients/gradients.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gpmobile/src/util/images.dart';

import 'TrocarSenhaBloc.dart';

class TrocarSenhaWidget extends StatefulWidget {
  @override
  _TrocarSenhaWidgetState createState() => _TrocarSenhaWidgetState();
}

class _TrocarSenhaWidgetState extends State<TrocarSenhaWidget> {
//VARIAVEIS
  final _formKeyTrocarSenhaWidget = GlobalKey<FormState>();
  final isWebMobile = (defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.android);

  TextEditingController senhaAtualController;
  TextEditingController senha1Controller;
  TextEditingController repetirsenha1Controller;

  final FocusNode _senhaAtualFocus = FocusNode();
  final FocusNode _senha1Focus = FocusNode();
  final FocusNode _repetirsenha1Focus = FocusNode();

  String _title = 'Trocar Senha';
  String campoVazio = 'Preenchimento obrigatório!';
  String campoMenor6 = 'Digite uma senha com mais de 6 caracteres!';
  String senhaDiferente = 'Senha digitada diferente da atual!';

  bool camposBloq = true; //BLOQUEAR CAMPOS
  bool userSalvo = false; //VALIDAR OS DADOS
  bool checkBoxValue = false; //VALIDAR TERMO
  bool large;
  bool medium;
  bool _large = false;
  bool _medium = false;

  double _pixelRatio;
  double _height;
  double _width;

  ///*[ notificar = 1 || _trocarSenha = 3]
  int _notificar = 1;
  int _trocarSenha = 3;

  // double _pixelRatio;
  Gradient _unfocusGradient = LinearGradientPainter(
    end: Alignment.topRight,
    begin: Alignment.bottomLeft,
    colors: <Color>[
      Color(0xFF2e2a4f),
      Color(0xFFC42224),
    ],
  );
  SharedPreferences prefs;
  String _senha;
  double _formProgress = 0;
  bool changeColor = false;
  Color colorSucess;

  /// * [INIT STATE]
  @override
  void initState() {
    super.initState();

    senhaAtualController = new TextEditingController();
    senha1Controller = new TextEditingController();
    repetirsenha1Controller = new TextEditingController();

    SharedPreferencesBloc().buscaParametro("usuario").then((retorno) {
      _senha = retorno;
    });
  }

  // void _updateFormProgress() {
  //   var progress = 0.0;
  //   final controllers = [
  //     senhaAtualController,
  //     senha1Controller,
  //     repetirsenha1Controller
  //   ];

  //   for (final controller in controllers) {
  //     if (controller.value.text.isNotEmpty) {
  //       progress += 1 / controllers.length;
  //     }
  //   }

  //   setState(() {
  //     _formProgress = progress;
  //   });
  // }

  @override
  void dispose() {
    senhaAtualController.dispose();
    senha1Controller.dispose();
    repetirsenha1Controller.dispose();
    super.dispose();
  }

  /// * [PRINCIPAL]
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    //BODY
    return Scaffold(
      // backgroundColor: Estilo().backgroundTelaViewTrocarSenha,
      body: Container(
        decoration: AppGradients.gradient,
        // decoration: AppGradients.gradient,
        child: ScreenTypeLayout(
          breakpoints: ScreenBreakpoints(
            desktop: 900,
            tablet: 499,
            watch: 250,
          ), //desktop: 900, tablet: 650, watch: 250
          mobile: OrientationLayoutBuilder(
            portrait: (context) => trocarSenhaWidgetMobile(context),
            landscape: (context) => trocarSenhaWidgetMobile(context),
          ),
          tablet: trocarSenhaWidgetWeb(context),
          desktop: trocarSenhaWidgetWeb(context),
        ),
      ),
    );
  }

  /// * [MOBILE]
  Widget trocarSenhaWidgetMobile(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    // _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    // _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    // _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: appbar(context),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            // logoTop(context),
            SizedBox(height: _height * 0.05), //48
            form(context),
            SizedBox(height: _height * 0.01), //48
            btnGravarNovaSenha(context),
            SizedBox(width: _width * 3, height: _height * 0.01),
            // possuiConta(context),
          ],
        ),
      ),
    );
  }

  /// * [WEB]
  Widget trocarSenhaWidgetWeb(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Estilo().backgroundTelaViewTrocarSenha,
      appBar: appbar(context),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            // logoTop(context),
            SizedBox(height: height * 0.1), //48
            form(context),
            // salvarDados(context),
            SizedBox(height: height * 0.01), //24
            btnGravarNovaSenha(context),
            SizedBox(height: height * 0.01), //24
          ],
        ),
      ),
    );
  }

  /// * [WIDGETS]
  Widget appbar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      centerTitle: true,
      title: Text(_title),
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

  // Widget salvarDados(BuildContext context) {
  //   double height = MediaQuery.of(context).size.height;
  //   double width = MediaQuery.of(context).size.width;
  //   final theme = Theme.of(context);
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: <Widget>[
  //       SizedBox(
  //         height: height * 0.1,
  //       ),
  //       Text(
  //         'Lembrar meu usuário',
  //         style: TextStyle(color: Colors.white70),
  //       ),
  //       SizedBox(
  //         width: width * 0.25,
  //       ),
  //       Column(
  //         children: [
  //           Container(
  //             alignment: Alignment.centerRight,
  //             child: ConditionalSwitch.single<String>(
  //               context: context,
  //               valueBuilder: (context) => "A",
  //               caseBuilders: {
  //                 'A': (context) => new Switch(
  //                       value: userSalvo,
  //                       onChanged: (value) async {
  //                         if (value == true &&
  //                             inputText(matriculaCtrl, senhaCtrl) != "") {
  //                           setState(() => userSalvo = true);
  //                           setState(() => camposBloq = userSalvo);
  //                         } else {
  //                           setState(() => userSalvo = false);
  //                           setState(() => camposBloq = userSalvo);
  //                           setState(() => clearInputText());
  //                         }
  //                       },
  //                       activeColor: theme.canvasColor,
  //                     ),
  //                 'B': (BuildContext context) => Text('B!'),
  //               },
  //               fallbackBuilder: (BuildContext context) => Text('None'),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }

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

  Widget possuiConta(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Já tem uma conta?",
            style:
                TextStyle(color: AppColors.white, fontWeight: FontWeight.w400),
          ),
          SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop(LOGIN);
              print("Routing to Sign up screen");
            },
            child: Text(
              "Entrar",
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.orange[200],
                  fontSize: 19),
            ),
          )
        ],
      ),
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

  /// * [FORMULARIO]

  Widget form(BuildContext context) {
    return Container(
      child: Form(
        key: _formKeyTrocarSenhaWidget,
        onChanged: _updateFormProgress, // NEW
        child: Column(
          children: <Widget>[
            // _buildAnimationLinear(context),
            SizedBox(height: 30.0),
            senhaAtualTextFormField(context),
            SizedBox(height: 30.0),
            senhaNovaTextFormField(context),
            SizedBox(height: 30.0),
            repetirSenhaNovaTextFormField(context),
            SizedBox(height: 30.0),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimationLinear(BuildContext context) {
    return Container(
      width: 150,
      height: 20,
      child: LinearProgressIndicator(
        value: _formProgress,
        valueColor: changeColor == false
            ? AlwaysStoppedAnimation<Color>(Colors.white)
            : AlwaysStoppedAnimation<Color>(Colors.green),
        backgroundColor: Colors.white10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0)),
      ),
    );
  }

  Widget btnGravarNovaSenha(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        child: MaterialButton(
          onPressed: _validarDados,
          color: Estilo().backgroundBtnGravarTelaTrocarSenha,
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0),
          ),
          height: 50,
          child: Text(
            'GRAVAR',
            style: TextStyle(
              fontSize: 18,
              color: Estilo().textoBtnGravarTelaTrocarSenha,
            ),
          ),
        ),
      ),
    );
  }

  Widget senhaAtualTextFormField(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    return Material(
      borderRadius: BorderRadius.circular(10.0),
      elevation: large ? 12 : (medium ? 10 : 8),
      child: TextFormField(
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
        controller: senhaAtualController,
        validator: (value) => validarSenhaAtual(value),
        textInputAction: TextInputAction.next,
        focusNode: _senhaAtualFocus,
        onFieldSubmitted: (term) {
          _fieldFocusChange(context, _senhaAtualFocus, _senha1Focus);
        },
        onSaved: (value) {
          // senhaAtualController.text = value;
        },
        style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
        cursorColor: Colors.orange[200],
        decoration: InputDecoration(
          labelText: "Insira senha atual",
          labelStyle: TextStyle(
            // color: theme.backgroundColor,
            height: 2,
            fontSize: 13.0,
          ),
          prefixIcon:
              Icon(Icons.lock_outline, color: Colors.orange[200], size: 20),
          // hintText: widget.hint,
          border: GradientOutlineInputBorder(
            focusedGradient: _unfocusGradient,
            unfocusedGradient: _unfocusGradient,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          filled: true,
          errorStyle: TextStyle(
            height: 2,
            fontSize: 16.0,
            color: Color(0xFFC42224),
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
          // suffixIcon: widget.suffixIcon,
        ),
      ),
    );
  }

  Widget senhaNovaTextFormField(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    return Material(
      borderRadius: BorderRadius.circular(10.0),
      elevation: large ? 12 : (medium ? 10 : 8),
      child: TextFormField(
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
        controller: senha1Controller,
        validator: (value) => validator(value),
        textInputAction: TextInputAction.next,
        focusNode: _senha1Focus,
        onFieldSubmitted: (term) {
          _fieldFocusChange(context, _senha1Focus, _repetirsenha1Focus);
        },
        onSaved: (value) {
          senha1Controller.text = value;
        },
        style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
        cursorColor: Colors.orange[200],
        decoration: InputDecoration(
          labelText: "Nova Senha",
          labelStyle: TextStyle(
            // color: theme.backgroundColor,
            height: 2,
            fontSize: 13.0,
          ),
          prefixIcon:
              Icon(Icons.lock_outline, color: Colors.orange[200], size: 20),
          // hintText: widget.hint,
          border: GradientOutlineInputBorder(
            focusedGradient: _unfocusGradient,
            unfocusedGradient: _unfocusGradient,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          filled: true,
          errorStyle: TextStyle(
            height: 2,
            fontSize: 16.0,
            color: Color(0xFFC42224),
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
          // suffixIcon: widget.suffixIcon,
        ),
      ),
    );
  }

  Widget repetirSenhaNovaTextFormField(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    return Material(
      borderRadius: BorderRadius.circular(10.0),
      elevation: large ? 12 : (medium ? 10 : 8),
      child: TextFormField(
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
        controller: repetirsenha1Controller,
        validator: (value) => validator(value),
        textInputAction: TextInputAction.done,
        focusNode: _repetirsenha1Focus,
        onFieldSubmitted: (value) {
          _repetirsenha1Focus.unfocus();
          // _calculator();
        },
        onSaved: (value) {
          repetirsenha1Controller.text = value;
        },
        style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
        cursorColor: Colors.orange[200],
        decoration: InputDecoration(
          labelText: "Repetir nova senha",
          labelStyle: TextStyle(
            // color: theme.backgroundColor,
            height: 2,
            fontSize: 13.0,
          ),
          prefixIcon:
              Icon(Icons.lock_outline, color: Colors.orange[200], size: 20),
          // hintText: widget.hint,
          border: GradientOutlineInputBorder(
            focusedGradient: _unfocusGradient,
            unfocusedGradient: _unfocusGradient,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          filled: true,
          errorStyle: TextStyle(
            height: 2,
            fontSize: 16.0,
            color: Color(0xFFC42224),
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
          // suffixIcon: widget.suffixIcon,
        ),
      ),
    );
  }

  Widget acceptTermsTextRow() {
    return Container(
      margin: EdgeInsets.only(top: 100.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Checkbox(
              activeColor: Colors.orange[200],
              value: checkBoxValue,
              onChanged: (bool newValue) {
                setState(() {
                  checkBoxValue = newValue;
                });
              }),
          Text(
            "I accept all terms and conditions",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: _large ? 12 : (_medium ? 11 : 10)),
          ),
        ],
      ),
    );
  }

  /// * [ANIMATIONS]
  void _updateFormProgress() {
    var progress = 0.0;
    final controllers = [
      senhaAtualController,
      senha1Controller,
      repetirsenha1Controller
    ];

    for (final controller in controllers) {
      if (controller.value.text.isNotEmpty) {
        progress += 1 / controllers.length;
      }
    }

    setState(() {
      _formProgress = progress;
    });
  }

  /// * [METODOS e FUNCOES]
  dynamic validarSenhaAtual(value) {
    if (value.isEmpty) {
      return campoVazio;
    } else if (value != senhaAtualController.text) {
      return senhaDiferente;
    }
    return null;
  }

  dynamic validator(value) {
    if (value.isEmpty) {
      return campoVazio;
    } else if (value.length < 6) {
      return campoMenor6;
    }
    return null;
  }

  Future<TextEditingController> _validarDados() async {
    //erro validacao
    if (!_formKeyTrocarSenhaWidget.currentState.validate()) {
      //return null
    } else {
      _formKeyTrocarSenhaWidget.currentState.save();
      //comparar novas senhas
      if (senha1Controller.text != repetirsenha1Controller.text) {
        //mostrar status erro
        await AlertDialogTemplate().showAlertDialogSimplesEnviarMensa(
            context, "Atenção", "Senhas diferentes!");
      } else {
        changeColor = true;

        //passar Uppercase(),
        // String _senhaUpada = repetirsenha1Controller.text.toUpperCase();
        String _senhaUpada = repetirsenha1Controller.text;
        print(_senhaUpada);
        //enviar post para back
        await new TrocarSenhaBloc().blocTrocaDeSenha(
            context, _senhaUpada, _notificar, _trocarSenha, true);
      }
    }
    return repetirsenha1Controller;
  }

  Future<void> clearInputText() async {
    //limpar todos os campos
    senhaAtualController.clear();
    senha1Controller.clear();
    repetirsenha1Controller.clear();
  }

  closeAppToLogin() {
    //metodo desloga e abre tela de login
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => EntrarWidget()),
        (Route<dynamic> route) => false);
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  Future<void> setData(matriculaCtrl, senhaCtrl, limparCampos) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (limparCampos == true) {
        prefs.remove('matricula');
        prefs.remove('cpfColaborador');
      } else {
        prefs.setString('matricula', matriculaCtrl.text);
        prefs.setString('cpfColaborador', senhaCtrl.text);
      }
    });
    print(prefs.get('matricula'));
    print(prefs.get('cpfColaborador'));
  }

  inputText(
      TextEditingController matriculaCtrl, TextEditingController senhaCtrl) {
    setData(matriculaCtrl, senhaCtrl, false);
    print('matricula: ${matriculaCtrl.text}, salva!');
  }
}

class ResponsiveWidget {
  static bool isScreenLarge(double width, double pixel) {
    return width * pixel >= 1440;
  }

  static bool isScreenMedium(double width, double pixel) {
    return width * pixel < 1440 && width * pixel >= 1080;
  }

  static bool isScreenSmall(double width, double pixel) {
    return width * pixel <= 720;
  }
}
