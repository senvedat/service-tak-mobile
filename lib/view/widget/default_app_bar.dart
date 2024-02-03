import 'package:flutter/material.dart';
import 'package:service_tak_mobile/utils/constants.dart';
import 'package:service_tak_mobile/utils/helper_methods.dart';
import 'package:service_tak_mobile/utils/navigation_helper.dart';

class DefaultAppBar extends StatelessWidget {
  const DefaultAppBar(
      {super.key,
      required this.navigatorResult,
      required this.title,
      this.onPressed,
      this.isLogout = false});

  final String navigatorResult;
  final String title;
  final void Function()? onPressed;
  final bool isLogout;

  @override
  Widget build(BuildContext context) {
    return Stack(
      textDirection: !isLogout ? TextDirection.ltr : TextDirection.rtl,
      children: [
        Container(
          height: getDynamicHeight(context, 0.0385),
          padding: !isLogout
              ? EdgeInsets.only(left: getDynamicWidth(context, 0.05))
              : EdgeInsets.only(right: getDynamicWidth(context, 0.05)),
          child: GestureDetector(
            onTap: onPressed ??
                () {
                  navigatorPop(context, navigatorResult);
                },
            child: !isLogout
                ? Icon(
                    Icons.arrow_back_ios_new,
                    color: kBlack,
                    size: getDynamicWidth(context, 0.060),
                  )
                : Image.asset(
                    "assets/icons/forward.png",
                    height: getDynamicHeight(context, 0.0385),
                    width: getDynamicWidth(context, 0.05),
                  ),
          ),
        ),
        Positioned(
          child: SizedBox(
            height: getDynamicHeight(context, 0.0385),
            child: Center(
              child: Text(title,
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge!
                      .copyWith(color: kBlack, letterSpacing: 0)),
            ),
          ),
        )
      ],
    );
  }
}
