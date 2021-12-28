import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/conditional_switch.dart';
import 'package:gpmobile/src/pages/mensagens/bloc/ListaMensaBloc.dart';
import 'package:gpmobile/src/pages/mensagens/model/MensagemRetornoModel.dart'
    as MensagemRetornoModel;
import 'package:gpmobile/src/util/AlertDialogTemplate.dart';
import 'package:gpmobile/src/util/Estilo.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VisualizaMensaWidget extends StatefulWidget {
  int index;
  String origemClick = "";

  VisualizaMensaWidget({this.index, Key key}) : super(key: key);

  @override
  _VisualizaMensaWidgetState createState() => _VisualizaMensaWidgetState();
}

class _VisualizaMensaWidgetState extends State<VisualizaMensaWidget> {
  bool _checkbox = false;
  bool releaseButton = false;
  String descricao = "";
  String title = "";
  bool requerCiencia = false;
  bool checkbox = false;
  bool docAssinado = false;
  bool docLido = false;
  String data = '';
  String hora = '';
  final snackBar = SnackBar(
    content: const Text('Confirmado! Voce Assinou o Documento!'),
  );

  List<MensagemRetornoModel.TtRetorno2> listaOutrasMensagens;

  @override
  void initState() {
    super.initState();
  }

  void _value1Changed(bool value) => setState(() => checkbox = value);

  Future<String> getFuturemsgs() async {
    await ListaMensaBloc()
        .getMessageBack(
            context: context,
            operacao: 2,
            cienciaConfirmada: false,
            codDocumento: widget.index)
        .then((map2) => {
              descricao = map2.response.ttRetorno.ttRetorno2[0].descricao,
              title = map2.response.ttRetorno.ttRetorno2[0].titulo,
              requerCiencia =
                  map2.response.ttRetorno.ttRetorno2[0].requerCiencia,
              docAssinado =
                  map2.response.ttRetorno.ttRetorno2[0].mensagemAssinada,
              data = map2.response.ttRetorno.ttRetorno2[0].dataCriacao,
              hora = map2.response.ttRetorno.ttRetorno2[0].horaCriacao,
              docLido = map2.response.ttRetorno.ttRetorno2[0].mensagemLida,
            })
        .whenComplete(() => ListaMensaBloc()
                .getMessageBack(
                    cienciaConfirmada: false, context: context, operacao: 1)
                .then((map1) {
              setState(() {
                listaOutrasMensagens = map1.response.ttRetorno.ttRetorno2
                    .where((element) => element.requerCiencia == false
                        ? element.mensagemLida == false
                        : element.mensagemAssinada == false)
                    .toList();
              });
            }));
    return descricao;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
          color: Color(0xff501d2c),
          child: FutureBuilder(
              future: getFuturemsgs(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ScreenTypeLayout(
                    breakpoints: ScreenBreakpoints(
                        desktop: 899, tablet: 730, watch: 279),
                    mobile: OrientationLayoutBuilder(
                      portrait: (context) => _msgWidgetMobile(),
                      landscape: (context) => _msgWidgetMobile(),
                    ),
                    tablet: _buildWeb(context),
                    desktop: _buildWeb(context),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              })),
      endDrawer: ConditionalSwitch.single<String>(
        context: context,
        valueBuilder: (BuildContext context) => widget.origemClick,
        caseBuilders: {
          'vejaOutrasMensa': (BuildContext context) => _msgWidgetMobile()
        },
        fallbackBuilder: (BuildContext context) {
          return Card(
            color: Colors.white,
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    // setState(() {
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
      endDrawerEnableOpenDragGesture: false,
    );
  }

  _msgWidgetMobile() {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Colors.transparent.withOpacity(0.2),
              expandedHeight: 120.0,
              floating: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  title,
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
                              children: [],
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
          width: MediaQuery.of(context).size.width,
          height: 300,
          padding: EdgeInsets.all(20),
          child: ListView(
            children: [
              ///*[corpo da mensagem]
              Text(
                descricao,
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
                    data,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    data,
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
              requerCiencia == false
                  ? SizedBox(height: 0.5)
                  : Container(
                      child: docLido != false && docAssinado == true
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
                                    'Termo assinado!',
                                    style: TextStyle(
                                      fontSize: 15,
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
                                          value: checkbox,
                                          onChanged: _value1Changed),
                                      new Text(
                                        'Li e concordo com os termos e condições.',
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
                                      onPressed: () async {
                                        checkbox == false
                                            ? {}
                                            : await AlertDialogTemplate()
                                                .ShowDialogSenhaDoc(
                                                    context,
                                                    'Assinar Documento',
                                                    'Preencha com sua Senha',
                                                    'Senha')
                                                .then((value) {
                                                if (value == ConfirmAction.OK) {
                                                  ListaMensaBloc()
                                                      .getMessageBack(
                                                          context: context,
                                                          codDocumento:
                                                              widget.index,
                                                          cienciaConfirmada:
                                                              true,
                                                          operacao: 3);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(snackBar);
                                                  Navigator.of(context).pop();
                                                }
                                              });
                                      },
                                      highlightColor: Colors.lightBlueAccent,
                                      highlightElevation: 8,
                                      elevation: checkbox == false ? 0.0 : 18.0,
                                      shape: StadiumBorder(),
                                      child: Text('ACEITAR',
                                          style: TextStyle(
                                              color: Estilo().branca,
                                              fontSize: 15)),
                                      color: checkbox == false
                                          ? Colors.grey
                                          : Colors.orange,
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
                  'Veja outras mensagens:',
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
                  itemCount: listaOutrasMensagens.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (ctx, i) {
                    MensagemRetornoModel.TtRetorno2 objMensaDetails =
                        listaOutrasMensagens[i];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => VisualizaMensaWidget(
                                index: objMensaDetails.codMensagem),
                          ),
                        );
                        //
                      },
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: listaOutrasMensagens[i].mensagemLida == false
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
                                    listaOutrasMensagens[i].titulo,
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
                                    "${listaOutrasMensagens[i].dataCriacao}",
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

  _buildWeb(context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      ///*[APPBAR]
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                backgroundColor: Colors.transparent.withOpacity(0.2),
                expandedHeight: 120.0,
                floating: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    title,
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
                                children: [],
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
                  descricao,
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
                      'Publicação: ',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      data,
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
                requerCiencia == false
                    ? SizedBox(height: 0.5)
                    : Container(
                        child: docLido != false && docAssinado == true
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
                                      'Termo assinado!',
                                      style: TextStyle(
                                        fontSize: 15,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        new Checkbox(
                                            activeColor: Colors.green,
                                            value: checkbox,
                                            onChanged: _value1Changed),
                                        new Text(
                                          'Li e concordo com os termos e condições.',
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
                                        onPressed: () async {
                                          checkbox == false
                                              ? {}
                                              : await AlertDialogTemplate()
                                                  .ShowDialogSenhaDoc(
                                                      context,
                                                      'Assinar Documento',
                                                      'Preencha com sua Senha',
                                                      'Senha')
                                                  .then((value) {
                                                  if (value ==
                                                      ConfirmAction.OK) {
                                                    ListaMensaBloc()
                                                        .getMessageBack(
                                                            context: context,
                                                            codDocumento:
                                                                widget.index,
                                                            cienciaConfirmada:
                                                                true,
                                                            operacao: 3);
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(snackBar);
                                                    Navigator.of(context).pop();
                                                  }
                                                });
                                        },
                                        highlightColor: Colors.lightBlueAccent,
                                        highlightElevation: 8,
                                        elevation:
                                            checkbox == false ? 0.0 : 18.0,
                                        shape: StadiumBorder(),
                                        child: Text('ACEITAR',
                                            style: TextStyle(
                                                color: Estilo().branca,
                                                fontSize: 15)),
                                        color: checkbox == false
                                            ? Colors.grey
                                            : Colors.orange,
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
}
