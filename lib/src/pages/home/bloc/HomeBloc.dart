import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeBloc extends BlocBase {
  var _pagesController = PageController();
  int _seletedItem;

  Future<String> getUsuario() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _usuario = prefs.getString('usuario');
    return _usuario;
  }

  Future<String> getSenha() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _senha = prefs.getString('senha');
    return _senha;
  }

  Future<String> getNomeColaborador() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _nomeColaborador = prefs.getString('nomecolaborador');
    return _nomeColaborador;
  }

  Future<String> getEmpresa() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _empres = prefs.getString('empresa');
    return _empres;
  }

  Future<String> getMatricula() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _matric = prefs.getString('matricula');
    return _matric;
  }

  Future<String> getCargo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _carg = prefs.getString('cargo');
    return _carg;
  }

  Future<String> getNomeEmpresa() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _empres = prefs.getString('nomeEmpresa');
    return _empres;
  }

  Future<String> getTelefoneColaborador() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _telefoneColaborador = prefs.getString('userTelefone');
    return _telefoneColaborador;
  }

  Future<String> getEmailColaborador() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _emailColaborador = prefs.getString('userEmail');
    return _emailColaborador;
  }

  //esse metodo muito importante para nao gerar erros na transicao das telas!!!
  Future<String> _openPageChanged(_seletedItem) async {
    // setState(() {
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
          print("Modo Noturno");
        }
        break;
      case 8:
        {
          print("Sobre o App");
        }
        break;
    }
    return a.toString();
    // });
  }

  @override
  void dispose() {
    _pagesController.dispose();
    super.dispose();
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }
}
