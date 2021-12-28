import 'dart:async';
import 'dart:core';
import 'package:clay_containers_plus/widgets/clay_containers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:gpmobile/src/pages/documentos/bloc/ListarDocBloc.dart';
import 'package:gpmobile/src/pages/documentos/model/ListarDocModel.dart';
import 'package:gpmobile/src/pages/documentos/view/DocsWidget.dart';
import 'package:gpmobile/src/pages/documentos/view/ListaDocNovosWidgets.dart';
import 'package:gpmobile/src/pages/envDoc/view/envDoc.dart';
import 'package:gpmobile/src/pages/home/model/listNotfic.dart';
import 'package:gpmobile/src/pages/home/view/HomeWebWidget.dart';
import 'package:gpmobile/src/pages/mensagens/view/ListaMensaNovas.dart';
import 'package:gpmobile/src/pages/mensagens/model/MensagemRetornoModel.dart'
    as MensagemRetornoModel;
import 'package:gpmobile/src/pages/mensagens/view/VisualizaMensaWidget.dart';
import 'package:gpmobile/src/pages/ponto/bloc/PontoBloc.dart';
import 'package:gpmobile/src/util/Globals.dart';
import 'package:gpmobile/src/widgets/countdown_timer.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial/tutorial.dart';
import 'package:gpmobile/src/pages/bcoHoras/view/BcoHorasWidget.dart';
import 'package:gpmobile/src/pages/configuracoes/view/ConfigWidget.dart';
import 'package:gpmobile/src/pages/contraCheque/view/ContraChequeWidget.dart';
import 'package:gpmobile/src/pages/ferias/view/FeriasWidget.dart';
import 'package:gpmobile/src/pages/mensagens/bloc/ListaMensaBloc.dart';
import 'package:gpmobile/src/pages/myDay/view/MyDayWidget.dart';
import 'package:gpmobile/src/pages/ponto/page/PontoWidget.dart';
import 'package:gpmobile/src/pages/sugestoes/view/SugestoesWidget.dart';
import 'package:gpmobile/src/routes/routes.dart';
import 'package:gpmobile/src/util/AlertDialogTemplate.dart';
import 'package:gpmobile/src/util/Estilo.dart';
import 'package:gpmobile/src/util/NavigationBloc.dart';
import 'package:gpmobile/src/util/SharedPreferencesBloc.dart';
import 'package:gpmobile/src/util/images.dart';
import 'package:gpmobile/src/widgets/navigation_item.dart';

import '../bloc/HomeBloc.dart';

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget>
    with SingleTickerProviderStateMixin {
  // List<StatusModel> listaFinal2 = new List();
  ListaMensaBloc listaMensaBloc = ListaMensaBloc();
  //
  String nomeColaborador = '';
  String empresa = '';
  String matricula = '';
  String cargo = '';
  String nomeEmpresa = '';
  double topContainer = 0;
  bool closeTopContainer = false;

  List<MensagemRetornoModel.TtRetorno2> listaFinal = [];
  List<TtRetorno2> listaFinalDoc = [];
  List<TutorialItens> itens = []; //criar lista de tutoriais
  List<ListNotific> dados = [];

  //MensagemRetornoModel.MensagemRetornoModel listaGlobal;
  //
  String titulo;
  String mensagem;
  String data;
  bool documentoLido;
  //CONTROLLERS
  ScrollController controller = ScrollController();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  EasyRefreshController _controller;
  TabController _tabController;
  //
  int _seletedItem;
  int index = 1;

//
  int resp;
  bool verificacao = false;
  //
  bool _userAdmin;
  bool _habilitaButton = false;

  //
  var _loading = false;
  var _pagesController = PageController();
  var _chaveHomeWeb = GlobalKey<ScaffoldState>(); //chave de acesso ao widget
  var keyBotaoSair = GlobalKey(); //chave de acesso ao widget
  var keyHomeBoxMensagens = GlobalKey(); //chave de acesso ao widget
  var keyHomeBotoes = GlobalKey(); //chave de acesso ao widget

  //INICIO
  @override
  void initState() {
    _tabController = TabController(vsync: this, initialIndex: 0, length: 2);
    _controller = EasyRefreshController();
    _pagesController = PageController(
      keepPage: false,
      initialPage: 0,
    );

    setState(() {
      _seletedItem = index;
    });

    setState(() {
      PontoBloc()
          .retornoTime(context, true, 2)
          .then((value) => {
                resp = value.response.ttRetornoErro.ttRetornoErro[0]
                    .tempoRestanteIntervaloEmSegundos
              })
          .whenComplete(() {
        PontoBloc()
            .retornoTime(context, true, 2)
            .then((value) => {
                  verificacao = value
                      .response.ttRetornoErro.ttRetornoErro[0].inicioIntervalo
                })
            .whenComplete(() => {
                  setState(() {
                    SharedPreferencesBloc()
                        .buscaParametroBool("userAdmin")
                        .then((retorno) {
                      _userAdmin = retorno;

                      if (_userAdmin == false) {
                        _habilitaButton = _userAdmin;
                      } else {
                        _habilitaButton = _userAdmin;
                      }
                    });
                  }),
                });
      });

      Timer(
          Duration(seconds: 1),
          () => setState(() {
                HomeBloc().getNomeColaborador().then((map) async {
                  nomeColaborador = map;
                });
                HomeBloc().getCargo().then((map) async {
                  cargo = map;
                });
                HomeBloc().getNomeEmpresa().then((map) async {
                  nomeEmpresa = map;
                });
                HomeBloc().getMatricula().then((map) async {
                  matricula = map;
                });
                //
                HomeBloc().getEmpresa().then((map) async {
                  empresa = map;
                });
              }));
    });

    controller.addListener(() {
      double value = controller.offset / 119;
      setState(() {
        topContainer = value;
        closeTopContainer = controller.offset > 50;
      });
    });
    setState(() {
      SharedPreferences.getInstance().then((prefs) {
        LisartDocsBloc()
            .getListDocs(
                context: context, cienciaConfirmada: false, operacao: 1)
            .then((value) => {
                  setState(() {
                    if (value != null &&
                        value.response.ttRetorno.ttRetorno2[0] != null) {
                      TtRetorno2 documentos =
                          value.response.ttRetorno.ttRetorno2.firstWhere(
                              (element) =>
                                  element.requerCiencia == true &&
                                  element.documentoAssinado == null,
                              orElse: () => null);
                      if (documentos == null) {
                        Globals.bloqueiaMenu = false;
                      } else {
                        Globals.bloqueiaMenu = true;
                      }
                      listaFinalDoc = value.response.ttRetorno.ttRetorno2
                          .where((element) => element.requerCiencia == false
                              ? element.documentoLido == false
                              : element.documentoAssinado == false)
                          .toList();
                    } else {
                      Globals.bloqueiaMenu = false;
                    }
                  })
                })
            .whenComplete(() => {
                  ListaMensaBloc()
                      .getMessageBack(
                          cienciaConfirmada: false,
                          context: context,
                          operacao: 1)
                      .then((map1) {
                    setState(() {
                      if (map1 != null &&
                          map1.response.ttRetorno.ttRetorno2 != null) {
                        //listaGlobal = map1;

                        MensagemRetornoModel.TtRetorno2 mensagem;
                        mensagem = map1.response.ttRetorno.ttRetorno2
                            .firstWhere(
                                (element) =>
                                    element.requerCiencia == true &&
                                    element.mensagemAssinada == false,
                                orElse: () => null);

                        if (mensagem == null) {
                          Globals.bloqueiaMenu = false;
                        } else {
                          Globals.bloqueiaMenu = true;
                        }
                        listaFinal = map1.response.ttRetorno.ttRetorno2
                            .where((element) => element.requerCiencia == false
                                ? element.mensagemLida == false
                                : element.mensagemAssinada == false)
                            .toList();
                      } else {
                        Globals.bloqueiaMenu = false;
                      }
                    });
                  }).whenComplete(() => preencherList()),
                });
      });
    });

    super.initState();
  }

  preencherList() {
    dados.clear();
    setState(() {
      for (var i = 0; i < listaFinalDoc.length; i++) {
        ListNotific item = new ListNotific();

        item.codDocumento = listaFinalDoc[i].codDocumento;
        item.titulo = listaFinalDoc[i].titulo;
        item.dataCriacao = listaFinalDoc[i].dataCriacao;
        item.documentoAssinado = listaFinalDoc[i].documentoAssinado;
        item.documentoLido = listaFinalDoc[i].documentoLido;
        item.arquivoBase64 = listaFinalDoc[i].arquivoBase64;
        item.icon2 = Icons.find_in_page;
        item.icon1 = Icons.find_in_page;
        item.descricao = listaFinalDoc[i].descricao;
        item.requerCiencia = listaFinalDoc[i].requerCiencia;
        item.horaCriacao = listaFinalDoc[i].horaCriacao;
        item.tipo = 'doc';

        dados.add(item);
      }

      for (var i = 0; i < listaFinal.length; i++) {
        ListNotific item = new ListNotific();
        item.codDocumento = listaFinal[i].codMensagem;
        item.titulo = listaFinal[i].titulo;
        item.dataCriacao = listaFinal[i].dataCriacao;
        item.requerCiencia = listaFinal[i].requerCiencia;
        item.documentoLido = listaFinal[i].mensagemLida;
        item.icon1 = Icons.message;
        item.icon2 = Icons.message;
        item.requerCiencia = listaFinal[i].requerCiencia;
        item.horaCriacao = listaFinal[i].horaCriacao;
        item.tipo = 'msg';

        dados.add(item);
      }
    });
  }

  final _scaffoldKeyHomeWidget = GlobalKey<ScaffoldState>();
  void _closeDrawer() {
    if (_scaffoldKeyHomeWidget.currentState.isDrawerOpen) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    // _pagesController.dispose();
    super.dispose();
  }

  //esse metodo muito importante para nao gerar erros na transicao das telas!!!
  void _openPageChanged(int page) {
    setState(() {
      _pagesController.jumpToPage(_seletedItem);
      var a = _seletedItem;
      switch (a) {
        case 0:
          {
            print("Home");
          }
          break;
        case 1:
          {
            print("Férias");
          }
          break;
        case 2:
          {
            print("Banco Horas");
          }
          break;
        case 3:
          {
            print("Ponto");
          }
          break;
        case 4:
          {
            print("Holerite");
          }
          break;
        case 5:
          {
            print("Meu Dia");
          }
          break;
        // case 6:
        //   {
        //     print("Aniversariantes");
        //   }
        //   break;
        case 6:
          {
            print("Mensagens");
          }
          break;
        case 7:
          {
            print("Sugestao");
          }
          break;
        case 8:
          {
            print("Sobre o App");
          }
          break;
        // case 9:
        //   {
        //     print("Enviar Doc.");
        //   }
        //   break;
      }
    });
  }

//PRINCIPAL
  @override
  Widget build(BuildContext context) {
    //
    return Scaffold(
      key: _scaffoldKeyHomeWidget,
      body: Container(
        decoration: AppGradients.gradient,
        child: ScreenTypeLayout(
          breakpoints: ScreenBreakpoints(desktop: 799, tablet: 730, watch: 279),
          mobile: OrientationLayoutBuilder(
            portrait: (context) => homeMobile(),
            landscape: (context) => homeMobile(),
          ),
          tablet: homeWeb(),
          desktop: homeWeb(),
        ),
      ),
    );
  }

//MOBILE////////////////////////////////////////////////////////////////////////
  Widget homeMobile() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * 0.4), // here the desired height
        child: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          flexibleSpace: SafeArea(
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: width * 0.02, vertical: height * 0.02),
                        child: _buttonLogoffWeb(context, 'web'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Wrap(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: height * 0.08), //35
                        child: _nomeUsuario(context),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _dadosUsuario(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          Container(
            child: verificacao
                ? CountDownTimer(
                    resp: resp == null ? 0 : resp,
                  )
                : SizedBox(),
          ),
          Container(
            color: Colors.transparent,

            // decoration: AppGradients.gradient,
            height: height * 1.2, //1.2
            // key: keyHomeBoxMensagens,

            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: _boxMensageMobile(context),
            ),
          ),
          // s
        ],
      ),
      bottomNavigationBar: Padding(
        key: keyHomeBotoes,
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: footerMenuMobile(),
      ),
    );
  }

  // Container Documento() {
  //   double width = MediaQuery.of(context).size.width;
  //   double height = MediaQuery.of(context).size.width;
  //   return Container(
  //     color: Colors.transparent,
  //     child: SmartRefresher(
  //       header: WaterDropHeader(waterDropColor: Colors.green),
  //       controller: _refreshController,
  //       onRefresh: _onRefresh,
  //       child: //listaFinal.isEmpty
  //           //? SizedBox() :
  //           Container(
  //         color: Colors.transparent.withOpacity(0.2),
  //         child: ListView(
  //           children: [
  //             Center(
  //               child: Text(
  //                 'Documentos:',
  //                 style: TextStyle(
  //                   color: Colors.white,
  //                   fontSize: 18,
  //                 ),
  //               ),
  //             ),
  //             SizedBox(
  //               height: 20,
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _boxMensageMobile(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.transparent,
      child: SmartRefresher(
        header: WaterDropHeader(waterDropColor: Colors.green),
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: dados.isEmpty
            ? Center(
                child: Image.asset(
                  imageLogoGrupoHorizontal,
                  width: width * 0.5,
                  height: height * 0.5,
                  filterQuality: FilterQuality.high,
                ),
              )
            : ListView.builder(
                itemCount: dados.length,
                itemBuilder: (BuildContext context, int index) {
                  ListNotific objMensaMob = dados[index];

                  bool mensagemLida;
                  if (dados[index].requerCiencia == true) {
                    if (dados[index].documentoLido == true &&
                        dados[index].documentoAssinado == true) {
                      mensagemLida = true;
                    } else {
                      mensagemLida = false;
                    }
                  } else {
                    if (dados[index].documentoLido == true) {
                      mensagemLida = true;
                    } else {
                      mensagemLida = false;
                    }
                  }

                  return Column(
                    children: [
                      //acao click!
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            objMensaMob.tipo == "doc"
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            new DocsWidget(
                                              index: objMensaMob.codDocumento,
                                              signature:
                                                  objMensaMob.documentoAssinado,
                                            )))
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            new VisualizaMensaWidget(
                                                index:
                                                    objMensaMob.codDocumento)));
                          });
                        },
                        child: Container(
                          margin: new EdgeInsets.fromLTRB(10, 0, 10, 0),
                          width: width * 0.89, // 0.29 web
                          height: 55.0,

                          decoration: BoxDecoration(
                            border: Border.fromBorderSide(
                              BorderSide(
                                color: AppColors.border,
                              ),
                            ),
                            borderRadius: BorderRadius.circular(5),
                            color: AppColors.white,
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
                                        child: mensagemLida == false
                                            ? Icon(
                                                objMensaMob.icon1,
                                                color: Colors.green,

                                                //: Colors.purple[200] ,
                                                size: 30,
                                              )
                                            : Icon(
                                                objMensaMob.icon1,
                                                // Icons.messenger_outline,
                                                color: mensagemLida == false
                                                    ? null
                                                    : Colors.grey,
                                                size: 30,
                                              ),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 20, 0),
                                          child: Text(
                                            objMensaMob.titulo,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontWeight: mensagemLida == false
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                              color: mensagemLida == false
                                                  ? null
                                                  : Colors.grey,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          objMensaMob.dataCriacao ==
                                                  DateFormat('dd/MM/yy')
                                                      .format(DateTime.now())
                                                      .toString()
                                              ? objMensaMob.horaCriacao
                                              : objMensaMob.dataCriacao, //dias
                                          style: TextStyle(
                                            fontWeight: mensagemLida == false
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            color: mensagemLida == false
                                                ? null
                                                : Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      objMensaMob == null
                                          ? Container()
                                          : Expanded(
                                              flex: 1,
                                              child: objMensaMob.requerCiencia
                                                  ? Icon(
                                                      Icons
                                                          .drive_file_rename_outline,
                                                      color: objMensaMob
                                                              .documentoLido
                                                          ? Colors.grey
                                                          : Colors.green,
                                                    )
                                                  : Icon(null),
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
                  );

                  //   actionPane: SlidableDrawerActionPane(),
                },
              ),
      ),
    );
  }

  Widget _buttonLogoffMobile(BuildContext context, tipoDispositivo) {
    return new Container(
      child: new Row(
        // mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
            child: ClayContainer(
              borderRadius: 5,
              // alignment: Alignment.centerRight,
              // emboss: true,
              // depth: 10,
              width: 30,
              height: 30,
              // duration: duration,
              color: Theme.of(context).backgroundColor,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: new IconButton(
                  // color: Theme.of(context).unselectedWidgetColor.withOpacity(0.9),
                  onPressed: () => AlertDialogTemplate()
                      .showAlertDialogLogoff(context, "Atenção",
                          "Deseja sair do aplicativo?", tipoDispositivo)
                      .then(
                        (map) async {},
                      ),
                  icon: Icon(
                    Icons.logout,
                    size: 18,
                    color: ThemeData.light().buttonColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget footerMenuMobile() {
    // double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.transparent,
      // decoration: AppGradients.gradient,
      padding: EdgeInsets.symmetric(
        horizontal: 5.0,
        vertical: 5.0,
      ),
      // height: height * 0.14,
      height: 110.0,
      child: ListView.separated(
          separatorBuilder: (context, index) => SizedBox(
                width: 5,
              ),
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          itemCount: cardItensMobile.length,
          itemBuilder: (context, index) {
            //
            MenuItemWidget objCard = cardItensMobile[index];
            //
            return Container(
              width: width * 0.225, //225
              child: MaterialButton(
                color: Colors.transparent,
                onPressed: () => openPage(index),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      objCard.iconData,
                      color: Colors.white.withOpacity(0.8),
                      // textDirection: TextDirection.,
                      size: 30,
                    ),
                    Text(
                      objCard.text,
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.bold,
                          fontSize: 11),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  List<BottomMenuItemWidget> cardItensMobile = [
    //[0]
    MenuItemWidget(
      text: "Férias",
      iconData: Icons.flight,
    ),
    // [1]
    MenuItemWidget(
      text: "Banco \nHoras",
      // iconData: Icons.access_alarms,
      iconData: Icons.watch_later_rounded,
    ),
    // [2]
    MenuItemWidget(
      text: "Ponto",
      iconData: Icons.touch_app,
    ),
    // [3]
    MenuItemWidget(
      text: "Holerite",
      iconData: Icons.request_page,
    ),
    // [4]
    MenuItemWidget(
      text: "Meu Dia",
      iconData: Icons.event_available_rounded,
    ),

    // // [5]
    // MenuItemWidget(
    //   text: "Aniver.",
    //   iconData: Icons.cake,
    // ),

    // [5]
    MenuItemWidget(
      text: "Mens.",
      iconData: Icons.messenger,
    ),
    // [6]
    MenuItemWidget(text: "Anexos", iconData: Icons.image_rounded),

    // [7]
    MenuItemWidget(text: "Sugestões", iconData: Icons.thumbs_up_down_rounded),

    //[8]
    MenuItemWidget(
      text: "Config. ",
      iconData: Icons.settings,
    ),
    //[9]
    // MenuItemWidget(
    //   text: "Enviar Doc.",
    //   iconData: Icons.quiz_outlined,
    // ),
  ];

  //WEB/////////////////////////////////////////////////////////////////////////

  Widget homeWeb() {
    // final GlobalKey<State> cartKey = GlobalKey();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.width;

    setState(() {});

    return Scaffold(
      key: _chaveHomeWeb,
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          // decoration: BoxDecoration(color: Colors.transparent),
          child: Row(
            children: [
              _buildColunaEsquerda(context),
              _buildColunaDireita(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Center(
        heightFactor: 1,
        child: footerMenuWeb(),
      ),
    );
  }

  Expanded _buildColunaEsquerda(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.width;
    return Expanded(
      // flex: widget.isMedium ? 1 : 3,
      flex: 1,
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.fromLTRB(18, 0, 0, 0),
        child: Card(
          color: Colors.transparent,
          // elevation: 8,
          margin: EdgeInsets.zero,
          // color: Color(0xFF8191c),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Color(0xFF8191c),
            ),
          ),
          child: Container(
            height: 800,
            //color: Color(0xFF8191c),
            // decoration: AppGradients.gradient2, //Geovane
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      key: keyBotaoSair,
                      padding: EdgeInsets.symmetric(
                          horizontal: height * 0.01, vertical: height * 0.03),
                      child: _buttonLogoffWeb(context, 'web'),
                    ),
                    // _buttonLogoffWeb(context),
                  ],
                ),

                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _nomeUsuario(context),
                      _dadosUsuario(context),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),

                // Chats list
                Expanded(
                  child: _boxMensageWeb(context),
                ),
                verificacao
                    ? CountDownTimer(resp: resp == null ? 0 : resp)
                    : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Expanded _buildColunaDireita() {
    // List<StatusModel> listMensag = [];
    TtRetorno2 objBoxMensa;

    var _pages = [
      new HomeWeb(), //0
      new FeriasWidget(), //1
      new BcoHorasWidget(), //2
      new PontoWidget(null, null), //3
      new ContraChequeWidget(), //4
      new MyDayWidget(), //5
      new ListaMensaNovas(), //6
      new ListaDocWidgetWeb(), //7
      new SugestoesWidget(), //8
      new ConfigWidget(), //8
      // new EnviarDocs(), //10
    ];

    return Expanded(
      // flex: widget.isMedium ? 2 : 8,
      flex: 2,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: Row(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.55,
                  height: 800,
                  child: PageView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _pagesController,
                    onPageChanged: _openPageChanged,
                    children: _pages,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _chatAppbar() {
  //   return Card(
  //     margin: EdgeInsets.zero,
  //     color: const Color(0xFF2A2F32),
  //     child: Container(
  //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //       child: Row(
  //         children: [
  //           CircleAvatar(
  //             backgroundColor: Colors.orange,
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 8.0),
  //             child: Text(
  //               'User name',
  //               overflow: TextOverflow.ellipsis,
  //             ),
  //           ),
  //           const Spacer(),
  //           IconButton(
  //             icon: Icon(Icons.search),
  //             onPressed: () {},
  //           ),
  //           IconButton(
  //             icon: Icon(Icons.more_vert),
  //             onPressed: () {},
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget _botaoHelpWeb(BuildContext context) {
  //   return new Container(
  //     // color: Colors.transparent,
  //     // width: 60,
  //     // height: 50,
  //     child: new Row(
  //       mainAxisAlignment: MainAxisAlignment.end,
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
  //           child: new ElevatedButton(
  //             onPressed: () {},
  //             style: ButtonStyle(
  //                 // elevation: MaterialStateProperty.all<double>(1.5),
  //                 shape: MaterialStateProperty.all<RoundedRectangleBorder>(
  //                     RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(18.0),
  //                         side: BorderSide(color: Colors.transparent))),
  //                 backgroundColor:
  //                     MaterialStateProperty.all<Color>(Colors.transparent)),
  //             child: Icon(
  //               Icons.info_outline,
  //               size: 20,
  //               color: ThemeData.light().buttonColor,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buttonAttPonto(BuildContext context, tipoDispositivo) {
  //   return Container(
  //     child: new ElevatedButton(
  //       onPressed: () => null,
  //       style: ButtonStyle(
  //         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
  //             RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(18.0),
  //                 side: BorderSide(color: Colors.transparent))),
  //         backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
  //       ),
  //       child: Icon(
  //         Icons.restore_page_outlined,
  //         size: 22,
  //         color: ThemeData.light().buttonColor,
  //       ),
  //     ),
  //   );
  // }

  Widget _buttonLogoffWeb(BuildContext context, tipoDispositivo) {
    return Container(
      child: new ElevatedButton(
        onPressed: () => AlertDialogTemplate()
            .showAlertDialogLogoff(context, "Atenção",
                "Deseja sair do aplicativo?", tipoDispositivo)
            .then(
              (map) async {},
            ),
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.transparent))),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
        ),
        child: Icon(
          Icons.logout,
          size: 18,
          color: ThemeData.light().buttonColor,
        ),
      ),
    );
  }

  Widget _boxMensageWeb(BuildContext context) {
    ///[alteracao 13/08]

    // double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.width;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.width;

    final cardImage = new Container(
      padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
      alignment: Alignment.topCenter,
      child: Image.asset(
        imageLogoGrupoVertical,
        width: width * 0.06,
        height: height * 0.06,
        filterQuality: FilterQuality.high,
        // width: 2,
        // height: 2,
      ),
    );
    return Container(
      color: Colors.transparent,
      // decoration: AppGradients.gradient,
      width: 500,
      height: 800,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Bem Vindo!",
            style: TextStyle(color: Colors.white70, fontSize: 30),
          ),
          cardImage,
        ],
      ),
    );

    ///[alteracao 13/08]
  }

  Widget footerMenuWeb() {
    // double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 5.0,
        vertical: 1.0,
      ),
      // height: height * 0.14,
      height: 110.0,
      child: Stack(
        children: [
          ListView.separated(
              controller: controller,
              separatorBuilder: (context, index) => SizedBox(
                    width: 5,
                  ),
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              itemCount: cardItensWeb.length,
              itemBuilder: (context, index) {
                //
                MenuItemWidget objCard = cardItensWeb[index];
                //
                return Container(
                  width: width * 0.202, //0.102 alterar largura do carrosel
                  child: MaterialButton(
                    color: Color(0xFF8191c), //Theme.of(context).cardColor,
                    onPressed: () => openPageWeb(index),
                    // onPressed: () => onHighLight('/routeHomeWidget'),
                    // onPressed: () => navKey.currentState.pushNamed('/feriasWidget'),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          // Icons.ac_unit,
                          objCard.iconData,
                          color: Colors.white.withOpacity(0.8),
                          // textDirection: TextDirection.rtl,
                          size: 30,
                        ),
                        Text(
                          objCard.text,
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontWeight: FontWeight.bold,
                              fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                );
              }),

          ///*[new] 31/08
          Positioned(
            left: 0,
            child: InkWell(
              onTap: () => onFooterPage('menos'),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                // onEnter: (event) => onEntered(true),
                child: Container(
                  width: 100,
                  height: 110.0,
                  color: Colors.black.withOpacity(0.04),
                  child: Icon(
                    Icons.chevron_left_rounded,
                    size: 80,
                    color: Colors.red.withOpacity(0.25),
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            right: 0,
            child: InkWell(
              onTap: () => onFooterPage('mais'),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                // onEnter: (event) => onEntered(true),
                child: Container(
                  width: 100,
                  height: 110.0,
                  color: Colors.black.withOpacity(0.04),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    size: 80,
                    color: Colors.red.withOpacity(0.25),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  //COMPARTILHADO//////////////////////////////////////////////////////////////////////

  Widget _nomeUsuario(BuildContext context) {
    return Wrap(
      children: [
        Text(
          nomeColaborador,
          overflow: TextOverflow.clip,
          style: TextStyle(
              color: Estilo().branca,
              fontWeight: FontWeight.bold,
              fontSize: 17,
              fontStyle: FontStyle.italic),
        ),
      ],
    );
  }

  Widget _dadosUsuario(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            "Cargo: " + cargo,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Theme.of(context).brightness == Brightness.light
                    ? Color(0xB3ffffff)
                    : Color(0xB3ffffff),
                fontWeight: FontWeight.bold,
                fontSize: 12),
          ),
          Text(
            "Empresa: " + nomeEmpresa,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Theme.of(context).brightness == Brightness.light
                    ? Color(0xB3ffffff)
                    : Color(0xB3ffffff),
                fontWeight: FontWeight.bold,
                fontSize: 12),
          ),
          new Text(
            "Matrícula: " + matricula,
            style: TextStyle(
                color: Theme.of(context).brightness == Brightness.light
                    ? Color(0xB3ffffff)
                    : Color(0xB3ffffff),
                fontWeight: FontWeight.bold,
                fontSize: 12),
          ),
        ],
      ),
    );
  }

  //METODOS/////////////////////////////////////////////////////////////////////
  onFooterPage(String direcao) {
    switch (direcao) {
      case 'mais':
        controller.animateTo(controller.offset + 200,
            curve: Curves.linear, duration: Duration(milliseconds: 300));
        break;
      case 'menos':
        controller.animateTo(controller.offset - 200,
            curve: Curves.linear, duration: Duration(milliseconds: 300));
        break;
      default:
    }
  }

  void onHighLight(String route) {
    switch (route) {
      case routeHomeWidget:
        changePage(0);
        break;
      case routeFeriasWidget:
        changePage(1);
        break;
      case routeBcoHorasWidget:
        changePage(2);
        break;
      case routePontoWidget:
        changePage(3);
        break;
      case routeMyDayWidget:
        changePage(4);
        break;
      // case routeNiverWidget:
      //   changePage(5);
      //   break;
      case routeEnviarMensaWidget:
        changePage(5);
        break;
      case routeListarDocWidget:
        changePage(6);
        break;
      case routeConfigWidget:
        changePage(7);
        break;
      case routeModoNoturno:
        changePage(8);
        break;
      case routeSobreWidget:
        changePage(9);
        break;

      // default:
    }
  }

  void changePage(int newIndex) {
    //mudar page por index
    setState(() {
      index = newIndex;
    });
  }

  void openPage(value) {
    //mudar page por index
    if (Globals.bloqueiaMenu == false) {
      setState(() {
        NavigationBloc.navegar(context, "$value", listaFinal);
      });
    } else {
      AlertDialogTemplate().showAlertDialogSimples(context, "Atencao",
          "Para que o menu seja liberado, você deverá dar aceite em todas as mensagens que requer ciência, ou seja, as que possui um \u{270F} em seu card. ");
    }
  }

  Future<String> openPageWeb(int value) {
    if (Globals.bloqueiaMenu == false) {
      if (mounted) {
        setState(() {
          _seletedItem = value;
          _pagesController.animateToPage(_seletedItem,
              duration: Duration(milliseconds: 200), curve: Curves.linear);

          // NavigationBloc.navegar(context, "$value", listaFinal);
        });
      }
    } else {
      AlertDialogTemplate().showAlertDialogSimples(context, "Atencao",
          "Para que o menu seja liberado, você deverá dar aceite em todas as mensagens que requer ciência, ou seja, as que possui um \u{270F} em seu card. ");
    }
  }

  _onRefresh() {
    // monitor network fetch
    atualizarBox();
    print('atualizando Box');
    // if failed,use refreshFailed()
    Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  atualizarBox() {
    SharedPreferences.getInstance().then((prefs) {
      LisartDocsBloc()
          .getListDocs(context: context, cienciaConfirmada: false, operacao: 1)
          .then((value) => {
                setState(() {
                  if (value != null &&
                      value.response.ttRetorno.ttRetorno2[0] != null) {
                    TtRetorno2 documentos = value.response.ttRetorno.ttRetorno2
                        .firstWhere(
                            (element) =>
                                element.requerCiencia == true &&
                                element.documentoAssinado == null,
                            orElse: () => null);
                    if (documentos == null) {
                      Globals.bloqueiaMenu = false;
                    } else {
                      Globals.bloqueiaMenu = true;
                    }
                    listaFinalDoc = value.response.ttRetorno.ttRetorno2
                        .where((element) => element.requerCiencia == false
                            ? element.documentoLido == false
                            : element.documentoAssinado == false)
                        .toList();
                  } else {
                    Globals.bloqueiaMenu = false;
                  }
                })
              })
          .whenComplete(() => {
                ListaMensaBloc()
                    .getMessageBack(
                        cienciaConfirmada: false, context: context, operacao: 1)
                    .then((map1) {
                  setState(() {
                    if (map1 != null &&
                        map1.response.ttRetorno.ttRetorno2 != null) {
                      //listaGlobal = map1;

                      MensagemRetornoModel.TtRetorno2 mensagem;
                      mensagem = map1.response.ttRetorno.ttRetorno2.firstWhere(
                          (element) =>
                              element.requerCiencia == true &&
                              element.mensagemAssinada == false,
                          orElse: () => null);
                      if (mensagem == null) {
                        Globals.bloqueiaMenu = false;
                      } else {
                        Globals.bloqueiaMenu = true;
                      }
                      listaFinal = map1.response.ttRetorno.ttRetorno2
                          .where((element) => element.requerCiencia == false
                              ? element.mensagemLida == false
                              : element.mensagemAssinada == false)
                          .toList();
                    } else {
                      Globals.bloqueiaMenu = false;
                    }
                  });
                }).whenComplete(() => preencherList()),
              });
    });
  }

  //////////////////////////////////////////////////////////////////////////////
  List<Widget> cardItensDesktop = [
    NavigationItem(
      title: 'Home',
      routeName: routeHomeWidget,
      selected: true, onHighlight: null,
      // onHighlight: ,
    ),
  ];

  List<BottomMenuItemWidget> cardItensWeb = [
    //[0]
    MenuItemWidget(
      text: "Home.",
      iconData: Icons.home,
    ),
    // [1]
    MenuItemWidget(
      text: "Férias",
      iconData: Icons.flight,
    ),
    // [2]
    MenuItemWidget(
      text: "Banco \nHoras",
      // iconData: Icons.access_alarms,
      iconData: Icons.watch_later_rounded,
    ),
    // [3]
    MenuItemWidget(
      text: "Ponto",
      iconData: Icons.touch_app,
    ),
    // [4]
    MenuItemWidget(
      text: "Holerite",
      iconData: Icons.request_page,
    ),
    // [5]
    MenuItemWidget(
      text: "Meu Dia",
      iconData: Icons.event_available_rounded,
    ),
    //[6]
    MenuItemWidget(
      text: "Mens.",
      iconData: Icons.messenger,
    ),
    // // [6]
    // MenuItemWidget(
    //   text: "Aniver.",
    //   iconData: Icons.cake,
    // ),
    // [7]
    MenuItemWidget(
      text: "Anexos",
      iconData: Icons.image_rounded,
    ),
    // [8]
    MenuItemWidget(
      text: "Sugestões",
      iconData: Icons.thumbs_up_down_rounded,
    ),
    //[9]
    MenuItemWidget(
      text: "Config. ",
      iconData: Icons.settings,
    ),
    //[10]
    MenuItemWidget(
      text: "Enviar Doc. ",
      iconData: Icons.settings,
    ),
  ];
}

abstract class BottomMenuItemWidget {
  Widget buildWidget(double diffPosition);
}

class MenuItemWidget extends BottomMenuItemWidget {
  final IconData iconData;
  final double sizeIcon;
  final String text;
  final Color selectedBgColor;
  final Color noSelectedBgColor;
  final Color selectedIconTextColor;
  final Color noSelectedIconTextColor;

  MenuItemWidget(
      {this.iconData,
      this.sizeIcon,
      this.text,
      this.selectedIconTextColor = Colors.white,
      this.noSelectedIconTextColor = Colors.grey,
      this.selectedBgColor = Colors.deepPurple,
      this.noSelectedBgColor = Colors.white});

  @override
  Widget buildWidget(double diffPosition) {
    double iconOnlyOpacity = 1.0;
    double iconTextOpacity = 0;

    if (diffPosition < 1) {
      iconOnlyOpacity = diffPosition;
      iconTextOpacity = 1 - diffPosition;
    } else {
      iconOnlyOpacity = 1.0;
      iconTextOpacity = 0;
    }

    return Container(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Opacity(
            opacity: iconTextOpacity,
            child: Container(
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 4),
                        blurRadius: 6)
                  ],
                  color: selectedIconTextColor,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Column(
                children: [
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Icon(
                        iconData,
                        size: sizeIcon,
                        color: selectedIconTextColor,
                      ),
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.fill,
                    child: Text(
                      text,
                      style:
                          TextStyle(fontSize: 15, color: selectedIconTextColor),
                    ),
                  )
                ],
              ),
            ),
          ),
          Opacity(
            opacity: iconOnlyOpacity,
            child: Container(
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 4),
                        blurRadius: 6),
                  ],
                  color: selectedIconTextColor,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              padding: EdgeInsets.all(10),
              child: FittedBox(
                fit: BoxFit.fill,
                child: Icon(
                  iconData,
                  color: selectedIconTextColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Pane1 extends StatelessWidget {
  final void Function(int) selectValue;
  final List<int> items;
  const Pane1({@required this.selectValue, this.items = const []});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView(
        children: [
          ...items.map(
            (e) => Card(
              child: ListTile(
                title: Text('Item number $e'),
                onTap: () => selectValue(e),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Pane2 extends StatelessWidget {
  final int value;

  const Pane2({Key key, this.value}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 48.0),
        child: Padding(
            padding: const EdgeInsets.all(48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Item card',
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .copyWith(color: Colors.blue[300]),
                ),
                SizedBox(height: 48),
                (value != null)
                    ? Text('Selected value is $value')
                    : Text(
                        'No Selected value .',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(color: Colors.red[300]),
                      ),
              ],
            )),
      ),
    );
  }
}

class TwoColumns extends StatefulWidget {
  final Widget pane1;
  final Widget pane2;
  final Widget pane2PopupPage;

  /// keeps track of the pane2 open state
  final bool showPane2;

  /// Called called when pane2Popup
  final void Function() onClosePane2Popup;

  /// the breakpoint for small devices
  final double breakpoint;

  /// pane1 has a flex of `paneProportion`. Default = 70
  ///
  /// pane2 `100 - paneProportion`. Default = 30.
  final int paneProportion;

  const TwoColumns({
    Key key,
    this.showPane2 = false,
    @required this.pane1,
    @required this.pane2,
    @required this.onClosePane2Popup,
    this.breakpoint = 800,
    this.paneProportion = 70,
    this.pane2PopupPage,
  }) : super(key: key);

  @override
  _TwoColumnsState createState() => _TwoColumnsState();
}

class _TwoColumnsState extends State<TwoColumns> {
  bool _popupNotOpen = true;

  bool get canSplitPanes =>
      widget.breakpoint < MediaQuery.of(context).size.width;

  /// Loads and removes the popup page for pane2 on small screens
  ///
  /// returns pane2PopupPage if provided othewise a `Scaffold` with `pane2` as it's body
  void loadPane2Page(BuildContext context) async {
    if (widget.showPane2 && _popupNotOpen) {
      _popupNotOpen = false;
      SchedulerBinding.instance.addPostFrameCallback((_) async {
        // sets _popupNotOpen to true after popup is closed
        Navigator.of(context)
            .push<Null>(
          new MaterialPageRoute<Null>(
            builder: (BuildContext context) {
              if (widget.pane2PopupPage != null) return widget.pane2PopupPage;
              return new Scaffold(
                backgroundColor: Colors.blueGrey[300],
                appBar: AppBar(title: Text('Details')),
                body: widget.pane2,
              );
            },
            fullscreenDialog: true,
          ),
        )
            .then((_) {
          // less code than wapping in a WillPopScope
          _popupNotOpen = true;
          // preserves value if screen canSplitPanes
          if (!canSplitPanes) widget.onClosePane2Popup();
        });
      });
    }
  }

  /// closes popup wind
  void _closePopup() {
    if (!_popupNotOpen) {
      SchedulerBinding.instance
          .addPostFrameCallback((_) => Navigator.pop(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (canSplitPanes) {
      _closePopup();
      return Flex(
        direction: Axis.horizontal,
        children: [
          Flexible(
            flex: widget.paneProportion,
            child: widget.pane1,
          ),
          Flexible(
            flex: 100 - widget.paneProportion,
            child: widget.pane2,
          ),
        ],
      );
    } else {
      loadPane2Page(context);
      return Flex(
        direction: Axis.horizontal,
        children: [
          Flexible(
            flex: 100,
            child: widget.pane1,
          ),
        ],
      );
    }
  }
}
