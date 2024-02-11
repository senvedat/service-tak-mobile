import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_tak_mobile/utils/constants.dart';
import 'package:service_tak_mobile/utils/helper_methods.dart';
import 'package:service_tak_mobile/utils/navigation_helper.dart';
import 'package:service_tak_mobile/view/security/security_product_detail_screen.dart';
import 'package:service_tak_mobile/view/widget/default_app_bar.dart';
import 'package:service_tak_mobile/viewmodel/security/open_viewmodel.dart';

class OpenScreen extends StatelessWidget {
  const OpenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => OpenViewModel(),
        child: Consumer<OpenViewModel>(
          builder: (context, viewModel, _) {
            return Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    emptySpaceHeight(context, 0.06),
                    const DefaultAppBar(
                      navigatorResult: "",
                      title: "Scan Barcode",
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
            );
          },
        ));
  }

  Row _header(BuildContext context) {
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
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl:
                  "https://images.odamax.com/img/1024x768/odamax/image/upload/ZmlsZU5hbWU9bG9nb2pwZw_20220322145542.jpg",
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
                "Example Hotel",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(
                height: getDynamicHeight(context, 0.01),
                child: const Divider(
                  color: kTextFieldUnderline,
                ),
              ),
              Text(
                "Ahmet Selim Mutlu - Reception",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Padding _body(BuildContext context, OpenViewModel viewModel) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getDynamicWidth(context, 0.06),
      ),
      child: Column(
        children: [
          _header(context),
          emptySpaceHeight(context, 0.02),
          const Divider(
            color: kTextFieldUnderline,
          ),
          emptySpaceHeight(context, 0.02),
          _itemBody(context, viewModel),
        ],
      ),
    );
  }

  Widget _itemBody(BuildContext context, OpenViewModel viewModel) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: 2,
      itemBuilder: (context, index) {
        return _bodyItem(context, index);
      },
    );
  }

  Widget _bodyItem(BuildContext context, int index) {
    return InkWell(
      onTap: () {
        navigatorPush(context, const SecurityProductDetailScreen());
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: getDynamicHeight(context, 0.02)),
        child: SizedBox(
          height: getDynamicHeight(context, 0.16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Guest $index",
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    fontWeight: FontWeight.w800,
                    color: kBlack,
                    fontSize: getDynamicHeight(context, 0.022)),
              ),
              emptySpaceHeight(context, 0.012),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getDynamicWidth(context, 0.02)),
                child: Row(
                  children: [
                    Container(
                      height: getDynamicWidth(context, 0.2),
                      width: getDynamicWidth(context, 0.2),
                      decoration: BoxDecoration(
                        color: kWhite,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
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
                    ),
                    emptySpaceWidth(context, 0.04),
                    Container(
                      height: getDynamicWidth(context, 0.17),
                      width: getDynamicWidth(context, 0.17),
                      decoration: BoxDecoration(
                        color: kWhite,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl:
                              "https://cdn.britannica.com/17/155017-050-9AC96FC8/Example-QR-code.jpg",
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
                    const Spacer(),
                    _button(context),
                  ],
                ),
              ),
              const Spacer(),
              const Divider(
                color: kTextFieldUnderline,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _button(BuildContext context) {
    return Container(
      height: getDynamicHeight(context, 0.075),
      width: getDynamicHeight(context, 0.075),
      decoration: BoxDecoration(
        color: kMediumGreen,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          "Detail",
          style: Theme.of(context)
              .textTheme
              .labelLarge!
              .copyWith(fontSize: getDynamicHeight(context, 0.016)),
        ),
      ),
    );
  }
}
