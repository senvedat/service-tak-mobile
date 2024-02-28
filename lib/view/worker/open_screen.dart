import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_tak_mobile/model/worker/current_worker_model.dart';
import 'package:service_tak_mobile/model/worker/qr_card_model.dart';
import 'package:service_tak_mobile/utils/constants.dart';
import 'package:service_tak_mobile/utils/helper_methods.dart';
import 'package:service_tak_mobile/utils/navigation_helper.dart';
import 'package:service_tak_mobile/view/widget/default_app_bar.dart';
import 'package:service_tak_mobile/view/worker/security/security_product_detail_screen.dart';
import 'package:service_tak_mobile/view/worker/spa/spa_product_detail_screen.dart';
import 'package:service_tak_mobile/viewmodel/security/open_viewmodel.dart';

class OpenScreen extends StatelessWidget {
  const OpenScreen({super.key, required this.qrCard, required this.worker});
  final QrCard? qrCard;
  final Worker? worker;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => OpenViewModel(qrCard, worker),
        child: Consumer<OpenViewModel>(
          builder: (context, viewModel, _) {
            return PopScope(
              canPop: false,
              child: Scaffold(
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
              ),
            );
          },
        ));
  }

  Row _header(BuildContext context, OpenViewModel viewModel) {
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
              imageUrl: viewModel.worker?.hotel?.logo ?? "",
              fit: BoxFit.contain,
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
                "${viewModel.worker?.firstName} ${viewModel.worker?.lastName} - ${viewModel.worker?.role}",
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
          _header(context, viewModel),
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
      itemCount: viewModel.guests.length,
      itemBuilder: (context, index) {
        Guest guest = viewModel.guests[index];
        return _bodyItem(context, guest, viewModel, index);
      },
    );
  }

  Widget _bodyItem(
      BuildContext context, Guest guest, OpenViewModel viewModel, int index) {
    return Padding(
      padding: EdgeInsets.only(bottom: getDynamicHeight(context, 0.02)),
      child: SizedBox(
        height: getDynamicHeight(context, 0.16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Guest ${index + 1}",
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      child: guest.passport != null
                          ? CachedNetworkImage(
                              imageUrl: guest.passport ?? "",
                              fit: BoxFit.contain,
                              placeholder: (context, _) {
                                return Center(
                                  child: SizedBox(
                                    height: getDynamicHeight(context, 0.02),
                                    width: getDynamicHeight(context, 0.02),
                                    child: const CircularProgressIndicator(
                                      color: kMediumGreen,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: Text(
                                "No Photo",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                        fontSize:
                                            getDynamicHeight(context, 0.012),
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.w600),
                              ),
                            ),
                    ),
                  ),
                  _button(context, viewModel, index),
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
    );
  }

  Widget _button(BuildContext context, OpenViewModel viewModel, int index) {
    return InkWell(
      onTap: () async {
        String type = viewModel.worker?.hotel?.type ?? "";

        if (type == "spa") {
          if (!context.mounted) return;
          await navigatorPush(
              context,
              SpaProductDetailScreen(
                qrCard: viewModel.qrCard,
                index: index,
              ));
        } else if (type == "security") {
          if (!context.mounted) return;
          await navigatorPush(
              context, SecurityProductDetailScreen(qrCard: viewModel.qrCard));
        }
      },
      child: Container(
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
      ),
    );
  }
}
