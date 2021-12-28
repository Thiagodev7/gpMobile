import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/conditional_switch.dart';
import 'package:gpmobile/src/core/app_colors.dart';
import 'package:gpmobile/src/pages/documentos/bloc/ListarDocBloc.dart';
import 'package:gpmobile/src/pages/documentos/model/ListarDocModel.dart';
import 'package:gpmobile/src/pages/mensagens/bloc/ListaMensaBloc.dart';
import 'package:gpmobile/src/pages/mensagens/model/MensagemRetornoModel.dart'
    as msg;
import 'package:gpmobile/src/pages/documentos/view/DocsWidget.dart';
import 'package:gpmobile/src/pages/home/model/listNotfic.dart';
import 'package:gpmobile/src/pages/mensagens/view/VisualizaMensaWidget.dart';
import 'package:gpmobile/src/util/Globals.dart';
import 'package:horizontal_data_table/refresh/pull_to_refresh/src/indicator/waterdrop_header.dart';
import 'package:horizontal_data_table/refresh/pull_to_refresh/src/smart_refresher.dart';
import 'package:intl/intl.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeWeb extends StatefulWidget {
  @override
  _HomeWebState createState() => _HomeWebState();
}

class _HomeWebState extends State<HomeWeb> {
  final GlobalKey<ScaffoldState> _scaffoldKeyHomeWeb =
      GlobalKey<ScaffoldState>();

  List<msg.TtRetorno2> listaFinal = [];
  List<TtRetorno2> listaFinalDoc = [];
  List<ListNotific> dados = [];
  // List<msg.TtRetorno2> listaFinalcompleta = [];

  TtRetorno2 objMensaEndDrawer;

  String origemClick = "";

  int indexPage;
  int count;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      LisartDocsBloc()
          .getListDocs(context: context, cienciaConfirmada: false, operacao: 1)
          .then((value) => {
                setState(() {
                  listaFinalDoc.clear();
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
                      listaFinal.clear();

                      msg.TtRetorno2 mensagem;
                      // listaFinalcompleta = map1.response.ttRetorno.ttRetorno2;
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

    super.initState();
  }

  preencherList() {
    dados.clear();
    setState(() {
      for (int i = 0; i < listaFinalDoc.length; i++) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      // key: _scaffoldKeyHomeWeb,
      body: Container(
        color: Colors.transparent.withOpacity(0.2),
        //decoration: AppGradients.gradient,
        child: ScreenTypeLayout(
          breakpoints: ScreenBreakpoints(desktop: 899, tablet: 730, watch: 279),
          mobile: OrientationLayoutBuilder(
            portrait: (context) => _buildWeb(),
            landscape: (context) => _buildWeb(),
          ),
          tablet: _buildWeb(),
          desktop: _buildWeb(),
        ),
      ),
    );
  }

  @override
  Widget _buildWeb() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.transparent,
      key: _scaffoldKeyHomeWeb,
      body: Container(
        color: Colors.transparent,
        // decoration: AppGradients.gradient,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return listaMensaLidasWeb();
          },
        ),
      ),
      endDrawer: ConditionalSwitch.single<String>(
          context: context,
          valueBuilder: (BuildContext context) => origemClick,
          caseBuilders: {
            'viewHome': (BuildContext context) =>
                indexPage < 0 ? SizedBox() : open()
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
      onEndDrawerChanged: (isOpened) {
        if (isOpened == false) {
          refreshAction();
        }
      },
    );
  }

  open() {
    if (dados[indexPage].tipo == "doc") {
      return new DocsWidget(
        index: dados[indexPage].codDocumento,
        signature: dados[indexPage].documentoAssinado,
      );
    } else {
      return new VisualizaMensaWidget(index: dados[indexPage].codDocumento);
    }
  }

  Widget listaMensaLidasWeb() {
    //
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text("HOME"),
        centerTitle: true,
        elevation: 0.7,
      ),
      body: SmartRefresher(
        header: WaterDropHeader(waterDropColor: Colors.green),
        controller: _refreshController,
        child: dados.isEmpty || dados == null || dados[0] == null
            ? Center(
                child: Text(
                  'Lista vazia no momento!',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: dados.length,
                itemBuilder: (BuildContext context, int index) {
                  ListNotific objMensaWeb = dados[index];

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
                          _visualizarMensaWeb(index);
                        },
                        child: Container(
                          margin: new EdgeInsets.fromLTRB(10, 0, 10, 0),
                          width: width * 0.89, // 0.29 web
                          height: 55.0, //height * 0.07

                          // child: Card(
                          //   clipBehavior: Clip.antiAlias,
                          //   shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(8.0)),
                          //   color: controller.isSelected(index)
                          //       ? AppColors.black
                          //       : AppColors.white,
                          //   child:
                          decoration: BoxDecoration(
                            // color: _selectedColorRight,
                            // gradient: AppGradients.linear2,
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
                              // Container(
                              //   color: AppColors.primary,
                              //   width: 10.0,
                              // ),
                              // SizedBox(
                              //   width: 10.0,
                              // ),
                              Expanded(
                                child: AbsorbPointer(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: mensagemLida == false
                                            ? Icon(
                                                objMensaWeb.icon1,
                                                color: Colors.green,

                                                //: Colors.purple[200] ,
                                                size: 30,
                                              )
                                            : Icon(
                                                objMensaWeb.icon1,
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
                                            objMensaWeb.titulo,
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
                                          objMensaWeb.dataCriacao ==
                                                  DateFormat('dd/MM/yy')
                                                      .format(DateTime.now())
                                                      .toString()
                                              ? objMensaWeb.horaCriacao
                                              : objMensaWeb.dataCriacao, //dias
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
                                      objMensaWeb == null
                                          ? Container()
                                          : Expanded(
                                              flex: 1,
                                              child: objMensaWeb
                                                              .requerCiencia ==
                                                          true &&
                                                      objMensaWeb
                                                              .documentoLido ==
                                                          false //pendente == isFalse
                                                  ? Icon(
                                                      Icons
                                                          .drive_file_rename_outline,
                                                      color: Colors.orange[200],
                                                      size: 30,
                                                    )
                                                  : objMensaWeb.requerCiencia ==
                                                              true &&
                                                          objMensaWeb
                                                                  .documentoLido ==
                                                              false
                                                      ? Icon(
                                                          Icons
                                                              .check_circle_sharp,
                                                          color: Colors.green,
                                                          size: 30,
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

                    //   actionPane: SlidableDrawerActionPane(),
                  );
                }),
      ),
    );
  }

  void _visualizarMensaWeb(pageIndex) {
    setState(() {
      origemClick = "viewHome";
      // objMensaEndDrawer = objMensa;
      _openEndDrawer(pageIndex);
    });
  }

  Future<int> _openEndDrawer(i) async {
    indexPage = i;
    _scaffoldKeyHomeWeb.currentState.openEndDrawer();
    return indexPage;
  }

  void closeEndDrawer() {
    setState(() {
      indexPage = indexPage - 1;
      Navigator.of(context).pop();
    });
  }

  _onRefresh() {
    // monitor network fetch
    refreshAction();
    print('atualizando Box');
    // if failed,use refreshFailed()
    Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  refreshAction() async {
    SharedPreferences.getInstance().then((prefs) {
      LisartDocsBloc()
          .getListDocs(context: context, cienciaConfirmada: false, operacao: 1)
          .then((value) => {
                listaFinalDoc.clear,
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
                  listaFinal.clear;
                  indexPage = indexPage - 1;
                  setState(() {
                    if (map1 != null &&
                        map1.response.ttRetorno.ttRetorno2 != null) {
                      //listaGlobal = map1;

                      msg.TtRetorno2 mensagem;
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
}
