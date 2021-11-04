import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gpmobile/src/util/Estilo.dart';

class AppBarWidget extends PreferredSize implements PreferredSizeWidget {
  // final StatusModel model;
  AppBarWidget()
      : super(
          preferredSize: Size.fromHeight(250),
          child: Material(
            child: Container(
              height: 250,
              decoration: BoxDecoration(gradient: AppGradients.splashGradient),
              child: Stack(
                children: [
                  Container(
                    height: 161,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    width: double.maxFinite,
                    decoration: BoxDecoration(gradient: AppGradients.linear2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.navigate_before, color: AppColors.white),
                        Text.rich(
                          TextSpan(
                              text: 'Olá, ',
                              style: AppTextStyles.title,
                              children: [
                                TextSpan(
                                    text: 'NomeUser',
                                    style: AppTextStyles.titleBold)
                              ]),
                        ),
                        Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(
                                  'https://cdn-images-1.medium.com/max/1200/1*nE4OFcqk2kx2-Lzhey8QKA.png'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    // alignment: Alignment.bottomCenter,
                    alignment: Alignment(-1.0, 0.0),
                    child: Container(
                      child: Text("Senha Atual"),
                    ),
                  ),
                  Align(
                    // alignment: Alignment.bottomCenter,
                    alignment: Alignment(-1.0, 0.2),
                    child: Container(
                      child: Text("Nova senha"),
                    ),
                  ),
                  Align(
                    // alignment: Alignment.bottomCenter,
                    alignment: Alignment(-1.0, 0.4),
                    child: Container(
                      child: Text("Repetir Nova senha"),
                    ),
                  ),
                  Align(
                    // alignment: Alignment.bottomCenter,
                    alignment: Alignment(-1.0, 0.6),
                    child: Container(
                      child: Text("Gravar"),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
}
