import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/conditional_switch.dart';
import 'package:gpmobile/src/pages/mensagens/listar_mensagens/ListaMensaBloc.dart';
import 'package:gpmobile/src/pages/mensagens/listar_mensagens/ListaMensaNovas.dart';
import 'package:gpmobile/src/pages/mensagens/listar_mensagens/ListaMensaWidgetWeb.dart';
import 'package:gpmobile/src/pages/mensagens/model/MensagemEnvioModel.dart' as MensagemEnvioModel;
import 'package:gpmobile/src/pages/mensagens/model/MensagemRetornoModel.dart' as MensagemRetornoModel;
import 'package:gpmobile/src/util/AlertDialogTemplate.dart';
import 'package:gpmobile/src/util/Estilo.dart';
import 'package:gpmobile/src/util/GetIp.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:universal_platform/universal_platform.dart';

///[ref]https://github.com/KumarArab/News-App-UI/blob/master/lib/details.dart
import 'PageHeroWidget.dart';

class VisualizaMensaWidget extends StatefulWidget {
  VisualizaMensaWidget(this.objMensa, this.objMensa2, this.listaOutrasMensagens);
  HeroType objMensa;
  final MensagemRetornoModel.TtMensagens objMensa2;
  GlobalKey<ScaffoldState> _scaffoldKeyVisualizaMensaWidget;
  GlobalKey<ScaffoldState> _scaffoldKeyVisualizaMensaWidgetWeb;
  List<MensagemRetornoModel.TtMensagens> listaOutrasMensagens;
  //
  MensagemRetornoModel.MensagemRetornoModel objGlobal;
  int indexPage;
  int count = 0;
  String origemClick = "";
  bool _checkbox = false;
  Random random = Random();
//
  String txtDataPublicacao = 'Publicação: ';
  String txtLiConcordo = 'Li e concordo com os termos e condições.';
  String txtTermoAssinado = 'Termo assinado!';
  String txtBtnSalvar = 'ACEITAR';
  String txtPopUpTitle = 'Atenção';
  String txtPopUpSubTitle = 'Informe a senha do aplicativo.';
  String txtPopUpTextField = 'Sua senha aqui...';
  String txtVejaOutraMensa = 'Veja outras mensagens:';
  //
  @override
  _VisualizaMensaWidgetState createState() => _VisualizaMensaWidgetState();
}

MensagemRetornoModel.TtMensagens objVisualizaEndDrawer;

class _VisualizaMensaWidgetState extends State<VisualizaMensaWidget> {
  @override
  void initState() {
    widget._scaffoldKeyVisualizaMensaWidget = GlobalKey<ScaffoldState>();
    widget._scaffoldKeyVisualizaMensaWidgetWeb = GlobalKey<ScaffoldState>();
    super.initState();

    GetIp().getIp().then((ip) async {
      if(ip == null){
        ip = "";
      }

      //listar mensagens
      MensagemEnvioModel.TtMensagens2 ttMensagens = new MensagemEnvioModel.TtMensagens2();
      ttMensagens.codMensagem = widget.objMensa2.codMensagem;
      ttMensagens.operacao = 2;

      MensagemEnvioModel.TtMensVisu2 ttMensVisu2 = new MensagemEnvioModel.TtMensVisu2();
      ttMensVisu2.plataforma = UniversalPlatform.isWeb == true ? "web" : UniversalPlatform.isWindows == true ? "win" : "mob";
      ttMensVisu2.cienciaConfirmada = true;
      ttMensVisu2.codMensagem = widget.objMensa2.codMensagem;
      ttMensVisu2.ipDispositivo = ip;

      if(widget.objMensa2.requerCiencia == false && widget.objMensa2.ttMensVisu == null){
        ListaMensaBloc().gravaStatusDeMensagemComoLida(context, true, ttMensagens, ttMensVisu2 ).then((map2) {
          if(map2 != null){
            MensagemRetornoModel.MensagemRetornoModel listaMapeada = map2;
          }

        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        color: Color(0xff501d2c),
        // decoration: AppGradients.gradient,
        child: ScreenTypeLayout(
          breakpoints: ScreenBreakpoints(desktop: 899, tablet: 730, watch: 279),
          mobile: OrientationLayoutBuilder(
            portrait: (context) => VizualizaMensaWidgetMobile(
                context: context, widget: widget, list: widget.listaOutrasMensagens),
            landscape: (context) => VizualizaMensaWidgetMobile(
                context: context, widget: widget, list: widget.listaOutrasMensagens),
          ),
          tablet: VizualizaMensaWidgetWeb(
            context: context,
            widget: widget,
            list: widget.listaOutrasMensagens,
            // orig: widget.origemClick,
          ),
          desktop: VizualizaMensaWidgetWeb(
            context: context,
            widget: widget,
            list: widget.listaOutrasMensagens,
            // orig: widget.origemClick,
          ),
        ),
      ),
      endDrawer: ConditionalSwitch.single<String>(
        context: context,
        valueBuilder: (BuildContext context) => widget.origemClick,
        caseBuilders: {
          'vejaOutrasMensa': (BuildContext context) => new VisualizaMensaWidget(
              HeroType(
                  data: objVisualizaEndDrawer.dataCriacao,
                  titulo: objVisualizaEndDrawer.titulo,
                  mensagem: objVisualizaEndDrawer.mensagem),
              objVisualizaEndDrawer,
              widget.listaOutrasMensagens),
        },
        fallbackBuilder: (BuildContext context) {
          return Card(
            color: Colors.white,
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    // setState(() {
                    widget.count = widget.count - 1;
                    Navigator.of(context).pop();
                    // });
                  },
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
}

class VizualizaMensaWidgetMobile extends StatefulWidget {
  const VizualizaMensaWidgetMobile({
    Key key,
    @required this.widget,
    @required this.context,
     this.list,
  }) : super(key: key);

  final VisualizaMensaWidget widget;
  final BuildContext context;
  final List list;

  @override
  _VizualizaMensaWidgetMobileState createState() =>
      _VizualizaMensaWidgetMobileState();
}

class _VizualizaMensaWidgetMobileState extends State<VizualizaMensaWidgetMobile> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.widget._scaffoldKeyVisualizaMensaWidget,
      backgroundColor: Colors.transparent,

      ///*[APPBAR]
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              // iconTheme: IconThemeData.fallback(),
              backgroundColor: Colors.transparent.withOpacity(0.2),
              expandedHeight: 120.0,
              floating: true,
              // pinned: true,

              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  '${widget.widget.objMensa.titulo}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                background: Stack(
                  children: [
                    Container(
                      // decoration: BoxDecoration(
                      //   gradient: Colors.transparent,
                      // ),
                      color: Color(0xff501d2c),
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(top: 30, bottom: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
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
          color: Color(0xff501d2c),
          // decoration: AppGradients.gradient,
          width: MediaQuery.of(context).size.width,
          height: 300,
          padding: EdgeInsets.all(20),
          child: ListView(
            children: [
              ///*[corpo da mensagem]
              Text(
                "${widget.widget.objMensa.mensagem}",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: AppColors.txtSemFundo,
                ),
              ),
              SizedBox(
                height: 20,
              ),

              ///*[data/hora]
              Row(
                children: [
                  Text(
                    widget.widget.txtDataPublicacao,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    "${widget.widget.objMensa.data}",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),

              ///*[ btn aceitar]
              widget.widget.objMensa2 == null || widget.widget.objMensa2.requerCiencia == false
                  ? SizedBox(height: 0.5)
                  : Container(
                      child: widget.widget.objMensa2.ttMensVisu != null && widget.widget.objMensa2.ttMensVisu.first.cienciaConfirmada == true
                          ? Container(
                              width: 300,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.widget.txtTermoAssinado ,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black54,
                                      // color: AppColors.txtSemFundo,
                                    ),
                                  ),
                                  Text(
                                    widget.widget.objMensa2.ttMensVisu.first.dataVisu + " - " + widget.widget.objMensa2.ttMensVisu.first.horaVisu,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.black54,
                                      // color: AppColors.txtSemFundo,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              width: 300,
                              height: 130,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      new Checkbox(
                                          activeColor: Colors.green,
                                          value: widget.widget._checkbox,
                                          onChanged: _value1Changed),
                                      new Text(
                                        widget.widget.txtLiConcordo,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black54,
                                          // color: AppColors.txtSemFundo,
                                        ),
                                      ),
                                    ],
                                  ),
                                  //SizedBox(height: 5),
                                  Container(
                                    width: 130,
                                    height: 40,
                                    child: MaterialButton(
                                      onPressed: () => materialButton('onPressed'),
                                      highlightColor: Colors.lightBlueAccent,
                                      highlightElevation: 8,
                                      elevation: materialButton('elevation'),
                                      shape: StadiumBorder(),
                                      child: Text(widget.widget.txtBtnSalvar,
                                          style: TextStyle(
                                              color: Estilo().branca,
                                              fontSize: 15)),
                                      color: materialButton('color'),
                                      enableFeedback: true,
                                    ),
                                  )
                                ],
                              ),
                            ),
                    ),
              SizedBox(
                height: 20,
              ),

              ///*[lista horizontal]
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.widget.txtVejaOutraMensa,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: AppColors.txtSemFundo,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.24,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.list.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (ctx, i) {
                    MensagemRetornoModel.TtMensagens objMensaDetails = widget.list[i];
                    return GestureDetector(
                      onTap: () {

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => VisualizaMensaWidget(
                                HeroType(
                                    data: objMensaDetails.dataCriacao,
                                    titulo: objMensaDetails.titulo,
                                    mensagem: objMensaDetails.mensagem),
                                objMensaDetails,
                                widget.list),
                          ),
                        );
                        //
                      },
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: objMensaDetails.ttMensVisu == null
                                ? Icon(
                                    Icons.messenger,
                                    color: Colors.greenAccent[400],
                                  )
                                : Icon(Icons.messenger),
                          ),
                          Container(
                            margin: EdgeInsets.all(5),
                            width: MediaQuery.of(context).size.width * 0.26,
                            height: MediaQuery.of(context).size.height * 0.15,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.55),
                              // image: DecorationImage(
                              //   image: AssetImage(imageLogoMessage),
                              //   fit: BoxFit.fill,
                              // ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Container(
                              height: double.infinity,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.9)
                                  ],
                                  begin: Alignment.topCenter,
                                  stops: [0.5, 1],
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Spacer(),
                                  Text(
                                    objMensaDetails.titulo,
                                    maxLines: 2,
                                    overflow: TextOverflow.fade,
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "${objMensaDetails.dataCriacao}",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///*[METODOS MOB]
  void _value1Changed(bool value) =>
      setState(() => widget.widget._checkbox = value);
  //
  onTapEnviarCiencia() async {
    await AlertDialogTemplate().showAlertDialogAceiteTermoMensa(
        widget.context,
        widget.widget.txtPopUpTitle,
        widget.widget.txtPopUpSubTitle,
        widget.widget.txtPopUpTextField).then((value) {

          if(value == ConfirmAction.OK){

            GetIp().getIp().then((ip) async {
              if(ip == null){
                ip = "";
              }

              //Geovane envia log de assinatura
              MensagemEnvioModel.TtMensagens2 ttMensagens = new MensagemEnvioModel.TtMensagens2();
              ttMensagens.codMensagem = widget.widget.objMensa2.codMensagem;
              ttMensagens.operacao = 2;

              MensagemEnvioModel.TtMensVisu2 ttMensVisu2 = new MensagemEnvioModel.TtMensVisu2();
              ttMensVisu2.plataforma = UniversalPlatform.isWeb == true ? "web" : UniversalPlatform.isWindows == true ? "win" : "mob";
              ttMensVisu2.cienciaConfirmada = true;
              ttMensVisu2.codMensagem = widget.widget.objMensa2.codMensagem;
              ttMensVisu2.ipDispositivo = ip;

              if(widget.widget.objMensa2.requerCiencia == true && widget.widget.objMensa2.ttMensVisu == null){
                ListaMensaBloc().gravaStatusDeMensagemComoLida(context, true, ttMensagens, ttMensVisu2 ).then((map2) {
                  if(map2 != null){
                    MensagemRetornoModel.MensagemRetornoModel listaMapeada = map2;
                  }

                  Navigator.pop(context);

                });
              }
            });
          }

        });

  }

  //
  materialButton(String tipo) {
    switch (tipo) {
      case 'onPressed':
        return widget.widget._checkbox == false ? {} : onTapEnviarCiencia();
        break;
      case 'elevation':
        return widget.widget._checkbox == false ? 0.0 : 18.0;
        break;
      case 'color':
        return widget.widget._checkbox == false ? Colors.grey : Colors.orange;
        break;
      default:
    }
  }
}

class VizualizaMensaWidgetWeb extends StatefulWidget {
  VizualizaMensaWidgetWeb({
    Key key,
    @required this.widget,
    this.context,
    this.list,
    // this.onPressed,
    // this.orig,
  }) : super(key: key);

  final VisualizaMensaWidget widget;
  // final VoidCallback onPressed;
  final BuildContext context;
  // final String orig;
  final List list;

  @override
  _VizualizaMensaWidgetWebState createState() => _VizualizaMensaWidgetWebState();
}

class _VizualizaMensaWidgetWebState extends State<VizualizaMensaWidgetWeb> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.widget._scaffoldKeyVisualizaMensaWidgetWeb,
      backgroundColor: Colors.transparent,

      ///*[APPBAR]
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                // iconTheme: IconThemeData.fallback(),
                backgroundColor: Colors.transparent.withOpacity(0.2),
                expandedHeight: 120.0,
                floating: true,
                // pinned: true,

                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    '${widget.widget.objMensa.titulo}',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  background: Stack(
                    children: [
                      Container(
                        // decoration: BoxDecoration(
                        //   gradient: Colors.transparent,
                        // ),
                        color: Color(0xff501d2c),
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(top: 30, bottom: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
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
            color: Color(0xff501d2c),
            // decoration: AppGradients.gradient,
            width: MediaQuery.of(context).size.width,
            height: 300,
            padding: EdgeInsets.all(20),
            child: ListView(
              children: [
                ///*[corpo da mensagem]
                Text(
                  "${widget.widget.objMensa.mensagem}",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: AppColors.txtSemFundo,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),

                ///*[data/hora]
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.widget.txtDataPublicacao,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      " ${widget.widget.objMensa.data}",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                    SizedBox(
                      height: 20,
                    ),

                    ///*[ btn aceitar]
                    widget.widget.objMensa2 == null || widget.widget.objMensa2.requerCiencia == false
                        ? SizedBox(height: 0.5)
                        : Container(
                      child: widget.widget.objMensa2.ttMensVisu != null && widget.widget.objMensa2.ttMensVisu.first.cienciaConfirmada == true
                          ? Container(
                        width: 300,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.widget.txtTermoAssinado ,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black54,
                                // color: AppColors.txtSemFundo,
                              ),
                            ),
                            Text(
                              widget.widget.objMensa2.ttMensVisu.first.dataVisu + " - " + widget.widget.objMensa2.ttMensVisu.first.horaVisu,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.black54,
                                // color: AppColors.txtSemFundo,
                              ),
                            ),
                          ],
                        ),
                      )
                          : Container(
                        width: 300,
                        height: 130,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                new Checkbox(
                                    activeColor: Colors.green,
                                    value: widget.widget._checkbox,
                                    onChanged: _value1ChangedWeb),
                                new Text(
                                  widget.widget.txtLiConcordo,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black54,
                                    // color: AppColors.txtSemFundo,
                                  ),
                                ),
                              ],
                            ),
                            //SizedBox(height: 5),
                            Container(
                              width: 130,
                              height: 40,
                              child: MaterialButton(
                                onPressed: () => materialButtonWeb('onPressed'),
                                highlightColor: Colors.lightBlueAccent,
                                highlightElevation: 8,
                                elevation: materialButtonWeb('elevation'),
                                shape: StadiumBorder(),
                                child: Text(widget.widget.txtBtnSalvar,
                                    style: TextStyle(
                                        color: Estilo().branca,
                                        fontSize: 15)),
                                color: materialButtonWeb('color'),
                                enableFeedback: true,
                              ),
                            )
                          ],
                        ),
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

  ///*[METODOS WEB]
  void _value1ChangedWeb(bool value) {
    setState(() => widget.widget._checkbox = value);
  }

  onTapEnviarCienciaWeb() {
     AlertDialogTemplate().showAlertDialogAceiteTermoMensa(
        widget.context,
        widget.widget.txtPopUpTitle,
        widget.widget.txtPopUpSubTitle,
        widget.widget.txtPopUpTextField).then((map) {

      if(map == ConfirmAction.OK){

        new GetIp().getIp().then((ip) {
          if(ip == null){
            ip = "";
          }

          //Geovane envia log de assinatura
          MensagemEnvioModel.TtMensagens2 ttMensagens = new MensagemEnvioModel.TtMensagens2();
          ttMensagens.codMensagem = widget.widget.objMensa2.codMensagem;
          ttMensagens.operacao = 2;

          MensagemEnvioModel.TtMensVisu2 ttMensVisu2 = new MensagemEnvioModel.TtMensVisu2();
          ttMensVisu2.plataforma = UniversalPlatform.isWeb == true ? "web" : UniversalPlatform.isWindows == true ? "win" : "mob";
          ttMensVisu2.cienciaConfirmada = true;
          ttMensVisu2.codMensagem = widget.widget.objMensa2.codMensagem;
          ttMensVisu2.ipDispositivo = ip;

          if(widget.widget.objMensa2.requerCiencia == true && widget.widget.objMensa2.ttMensVisu == null){
            ListaMensaBloc().gravaStatusDeMensagemComoLida(widget.context, true, ttMensagens, ttMensVisu2 ).then((map2) {
              if(map2 != null){
                MensagemRetornoModel.MensagemRetornoModel listaMapeada = map2;
              }

              Navigator.pop(widget.context);

            });
          }
        });
      }

    });
  }

  Future<int> _openEndDrawer(i) async {
    widget.widget.indexPage = i;
    widget.widget._scaffoldKeyVisualizaMensaWidgetWeb.currentState.openEndDrawer();
    return widget.widget.indexPage;
  }

  closeEndDrawer() {
    // setState(() {
    widget.widget.count = widget.widget.count - 1;
    Navigator.of(widget.context).pop();
    // });
  }

  materialButtonWeb(String tipo) {
    switch (tipo) {
      case 'onPressed':
        return widget.widget._checkbox == false ? {} : onTapEnviarCienciaWeb();
        break;
      case 'elevation':
        return widget.widget._checkbox == false ? 0.0 : 18.0;
        break;
      case 'color':
        return widget.widget._checkbox == false ? Colors.grey : Colors.orange;
        break;
      default:
    }
  }
}
