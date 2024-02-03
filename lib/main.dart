import 'package:flutter/material.dart';
import 'package:service_tak_mobile/utils/theme.dart';
import 'package:service_tak_mobile/view/splash/splash_screen.dart';
import 'package:service_tak_mobile/view/security/open_screen.dart';
import 'package:service_tak_mobile/view/spa/spa_product_detail_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Service Tak Mobile',
      debugShowCheckedModeBanner: false,
      theme: customTheme(context),
      home: const SplashScreen(),
    );
  }
}
