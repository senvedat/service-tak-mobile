import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:service_tak_mobile/utils/constants.dart';
import 'package:service_tak_mobile/utils/helper_methods.dart';
import 'package:service_tak_mobile/viewmodel/auth/login_viewmodel.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: Consumer<LoginViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
            backgroundColor: kTransparent,
            body: Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/login_bg.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  emptySpaceHeight(context, 0.1),
                  _logo(context),
                  emptySpaceHeight(context, 0.1),
                  _body(context, viewModel),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Padding _body(BuildContext context, LoginViewModel viewModel) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getDynamicWidth(context, 0.06),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Login",
              style: Theme.of(context).textTheme.displayMedium,
            ),
            emptySpaceHeight(context, 0.01),
            Text(
              "Enter your emails and password",
              style: Theme.of(context).textTheme.displaySmall,
            ),
            emptySpaceHeight(context, 0.04),
            InputField(
              controller: viewModel.emailController,
              isPassword: false,
            ),
            emptySpaceHeight(context, 0.03),
            InputField(
              controller: viewModel.passwordController,
              isPassword: true,
            ),
            emptySpaceHeight(context, 0.01),
            _rememberMe(context, viewModel),
            emptySpaceHeight(context, 0.03),
            _loginButton(context),
          ],
        ),
      ),
    );
  }

  Row _rememberMe(BuildContext context, LoginViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              height: getDynamicHeight(context, 0.03),
              width: getDynamicHeight(context, 0.02),
              child: Checkbox(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
                value: viewModel.isChecked,
                onChanged: (value) {
                  viewModel.toggleCheckbox();
                },
                activeColor: kMediumGreen,
              ),
            ),
            emptySpaceWidth(context, 0.015),
            Text(
              "Remember Me",
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    color: kBlack,
                  ),
            ),
          ],
        ),
        Text(
          "Forgot Password?",
          style: Theme.of(context).textTheme.displaySmall!.copyWith(
                color: kBlack,
              ),
        ),
      ],
    );
  }

  ElevatedButton _loginButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: kMediumGreen,
        minimumSize:
            Size(getDynamicWidth(context, 1), getDynamicHeight(context, 0.075)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      onPressed: () {},
      child: Text(
        "Log In",
        style: Theme.of(context).textTheme.labelLarge,
      ),
    );
  }

  Text _logo(BuildContext context) {
    return Text(
      textAlign: TextAlign.center,
      "SERVICE\nTAK",
      style: Theme.of(context).textTheme.displayLarge!.copyWith(
            color: kMediumGreen,
          ),
    );
  }
}

class InputField extends StatelessWidget {
  const InputField({
    super.key,
    required this.controller,
    required this.isPassword,
  });

  final TextEditingController controller;
  final bool isPassword;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isPassword ? "Password" : "Email",
          style: Theme.of(context).textTheme.displaySmall!.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        TextFormField(
          controller: controller,
          cursorColor: kMediumGreen,
          obscureText: isPassword,
          style: GoogleFonts.montserrat(
            color: kBlack,
            fontSize: getDynamicHeight(context, 0.018),
            fontWeight: FontWeight.w500,
          ),
          decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: kTextFieldUnderline),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: kMediumGreen),
            ),
          ),
        ),
      ],
    );
  }
}
