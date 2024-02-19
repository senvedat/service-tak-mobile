import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:service_tak_mobile/model/hotel/current_hotel_model.dart';
import 'package:service_tak_mobile/model/hotel/hotel_room_model.dart';
import 'package:service_tak_mobile/model/hotel/new_guest_model.dart';
import 'package:service_tak_mobile/service/local/local_storage_service.dart';
import 'package:service_tak_mobile/utils/constants.dart';
import 'package:service_tak_mobile/utils/helper_methods.dart';
import 'package:service_tak_mobile/utils/local_storage_keys.dart';
import 'package:service_tak_mobile/utils/navigation_helper.dart';
import 'package:service_tak_mobile/view/reception/camera_screen.dart';
import 'package:service_tak_mobile/view/reception/recception_scan_barcode_screen.dart';
import 'package:service_tak_mobile/view/widget/default_app_bar.dart';
import 'package:service_tak_mobile/viewmodel/reception/room_viewmodel.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';

class RoomScreen extends StatelessWidget {
  const RoomScreen({super.key, this.type, this.hotel});
  final String? type;
  final Hotel? hotel;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => RoomViewModel(type, hotel),
        child: Consumer<RoomViewModel>(
          builder: (context, viewModel, _) {
            return PopScope(
              canPop: true,
              onPopInvoked: (didPop) async {
                await LocalStorageService.instance
                    .deleteItem(LocalStorageKeys.roomNumber);
              },
              child: Scaffold(
                key: viewModel.myWidgetKey,
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      emptySpaceHeight(context, 0.06),
                      DefaultAppBar(
                        navigatorResult: "",
                        title: "Room ${viewModel.room?.roomNumber ?? ""}",
                        onPressed: () async {
                          await LocalStorageService.instance
                              .deleteItem(LocalStorageKeys.roomNumber);
                          navigatorPop(
                              viewModel.myWidgetKey!.currentContext!, "");
                        },
                      ),
                      emptySpaceHeight(context, 0.02),
                      const Divider(
                        color: kTextFieldUnderline,
                      ),
                      emptySpaceHeight(context, 0.02),
                      SingleChildScrollView(
                        child: _body(context, viewModel),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }

  Widget _body(BuildContext context, RoomViewModel viewModel) {
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
      return Stack(
        children: [
          Padding(
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
                _topPart(context, viewModel),
                emptySpaceHeight(context, 0.01),
                const Divider(
                  color: kTextFieldUnderline,
                ),
                _itemBuilder(context, viewModel),
                emptySpaceHeight(
                    context,
                    viewModel.isEntryDatePickerClicked
                        ? 0.2
                        : viewModel.isReleaseDatePickerClicked
                            ? 0.27
                            : 0.01),
                _button(context, viewModel),
                emptySpaceHeight(
                    context,
                    viewModel.isEntryDatePickerClicked ||
                            viewModel.isReleaseDatePickerClicked
                        ? 0.02
                        : 0.01),
              ],
            ),
          ),
          viewModel.isEntryDatePickerClicked
              ? _datePickerModal(context, viewModel, true)
              : const SizedBox.shrink(),
          viewModel.isReleaseDatePickerClicked
              ? _datePickerModal(context, viewModel, false)
              : const SizedBox.shrink(),
        ],
      );
    }
  }

  SizedBox _itemBuilder(BuildContext context, RoomViewModel viewModel) {
    return SizedBox(
      height: getDynamicHeight(context, 0.35),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: viewModel.room!.guests.length,
        itemBuilder: (context, index) {
          Guest guest = viewModel.room!.guests[index];
          return _guestCard(context, viewModel, index, guest);
        },
      ),
    );
  }

  Widget _guestCard(
      BuildContext context, RoomViewModel viewModel, int index, Guest guest) {
    return Column(
      children: [
        index == 0
            ? const SizedBox.shrink()
            : const Divider(
                color: kTextFieldUnderline,
              ),
        index == 0
            ? const SizedBox.shrink()
            : emptySpaceHeight(context, 0.0002),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Guest ${index + 1}",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontSize: getDynamicHeight(context, 0.019),
                  letterSpacing: 0,
                  fontWeight: FontWeight.w600),
            ),
            Padding(
              padding: EdgeInsets.only(
                right: getDynamicWidth(context, 0.01),
              ),
              child: GestureDetector(
                onTap: () async {
                  await viewModel.deleteGuest(guest.id.toString());
                },
                child: Image.asset(
                  "assets/icons/trash.png",
                  height: getDynamicHeight(context, 0.04),
                  width: getDynamicWidth(context, 0.06),
                ),
              ),
            ),
          ],
        ),
        viewModel.qrType == "card"
            ? Align(
                alignment: Alignment.centerLeft,
                child: _guestCardImage(context, false, viewModel, index),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _guestCardImage(context, false, viewModel, index),
                  emptySpaceWidth(context, 0.02),
                  _guestCardImage(context, true, viewModel, index),
                ],
              ),
        emptySpaceHeight(context, 0.01),
      ],
    );
  }

  Widget _guestCardImage(
      BuildContext context, bool isQr, RoomViewModel viewModel, int index) {
    return GestureDetector(
      onTap: () async {
        if (isQr) {
          await navigatorPush(
              context,
              ReceptionScanBarcodeScreen(
                  hotel: hotel,
                  roomId: viewModel.room!.guests.first.qrId,
                  isEdit: viewModel.qrType == "card"));
        } else {
          NewGuest guest = NewGuest(
              id: viewModel.room!.guests[index].id, roomId: viewModel.room!.id);
          var result = await navigatorPush(
              context,
              CameraScreen(
                hotel: hotel,
                imageUrl: viewModel.room?.guests[index].passport,
                guest: guest,
                isEdit: true,
              ));
          if (result == "refresh") {
            await viewModel.getRoom();
          }
        }
      },
      child: Stack(
        children: [
          Container(
            height: getDynamicWidth(
                context, isQr && viewModel.qrType == "card" ? 0.3 : 0.18),
            width: getDynamicWidth(
                context, isQr && viewModel.qrType == "card" ? 0.3 : 0.18),
            decoration: BoxDecoration(
              color: isQr && viewModel.qrList.isEmpty
                  ? kTextGrey.withOpacity(0.05)
                  : viewModel.room!.guests[index].passport == null
                      ? kTextGrey.withOpacity(0.05)
                      : kWhite,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: isQr
                  ? viewModel.qrList.isNotEmpty
                      ? SvgPicture.network(viewModel.qrList[index].svg ?? "",
                          fit: BoxFit.cover,
                          placeholderBuilder: (context) => const Center(
                                child: CircularProgressIndicator(
                                  color: kMediumGreen,
                                ),
                              ))
                      : Center(
                          child: Text(
                            "No Qr",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    fontSize: getDynamicHeight(
                                        context,
                                        viewModel.qrType == "card"
                                            ? 0.016
                                            : 0.012),
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.w600),
                          ),
                        )
                  : viewModel.room!.guests[index].passport != null
                      ? CachedNetworkImage(
                          imageUrl: viewModel.room!.guests[index].passport!,
                          fit: BoxFit.cover,
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
                                    fontSize: getDynamicHeight(context, 0.012),
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.w600),
                          ),
                        ),
            ),
          ),
          Positioned(
              bottom: getDynamicHeight(
                  context, isQr && viewModel.qrType == "card" ? 0.11 : 0.063),
              right: 2,
              child: CircleAvatar(
                backgroundColor: kWhite,
                radius: getDynamicWidth(
                    context, isQr && viewModel.qrType == "card" ? 0.03 : 0.02),
                child: Icon(
                  Icons.edit,
                  color: kMediumGreen,
                  size: getDynamicWidth(context,
                      isQr && viewModel.qrType == "card" ? 0.035 : 0.025),
                ),
              )),
        ],
      ),
    );
  }

  ElevatedButton _button(BuildContext context, RoomViewModel viewModel) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor:
            viewModel.isButtonActive() || !viewModel.isButtonLoading
                ? kMediumGreen
                : kMediumGreen.withOpacity(0.4),
        minimumSize:
            Size(getDynamicWidth(context, 1), getDynamicHeight(context, 0.075)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      onPressed: viewModel.isButtonActive() || !viewModel.isButtonLoading
          ? () async {
              await viewModel.createGuest();
            }
          : null,
      child: viewModel.isButtonLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: kWhite,
              ),
            )
          : Text(
              "Add Guest",
              style: Theme.of(context).textTheme.labelLarge,
            ),
    );
  }

  Widget _topPart(BuildContext context, RoomViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _roomNumAndClearButton(viewModel, context),
        emptySpaceHeight(context, 0.02),
        viewModel.qrType == "card"
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      _dateInputField(context, viewModel, true),
                      emptySpaceHeight(context, 0.01),
                      _dateInputField(context, viewModel, false),
                    ],
                  ),
                  _guestCardImage(context, true, viewModel, 0),
                ],
              )
            : Column(
                children: [
                  _dateInputField(context, viewModel, true),
                  emptySpaceHeight(context, 0.01),
                  _dateInputField(context, viewModel, false),
                ],
              ),
      ],
    );
  }

  Widget _dateInputField(
      BuildContext context, RoomViewModel viewModel, bool isEntryDate) {
    return viewModel.qrType == "card"
        ? _cardTypeInput(isEntryDate, context, viewModel)
        : _braceletTypeInput(isEntryDate, context, viewModel);
  }

  Column _cardTypeInput(
      bool isEntryDate, BuildContext context, RoomViewModel viewModel) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isEntryDate ? "Entry Date" : "Release Date",
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontSize: getDynamicHeight(context, 0.018),
              letterSpacing: 0,
              fontWeight: FontWeight.w600),
        ),
        GestureDetector(
          onTap: () {
            if (isEntryDate) {
              viewModel.isEntryDatePickerClickedToggle();
            } else {
              viewModel.isReleaseDatePickerClickedToggle();
            }
          },
          child: SizedBox(
            width: getDynamicWidth(context, 0.4),
            child: TextFormField(
              textAlign: TextAlign.center,
              enabled: false,
              cursorColor: kMediumGreen,
              style: GoogleFonts.montserrat(
                color: kBlack,
                fontSize: getDynamicHeight(context, 0.018),
                fontWeight: FontWeight.w500,
              ),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.all(getDynamicHeight(context, 0.005)),
                hintText: isEntryDate
                    ? viewModel.chosenEntryDate == null
                        ? "Entry Date"
                        : dateFormatterYearMonthDay(viewModel.chosenEntryDate!)
                    : viewModel.chosenReleaseDate == null
                        ? "Release Date"
                        : dateFormatterYearMonthDay(
                            viewModel.chosenReleaseDate!),
                hintStyle: GoogleFonts.montserrat(
                  color: isEntryDate
                      ? viewModel.chosenEntryDate == null
                          ? kTextGrey
                          : kBlack
                      : viewModel.chosenReleaseDate == null
                          ? kTextGrey
                          : kBlack,
                  fontSize: getDynamicHeight(context, 0.018),
                  fontWeight: FontWeight.w500,
                ),
                fillColor: kTextGrey.withOpacity(0.05),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {},
            ),
          ),
        ),
      ],
    );
  }

  Row _braceletTypeInput(
      bool isEntryDate, BuildContext context, RoomViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          isEntryDate ? "Entry Date:" : "Release Date:",
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontSize: getDynamicHeight(context, 0.018),
              letterSpacing: 0,
              fontWeight: FontWeight.w600),
        ),
        GestureDetector(
          onTap: () {
            if (isEntryDate) {
              viewModel.isEntryDatePickerClickedToggle();
            } else {
              viewModel.isReleaseDatePickerClickedToggle();
            }
          },
          child: SizedBox(
            width: getDynamicWidth(context, 0.4),
            child: TextFormField(
              textAlign: TextAlign.center,
              enabled: false,
              cursorColor: kMediumGreen,
              style: GoogleFonts.montserrat(
                color: kBlack,
                fontSize: getDynamicHeight(context, 0.018),
                fontWeight: FontWeight.w500,
              ),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.all(getDynamicHeight(context, 0.005)),
                hintText: isEntryDate
                    ? viewModel.chosenEntryDate == null
                        ? "Entry Date"
                        : dateFormatterYearMonthDay(viewModel.chosenEntryDate!)
                    : viewModel.chosenReleaseDate == null
                        ? "Release Date"
                        : dateFormatterYearMonthDay(
                            viewModel.chosenReleaseDate!),
                hintStyle: GoogleFonts.montserrat(
                  color: isEntryDate
                      ? viewModel.chosenEntryDate == null
                          ? kTextGrey
                          : kBlack
                      : viewModel.chosenReleaseDate == null
                          ? kTextGrey
                          : kBlack,
                  fontSize: getDynamicHeight(context, 0.018),
                  fontWeight: FontWeight.w500,
                ),
                fillColor: kTextGrey.withOpacity(0.05),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {},
            ),
          ),
        ),
      ],
    );
  }

  Widget _datePickerModal(
      BuildContext context, RoomViewModel viewModel, bool isEntry) {
    return Positioned(
      right: getDynamicWidth(context, 0.05),
      top: isEntry
          ? getDynamicHeight(context, 0.285)
          : getDynamicHeight(context, 0.355),
      child: Container(
        width: getDynamicWidth(context, 0.91),
        height: getDynamicHeight(context, 0.6),
        padding: EdgeInsets.only(
          top: getDynamicHeight(context, 0.035),
          bottom: getDynamicHeight(context, 0.01),
        ),
        margin: EdgeInsets.only(
          left: getDynamicWidth(context, 0.04),
        ),
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              offset: const Offset(-3, -2),
              blurRadius: 4,
              color: kTextGrey.withOpacity(.3),
              spreadRadius: 4,
            ),
          ],
        ),
        child: Column(
          children: [
            _datePickerHeader(context, viewModel, isEntry),
            _datePickerBody(context, viewModel, isEntry),
            _datePickerBottomField(context, viewModel, isEntry),
          ],
        ),
      ),
    );
  }

  Container _datePickerHeader(
      BuildContext context, RoomViewModel viewModel, bool isEntryDate) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: kDialogGrey),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              right: getDynamicWidth(context, 0.03),
              left: getDynamicWidth(context, 0.05),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEntryDate ? "Entry date" : "Release date",
                      style: GoogleFonts.roboto(
                        fontSize: getDynamicHeight(context, 0.018),
                        color: kMediumGreen,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    emptySpaceHeight(context, 0.01),
                    isEntryDate
                        ? viewModel.chosenEntryDate == null
                            ? Text(
                                " - ",
                                style: GoogleFonts.roboto(
                                  fontSize: getDynamicHeight(context, 0.026),
                                  color: kBlack,
                                  fontWeight: FontWeight.w400,
                                ),
                              )
                            : Text(
                                dateFormatterMonthDay(
                                    viewModel.chosenEntryDate),
                                style: GoogleFonts.roboto(
                                  fontSize: getDynamicHeight(context, 0.026),
                                  color: kBlack,
                                  fontWeight: FontWeight.w400,
                                ),
                              )
                        : viewModel.chosenReleaseDate == null
                            ? Text(
                                " - ",
                                style: GoogleFonts.roboto(
                                  fontSize: getDynamicHeight(context, 0.026),
                                  color: kBlack,
                                  fontWeight: FontWeight.w400,
                                ),
                              )
                            : Text(
                                dateFormatterMonthDay(
                                    viewModel.chosenReleaseDate),
                                style: GoogleFonts.roboto(
                                  fontSize: getDynamicHeight(context, 0.026),
                                  color: kBlack,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                  ],
                ),
                emptySpaceWidth(context, 0.01),
                GestureDetector(
                  onTap: () {
                    viewModel.datePickerResetButtonClicked(isEntryDate);
                  },
                  child: Icon(Icons.close,
                      color: kMediumGreen,
                      size: getDynamicHeight(context, 0.033)),
                ),
              ],
            ),
          ),
          emptySpaceHeight(context, 0.015),
        ],
      ),
    );
  }

  Container _datePickerBottomField(
      BuildContext context, RoomViewModel viewModel, bool isPurchaseDate) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: kDialogGrey),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            child: Text(
              "Cancel",
              style: GoogleFonts.roboto(
                color: kMediumGreen,
                fontWeight: FontWeight.w500,
                fontSize: getDynamicHeight(context, 0.018),
              ),
            ),
            onPressed: () {
              isPurchaseDate
                  ? viewModel.isEntryDatePickerClickedToggle()
                  : viewModel.isReleaseDatePickerClickedToggle();
            },
          ),
          TextButton(
            child: Text(
              "OK",
              style: GoogleFonts.roboto(
                color: kMediumGreen,
                fontWeight: FontWeight.w500,
                fontSize: getDynamicHeight(context, 0.018),
              ),
            ),
            onPressed: () {
              viewModel.datePickerOkButtonClicked(isPurchaseDate);
            },
          ),
        ],
      ),
    );
  }

  Expanded _datePickerBody(
      BuildContext context, RoomViewModel viewModel, bool isPurchaseDate) {
    return Expanded(
      child: CalendarDatePicker2(
        config: CalendarDatePicker2Config(
          currentDate: DateTime.now(),
          controlsTextStyle: GoogleFonts.roboto(
            fontSize: getDynamicHeight(context, 0.018),
            color: kMediumGreen,
            fontWeight: FontWeight.w500,
          ),
          dayTextStyle: GoogleFonts.roboto(
            fontSize: getDynamicHeight(context, 0.02),
            color: kBlack,
            fontWeight: FontWeight.w400,
          ),
          selectedDayTextStyle: GoogleFonts.roboto(
            color: kWhite,
            fontWeight: FontWeight.w400,
            fontSize: getDynamicHeight(context, 0.02),
          ),
          todayTextStyle: GoogleFonts.roboto(
            color: kBlack,
            fontWeight: FontWeight.w400,
            fontSize: getDynamicHeight(context, 0.02),
          ),
          selectedDayHighlightColor: kMediumGreen,
          selectedYearTextStyle: GoogleFonts.roboto(
            fontSize: getDynamicHeight(context, 0.018),
            color: kMediumGreen,
            fontWeight: FontWeight.w500,
          ),
          yearTextStyle: GoogleFonts.roboto(
            fontSize: getDynamicHeight(context, 0.02),
            color: kBlack,
            fontWeight: FontWeight.w400,
          ),
          weekdayLabelTextStyle: TextStyle(
            color: kMediumGreen,
            fontSize: getDynamicHeight(context, 0.02),
            fontWeight: FontWeight.w500,
          ),
        ),
        value: isPurchaseDate ? [viewModel.entryDate] : [viewModel.releaseDate],
        onValueChanged: (dates) {
          isPurchaseDate
              ? viewModel.setEntryDate = dates.first!
              : viewModel.setReleaseDate = dates.first!;
        },
      ),
    );
  }

  Row _roomNumAndClearButton(RoomViewModel viewModel, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Room Number: ${viewModel.room?.roomNumber}",
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontSize: getDynamicHeight(context, 0.019),
              letterSpacing: 0,
              fontWeight: FontWeight.w600),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: kErrorRed,
            minimumSize: Size(
                getDynamicWidth(context, 0.2), getDynamicHeight(context, 0.04)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          onPressed: () async {
            await viewModel.clearRoom();
          },
          child: Text(
            "Clear Room",
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontSize: getDynamicHeight(context, 0.015),
                letterSpacing: 0,
                color: kWhite,
                fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Row _header(BuildContext context, RoomViewModel viewModel) {
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
