import 'dart:convert';

import 'package:dart_ipify/dart_ipify.dart';

class GetIp {
  Future<String> getIp() async {
    final ip = await Ipify.ipv4();
    return ip;
  }
}
