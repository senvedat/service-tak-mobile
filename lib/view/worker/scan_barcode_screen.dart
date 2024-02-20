import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:service_tak_mobile/service/local/local_storage_service.dart';
import 'package:service_tak_mobile/utils/constants.dart';
import 'package:service_tak_mobile/utils/helper_methods.dart';
import 'package:service_tak_mobile/utils/local_storage_keys.dart';
import 'package:service_tak_mobile/utils/navigation_helper.dart';
import 'package:service_tak_mobile/view/splash/splash_screen.dart';
import 'package:service_tak_mobile/view/widget/default_app_bar.dart';
import 'package:service_tak_mobile/viewmodel/security/scan_barcode_viewmodel.dart';
import 'package:permission_handler/permission_handler.dart';

class ScanBarcodeScreen extends StatelessWidget {
  const ScanBarcodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ScanBarcodeViewModel(),
      child: Consumer<ScanBarcodeViewModel>(
        builder: (context, viewModel, _) {
          return PopScope(
            canPop: false,
            child: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    emptySpaceHeight(context, 0.06),
                    DefaultAppBar(
                      navigatorResult: "",
                      title: "Scan Barcode",
                      onPressed: () async {
                        await LocalStorageService.instance
                            .setBool(LocalStorageKeys.isUserLoggedIn, false);
                        await LocalStorageService.instance
                            .deleteItem(LocalStorageKeys.userAuthToken);
                        await LocalStorageService.instance
                            .deleteItem(LocalStorageKeys.userType)
                            .then((value) async {
                          await navigatorPushReplacement(
                              context, const SplashScreen(), "");
                        });
                      },
                      isLogout: true,
                    ),
                    emptySpaceHeight(context, 0.02),
                    const Divider(
                      color: kTextFieldUnderline,
                    ),
                    emptySpaceHeight(context, 0.02),
                    _body(context, viewModel),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Padding _body(BuildContext context, ScanBarcodeViewModel viewModel) {
    if (!viewModel.isPageLoaded && viewModel.errorResponse == null) {
      return Padding(
        padding: EdgeInsets.only(top: getDynamicHeight(context, 0.34)),
        child: const Center(
          child: CircularProgressIndicator(
            color: kMediumGreen,
          ),
        ),
      );
    } else if (viewModel.errorResponse != null) {
      return Padding(
        padding: EdgeInsets.only(
            left: getDynamicWidth(context, 0.06),
            right: getDynamicWidth(context, 0.06),
            top: getDynamicHeight(context, 0.34)),
        child: Center(
          child: Text(
            viewModel.errorResponse!.message!,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: kBlack,
                ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getDynamicWidth(context, 0.06),
        ),
        child: Column(
          children: [
            _header(context, viewModel),
            emptySpaceHeight(context, 0.02),
            const Divider(
              color: kTextFieldUnderline,
            ),
            emptySpaceHeight(context, 0.02),
            (viewModel.status?.isDenied == false) || viewModel.isUpdating
                ? SizedBox(
                    height: getDynamicHeight(context, 0.5),
                    width: getDynamicWidth(context, 1),
                    child: QRView(
                        key: viewModel.key,
                        onQRViewCreated: (QRViewController controller) async {
                          await viewModel.scanQr1(controller, context);
                        }),
                  )
                : SizedBox(
                    height: getDynamicHeight(context, 0.5),
                    width: getDynamicWidth(context, 1),
                    child: const ColoredBox(color: kTransparent)),
            emptySpaceHeight(context, 0.02),
            const Divider(
              color: kTextFieldUnderline,
            ),
            emptySpaceHeight(context, 0.01),
            Text(
              "if you have a problem for scan, please use this button",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontSize: getDynamicHeight(context, 0.014),
                  ),
            ),
            emptySpaceHeight(context, 0.01),
            _button(context, viewModel),
          ],
        ),
      );
    }
  }

  // ElevatedButton _errorDialogButton(
  //     BuildContext context, ScanBarcodeViewModel viewModel) {
  //   return ElevatedButton(
  //     style: ElevatedButton.styleFrom(
  //       backgroundColor: kMediumGreen,
  //       minimumSize:
  //           Size(getDynamicWidth(context, 1), getDynamicHeight(context, 0.075)),
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(18),
  //       ),
  //     ),
  //     onPressed: () async {
  //       await viewModel.scanQr2(context);
  //     },
  //     child: Text(
  //       "Please Try Again",
  //       style: Theme.of(context).textTheme.labelLarge,
  //     ),
  //   );
  // }

  ElevatedButton _button(BuildContext context, ScanBarcodeViewModel viewModel) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: kMediumGreen,
        minimumSize:
            Size(getDynamicWidth(context, 1), getDynamicHeight(context, 0.075)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      onPressed: () async {
        await viewModel.scanQr2(context);
      },
      child: Text(
        "Try Alternative Scanner",
        style: Theme.of(context).textTheme.labelLarge,
      ),
    );
  }

  // Dialog _errorDialog(BuildContext context, ScanBarcodeViewModel viewModel) {
  //   return Dialog(
  //     child: Container(
  //       decoration: BoxDecoration(
  //         color: kDialogGrey,
  //         borderRadius: BorderRadius.circular(20),
  //       ),
  //       height: getDynamicHeight(context, 0.6),
  //       width: getDynamicHeight(context, 1),
  //       child: Padding(
  //         padding: EdgeInsets.all(getDynamicHeight(context, 0.02)),
  //         child: Column(
  //           children: [
  //             Align(
  //                 alignment: Alignment.topRight,
  //                 child: InkWell(
  //                     onTap: () => navigatorPop(context, ""),
  //                     child: const Icon(Icons.close))),
  //             emptySpaceHeight(context, 0.06),
  //             Padding(
  //               padding: EdgeInsets.all(getDynamicHeight(context, 0.02)),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 children: [
  //                   Image.asset(
  //                     "assets/images/error.png",
  //                   ),
  //                   emptySpaceHeight(context, 0.08),
  //                   Text(
  //                     "Oops! Scan failed",
  //                     style: Theme.of(context)
  //                         .textTheme
  //                         .displayLarge!
  //                         .copyWith(color: kBlack, letterSpacing: 0),
  //                   ),
  //                   emptySpaceHeight(context, 0.03),
  //                   Text(
  //                     "Something went tembly wrong.",
  //                     style: Theme.of(context).textTheme.bodySmall!.copyWith(
  //                           fontSize: getDynamicHeight(context, 0.014),
  //                         ),
  //                   ),
  //                   emptySpaceHeight(context, 0.03),
  //                   _errorDialogButton(context, viewModel),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Row _header(BuildContext context, ScanBarcodeViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: getDynamicWidth(context, 0.2),
          width: getDynamicWidth(context, 0.2),
          decoration: BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.circular(8),
          ),
          child: (viewModel.worker?.hotel?.logo?.isEmpty ?? true)
              ? const SizedBox.shrink()
              : ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: viewModel.worker?.hotel?.logo ?? "",
                    fit: BoxFit.cover,
                    placeholder: (context, _) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: kMediumGreen,
                        ),
                      );
                    },
                  ),
                ),
        ),
        emptySpaceWidth(context, 0.015),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                viewModel.worker?.hotel?.hotelName ?? "",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(
                height: getDynamicHeight(context, 0.01),
                child: const Divider(
                  color: kTextFieldUnderline,
                ),
              ),
              Text(
                "${viewModel.worker!.firstName} ${viewModel.worker!.lastName} - ${viewModel.worker!.role}",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
