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
import 'package:service_tak_mobile/viewmodel/spa/spa_product_detail_viewmodel.dart';

class SpaProductDetailScreen extends StatelessWidget {
  const SpaProductDetailScreen(
      {super.key,
      this.qrBracelet,
      this.qrCard,
      this.isBracelet = true,
      this.index});
  final QrBracelet? qrBracelet;
  final QrCard? qrCard;
  final bool isBracelet;
  final int? index;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) =>
            SpaProductDetailViewModel(qrBracelet, qrCard, isBracelet, index),
        child: Consumer<SpaProductDetailViewModel>(
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
                      emptySpaceHeight(context, 0.01),
                      const Divider(
                        color: kTextFieldUnderline,
                      ),
                      _switch(context, viewModel),
                      const Divider(
                        color: kTextFieldUnderline,
                      ),
                      _scrollableList(context, viewModel),
                      emptySpaceHeight(context, 0.07),
                      _button(context),
                      emptySpaceHeight(context, 0.04),
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }

  SizedBox _scrollableList(
      BuildContext context, SpaProductDetailViewModel viewModel) {
    return SizedBox(
      height: getDynamicHeight(context, 0.4),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: viewModel.towelHistories.length,
        itemBuilder: (context, index) {
          TowelHistory towelHistory = viewModel.towelHistories[index];
          return _towelHistoryCard(context, towelHistory, viewModel, index);
        },
      ),
    );
  }

  Padding _towelHistoryCard(BuildContext context, TowelHistory towelHistory,
      SpaProductDetailViewModel viewModel, int index) {
    return Padding(
      padding: EdgeInsets.only(
        left: getDynamicWidth(context, 0.06),
        right: getDynamicWidth(context, 0.06),
        bottom: getDynamicHeight(context,
            viewModel.towelHistories.length - 1 == index ? 0.12 : 0.01),
      ),
      child: ExpansionTile(
        collapsedBackgroundColor: kDialogGrey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: kDialogGrey,
        title: Text(
          towelHistory.towelGiverName ?? "",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        expandedAlignment: Alignment.centerLeft,
        childrenPadding: EdgeInsets.only(left: getDynamicWidth(context, 0.04)),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _tileInfoLine(context, "Type",
                    viewModel.type(towelHistory.towelGiverRole ?? "")),
                _tileInfoLine(context, "Status",
                    viewModel.status(towelHistory.towel ?? "")),
                _tileInfoLine(context, "Date",
                    viewModel.date(towelHistory.createdAt ?? "")),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Padding _switch(BuildContext context, SpaProductDetailViewModel viewModel) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getDynamicWidth(context, 0.06),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Towel",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          emptySpaceWidth(context, 0.02),
          SizedBox(
            height: getDynamicHeight(context, 0.04),
            width: getDynamicWidth(context, 0.1),
            child: FittedBox(
              fit: BoxFit.fill,
              child: Switch(
                value: viewModel.isSwitched,
                activeColor: kWhite,
                activeTrackColor: kMediumGreen,
                onChanged: (value) async => await viewModel.toggleSwitch(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _description(
      BuildContext context, SpaProductDetailViewModel viewModel) {
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

  RichText _tileInfoLine(
      BuildContext context, String title, String description) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "$title: ",
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontSize: getDynamicHeight(context, 0.018)),
          ),
          TextSpan(
            text: description,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: getDynamicHeight(context, 0.018)),
          ),
        ],
      ),
    );
  }

  Widget _imageArea(BuildContext context, SpaProductDetailViewModel viewModel) {
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
