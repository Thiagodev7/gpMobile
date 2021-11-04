import 'dart:convert';

import 'package:dart_ipify/dart_ipify.dart';

// import 'package:ip_geolocation_api/ip_geolocation_api.dart';
//
// class GetIp { //Funciona apenas com http
//
//   Future<String> getIp() async {
//     String ip;
//     GeolocationData geolocationData;
//     geolocationData = await GeolocationAPI.getData();
//     if (geolocationData != null) {
//         ip = geolocationData.ip;
//     }
//     return ip;
//   }
// }

class GetIp {
  Future<String> getIp() async {
    final ip = await Ipify.ipv4();
    return ip;
  }
}