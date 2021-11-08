import 'package:flutter/material.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:gpmobile/src/pages/configuracoes/view/ConfigWidget.dart';
import 'package:gpmobile/src/pages/aniversariantes/view/NiverWidget.dart';
import 'package:gpmobile/src/pages/documentos/view/ListarDocWidget.dart';
import 'package:gpmobile/src/pages/ferias/view/FeriasWidget.dart';
import 'package:gpmobile/src/pages/mensagens/listar_mensagens/ListaMensaWidget.dart';
import 'package:gpmobile/src/pages/mensagens/model/MensagemEnvioModel.dart';
import 'package:gpmobile/src/pages/mensagens/model/MensagemRetornoModel.dart'
    as MensagemRetornoModel;
import 'package:gpmobile/src/pages/myDay/view/MyDayWidget.dart';
import 'package:gpmobile/src/pages/sugestoes/view/SugestoesWidget.dart';
import 'package:gpmobile/src/pages/ponto/page/PontoWidget.dart';

import '../pages/bcoHoras/view/BcoHorasWidget.dart';
import '../pages/contraCheque/view/ContraChequeWidget.dart';

class NavigationBloc extends BlocBase {
  static navegar(context, String index,
      List<MensagemRetornoModel.TtMensagens> listMensag) {
    //adicione if(page == 0...) para cada tela!...
    if (index == "0") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FeriasWidget()),
      );
    }
    if (index == "1") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => new BcoHorasWidget()),
      );
    }

    if (index == "2") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PontoWidget(null, null)),
      );
    }

    if (index == "3") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => new ContraChequeWidget()),
      );
    }
    if (index == "4") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyDayWidget()),
      );
    }
    if (index == "5") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ListarMensaWidget()),
      );
    }
    if (index == "6") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ListarDocWidget()),
      );
    }
    if (index == "7") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SugestoesWidget()),
      );
    }
    if (index == "8") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ConfigWidget()),
      );
    }
  }
}
