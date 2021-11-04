// // ignore: library_prefixes
// import 'dart:io' as Io;
// import 'dart:convert';
//
// import 'package:file_picker/file_picker.dart';
// import 'package:universal_html/html.dart';
//
// ///tipos de arquivos (FileType.any)
// var img = 'images/myDay.png';
// var pdf = 'images/pdf-test.pdf';
// File selectFile;
//
// Future<void> main() async {
//   selectFile = (await FilePicker.getFile()) as File;
//   final fileBytes = Io.File(selectFile.type).readAsBytesSync();
//
//   var img64 = base64Encode(fileBytes);
//
//   print(img64.substring(0, 100));
//   //run on command: $ dart bin/main or bin/caminho principal
//   //out: 9j/4AAQSkZJRgABAQEASABIAAD/4gIcSUNDX1BST0ZJTEUAAQEAAAIMbGNtcwIQAABtbnRyUkdCIFhZWiAH3AABABkAAwApADlh
// }
