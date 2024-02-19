import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_tak_mobile/model/worker/qr_bracelet_model.dart';
import 'package:service_tak_mobile/model/worker/qr_card_model.dart';
import 'package:service_tak_mobile/utils/constants.dart';
import 'package:service_tak_mobile/utils/helper_methods.dart';
import 'package:service_tak_mobile/utils/navigation_helper.dart';
import 'package:service_tak_mobile/view/widget/default_app_bar.dart';
import 'package:service_tak_mobile/view/worker/scan_barcode_screen.dart';
import 'package:service_tak_mobile/viewmodel/security/product_detail_viewmodel.dart';

class SecurityProductDetailScreen extends StatelessWidget {
  const SecurityProductDetailScreen(
      {super.key, this.qrBracelet, this.qrCard, this.isBracelet = true});
  final QrBracelet? qrBracelet;
  final QrCard? qrCard;
  final bool isBracelet;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) =>
            SecurityProductDetailViewModel(qrBracelet, qrCard, isBracelet),
        child: Consumer<SecurityProductDetailViewModel>(
          builder: (context, viewModel, _) {
            return PopScope(
              canPop: false,
              child: Scaffold(
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      emptySpaceHeight(context, 0.06),
                      const DefaultAppBar(
                        navigatorResult: "resume",
                        title: "",
                      ),
                      emptySpaceHeight(context, 0.025),
                      _imageArea(context, viewModel),
                      emptySpaceHeight(context, 0.04),
                      _description(context, viewModel),
                      emptySpaceHeight(context, 0.3),
                      _button(context),
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }

  Widget _description(
      BuildContext context, SecurityProductDetailViewModel viewModel) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getDynamicWidth(context, 0.06),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoLine(context, "Room Number", viewModel.roomNumber),
            _infoLine(context, "Entry Date", viewModel.entryDate),
            _infoLine(context, "Release Date", viewModel.releaseDate),
          ],
        ),
      ),
    );
  }

  Widget _button(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getDynamicWidth(context, 0.06),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: kMediumGreen,
          minimumSize: Size(
              getDynamicWidth(context, 1), getDynamicHeight(context, 0.075)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        onPressed: () async {
          await navigatorPushReplacement(
              context, const ScanBarcodeScreen(), "");
        },
        child: Text(
          "Go To Scan Page",
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ),
    );
  }

  RichText _infoLine(BuildContext context, String title, String description) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "$title: ",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          TextSpan(
            text: description,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _imageArea(
      BuildContext context, SecurityProductDetailViewModel viewModel) {
    return Container(
      height: getDynamicWidth(context, 0.7),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(8), bottomLeft: Radius.circular(8)),
        child: viewModel.imageUrl.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: viewModel.imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, _) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: kMediumGreen,
                    ),
                  );
                },
              )
            : Center(
                child: Text(
                  "No Photo Available",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: getDynamicHeight(context, 0.016),
                      letterSpacing: 0,
                      fontWeight: FontWeight.w600),
                ),
              ),
      ),
    );
  }
}
