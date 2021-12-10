// import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:flutter_conditional_rendering/conditional_switch.dart';
import 'package:gpmobile/src/pages/login/trocar_senha/TrocarSenhaWidget.dart';
import 'package:gpmobile/src/versao/VersaoAppWidget.dart';
import 'package:gpmobile/src/util/Estilo.dart';
import 'package:responsive_builder/responsive_builder.dart';

//lib: https://pub.dev/packages/flutter_conditional_rendering
class ConfigWidget extends StatefulWidget {
  @override
  _ConfigWidgetState createState() => _ConfigWidgetState();
}

class _ConfigWidgetState extends State<ConfigWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKeyConfigWidget =
      GlobalKey<ScaffoldState>();
  int indexPage;

  @override
  void initState() {
    setState(() {});
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

//PRINCIPAL
  @override
  Widget build(BuildContext context) {
    // List<StatusModel> listQuiz = [];
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    //BODY
    return Scaffold(
      backgroundColor: Colors.transparent.withOpacity(0.3),
      key: _scaffoldKeyConfigWidget,

      body: Container(
        color: Colors.transparent,
        // decoration: BoxDecoration(gradient: widget.backgroundGradient),
        // decoration: AppGradients.gradient,
        child: ScreenTypeLayout(
          breakpoints: ScreenBreakpoints(desktop: 799, tablet: 650, watch: 250),
          mobile: OrientationLayoutBuilder(
            portrait: (context) => configWidgetMobile(context),
            landscape: (context) => configWidgetMobile(context),
          ),
          tablet: configWidgetWeb(context),
          desktop: configWidgetWeb(context),
        ),
      ),
      endDrawer: ConditionalSwitch.single<int>(
        context: context,
        valueBuilder: (BuildContext context) => indexPage,
        caseBuilders: {
          0: (BuildContext context) => new Container(
              width: width * 1, child: Center(child: new VersaoAppWidget())),
          1: (BuildContext context) => new Container(
              width: width * 1, child: Center(child: new TrocarSenhaWidget())),
          // 2: (BuildContext context) => new Container(
          //       width: width * 1,
          //       // width: 410,
          //       child: Center(
          //         child: new SobreWidget(),
          //       ),
          //     ),
        },
//fallbackBuilder, se o indexPage == null
        fallbackBuilder: (BuildContext context) {
          return Card(
            color: Colors.white,
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: closeDrawer,
                  icon: Icon(Icons.close, size: 60, color: Colors.red),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                const Text(
                  'tela TESTE vazia!!!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
      //bloqueia acesso ao Drawer no mobile and web
      endDrawerEnableOpenDragGesture: false,
    );
  }

////////////////////////widgets/////////////////////////////
  Widget configWidgetMobile(context) {
    // double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      decoration: AppGradients.gradient,
      child: Scaffold(
        backgroundColor: Estilo().backgroundConfig,
        appBar: appBar(context),
        body: Column(
          children: [
            Center(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 24.0, right: 24.0),
                children: <Widget>[
                  // btnModoNoturno(context),
                  SizedBox(height: height * 0.03), //8
                  btnSobreApp(context),
                  SizedBox(height: height * 0.03), //24
                  // btnCadQuestoes(context),
                  btnTrocarSenha(context),
                  SizedBox(height: height * 0.03), //24
                  // btnTESTE(context),
                  // SizedBox(height: height * 0.03), //48
                  // btnBemVindo(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget configWidgetWeb(context) {
    // double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: appBarWeb(context),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            // btnModoNoturno(context),
            // SizedBox(height: height * 0.03), //8
            btnSobreApp(context),
            SizedBox(height: height * 0.03), //24
            // btnTESTE(context),
            btnTrocarSenha(context),
            SizedBox(height: height * 0.03), //24
            // SizedBox(height: height * 0.03), //48
            // btnBemVindo(context),
          ],
        ),
      ),
    );
  }

//WIDGETS
  Widget appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: BackButton(),
      actions: <Widget>[
        new Container(),
      ],
      toolbarHeight: 50.0,
      elevation: 0,
      centerTitle: true,
      title: Text(
        "Configurações",
        style: TextStyle(
          color: Colors.white,
          // fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        // textAlign: TextAlign.left,
      ),
    );
  }

  Widget appBarWeb(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      actions: <Widget>[
        new Container(),
      ],
      toolbarHeight: 50.0,
      elevation: 0,
      centerTitle: true,
      title: Text(
        "Configurações",
        style: TextStyle(
          color: Colors.white,
          // fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        // textAlign: TextAlign.left,
      ),
    );
  }

  Widget appBar2(BuildContext context) {
    return Container(
      height: 250,
      // decoration: BoxDecoration(gradient: AppGradients.linear),
      child: Stack(
        children: [
          Container(
            height: 161,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            width: double.maxFinite,
            decoration: BoxDecoration(gradient: AppGradients.linear),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(text: 'Olá, ',
                      // style: AppTextStyles.title,
                      children: [
                        TextSpan(
                            // text: user.name, style: AppTextStyles.titleBold
                            )
                      ]),
                ),
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage('user.photoUrl'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
              // alignment: Alignment.bottomCenter,
              alignment: Alignment(0.0, 1.0),
              child: Container())
        ],
      ),
    );
  }

  Widget btnSobreApp(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () {
        setState(() {
          _openEndDrawer(0);
        });
      },
      child: Container(
        width: width * 0.59, // 0.29 web
        height: height * 0.07, // null
        decoration: BoxDecoration(
          // color: _selectedColorRight,
          // gradient: AppGradients.linear2,
          border: Border.fromBorderSide(
            BorderSide(
              color: AppColors.border,
            ),
          ),
          borderRadius: BorderRadius.circular(5),
          color: Estilo().fillColor,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Icon(
                Icons.system_update_rounded,
                color: Estilo().textCorDark,
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 120, 0),
                child: Text('Versao do App',
                    style: TextStyle(
                      color: Estilo().textCorDark,
                    )),
              ),
            ),
            Expanded(
              flex: 1,
              child: Icon(
                Icons.keyboard_arrow_right_rounded,
                color: Estilo().textCorDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget btnTrocarSenha(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () {
        setState(() {
          _openEndDrawer(1);
        });
      },
      child: Container(
        width: width * 0.59, // 0.29 web
        height: height * 0.07, // null
        decoration: BoxDecoration(
          // color: _selectedColorRight,
          // gradient: AppGradients.linear2,
          border: Border.fromBorderSide(
            BorderSide(
              color: AppColors.border,
            ),
          ),
          borderRadius: BorderRadius.circular(5),
          color: Estilo().fillColor,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Icon(
                Icons.lock_open_rounded,
                color: Estilo().textCorDark,
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 120, 0),
                child: Text('Trocar minha senha',
                    style: TextStyle(
                      color: Estilo().textCorDark,
                    )),
              ),
            ),
            Expanded(
              flex: 1,
              child: Icon(
                Icons.keyboard_arrow_right_rounded,
                color: Estilo().textCorDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget btnSobreAppWeb(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () {
        setState(() {
          _openEndDrawer(0);
        });
      },
      child: Container(
        width: width * 0.59, // 0.29 web
        height: height * 0.07, // null
        decoration: BoxDecoration(
          // color: _selectedColorRight,
          // gradient: AppGradients.linear2,
          border: Border.fromBorderSide(
            BorderSide(
              color: AppColors.border,
            ),
          ),
          borderRadius: BorderRadius.circular(5),
          color: Estilo().fillColor,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Icon(
                Icons.lightbulb,
                color: Estilo().textCorDark,
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 120, 0),
                child: Text('Sobre o App',
                    style: TextStyle(
                      color: Estilo().textCorDark,
                    )),
              ),
            ),
            Expanded(
              flex: 1,
              child: Icon(
                Icons.keyboard_arrow_right_rounded,
                color: Estilo().textCorDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget btnTEST(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: width * 0.59, // 0.29 web
      height: height * 0.07, // null
      decoration: BoxDecoration(
        border: Border.fromBorderSide(
          BorderSide(
            color: AppColors.border,
          ),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(
          Icons.lightbulb,
          color: Estilo().branca,
        ),
        title: Text(
          'Teste',
          style: TextStyle(
            color: Estilo().branca,
          ),
        ),
        trailing: Icon(
          Icons.keyboard_arrow_right_rounded,
          color: Estilo().branca,
        ),
        onTap: () {
          setState(() {
            _openEndDrawer(2);
          });
        },
      ),
    );
  }

  //METODOS
  void closeDrawer() {
    setState(() {
      Navigator.of(context).pop();
    });
  }

  Future<void> _openEndDrawer(i) async {
    indexPage = i;
    _scaffoldKeyConfigWidget.currentState.openEndDrawer();
  }
}
