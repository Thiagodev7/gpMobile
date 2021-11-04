import 'dart:async';

import 'dart:ui';

//import 'package:dio/dio.dart';

//Aguardar determinado tempo para executar tarefa

class AtualizarPorTimer {
  final int milisegundos;
  VoidCallback action;
  Timer _timer;

  AtualizarPorTimer({this.milisegundos});

  run(VoidCallback action){
    if(null != _timer){
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milisegundos), action);
  }

}

//Como usar

//Define o tempo
//final _atualizaPorTempo = AtualizarPorTimer(milisegundos: 500);

//_atualizaPorTempo.run((){
  //Coloca aqui o bloco que se deseja usar
//});
