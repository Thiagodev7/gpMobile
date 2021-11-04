import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gpmobile/src/core/app_colors.dart';
import 'package:gpmobile/src/pages/mensagens/model/StatusMensaModel.dart';

class SampleListItem extends StatelessWidget {
  final String title;
  final String message;
  final String data;

  final Widget icon;
  final TextStyle style;
  final GestureTapCallback onClick;
  final Axis direction;
  final double width;
  SampleListItem({
    Key key,
    this.title,
    this.message,
    this.data,
    this.icon,
    this.onClick,
    this.direction = Axis.vertical,
    this.width = double.infinity,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return direction == Axis.vertical
        ? InkWell(
            onTap: onClick,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              child: Row(
                children: <Widget>[
                  Container(
                    height: 100.0,
                    child: AspectRatio(
                      aspectRatio: 1.0,
                      child: Container(
                        // color: Colors.grey[200],
                        child: icon,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                        padding: EdgeInsets.all(
                          10.0,
                        ),
                        color: Colors.white,
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.grey[200],
                                      ),
                                      width: 120.0,
                                      height: 15.0,
                                      child: Text(
                                        title.toString(),
                                        style: TextStyle(fontSize: 12.0),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.grey[200],
                                      ),
                                      width: 60.0,
                                      height: 10.0,
                                      margin: EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        data.toString(),
                                        style: TextStyle(fontSize: 10.0),
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  flex: 1,
                                  child: SizedBox(),
                                ),
                                // d
                              ],
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.grey[200],
                                  ),
                                  height: 30.0,
                                  width: 180.0,
                                  child: Text(
                                    message.toString(),
                                    style: TextStyle(fontSize: 12.0),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )),
                  ),
                ],
              ),
            ),
          )
        : Card(
            child: Container(
              alignment: Alignment.center,
              child: Column(
                children: <Widget>[
                  Container(
                    height: 100.0,
                    width: width,
                    color: Colors.grey[200],
                  ),
                  Container(
                    width: width,
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 80.0,
                                  height: 15.0,
                                  color: Colors.grey[200],
                                ),
                                Container(
                                  width: 60.0,
                                  height: 10.0,
                                  margin: EdgeInsets.only(top: 8.0),
                                  color: Colors.grey[200],
                                ),
                              ],
                            ),
                            Expanded(
                              flex: 1,
                              child: SizedBox(),
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.grey[200],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: 10.0,
                              color: Colors.grey[200],
                            ),
                            SizedBox(
                              height: 4.0,
                            ),
                            Container(
                              height: 10.0,
                              color: Colors.grey[200],
                            ),
                            SizedBox(
                              height: 4.0,
                            ),
                            Container(
                              height: 10.0,
                              width: 100.0,
                              color: Colors.grey[200],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
