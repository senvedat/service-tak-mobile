import 'package:flutter/material.dart';
import 'package:service_tak_mobile/view/scan_qr_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Service Tak Mobile',
      home: ScanQrView(),
    );
  }
}
