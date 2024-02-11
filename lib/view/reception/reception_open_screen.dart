import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_tak_mobile/utils/constants.dart';
import 'package:service_tak_mobile/utils/helper_methods.dart';
import 'package:service_tak_mobile/view/widget/default_app_bar.dart';
import 'package:service_tak_mobile/viewmodel/spa/spa_product_detail_viewmodel.dart';

class ReceptionOpenScreen extends StatelessWidget {
  const ReceptionOpenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => SpaProductDetailViewModel(),
        child: Consumer<SpaProductDetailViewModel>(
          builder: (context, viewModel, _) {
            return Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    emptySpaceHeight(context, 0.06),
                    const DefaultAppBar(
                      navigatorResult: "",
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
                    _scrollableList(context),
                    emptySpaceHeight(context, 0.07),
                    _button(context),
                    emptySpaceHeight(context, 0.04),
                  ],
                ),
              ),
            );
          },
        ));
  }

  SizedBox _scrollableList(BuildContext context) {
    return SizedBox(
      height: getDynamicHeight(context, 0.4),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(
              left: getDynamicWidth(context, 0.06),
              right: getDynamicWidth(context, 0.06),
              bottom: getDynamicHeight(context, 0.01),
            ),
            child: ExpansionTile(
              collapsedBackgroundColor: kDialogGrey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              backgroundColor: kDialogGrey,
              title: Text(
                "OSMAN",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              expandedAlignment: Alignment.centerLeft,
              childrenPadding:
                  EdgeInsets.only(left: getDynamicWidth(context, 0.04)),
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _tileInfoLine(context, "Type", "Spa Personel"),
                      _tileInfoLine(context, "Status", "Towel Left"),
                      _tileInfoLine(context, "Date", "2024-03-29"),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
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
                onChanged: (value) => viewModel.toggleSwitch(value),
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
            _infoLine(context, "Room Number", "1010101010"),
            _infoLine(context, "Entry Date", "2024-02-29"),
            _infoLine(context, "Release Date", "2024-03-29"),
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
        onPressed: () {},
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
        child: CachedNetworkImage(
          imageUrl:
              "https://images.inc.com/uploaded_files/image/1920x1080/getty_481292845_77896.jpg",
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
    );
  }
}
