import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parkio/util/color.dart';
import 'package:parkio/widgets/app_bar.dart';
import 'package:parkio/widgets/buttons.dart';
import 'package:parkio/widgets/inputs.dart';
import 'package:parkio/widgets/logo.dart';
import 'package:parkio/widgets/snackbar.dart';
import 'package:parkio/widgets/switches.dart';

import '../model/auth.dart';
import '../service/auth_service.dart';
import '../util/const.dart';
import 'otp_verification.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  // If value set to true, enable email input, enable phone input if false
  bool _isPhoneInput = false;
  bool _isLoading = false;

  // Values for email, phone and password inputs
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _resetPasswordWithEmail() async {
    _isLoading = true;

    try {
      AuthResponse response =
          await AuthService().resetPasswordWithEmail(emailController.text);

      _isLoading = false;

      if (response.requestSucceed == "true") {
        if (!context.mounted) return;

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OtpVerificationScreen(
              sessionType: SessionType.forgotPassword,
              email: emailController.text,
              token: response.verificationToken!,
            ),
          ),
        );
      }
    } catch (e) {
      final exceptionString = e.toString();
      if (!context.mounted) return;

      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          buildParkioSnackBar(exceptionString.substring(
              exceptionString.indexOf(' '), exceptionString.length - 1)),
        );
    }
  }

  Future<void> _resetPasswordWithPhone() async {
    setState(() {
      _isLoading = true;
    });

    try {
      AuthResponse response =
          await AuthService().resetPasswordWithPhone(phoneController.text);

      setState(() {
        _isLoading = false;
      });

      if (response.requestSucceed == "true") {
        if (!context.mounted) return;

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OtpVerificationScreen(
              sessionType: SessionType.forgotPassword,
              phone: phoneController.text,
              token: response.verificationToken!,
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      final exceptionString = e.toString();
      if (!context.mounted) return;

      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          buildParkioSnackBar(exceptionString.substring(
              exceptionString.indexOf(' '), exceptionString.length - 1)),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: parkioBackgroundGradient),
      child: Scaffold(
        appBar: const ParkioAppBar(),
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.only(
                start: 24.0,
                top: 56.0,
                end: 24.0,
                bottom: 32.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          AppLocalizations.of(context)!.forgotPasswordTitle,
                          softWrap: true,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const ParkioLogo(),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 14.0, bottom: 24.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppLocalizations.of(context)!.forgotPasswordSubtitle,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.email,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: ParkioSwitch(
                          value: _isPhoneInput,
                          activeColors: parkioGoldenColors,
                          inactiveColors: parkioGradientColors,
                          onChange: (value) {
                            setState(() {
                              _isPhoneInput = value;
                            });
                          },
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.phone,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6, bottom: 20),
                    child: _isPhoneInput
                        ? PhoneTextField(
                            controller: phoneController,
                          )
                        : MailTextField(
                            controller: emailController,
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(24.0, 6.0, 24.0, 32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: [
                  ParkioButton(
                    text: AppLocalizations.of(context)!.continueButton,
                    onPressed: () {
                      if (!_isPhoneInput && emailController.text.isEmpty) {
                        ScaffoldMessenger.of(context)
                          ..removeCurrentSnackBar()
                          ..showSnackBar(
                            buildParkioSnackBar(
                              AppLocalizations.of(context)!.errorEmailEmpty,
                            ),
                          );
                      } else if (_isPhoneInput &&
                          phoneController.text.isEmpty) {
                        ScaffoldMessenger.of(context)
                          ..removeCurrentSnackBar()
                          ..showSnackBar(
                            buildParkioSnackBar(
                              AppLocalizations.of(context)!.errorPhoneEmpty,
                            ),
                          );
                      } else {
                        _isPhoneInput
                            ? _resetPasswordWithPhone()
                            : _resetPasswordWithEmail();
                      }
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
