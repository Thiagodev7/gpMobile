import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:gpmobile/src/pages/ponto/bloc/PontoBloc.dart';
import 'package:gpmobile/src/util/Globals.dart';

class CardAlmoco extends StatefulWidget {
  const CardAlmoco({
    Key key,
  }) : super(key: key);
  @override
  State<CardAlmoco> createState() => _CardAlmocoState();
}

class _CardAlmocoState extends State<CardAlmoco> {
  int endTime = 50000;
  int resp = 0;
  int count = 0;

  @override
  void initState() {
    super.initState();
    time(context);

    _incrementCounter();
  }

  time(context) async {
    await PontoBloc().retornoTime(context, true, 2).then((value) => {
          resp = value.response.ttRetornoErro.ttRetornoErro[0]
              .horaUltimaBatidaEmSegundos
        });

    var currDt = DateTime.now();
    int total =
        (60 * (60 * (currDt.hour))) + (60 * (currDt.minute)) + currDt.second;
    int res = (resp + 3600) - total;
    count = res;

    if (resp != null) {
      endTime = DateTime.now().millisecondsSinceEpoch + 1000 * res;
    } else {
      endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 3600;
    }
  }

  void _incrementCounter() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        endTime--;
        count--;
        if (count < 0 || count > 3600) {
          Globals.validacao = false;
        } else {
          Globals.validacao = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Globals.validacao
        ? Card(
            elevation: 0,
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.restaurant_menu,
                  color: Colors.white,
                  size: 35,
                ),
                SizedBox(
                  width: 7,
                ),
                Column(
                  children: [
                    Text(
                      'Horario de Almoço',
                      style: TextStyle(color: Colors.white),
                    ),
                    CountdownTimer(
                      //onEnd: valida,
                      endWidget: Text(
                        'Almoço acabou',
                        style: TextStyle(color: Colors.white),
                      ),
                      textStyle: TextStyle(color: Colors.white),
                      endTime: endTime,
                    ),
                    // Text(
                    //   '$_counter',
                    //   style: TextStyle(color: Colors.white),
                    // ),
                  ],
                ),
              ],
            ),
          )
        : SizedBox();
  }
}

void valida() {
  Globals.validacao = false;
}
