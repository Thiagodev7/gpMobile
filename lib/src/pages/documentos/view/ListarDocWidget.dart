import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gpmobile/src/pages/documentos/model/ListarDocModel.dart';
import 'package:gpmobile/src/pages/documentos/view/DocsWidget.dart';

//https://github.com/iang12/flutter_url_launcher_example/blob/master/lib/main.dart
import 'package:gpmobile/src/util/AlertDialogTemplate.dart';
import 'package:gpmobile/src/util/BuscaUrl.dart';
import 'package:gpmobile/src/util/Estilo.dart';
import 'package:gpmobile/src/util/SharedPreferencesBloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../bloc/ListarDocBloc.dart';
//new 17/09
import "dart:convert" show utf8;

//
class ListarDocWidget extends StatefulWidget {
  @override
  _ListarDocWidgetState createState() => _ListarDocWidgetState();
}

class _ListarDocWidgetState extends State<ListarDocWidget> {
  //VARIAVEIS
  String appBarTitle = "Anexos";
  bool _userAdmin;
  bool _habilitaButton = false;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  ListarDocModel listDocs = new ListarDocModel();
  List<TtRetorno2> listArquivos = List();
  @override
  initState() {
    super.initState();

    setState(() {
      SharedPreferencesBloc().buscaParametroBool("userAdmin").then((retorno) {
        _userAdmin = retorno;

        if (_userAdmin == false) {
          _habilitaButton = false; //_userAdmin;
        } else {
          _habilitaButton = false; //_userAdmin;
        }
      });
    });

    LisartDocsBloc()
        .getListDocs(
            context: context,
            barraStatus: true,
            operacao: 1,
            cienciaConfirmada: false)
        .then((map) {
      setState(() {
        listDocs = map;
        listArquivos = listDocs.response.ttRetorno.ttRetorno2;
      });
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
      backgroundColor: Colors.transparent.withOpacity(0.3),
      key: _scaffoldKeyListarDocWidget,
      body: Container(
        color: Colors.transparent,
        child: ScreenTypeLayout(
          breakpoints: ScreenBreakpoints(desktop: 899, tablet: 730, watch: 279),
          mobile: OrientationLayoutBuilder(
            portrait: (context) => listDocWidgetMobile(context),
            landscape: (context) => listDocWidgetMobile(context),
          ),
          tablet: listDocWidgetWeb(context),
          desktop: listDocWidgetWeb(context),
        ),
      ),
      //endDrawer: EnviarDocWidget(),
      endDrawerEnableOpenDragGesture: false,
    );
  }

  Widget listDocWidgetMobile(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
        decoration: AppGradients.gradient,
        child: Scaffold(
          backgroundColor: Estilo().backgroundAnexo,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: BackButton(),
            elevation: 0,
            centerTitle: true,
            title: Text(
              appBarTitle,
              style: TextStyle(
                color: AppColors.txtSemFundo,
                fontWeight: FontWeight.w500,
              ),
              // textAlign: TextAlign.left,
            ),
            // actions: [
            //   //botao enviar doc
            //   _habilitaButton == false
            //       ? IconButton(
            //           icon: Icon(Icons.add_photo_alternate_rounded,
            //               size: 30, color: Colors.amber.withOpacity(0.0)),
            //           splashColor: Colors.blue,
            //           splashRadius: 20,
            //           onPressed: null)
            //       : IconButton(
            //           icon: Icon(
            //             Icons.add_photo_alternate_rounded,
            //             size: 30,
            //           ),
            //           splashColor: Colors.blue,
            //           splashRadius: 20,
            //           onPressed: () => openEndDrawer(),
            //         ),
            //botao atualiza a tela
            // IconButton(
            //     icon: Icon(
            //       Icons.autorenew,
            //       size: 30,
            //     ),
            //     onPressed: _refreshAction,
            //     ),
            //],
          ),
          body: Center(
            child: Container(
              width: width * 1,
              height: height * 0.9,
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      AlertDialogTemplate().showAlertDialogAno(
                        context,
                        'Selecione o Ano',
                      );
                    },
                    child: Container(
                        margin: new EdgeInsets.fromLTRB(10, 0, 10, 0),
                        width: width * 0.96, // 0.29 web
                        height: 55.0, //height * 0.07
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          color: AppColors.white,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                color: AppColors.grey,
                                width: 10.0,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    new Text("Cedula C",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                  Expanded(
                    child: SmartRefresher(
                      header: WaterDropHeader(waterDropColor: Colors.green),
                      controller: _refreshController,
                      onRefresh: _onRefresh,
                      child: listArquivos
                              .isEmpty //se retorno null(renderiza a mensagem)
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
                              itemCount: listArquivos
                                  .length, //passa o tamanho da lista
                              itemBuilder: (BuildContext ctxt, int index) {
                                //como será mostrado os dados na tela
                                final listDocs = listArquivos[
                                    index]; //variavel recebe cada indice do array(objeto)

                                //atualizado 12/02 as 09:20...
                                String _description1 = listDocs.titulo == null
                                    ? listDocs.titulo.toString()
                                    : listDocs.titulo;

                                var string = utf8.encode(_description1);
                                // print("utf8 ${string}");
                                String _pdfMob = listDocs.titulo == null
                                    ? listDocs.titulo.toString()
                                    : listDocs.titulo;

                                return InkWell(
                                  onTap: () async {
                                    await _viewFile(index);
                                  },
                                  child: Container(
                                      margin:
                                          new EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      width: width * 0.89, // 0.29 web
                                      height: 55.0, //height * 0.07
                                      child: Card(
                                        clipBehavior: Clip.antiAlias,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0)),
                                        color: AppColors.white,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              color: AppColors.primary,
                                              width: 10.0,
                                            ),
                                            SizedBox(
                                              width: 10.0,
                                            ),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  new Text(_description1,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1),
                                                ],
                                              ),
                                            ),
                                            listDocs.documentoLido
                                                ? Icon(
                                                    Icons.check_circle_sharp,
                                                    color: Colors.green,
                                                    size: 30,
                                                  )
                                                : Icon(null),
                                            SizedBox(
                                              width: 8,
                                            )
                                          ],
                                        ),
                                      )),
                                );
                                // return Container(
                                //     child: Column(
                                //   // mainAxisAlignment: MainAxisAlignment.center,
                                //   children: <Widget>[
                                //     ////////////new
                                //     Container(
                                //       width: width * 0.89, // 0.29 web
                                //       height: height * 0.07, // null
                                //       decoration: BoxDecoration(
                                //         // color: _selectedColorRight,
                                //         // gradient: AppGradients.linear2,
                                //         border: Border.fromBorderSide(
                                //           BorderSide(
                                //             color: AppColors.border,
                                //           ),
                                //         ),
                                //         borderRadius: BorderRadius.circular(5),
                                //         color: Estilo().fillColor,
                                //       ),
                                //       child: Row(
                                //         children: [
                                //           Expanded(flex: 6,
                                //             child: TextButton(
                                //               child: Padding(
                                //                 padding: const EdgeInsets.fromLTRB(0,0,120,0),
                                //                 child: Text(
                                //                   _description1,
                                //                   textAlign: TextAlign.start,
                                //                   textDirection: ,
                                //                   // str1,
                                //                   style: TextStyle(
                                //                     color: Estilo().textCorDark,
                                //                   ),
                                //                 ),
                                //               ),
                                //               onPressed: () async {
                                //                 if (await canLaunch(_url)) {
                                //                   await launch(_url);
                                //                 } else {
                                //                   AlertDialogTemplate()
                                //                       .showAlertDialogSimples(
                                //                       context, "Alerta", _url);
                                //                 }
                                //               },
                                //             ),
                                //           ),
                                //
                                //           new Icon(
                                //             // Icons.cloud_download_rounded,
                                //             Icons.file_download,
                                //             color: Estilo().textCorDark,
                                //           ),
                                //
                                //         ],
                                //       ),
                                //     ),
                                //     SizedBox(height: 10)
                                //   ],
                                // ));
                              },
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget listDocWidgetTablet(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Documentações",
          style: TextStyle(
            color: Colors.white,
            // fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
          // textAlign: TextAlign.left,
        ),
        actions: [
          //botao enviar doc
          _habilitaButton == false
              ? IconButton(
                  icon: Icon(Icons.add_photo_alternate_rounded,
                      size: 30, color: Colors.amber.withOpacity(0.0)),
                  splashColor: Colors.blue,
                  splashRadius: 20,
                  onPressed: null)
              : IconButton(
                  icon: Icon(
                    Icons.add_photo_alternate_rounded,
                    size: 30,
                  ),
                  splashColor: Colors.blue,
                  splashRadius: 20,
                  onPressed: () => openEndDrawer(),
                ),
          //botao atualiza a tela
          IconButton(
              icon: Icon(
                Icons.autorenew,
                size: 30,
              ),
              onPressed: _refreshAction),
        ],
      ),
      body: Card(
          // backgroundColor: Theme.of(context).backgroundColor,
          child: Center(
        child: Container(
          width: width * 1,
          height: height * 0.9,
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  AlertDialogTemplate().showAlertDialogAno(
                    context,
                    'Selecione o Ano',
                  );
                },
                child: Container(
                    margin: new EdgeInsets.fromLTRB(10, 0, 10, 0),
                    width: width * 0.96, // 0.29 web
                    height: 55.0, //height * 0.07
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      color: AppColors.white,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            color: AppColors.grey,
                            width: 10.0,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                new Text("Cedula C",
                                    style:
                                        Theme.of(context).textTheme.bodyText1),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
              Expanded(
                child:
                    listArquivos.isEmpty //se retorno null(renderiza a mensagem)
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
                            itemCount:
                                listArquivos.length, //passa o tamanho da lista
                            itemBuilder: (BuildContext ctxt, int index) {
                              //como será mostrado os dados na tela
                              final listDocs = listArquivos[
                                  index]; //variavel recebe cada indice do array(objeto)

                              //atualizado 12/02 as 09:20...
                              String _description1 = listDocs.titulo == null
                                  ? listDocs.titulo.toString()
                                  : listDocs.titulo.split(';')[0];

                              String _pdfTablet = listDocs.titulo == null
                                  ? listDocs.titulo.toString()
                                  : listDocs.titulo.split(';')[1];

                              return Container(
                                  child: Column(
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Card(
                                    elevation: 10,
                                    color: Theme.of(context).backgroundColor,
                                    child: ListTile(
                                      // leading: Icon(
                                      //   Icons.archive,
                                      //   color: Estilo().branca,
                                      // ),
                                      title: Text(
                                        _description1,
                                        // str1,
                                        style: TextStyle(
                                          color: Estilo().branca,
                                        ),
                                      ),
                                      trailing: new Icon(
                                        // Icons.cloud_download_rounded,
                                        Icons.file_download,
                                        color: Estilo().branca,
                                      ),
                                      onTap: () => _viewFile(index),
                                    ),
                                  ),
                                ],
                              ));
                            },
                          ),
              ),
            ],
          ),
        ),
      )),
    );
  }

  Widget listDocWidgetWeb(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.8;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        title: Text(
          appBarTitle,
          style: TextStyle(
            color: Colors.white,
            // fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
          // textAlign: TextAlign.left,
        ),
        actions: [
          //botao enviar doc
          _habilitaButton == false
              ? IconButton(
                  icon: Icon(Icons.add_photo_alternate_rounded,
                      size: 30, color: Colors.amber.withOpacity(0.0)),
                  splashColor: Colors.blue,
                  splashRadius: 20,
                  onPressed: null)
              : IconButton(
                  icon: Icon(
                    Icons.add_photo_alternate_rounded,
                    size: 30,
                  ),
                  splashColor: Colors.blue,
                  splashRadius: 20,
                  onPressed: () => openEndDrawer(),
                ),
        ],
      ),
      body: Center(
        child: Container(
          width: width * 1,
          height: height * 0.9,
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  AlertDialogTemplate().showAlertDialogAno(
                    context,
                    'Selecione o Ano',
                  );
                },
                child: Container(
                    margin: new EdgeInsets.fromLTRB(10, 0, 10, 0),
                    width: width * 0.96, // 0.29 web
                    height: 55.0, //height * 0.07
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      color: AppColors.white,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            color: AppColors.grey,
                            width: 10.0,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                new Text("Cedula C",
                                    style:
                                        Theme.of(context).textTheme.bodyText1),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
              Expanded(
                child: listArquivos
                        .isEmpty //se retorno null(renderiza a mensagem)
                    ? Center(
                        child: Text(
                          'Lista vazia no momento!',
                          style: TextStyle(
                            color: AppColors.txtSemFundo,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    : SmartRefresher(
                        header: WaterDropHeader(waterDropColor: Colors.green),
                        controller: _refreshController,
                        onRefresh: _onRefresh,
                        child: ListView.builder(
                          itemCount:
                              listArquivos.length, //passa o tamanho da lista
                          itemBuilder: (BuildContext ctxt, int index) {
                            //como será mostrado os dados na tela
                            final listDocs = listArquivos[
                                index]; //variavel recebe cada indice do array(objeto)

                            //atualizado 12/02 as 09:20...
                            String _description1 = listDocs.titulo == null
                                ? listDocs.titulo.toString()
                                : listDocs.titulo;

                            String _pdfWeb = listDocs.titulo == null
                                ? listDocs.titulo.toString()
                                : listDocs.titulo;

                            return Container(
                                margin: new EdgeInsets.fromLTRB(10, 0, 10, 0),
                                width: width * 0.29, // 0.29 web
                                height: 55.0, //height * 0.07
                                child: Card(
                                  clipBehavior: Clip.antiAlias,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0)),
                                  color: AppColors.white,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        color: AppColors.primary,
                                        width: 10.0,
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Expanded(
                                        child: FocusableActionDetector(
                                          mouseCursor: SystemMouseCursors.basic,
                                          autofocus: true,
                                          child: GestureDetector(
                                            onTap: () => _viewFile(index),
                                            child: AbsorbPointer(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  new Text(_description1,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ));
                          },
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onRefresh() {
    // monitor network fetch
    _refreshAction();
    print('atualizando Box');
    // if failed,use refreshFailed()
    Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  _refreshAction() {
    setState(() {
      LisartDocsBloc()
          .getListDocs(
              context: context,
              barraStatus: true,
              operacao: 1,
              cienciaConfirmada: false)
          .then((map) {
        setState(() {
          listDocs = map;
          listArquivos = listDocs.response.ttRetorno.ttRetorno2;
        });
      });
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKeyListarDocWidget =
      GlobalKey<ScaffoldState>();

  void openEndDrawer() {
    _scaffoldKeyListarDocWidget.currentState.openEndDrawer();
  }

  void _viewFile(inde) async {
    int index = inde + 1;
    var base;
    final listDocs = listArquivos[inde];
    await LisartDocsBloc()
        .getListDocs(
            context: context,
            barraStatus: true,
            cienciaConfirmada: true,
            codDocumento: index,
            operacao: 2)
        .then((value) =>
            {base = value.response.ttRetorno.ttRetorno2[0].arquivoBase64})
        .whenComplete(() {
      print(base);
      PdfDocument document = PdfDocument.fromBase64String(base);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (document) => DocsWidget(
                  file: base,
                  title: listDocs.titulo.toString(),
                )),
      );
    });
  }
}
