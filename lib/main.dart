import 'package:flutter/material.dart';
import 'package:qr_scanner/screen/qr_scanner.dart';

void main(){
  runApp(const MyAPP());
}
class MyAPP extends StatelessWidget {
  const MyAPP({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: QrScanner(),
    );
  }
}