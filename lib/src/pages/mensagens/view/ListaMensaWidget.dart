import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:gpmobile/src/pages/mensagens/bloc/ListaMensaBloc.dart';
import 'package:gpmobile/src/pages/mensagens/model/MensagemRetornoModel.dart'
    as MensagemRetornoModel;
import 'package:gpmobile/src/pages/mensagens/view/VisualizaMensaWidget.dart';
import 'package:gpmobile/src/util/Estilo.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_item/multi_select_item.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListarMensaWidget extends StatefulWidget {
  @override
  _ListarMensaWidgetState createState() => _ListarMensaWidgetState();
}

class _ListarMensaWidgetState extends State<ListarMensaWidget> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  MensagemRetornoModel.TtRetorno2 objMensaEndDrawer;

  String titulo = "";
  String mensg;
  String data;
  int sequencia;
  String matriculasView;
  bool lido;
  bool aceite;

  List<MensagemRetornoModel.TtRetorno2> listaFinal = [];
  //
  final GlobalKey<ScaffoldState> _scaffoldKeyListarMensaWidget =
      GlobalKey<ScaffoldState>();
  int indexPage;
  int count = 0;
  String origemClick = "";
  //
  List mainList = new List();
  Random random = Random();
  MultiSelectController controller;
  //
  @override
  void initState() {
    controller = MultiSelectController();
    controller.disableEditingWhenNoneSelected = true;
    controller.set(listaFinal.length);

    super.initState();

    ListaMensaBloc()
        .getMessageBack(context: context, barraStatus: true, operacao: 1)
        .then((map) {
      if (map != null) {
        setState(() {
          listaFinal = map.response.ttRetorno.ttRetorno2;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  ///////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKeyListarMensaWidget,
      body: Container(
        decoration: AppGradients.gradient,
        child: ScreenTypeLayout(
          breakpoints: ScreenBreakpoints(desktop: 899, tablet: 730, watch: 279),
          mobile: OrientationLayoutBuilder(
            portrait: (context) => _listarMensaWidgetMobile(),
            landscape: (context) => _listarMensaWidgetMobile(),
          ),
        ),
      ),

      //////////////////////////////////?????????????/////////////////////////////////
      endDrawer: ConditionalSwitch.single<String>(
          context: context,
          valueBuilder: (BuildContext context) => origemClick,
          caseBuilders: {
            'viewMensa': (BuildContext context) =>
                // new VisualizaMensaWidget(objMensaEndDrawer),
                new VisualizaMensaWidget(
                    index: listaFinal[indexPage].codMensagem),
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
  ///////////////////////////////////////////////////////////

  //MOBILE
  Widget _listarMensaWidgetMobile() {
    //
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    //
    final txtAppBarTitle = (controller.isSelecting)
        ? Text('Selecionado(s) ${controller.selectedIndexes.length}  ')
        : Text(
            "Mensagens",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          );

    final btnRefresh = new IconButton(
      icon: Icon(
        Icons.autorenew,
        color: AppColors.iconSemFundo,
        size: 30,
      ),
      // onPressed: refreshAction,
      onPressed: () => null, //_listaMensaBloc.refreshList(context),
    );
    //
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: txtAppBarTitle,
        actions: [
          // btnAddMensa,
          // btnRefresh
        ],
      ),

      body: SmartRefresher(
        header: WaterDropHeader(waterDropColor: Colors.green),
        controller: _refreshController,
        onRefresh: _onRefresh,
        //
        child: listaFinal == null || listaFinal.isEmpty
            ? Center(
                child: Text(
                  'Lista vazia no momento!',
                  style: TextStyle(
                    color: AppColors.txtSemFundo,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: listaFinal.length,
                itemBuilder: (BuildContext context, int index) {
                  MensagemRetornoModel.TtRetorno2 objMensaMob =
                      listaFinal[index];

                  bool mensagemLida;
                  if (listaFinal[index].requerCiencia == true) {
                    if (listaFinal[index].mensagemLida == true &&
                        listaFinal[index].mensagemAssinada == true) {
                      mensagemLida = true;
                    } else {
                      mensagemLida = false;
                    }
                  } else {
                    if (listaFinal[index].mensagemLida == true) {
                      mensagemLida = true;
                    } else {
                      mensagemLida = false;
                    }
                  }

                  return Column(
                    children: [
                      //acao click!
                      GestureDetector(
                        onTap: () =>
                            acaoClick(objMensaMob.codMensagem, listaFinal),
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
                              // Container(
                              //   color: AppColors.primary,
                              //   width: 10.0,
                              // ),
                              // SizedBox(
                              //   width: 10.0,
                              // ),
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child: Icon(
                                          Icons.message,
                                          color: mensagemLida
                                              ? Colors.grey
                                              : Colors.green,
                                          size: 30,
                                        )),
                                    Expanded(
                                      flex: 5,
                                      child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 20, 0),
                                          child: new Text(
                                            listaFinal[index].titulo,
                                            style: TextStyle(
                                              fontWeight: mensagemLida
                                                  ? FontWeight.normal
                                                  : FontWeight.bold,
                                              color: mensagemLida
                                                  ? Colors.grey
                                                  : null,
                                              fontSize: 15,
                                            ),
                                          )),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        listaFinal[index].dataCriacao ==
                                                DateFormat('dd/MM/yy')
                                                    .format(DateTime.now())
                                                    .toString()
                                            ? listaFinal[index].dataCriacao
                                            : listaFinal[index].horaCriacao,
                                        style: TextStyle(
                                          fontWeight: mensagemLida
                                              ? FontWeight.normal
                                              : FontWeight.bold,
                                          color:
                                              mensagemLida ? Colors.grey : null,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    listaFinal[index].requerCiencia
                                        ? Icon(
                                            Icons.drive_file_rename_outline,
                                            color: listaFinal[index]
                                                    .mensagemAssinada
                                                ? Colors.grey
                                                : Colors.green,
                                          )
                                        : Icon(null),
                                    SizedBox(
                                      width: 10,
                                    ),
                                  ],
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
                },
              ),
      ), //
    );
  }

////////////////////////////////////////////////////////////////////////////////
  ///[MOBILE]
  void acaoClick(
      index, List<MensagemRetornoModel.TtRetorno2> listOutrasMensagens) {
    //
    abrirMensa(index, listOutrasMensagens);
    //
    setState(() {
      refreshAction();
    });
  }

  abrirMensa(
      index, List<MensagemRetornoModel.TtRetorno2> listOutrasMensagens) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (document) => VisualizaMensaWidget(
          index: index,
        ),
      ),
    );
  }

  //METODOS COMPARTILHADOS
  Future<int> _openEndDrawer(i) async {
    indexPage = i;
    _scaffoldKeyListarMensaWidget.currentState.openEndDrawer();
  }

  void closeEndDrawer() {
    setState(() {
      count = count - 1;
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

  Future<void> refreshAction() async => setState(() {
        SharedPreferences.getInstance().then((prefs) {
          ListaMensaBloc()
              .getMessageBack(context: context, barraStatus: true, operacao: 1)
              .then((map) {
            if (map != null) {
              setState(() {
                listaFinal = map.response.ttRetorno.ttRetorno2;
              });
            }
          });
        });
      });
}
