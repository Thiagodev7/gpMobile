import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/conditional_switch.dart';
import 'package:gpmobile/src/pages/sugestoes/model/SugestoesModel.dart';

import 'package:gpmobile/src/util/AlertDialogTemplate.dart';
import 'package:gpmobile/src/util/Estilo.dart';
import 'package:gpmobile/src/util/SharedPreferencesBloc.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_item/multi_select_item.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:universal_io/io.dart';
import 'dart:ui';
import '../bloc/SugestoesBloc.dart';
import 'SugestoesViewWidget.dart';
import '../model/SugetoesViewModel.dart';

class SugestoesWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SugestoesWidgetState();
  }
}

//
String titleAppBar = 'Canal Aberto';
//
String txtTitleCampoSugestao = 'Sugestão...';
//
String txtBtnSalvar = 'Enviar';
//
String txtEnviadoComSucesso = 'Sugestão enviada com sucesso!';
//
String campoObsVazio = 'Preenchimento obrigatório';
//
String _plataforma;
//
String origemClick = "";
//
TtRetSugestoes2 objSugestaoEndDrawer;
//
int count = 0;
int indexPage;
int operacaoCriarSugestao = 1;
int operacaoListarSugestao = 2;

bool _userAdmin;
bool _habilitaButton = false;

//
/// {@template custom_rect_tween}
/// Linear RectTween with a [Curves.easeOut] curve.
///
/// Less dramatic that the regular [RectTween] used in [Hero] animations.
/// {@endtemplate}
class CustomRectTween extends RectTween {
  /// {@macro custom_rect_tween}
  CustomRectTween({
    @required Rect begin,
    @required Rect end,
  }) : super(begin: begin, end: end);

  @override
  Rect lerp(double t) {
    final elasticCurveValue = Curves.easeOut.transform(t);
    return Rect.fromLTRB(
      lerpDouble(begin.left, end.left, elasticCurveValue),
      lerpDouble(begin.top, end.top, elasticCurveValue),
      lerpDouble(begin.right, end.right, elasticCurveValue),
      lerpDouble(begin.bottom, end.bottom, elasticCurveValue),
    );
  }
}

class _SugestoesWidgetState extends State<SugestoesWidget> {
//
  final GlobalKey<ScaffoldState> _scaffoldKeySugestoesWidget =
      GlobalKey<ScaffoldState>();
  final _formKeyEnviarSugestaoMob = GlobalKey<FormState>();
  final _formKeyEnviarSugestaoWeb = GlobalKey<FormState>();

  dynamic dataFormatada =
      DateFormat('dd/MM/yyyy kk:mm:ss').format(DateTime.now());
  String campoDescricaoVazio = 'Campo não pode ser vazio!...';

  bool campoVazio;
  bool isVisible = true;
  //
  TextEditingController _tituloController = new TextEditingController();
  TextEditingController _crtlSugestao = new TextEditingController();
  RefreshController _refreshCtrlListObs =
      RefreshController(initialRefresh: false);
  MultiSelectController controller;
  //
  List<TtRetSugestoes2> listaFinal2 = new List();
  List<TtRetSugestoes2> listaFinal = new List();
  List sugestoesModel = <SugestoesModel>[];
  SugestoesModel objSugestao = new SugestoesModel();
  // List<SugestoesModel> listaFinal = [];

  //
  @override
  void initState() {
    setState(() {
      SharedPreferencesBloc().buscaParametroBool("userAdmin").then((retorno2) {
        _userAdmin = retorno2;

        if (_userAdmin == false) {
          setState(() {
            _habilitaButton = _userAdmin;
          });
        } else {
          setState(() {
            _habilitaButton = _userAdmin;
          });
        }
      });
    });
    super.initState();
    controller = MultiSelectController();
    isVisible = false;

    if (Platform.isAndroid || Platform.isIOS) {
      _plataforma = 'mob';
    } else {
      _plataforma = 'web';
    }

    SugestoesBloc()
        .blocSugestoes(context, _crtlSugestao.text, _plataforma,
            operacaoListarSugestao, true)
        .then((map2) {
      setState(() {
        objSugestao = map2;
        for (var ttPonto2
            in objSugestao.response.ttRetSugestoes.ttRetSugestoes2) {
          if (objSugestao.response.pIntCodErro == 0) {
            listaFinal2.add(ttPonto2);
          }
          setState(() {
            // List<TtRetSugestoes2> listaFinal2 = listaFinal.reversed;
            return listaFinal2;
          });
        }
      });
    });
  }

  // //PRINCIPAL
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //       key: _scaffoldKeySugestoesWidget,
  //       body: LayoutBuilder(
  //         builder: (context, constraint) {
  //           if (Platform.isAndroid) {
  //             return _SugestoesWidgetMobile(context);
  //           } else {
  //             return _SugestoesWidgetWeb(context);
  //           }
  //         },
  //       ));
  // }
  // //PRINCIPAL
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent.withOpacity(0.3),
      key: _scaffoldKeySugestoesWidget,
      body: Container(
        color: Colors.transparent,
        child: ScreenTypeLayout(
          breakpoints: ScreenBreakpoints(desktop: 899, tablet: 730, watch: 279),
          mobile: OrientationLayoutBuilder(
            portrait: (context) => _SugestoesWidgetMobile(context),
            landscape: (context) => _SugestoesWidgetMobile(context),
          ),
          tablet: _SugestoesWidgetWeb(context),
          desktop: _SugestoesWidgetWeb(context),
        ),
      ),
      endDrawer: ConditionalSwitch.single<String>(
          context: context,
          valueBuilder: (BuildContext context) => origemClick,
          caseBuilders: {
            'viewSugestao': (BuildContext context) =>
                // new VisualizaMensaWidget(objMensaEndDrawer),
                new SugestoesViewWidget(
                    HeroTypeSugetao(
                        sugestao: objSugestaoEndDrawer.sugestao,
                        dataCriacao: objSugestaoEndDrawer.dataCriacao,
                        horaCriacao: objSugestaoEndDrawer.horaCriacao),
                    objSugestao),
            // 'createMensa': (BuildContext context) => EnviarMensaWidget(),
            // // 'EnviarMensaWidget': (BuildContext context) => ProductCard(),
            // 'editMensa': (BuildContext context) =>
            //     new EditarMensaWidget(objMensaEndDrawer),
          },
          fallbackBuilder: (BuildContext context) {
            return Card(
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  // const Icon(Icons.close, size: 60, color: Colors.red),
                  IconButton(
                    // color: Colors.red,
                    onPressed: closeEndDrawer,
                    icon: Icon(Icons.close, size: 60, color: Colors.red),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  const Text(
                    'Erro: Favor contactar o departameto de tecnologia!!!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }),
      endDrawerEnableOpenDragGesture: false,
    );
  }

  //MOBILE
  Widget _SugestoesWidgetMobile(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.width;
    return Container(
        decoration: AppGradients.gradient,
        child: Scaffold(
          backgroundColor: Estilo().backgroundTelaListSugestoes,
          appBar: _appBar(height, context),
          body: Container(
            // decoration: AppGradients.gradient,
            height: height * 3, //2
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 60, 0, 0),
              child: _boxListarSugestoes(context),
            ),
          ),
        ));
  }

  //WEB
  Widget _SugestoesWidgetWeb(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: _appBarWeb(height, context),
      body: Container(
        // decoration: AppGradients.gradient,
        height: height * 3, //2
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 60, 0, 0),
          child: _boxListarSugestoesWeb(context),
        ),
      ),
    );
  }

  ///*[COMPONETS]

  PreferredSize _appBar(double height, BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(height * 0.4), // here the desired height
      child: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: BackButton(),
        flexibleSpace: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      // Text(
                      //   titleAppBar,
                      //   style: TextStyle(color: Colors.white),
                      // ),
                      Text(
                        titleAppBar,
                        style: TextStyle(
                          color: AppColors.txtSemFundo,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                        // textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 80,
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 20, 5),
                        child: _btnEnviarSugestao(context, 'mob'),
                      ),
                    ],
                  ),
                ],
              ),
              Expanded(
                flex: 1,
                child: Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: buildCampoSugestao(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // elevation: 0.0,
        // backgroundColor: Theme.of(context).backgroundColor,
      ),
    );
  }

  PreferredSize _appBarWeb(double height, BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(200.0), // here the desired height
      child: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        // leading: BackButton(),
        flexibleSpace: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Text(
                          titleAppBar,
                          style: TextStyle(
                            color: AppColors.txtSemFundo,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                          // textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 80,
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 20, 5),
                          child: _btnEnviarSugestao(context, 'mob'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                flex: 1,
                child: Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: buildCampoSugestao(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // elevation: 0.0,
        // backgroundColor: Theme.of(context).backgroundColor,
      ),
    );
  }

  Widget _btnEnviarSugestao(BuildContext context, tipoDispositivo) {
    return Container(
      child: MaterialButton(
        onPressed: () => onTapEnviarSugestao(tipoDispositivo),
        highlightColor: Colors.lightBlueAccent,
        highlightElevation: 8,
        elevation: 18,
        shape: StadiumBorder(),
        child: Text(
          txtBtnSalvar,
          style: TextStyle(
            color: Estilo().branca,
          ),
        ),
        color: Theme.of(context).backgroundColor,
        enableFeedback: true,
      ),
    );
  }

  Widget buildCampoSugestao(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
      child: Container(
        child: Form(
          key: _formKeyEnviarSugestaoMob,
          child: TextFormField(
            // The validator receives the text that the user has entered.
            validator: (value) => validarCampo(value),
            controller: _crtlSugestao,
            minLines: 4,
            maxLines: 15,
            autocorrect: false,
            decoration: InputDecoration(
              labelText: txtTitleCampoSugestao,
              // icon: Icon(Icons.description, size: 30, color: Colors.grey),
              labelStyle: TextStyle(
                  height: 2,
                  fontSize: 16.0,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold),
              filled: true,
              fillColor: Colors.white,
              errorStyle: TextStyle(
                  height: 2,
                  fontSize: 16.0,
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold),
              border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(10.0),
                borderSide: new BorderSide(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _boxListarSugestoes(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.width;
    NumberFormat f = new NumberFormat("00");
    return Container(
      color: Colors.transparent,
      child: SmartRefresher(
        header: WaterDropHeader(waterDropColor: Colors.green),
        controller: _refreshCtrlListObs,
        onRefresh: _onRefresh,
//
        child: listaFinal2.isEmpty
            ? Center(
                child: Text(
                  'Sem sugestão no momento!',
                  style: TextStyle(
                    color: AppColors.txtSemFundo,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: listaFinal2.length,
                itemBuilder: (BuildContext context, int index) {
                  TtRetSugestoes2 objMensa = listaFinal2[index];

                  //convert string in date
                  DateTime dataConvertida =
                      DateTime.parse(objMensa.dataCriacao);
                  //montar data formato brasileiro
                  dynamic dataDaMensagem =
                      f.format(dataConvertida.day).toString() +
                          "/" +
                          f.format(dataConvertida.month).toString() +
                          "/" +
                          dataConvertida.year.toString();
                  //print(periodoAtual);
                  //
                  return MultiSelectItem(
                    isSelecting: controller.isSelecting,
                    onSelected: _habilitaButton == false
                        ? () {}
                        : () => onSelected(index),
                    child: Column(
                      children: [
                        //acao click!
                        InkWell(
                          onTap: () => acaoClick(objMensa),
                          child: Container(
                            margin: new EdgeInsets.fromLTRB(10, 0, 10, 0),
                            width: width * 0.89, // 0.29 web
                            height: 55.0, //height * 0.07
                            decoration: BoxDecoration(
                              // color: _selectedColorRight,
                              // gradient: AppGradients.linear2,
                              border: Border.fromBorderSide(
                                BorderSide(
                                  color: AppColors.border,
                                ),
                              ),
                              borderRadius: BorderRadius.circular(5),
                              color: controller.isSelected(index)
                                  ? AppColors.black
                                  : AppColors.white,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: AbsorbPointer(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Icon(
                                            Icons.thumbs_up_down_rounded,
                                            color: Colors.grey,
                                            size: 30,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 120, 0),
                                            child: Text(
                                              objMensa.sugestao,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey,
                                                fontSize: 15,
                                              ),
                                              // style: TextStyle(
                                              //   fontWeight:
                                              //       objMensa.lido == false
                                              //           ? FontWeight.bold
                                              //           : FontWeight.normal,
                                              //   color: objMensa.lido == false
                                              //       ? null
                                              //       : Colors.grey,
                                              //   fontSize: 15,
                                              // ),
                                            ),
                                            // child: Text(
                                            //   objMensa.sugestao,
                                            //   overflow: TextOverflow.ellipsis,
                                            //   style: TextStyle(
                                            //       fontWeight: FontWeight.bold,
                                            //       color: Colors.grey,
                                            //       fontSize: 15,
                                            //       height: 2,

                                            //       ),
                                            //   // style: TextStyle(
                                            //   //   fontWeight:
                                            //   //       objMensa.lido == false
                                            //   //           ? FontWeight.bold
                                            //   //           : FontWeight.normal,
                                            //   //   color: objMensa.lido == false
                                            //   //       ? null
                                            //   //       : Colors.grey,
                                            //   //   fontSize: 15,
                                            //   // ),
                                            // ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            dataDaMensagem ==
                                                    DateTime.now()
                                                        .toString() //true == horas
                                                ? objMensa.horaCriacao
                                                    .substring(0, 5) //horas
                                                : dataDaMensagem, //dias
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // ),
                        SizedBox(height: 10),
                      ],
                    ),

                    //   actionPane: SlidableDrawerActionPane(),
                  );
                },
              ),
//
      ),
    );
  }

  Widget _boxListarSugestoesWeb(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.transparent,
      child: SmartRefresher(
        header: WaterDropHeader(waterDropColor: Colors.green),
        controller: _refreshCtrlListObs,
        onRefresh: _onRefresh,
//
        child: listaFinal2.isEmpty
            ? Center(
                child: Text(
                  'Sem sugestão no momento!',
                  style: TextStyle(
                    color: AppColors.txtSemFundo,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: listaFinal2.length,
                itemBuilder: (BuildContext context, int index) {
                  TtRetSugestoes2 objSugestoesWeb = listaFinal2[index];
                  //convert string in date
                  DateTime dataConvertida =
                      DateTime.parse(objSugestoesWeb.dataCriacao);
                  //montar data formato brasileiro
                  dynamic dataDaMensagem =
                      f.format(dataConvertida.day).toString() +
                          "/" +
                          f.format(dataConvertida.month).toString() +
                          "/" +
                          dataConvertida.year.toString();
                  //
                  return MultiSelectItem(
                    isSelecting: controller.isSelecting,
                    onSelected: _habilitaButton == false
                        ? () {}
                        : () => onSelected(index),
                    child: Column(
                      children: [
                        //acao click!
                        InkWell(
                          // onTap: () => acaoClick(objMensa),
                          onTap: () =>
                              _visualizarSugestoesWeb(objSugestoesWeb, index),
                          child: Container(
                            margin: new EdgeInsets.fromLTRB(10, 0, 10, 0),
                            width: width * 0.89, // 0.29 web
                            height: 55.0, //height * 0.07
                            decoration: BoxDecoration(
                              // color: _selectedColorRight,
                              // gradient: AppGradients.linear2,
                              border: Border.fromBorderSide(
                                BorderSide(
                                  color: AppColors.border,
                                ),
                              ),
                              borderRadius: BorderRadius.circular(5),
                              color: controller.isSelected(index)
                                  ? AppColors.black
                                  : AppColors.white,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: AbsorbPointer(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Icon(
                                            Icons.thumbs_up_down_rounded,
                                            color: Colors.grey,
                                            size: 30,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 120, 0),
                                            child: Text(
                                              objSugestoesWeb.sugestao,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey,
                                                fontSize: 15,
                                              ),
                                              // style: TextStyle(
                                              //   fontWeight:
                                              //       objSugestoesWeb.lido == false
                                              //           ? FontWeight.bold
                                              //           : FontWeight.normal,
                                              //   color: objSugestoesWeb.lido == false
                                              //       ? null
                                              //       : Colors.grey,
                                              //   fontSize: 15,
                                              // ),
                                            ),
                                            // child: Text(
                                            //   objSugestoesWeb.sugestao,
                                            //   overflow: TextOverflow.ellipsis,
                                            //   style: TextStyle(
                                            //       fontWeight: FontWeight.bold,
                                            //       color: Colors.grey,
                                            //       fontSize: 15,
                                            //       height: 2,

                                            //       ),
                                            //   // style: TextStyle(
                                            //   //   fontWeight:
                                            //   //       objSugestoesWeb.lido == false
                                            //   //           ? FontWeight.bold
                                            //   //           : FontWeight.normal,
                                            //   //   color: objSugestoesWeb.lido == false
                                            //   //       ? null
                                            //   //       : Colors.grey,
                                            //   //   fontSize: 15,
                                            //   // ),
                                            // ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            dataDaMensagem ==
                                                    DateTime.now()
                                                        .toString() //true == horas
                                                ? objSugestoesWeb.horaCriacao
                                                    .substring(0, 5) //horas
                                                : dataDaMensagem, //dias
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // ),
                        SizedBox(height: 10),
                      ],
                    ),

                    //   actionPane: SlidableDrawerActionPane(),
                  );
                },
              ),
//
      ),
    );
  }

///////////// *[METODOS] /////////////////
  void acaoClick(TtRetSugestoes2 obj) {
    SugestoesModel sugestoesModel;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => new SugestoesViewWidget(
            HeroTypeSugetao(
                sugestao: obj.sugestao,
                dataCriacao: obj.dataCriacao,
                horaCriacao: obj.horaCriacao),
            sugestoesModel),
      ),
    );
  }

  abrirMensa(objAbrirMensa) {
    setState(() {
      // ListaMensaBloc().actionOpenMsg(context, objAbrirMensa, true);
    });
    // refreshAction();
  }

  onTapEnviarSugestao(_plataforma) async {
    bool camposValidos = true;
    //campos preenchidos...
    if (_plataforma == 'mob') {
      //mob
      camposValidos = _formKeyEnviarSugestaoMob.currentState.validate();
    } else {
      //web
      camposValidos = _formKeyEnviarSugestaoWeb.currentState.validate();
    }

    if (camposValidos == true) {
      //salvar dados
      await new SugestoesBloc().blocSugestoes(
        context,
        _crtlSugestao.text,
        _plataforma,
        operacaoCriarSugestao,
        true,
      );
      //chamar pop-up
      await AlertDialogTemplate()
          .showAlertDialogSimplesEnviarMensa(context, "", txtEnviadoComSucesso);
      //limpar campos
      _tituloController.clear();
      _crtlSugestao.clear();
      _onRefresh();
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Campo não pode ser vazio!')),
      // );
    }
  }

  dynamic validarCampo(value) {
    if (value.isEmpty) {
      return campoObsVazio;
    }
    return null;
  }

  String validaCampos(value) {
    if (_crtlSugestao.value.text == null || _crtlSugestao.value.text == "") {
      return campoDescricaoVazio;
    }
    return null;
  }

  _onRefresh() {
    // monitor network fetch
    refreshAction();
    print('atualizando Box');
    // if failed,use refreshFailed()
    Future.delayed(Duration(milliseconds: 1000));
    _refreshCtrlListObs.refreshCompleted();
  }

  Future<void> refreshAction() async => setState(() {
        listaFinal2 = [];
        SugestoesBloc()
            .blocSugestoes(context, _crtlSugestao.text, _plataforma,
                operacaoListarSugestao, true)
            .then((map2) {
          setState(() {
            objSugestao = map2;
            for (var ttPonto2
                in objSugestao.response.ttRetSugestoes.ttRetSugestoes2) {
              if (objSugestao.response.pIntCodErro == 0) {
                listaFinal2.add(ttPonto2);
              }
              setState(() {
                return listaFinal2;
              });
            }
          });
        });
      });
  atualizarBox() {
    // SharedPreferences.getInstance().then((prefs) {
    //   listaMensaBloc.getMessageBack(context, true).then((map1) {
    //     // SugestoesModelMok().list().then((map1) {
    //     setState(() {
    //       listaFinal.clear();
    //       listaFinal2.clear();
    //       listaGlobal.clear();
    //       if (map1 != null) {
    //         listaGlobal = map1;

    //         if (map1 != null && map1.length > 0) {
    //           for (SugestoesModel indexList in listaGlobal) {
    //             for (String matricula in indexList.matriculasView.split(",")) {
    //               if (matricula == prefs.getString('matricula'))
    //                 indexList.lido = true;
    //             }
    //             setState(() {
    //               listaFinal.add(indexList);
    //             });
    //           }
    //         } else {
    //           for (SugestoesModel mensBack1 in listaGlobal) {
    //             setState(() {
    //               listaFinal.add(mensBack1);
    //             });
    //           }
    //         }
    //         setState(() {
    //           listaFinal2.clear();
    //           listaFinal2
    //               .addAll(listaFinal.where((element) => element.lido == false));
    //         });
    //       }
    //     });
    //   }); //ms
    // });
  }
  void _visualizarSugestoesWeb(objeto, pageIndex) {
    // setState(() {
    //   //
    //   String tituloViewMensa = objMensa.titulo;
    //   String mensgViewMensa = objMensa.mensagem;
    //   String dataViewMensa = objMensa.data;
    //   int sequenciaViewMensa = objMensa.sequencia;
    //   bool lidoViewMensa = objMensa.lido = true; //objMensa.lido true == lido!

    //   EnviarMensaBloc()
    //       .postEnviarMensagem(context, tituloViewMensa, mensgViewMensa,
    //           dataViewMensa, 2, sequenciaViewMensa, objMensa, lidoViewMensa)
    //       .then((map) async {
    setState(() {
      origemClick = "viewSugestao";
      objSugestaoEndDrawer = objeto;
      _openEndDrawer(pageIndex);
    });
    // });
    // });
  }

  //METODOS COMPARTILHADOS
  Future<int> _openEndDrawer(i) async {
    indexPage = i;
    _scaffoldKeySugestoesWidget.currentState.openEndDrawer();
    return indexPage;
  }

  void closeEndDrawer() {
    setState(() {
      count = count - 1;
      Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onSelected(int value) {
    setState(() {
      controller.toggle(value);
    });
  }
}
