import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_tak_mobile/utils/constants.dart';
import 'package:service_tak_mobile/utils/helper_methods.dart';
import 'package:service_tak_mobile/view/widget/default_app_bar.dart';
import 'package:service_tak_mobile/viewmodel/security/product_detail_viewmodel.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => ProductDetailViewModel(),
        child: Consumer<ProductDetailViewModel>(
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
                    emptySpaceHeight(context, 0.25),
                    _button(context),
                  ],
                ),
              ),
            );
          },
        ));
  }

  Widget _description(BuildContext context, ProductDetailViewModel viewModel) {
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

  Widget _imageArea(BuildContext context, ProductDetailViewModel viewModel) {
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
