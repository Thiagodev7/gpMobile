import 'package:flutter/material.dart';
import 'package:gpmobile/src/pages/mensagens/bloc/ListaMensaBloc.dart';
import 'package:gpmobile/src/util/Estilo.dart';
import 'package:intl/intl.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/SugestoesModel.dart';
import '../model/SugetoesViewModel.dart';

///[ref]https://github.com/KumarArab/News-App-UI/blob/master/lib/details.dart

class SugestoesViewWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> _viewKey1 = new GlobalKey<ScaffoldState>();
  HeroTypeSugetao objMensa;
  final SugestoesModel objMensa2;

  SugestoesViewWidget(this.objMensa, this.objMensa2);

  // SugestoesViewWidget({@required this.heroType}) : super();
  @override
  _VisualizaMensaWidgetState createState() => _VisualizaMensaWidgetState();
}

final _scaffoldKeyVisualizaMensaWidget = GlobalKey<ScaffoldState>();

class _VisualizaMensaWidgetState extends State<SugestoesViewWidget> {
  // List<StatusModel> listaFinal = [];
  @override
  void initState() {
    //atuliza status
    // new EnviarMensaBloc().postEnviarMensagem(
    //     context,
    //     widget.objMensa.titulo,
    //     widget.objMensa.mensagem,
    //     widget.objMensa.data,
    //     2,
    //     widget.objMensa2.sequencia,
    //     widget.objMensa2,
    //     true);
    super.initState();
    //listar mensagens
    // SharedPreferences.getInstance().then((prefs) {
    //   ListaMensaBloc().getMessageBack(context, true).then((map2) {
    //     List<StatusModel> listaMapeada = map2;
    //     setState(() {
    //       if (map2 != null) {
    //         listaFinal = listaMapeada;
    //         for (StatusModel mensagem in listaFinal) {
    //           for (String matricula in mensagem.matriculasView.split(",")) {
    //             if (matricula == prefs.getString('matricula')) {
    //               mensagem.lido = true;
    //             }
    //           }
    //         }
    //       }
    //     });
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Estilo().backgroundTelaViewSugestoes,
      key: _scaffoldKeyVisualizaMensaWidget,
      body: Container(
        color: Colors.transparent,
        child: ScreenTypeLayout(
          breakpoints: ScreenBreakpoints(desktop: 899, tablet: 730, watch: 279),
          mobile: OrientationLayoutBuilder(
            portrait: (context) =>
                VizualizaMensaWidgetMobile(context: context, widget: widget),
            landscape: (context) =>
                VizualizaMensaWidgetMobile(context: context, widget: widget),
          ),
          tablet: VizualizaMensaWidgetWeb(context: context, widget: widget),
          desktop: VizualizaMensaWidgetWeb(context: context, widget: widget),
        ),
      ),
    );
  }
}

class VizualizaMensaWidgetMobile extends StatelessWidget {
  const VizualizaMensaWidgetMobile({
    Key key,
    @required this.widget,
    @required this.context,
  }) : super(key: key);

  final SugestoesViewWidget widget;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    NumberFormat f = new NumberFormat("00");
    //convert string in date
    DateTime dataConvertida = DateTime.parse(widget.objMensa.dataCriacao);
    //montar data formato brasileiro
    dynamic dataDaMensagem = f.format(dataConvertida.day).toString() +
        "/" +
        f.format(dataConvertida.month).toString() +
        "/" +
        dataConvertida.year.toString();
    return Container(
      decoration: AppGradients.gradient,
      child: Scaffold(
        backgroundColor: Colors.transparent,

        ///*[APPBAR]
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                // iconTheme: IconThemeData.fallback(),
                // backgroundColor: Colors.transparent.withOpacity(0.2),
                backgroundColor: Colors.transparent,
                expandedHeight: 150.0,
                floating: true,
                // pinned: true,

                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    '',
                    // '${widget.objMensa.sugestao}',
                    // " ${widget.objMensa.dataCriacao} ${widget.objMensa.horaCriacao}",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  background: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                        child: Center(
                            child: Icon(
                          Icons.thumbs_up_down_rounded,
                          size: 50,
                          color: Colors.white,
                        )),
                      ),
                    ],
                  ),
                ),
              )
            ];
          },

          ///*[BODY]
          body: Container(
            color: Estilo().backgroundTelaListSugestoes,
            width: MediaQuery.of(context).size.width,
            height: 300,
            padding: EdgeInsets.all(20),
            child: ListView(
              children: [
                Text(
                  "${widget.objMensa.sugestao}",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    color: AppColors.txtSemFundo,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "${dataDaMensagem.toString()} ${widget.objMensa.horaCriacao}",
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.txtSemFundo,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class VizualizaMensaWidgetWeb extends StatelessWidget {
  VizualizaMensaWidgetWeb({
    Key key,
    @required this.widget,
    this.context,
  }) : super(key: key);

  final SugestoesViewWidget widget;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    NumberFormat f = new NumberFormat("00");
    //convert string in date
    DateTime dataConvertida = DateTime.parse(widget.objMensa.dataCriacao);
    //montar data formato brasileiro
    dynamic dataDaMensagem = f.format(dataConvertida.day).toString() +
        "/" +
        f.format(dataConvertida.month).toString() +
        "/" +
        dataConvertida.year.toString();
    return Scaffold(
      backgroundColor: Estilo().backgroundTelaViewSugestoes,

      ///*[APPBAR]
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                // iconTheme: IconThemeData.fallback(),
                backgroundColor: Colors.transparent,
                expandedHeight: 200.0,
                floating: true,
                // pinned: true,

                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    '',
                    // '${widget.objMensa.sugestao}',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  background: Stack(
                    children: [
                      Center(
                          child: Icon(
                        Icons.thumbs_up_down_rounded,
                        size: 40,
                        color: Colors.white,
                      )),
                      // Container(
                      //   width: MediaQuery.of(context).size.width,
                      //   height: double.infinity,
                      //   child: Image.asset(
                      //     imageLogoMessage,
                      //     scale: 4.0,
                      //     centerSlice: new Rect.fromLTRB(1.0, 1.0, 150.0, 70.0),
                      //     fit: BoxFit.fill,
                      //   ),
                      // ),
                      Container(
                        // decoration: BoxDecoration(
                        //   gradient: Colors.transparent,
                        // ),
                        color: Colors.transparent,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(top: 30, bottom: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Text(
                            //   "World",
                            //   style: TextStyle(
                            //       color: Colors.white,
                            //       fontSize: 25,
                            //       fontFamily: "Sigmar"),
                            // ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  // Container(
                                  //   height: 45,
                                  //   decoration:
                                  //       BoxDecoration(shape: BoxShape.circle),
                                  //   child: ClipRRect(
                                  //     borderRadius: BorderRadius.circular(100),
                                  //     child: Image.asset(
                                  //       imageLogoLogin,
                                  //       fit: BoxFit.cover,
                                  //     ),
                                  //   ),
                                  // ),
                                  // Text(
                                  //   "12:00 hours ago",
                                  //   style: TextStyle(
                                  //     color: Colors.white,
                                  //   ),
                                  // )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ];
          },

          ///*[BODY]
          body: Container(
            color: Estilo().backgroundTelaListSugestoes,
            width: MediaQuery.of(context).size.width,
            height: 300,
            padding: EdgeInsets.all(20),
            child: ListView(
              children: [
                Text(
                  "${widget.objMensa.sugestao}",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    color: AppColors.txtSemFundo,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "${dataDaMensagem.toString()} ${widget.objMensa.horaCriacao}",
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.txtSemFundo,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
