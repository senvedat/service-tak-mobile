// custom_theme.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:service_tak_mobile/utils/constants.dart';
import 'package:service_tak_mobile/utils/helper_methods.dart'; // Eğer kullanmıyorsanız Google Fonts kütüphanesini ekleyin.

ThemeData customTheme(BuildContext context) {
  return ThemeData(
    textTheme: TextTheme(
      displayLarge: GoogleFonts.montserrat(
        color: kWhite,
        fontSize: getDynamicHeight(context, 0.026),
        letterSpacing: 8,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: GoogleFonts.montserrat(
        color: kBlack,
        fontSize: getDynamicHeight(context, 0.034),
        fontWeight: FontWeight.w400,
      ),
      displaySmall: GoogleFonts.montserrat(
        color: kTextGrey,
        fontSize: getDynamicHeight(context, 0.018),
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: GoogleFonts.montserrat(
        color: kBlack,
        fontSize: getDynamicHeight(context, 0.022),
        fontWeight: FontWeight.w500,
      ),
      bodySmall: GoogleFonts.montserrat(
        color: kBlack,
        fontSize: getDynamicHeight(context, 0.018),
        fontWeight: FontWeight.w500,
      ),
      labelLarge: GoogleFonts.montserrat(
        color: kWhite,
        fontSize: getDynamicHeight(context, 0.02),
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
