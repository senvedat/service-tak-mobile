import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class ScanQrView extends StatefulWidget {
  const ScanQrView({super.key});

  @override
  State<ScanQrView> createState() => _ScanQrViewState();
}

class _ScanQrViewState extends State<ScanQrView> {
  final GlobalKey key = GlobalKey();
  QRViewController? controller;
  Barcode? barcode;
  PermissionStatus? status;

  @override
  void initState() {
    _getCameraPermission();
    super.initState();
  }

  Future<void> qr(QRViewController controller) async {
    this.controller = controller;
    controller.scannedDataStream.listen((barcode) {
      setState(() {
        this.barcode = barcode;
      });
    });
    controller.getCameraInfo().then((camera) {
      debugPrint(camera.toString());
      if (camera == CameraFacing.front) {
        controller.flipCamera();
      }
    });
    await Future.delayed(const Duration(milliseconds: 400));
  }

  Future<void> _getCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      final result = await Permission.camera.request();
      setState(() {
        status = result;
      });
    } else {
      setState(() {
        this.status = status;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: (status?.isGranted ?? false)
            ? SizedBox(
                height: 400,
                width: 400,
                child: QRView(key: key, onQRViewCreated: qr),
              )
            : const ColoredBox(color: Colors.red),
      ),
    );
  }
}
