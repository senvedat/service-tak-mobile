import 'package:flutter/material.dart';
import 'package:service_tak_mobile/view/scan_qr_2_view.dart';
import 'package:service_tak_mobile/view/scan_qr_view.dart';

class OptionListView extends StatefulWidget {
  const OptionListView({super.key});

  @override
  State<OptionListView> createState() => _OptionListViewState();
}

class _OptionListViewState extends State<OptionListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                elevation: 0,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ScanQrView(),
                  ),
                );
              },
              child: const Text("Scan QR Code 1",
                  style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                elevation: 0,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ScanQrView2(),
                  ),
                );
              },
              child: const Text("Scan Qr Code 2",
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
