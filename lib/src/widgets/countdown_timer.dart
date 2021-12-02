import 'package:flutter/material.dart';

import 'dart:math' as math;

import 'package:gpmobile/src/pages/ponto/bloc/PontoBloc.dart';
import 'package:gpmobile/src/util/AlertDialogTemplate.dart';
import 'package:mobx/mobx.dart';
import 'package:timer_button/timer_button.dart';

class CountDownTimer extends StatefulWidget {
  int temp;
  int resp;
  bool verificacao;

  CountDownTimer({Key key, this.verificacao, this.temp, this.resp})
      : super(key: key);

  @override
  _CountDownTimerState createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer>
    with TickerProviderStateMixin {
  int res = 10;
  AnimationController controller;

  String get timerString {
    Duration duration = controller.duration * controller.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    time(context);

    //_incrementCounter();
    super.initState();
  }

  time(context) async {
    res = widget.resp;
    res = res <= 0 ? 0 : res;
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: res),
    );
    cont();
  }

  cont() {
    controller.reverse(from: controller.value == 0.0 ? 1.0 : controller.value);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    double height = MediaQuery.of(context).size.height;
    return Card(
      elevation: 0,
      color: Colors.transparent.withOpacity(0.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          countDownTimer(themeData),
          // Icon(
          //   Icons.restaurant_menu,
          //   color: Colors.white,
          //   size: 35,
          // ),
          SizedBox(
            width: 10,
          ),
          Container(
            width: 2,
            height: 70,
            color: Colors.transparent.withOpacity(0.5),
          ),
          SizedBox(
            width: 25,
          ),

          Column(
            children: [
              Text(
                'Horario de Almoço',
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
              SizedBox(
                height: height * 0.005,
              ),
              TimerButton(
                  label: 'Bater Ponto',
                  timeOutInSeconds: 1,
                  onPressed: () async {
                    intervalo = false;
                    entradaSaida = '1';
                    await AlertDialogTemplate()
                        .ShowDialogSenhaPonto(
                      context,
                      'Atenção',
                      'Confirme sua Senha',
                      'Senha',
                    )
                        .then((map) async {
                      if (map == ConfirmAction.OK) {
                        PontoBloc().blocBaterPonto(context, true, 1);
                      }
                      ;
                    });
                  },
                  disabledColor: Theme.of(context).backgroundColor,
                  color: Theme.of(context).backgroundColor,
                  activeTextStyle: new TextStyle(color: Colors.white),
                  buttonType: ButtonType.RaisedButton)
            ],
          ),
        ],
      ),
    );
  }

  AnimatedBuilder countDownTimer(ThemeData themeData) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            height: 60,
            width: 60,
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: FractionalOffset.center,
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: Stack(
                      children: <Widget>[
                        Positioned.fill(
                          child: CustomPaint(
                              painter: CustomTimerPainter(
                            cont: res,
                            // widget.resp,
                            animation: controller,
                            backgroundColor: Colors.white,
                            color: themeData.indicatorColor,
                          )),
                        ),
                        Align(
                          alignment: FractionalOffset.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                timerString,
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CustomTimerPainter extends CustomPainter {
  int cont;
  CustomTimerPainter({
    this.cont,
    this.animation,
    this.backgroundColor,
    this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, color;

  void paint(Canvas canvas, Size size) {
    @observable
    double duration = (cont * 6.3) / 3600;

    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;
    duration--;
    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;
    //double progress = (1.0 - animation.value);
    double progress = (cont * (animation.value * 6.3)) / 3600;
    print(progress);
    canvas.drawArc(Offset.zero & size, 4.65, progress, false, paint);
    // canvas.drawArc((Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(CustomTimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}
