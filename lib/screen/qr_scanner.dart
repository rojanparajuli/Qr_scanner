import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

class QrScanner extends StatefulWidget {
  const QrScanner({Key? key});

  @override
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  @override
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String scannedCode = '';

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
      controller.scannedDataStream.listen((scanData) async {
        setState(() {
          scannedCode = scanData.code!;
        });

        // Send a GET request to the scanned URL
        final response = await http.get(Uri.parse(scannedCode));

        // Check if the response is successful and the content is a web URL
        if (response.statusCode == 200 && response.headers['content-type']!.contains('text/html')) {
          // Launch the web URL
          launch(scannedCode);
        } else {
          // Handle other types of content or errors
          print('Invalid URL or content: $scannedCode');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        title: const Text('QR scanner'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                'Scanned code: $scannedCode',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          )
        ],
      ),
    );
  }
}
