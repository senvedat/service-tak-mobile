import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:service_tak_mobile/model/hotel/current_hotel_model.dart';
import 'package:service_tak_mobile/model/hotel/new_guest_model.dart';
import 'package:service_tak_mobile/utils/constants.dart';
import 'package:service_tak_mobile/utils/helper_methods.dart';
import 'package:service_tak_mobile/utils/navigation_helper.dart';
import 'package:service_tak_mobile/view/widget/default_app_bar.dart';
import 'package:service_tak_mobile/viewmodel/reception/camera_viewmodel.dart';

class CameraScreen extends StatelessWidget {
  const CameraScreen(
      {super.key, this.hotel, this.imageUrl, this.guest, this.isEdit = false});
  final Hotel? hotel;
  final NewGuest? guest;
  final String? imageUrl;
  final bool isEdit;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => CameraViewModel(guest, hotel, isEdit),
        child: Consumer<CameraViewModel>(
          builder: (context, viewModel, _) {
            return PopScope(
              canPop: false,
              child: Scaffold(
                key: viewModel.myWidgetKey,
                body: SingleChildScrollView(
                  controller: viewModel.scrollController,
                  child: Column(
                    children: [
                      emptySpaceHeight(context, 0.06),
                      DefaultAppBar(
                        navigatorResult: "refresh",
                        title: "Take User Photo",
                        onPressed: () async => await viewModel.appBarOnBack(),
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

  Padding _body(BuildContext context, CameraViewModel viewModel) {
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
          inputField(context, viewModel),
          emptySpaceHeight(context, 0.03),
          _photoView(context, viewModel),
          emptySpaceHeight(context, 0.08),
          _confirmButton(context, viewModel),
          emptySpaceHeight(context, viewModel.localImage.isEmpty ? 0.0 : 0.02),
          _button(context, viewModel),
          emptySpaceHeight(context, viewModel.localImage.isEmpty ? 0.0 : 0.02),
        ],
      ),
    );
  }

  Widget _photoView(BuildContext context, CameraViewModel viewModel) {
    return Container(
      height: getDynamicHeight(context, 0.45),
      decoration: BoxDecoration(
        image: viewModel.localImage.isEmpty
            ? null
            : DecorationImage(
                fit: BoxFit.contain,
                image: Image.memory(base64Decode(viewModel.localImage),
                        gaplessPlayback: true)
                    .image),
        color: kTransparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: (imageUrl?.isEmpty ?? true)
          ? viewModel.isImageInProgress == true
              ? const Center(
                  child: CircularProgressIndicator(
                    color: kMediumGreen,
                  ),
                )
              : null
          : viewModel.localImage.isNotEmpty
              ? null
              : ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl ?? "",
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
    );
  }

  Widget _confirmButton(BuildContext context, CameraViewModel viewModel) {
    return viewModel.localImage.isNotEmpty
        ? ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kWhite,
              minimumSize: Size(getDynamicWidth(context, 1),
                  getDynamicHeight(context, 0.075)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: const BorderSide(color: kMediumGreen, width: 2),
              ),
            ),
            onPressed: viewModel.isButtonLoading
                ? null
                : () async {
                    await viewModel.updatePassport().then((result) async {
                      viewModel.scrollController.animateTo(0,
                          duration: const Duration(milliseconds: 1000),
                          curve: Curves.fastOutSlowIn);
                      if (!result) {
                        await showDialog(
                          context: context,
                          builder: (context) =>
                              _errorDialog(context, viewModel),
                        );
                      }
                    });
                  },
            child: viewModel.isButtonLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: kMediumGreen,
                    ),
                  )
                : Text(
                    "Confirm",
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: kMediumGreen,
                        ),
                  ),
          )
        : const SizedBox.shrink();
  }

  ElevatedButton _button(BuildContext context, CameraViewModel viewModel) {
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
        if (viewModel.status?.isDenied != true) {
          debugPrint("Camera access is granted.");
          viewModel.pickImage(context, ImageSource.camera);
        } else if (viewModel.status?.isPermanentlyDenied ?? false) {
          debugPrint("Access need for camera. 1");
          await openAppSettings();
        }
      },
      child: Text(
        viewModel.localImage.isEmpty ? "Take Photo" : "Retake Photo",
        style: Theme.of(context).textTheme.labelLarge,
      ),
    );
  }

  Dialog _errorDialog(BuildContext context, CameraViewModel viewModel) {
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
                      "Something went tembly wrong.",
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
      BuildContext context, CameraViewModel viewModel) {
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

  Widget inputField(BuildContext context, CameraViewModel viewModel) {
    return Align(
      alignment: Alignment.topCenter,
      child: Text(
        viewModel.localImage.isNotEmpty || (imageUrl?.isNotEmpty ?? false)
            ? "Guest Photo"
            : "",
        style: Theme.of(context).textTheme.displaySmall!.copyWith(
              fontWeight: FontWeight.w700,
              color: kBlack,
            ),
      ),
    );
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
              imageUrl: hotel?.logo ?? "",
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
                hotel?.hotelName ?? "",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(
                height: getDynamicHeight(context, 0.01),
                child: const Divider(
                  color: kTextFieldUnderline,
                ),
              ),
              Text(
                "${hotel?.email}",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
