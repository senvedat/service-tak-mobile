import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:service_tak_mobile/locator.dart';
import 'package:service_tak_mobile/service/local/local_storage_service.dart';
import 'package:service_tak_mobile/utils/theme.dart';
import 'package:service_tak_mobile/view/splash/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  initLocator();
  await LocalStorageService().onInitialize();
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
