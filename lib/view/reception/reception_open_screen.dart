import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:service_tak_mobile/service/local/local_storage_service.dart';
import 'package:service_tak_mobile/utils/constants.dart';
import 'package:service_tak_mobile/utils/helper_methods.dart';
import 'package:service_tak_mobile/utils/local_storage_keys.dart';
import 'package:service_tak_mobile/utils/navigation_helper.dart';
import 'package:service_tak_mobile/view/splash/splash_screen.dart';
import 'package:service_tak_mobile/view/widget/default_app_bar.dart';
import 'package:service_tak_mobile/viewmodel/reception/reception_open_viewmodel.dart';

class ReceptionOpenScreen extends StatelessWidget {
  const ReceptionOpenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => ReceptionOpenViewModel(),
        child: Consumer<ReceptionOpenViewModel>(
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
                        title: "Service Tak",
                        isLogout: true,
                        onPressed: () async {
                          await LocalStorageService.instance
                              .setBool(LocalStorageKeys.isUserLoggedIn, false);
                          await LocalStorageService.instance
                              .deleteItem(LocalStorageKeys.userAuthToken);
                          await LocalStorageService.instance
                              .deleteItem(LocalStorageKeys.userType)
                              .then(
                            (value) async {
                              await navigatorPushReplacement(
                                  context, const SplashScreen(), "");
                            },
                          );
                        },
                      ),
                      emptySpaceHeight(context, 0.02),
                      const Divider(
                        color: kTextFieldUnderline,
                      ),
                      emptySpaceHeight(context, 0.02),
                      SingleChildScrollView(child: _body(context, viewModel)),
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }

  Padding _body(BuildContext context, ReceptionOpenViewModel viewModel) {
    if (!viewModel.isPageLoaded && viewModel.errorResponse == null) {
      return Padding(
        padding: EdgeInsets.only(top: getDynamicHeight(context, 0.34)),
        child: const Center(
          child: CircularProgressIndicator(
            color: kMediumGreen,
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
            inputField(context, viewModel),
            emptySpaceHeight(context, 0.02),
            const Divider(
              color: kTextFieldUnderline,
            ),
            emptySpaceHeight(context, 0.02),
            emptySpaceHeight(context, 0.01),
            _button(context, viewModel),
          ],
        ),
      );
    }
  }

  ElevatedButton _button(
      BuildContext context, ReceptionOpenViewModel viewModel) {
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
        viewModel.roomNumberFocusNode.unfocus();

        await viewModel
            .checkExistRoom(viewModel.roomNumberController.text, context)
            .then((value) async {
          if (viewModel.errorResponse != null) {
            await showDialog(
                context: context,
                builder: (context) => _errorDialog(context, viewModel));
          }
        });
      },
      child: Text(
        "Go To Room Detail",
        style: Theme.of(context).textTheme.labelLarge,
      ),
    );
  }

  Dialog _errorDialog(BuildContext context, ReceptionOpenViewModel viewModel) {
    return Dialog(
      child: Container(
        decoration: BoxDecoration(
          color: kDialogGrey,
          borderRadius: BorderRadius.circular(20),
        ),
        height: getDynamicHeight(context, 0.6),
        width: getDynamicHeight(context, 1),
        child: Padding(
          padding: EdgeInsets.all(getDynamicHeight(context, 0.02)),
          child: Column(
            children: [
              Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                      onTap: () => navigatorPop(context, ""),
                      child: const Icon(Icons.close))),
              emptySpaceHeight(context, 0.06),
              Padding(
                padding: EdgeInsets.all(getDynamicHeight(context, 0.02)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/error.png",
                    ),
                    emptySpaceHeight(context, 0.08),
                    Text(
                      viewModel.errorResponse?.message ?? "",
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge!
                          .copyWith(color: kBlack, letterSpacing: 0),
                    ),
                    emptySpaceHeight(context, 0.03),
                    Text(
                      "Something went terribly wrong.",
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontSize: getDynamicHeight(context, 0.014),
                          ),
                    ),
                    emptySpaceHeight(context, 0.03),
                    _errorDialogButton(context, viewModel),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButton _errorDialogButton(
      BuildContext context, ReceptionOpenViewModel viewModel) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: kMediumGreen,
        minimumSize:
            Size(getDynamicWidth(context, 1), getDynamicHeight(context, 0.075)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      onPressed: () {
        navigatorPop(context, "");
      },
      child: Text(
        "Close",
        style: Theme.of(context).textTheme.labelLarge,
      ),
    );
  }

  Widget inputField(BuildContext context, ReceptionOpenViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Room Number",
          style: Theme.of(context).textTheme.displaySmall!.copyWith(
                fontWeight: FontWeight.w700,
                color: kBlack,
              ),
        ),
        emptySpaceHeight(context, 0.01),
        TextFormField(
          controller: viewModel.roomNumberController,
          cursorColor: kMediumGreen,
          focusNode: viewModel.roomNumberFocusNode,
          style: GoogleFonts.montserrat(
            color: kBlack,
            fontSize: getDynamicHeight(context, 0.018),
            fontWeight: FontWeight.w500,
          ),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: "Room Number",
            fillColor: kTextGrey.withOpacity(0.05),
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: (value) {},
        ),
      ],
    );
  }

  Row _header(BuildContext context, ReceptionOpenViewModel viewModel) {
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
              imageUrl: viewModel.hotel?.logo ?? "",
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
                viewModel.hotel?.hotelName ?? "",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(
                height: getDynamicHeight(context, 0.01),
                child: const Divider(
                  color: kTextFieldUnderline,
                ),
              ),
              Text(
                "${viewModel.hotel!.email}",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
