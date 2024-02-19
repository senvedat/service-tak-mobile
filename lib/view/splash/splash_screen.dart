import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_tak_mobile/utils/constants.dart';
import 'package:service_tak_mobile/viewmodel/splash/splash_viewmodel.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SplashViewModel(context),
      child: Consumer<SplashViewModel>(
        builder: (context, viewModel, _) {
          return PopScope(
            canPop: false,
            child: Scaffold(
              backgroundColor: kMediumGreen,
              body: Center(
                child: Text(
                  textAlign: TextAlign.center,
                  "SERVICE\nTAK",
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
