import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parkio/service/auth_service.dart';
import 'package:parkio/util/color.dart';
import 'package:parkio/widgets/buttons.dart';
import 'package:parkio/widgets/divider.dart';
import 'package:parkio/widgets/inputs.dart';
import 'package:parkio/widgets/logo.dart';
import 'package:parkio/widgets/snackbar.dart';
import 'package:parkio/widgets/switches.dart';
import 'package:parkio/widgets/text.dart';
import 'package:parkio/widgets/third_party_auth.dart';

import '../model/auth.dart';
import '../util/const.dart';
import 'create_account.dart';
import 'forgot_password.dart';
import 'otp_verification.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  // If value set to true, enable email input, enable phone input if false
  bool _isPhoneInput = false;
  bool _isLoading = false;

  // Values for email, phone and password inputs
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _logInWithEmail() async {
    setState(() {
      _isLoading = true;
    });

    try {
      AuthResponse response = await AuthService().logInWithEmail(
        emailController.text,
        passwordController.text,
      );

      setState(() {
        _isLoading = false;
      });

      if (response.requestSucceed == "true") {
        if (!context.mounted) return;

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OtpVerificationScreen(
              sessionType: SessionType.login,
              email: emailController.text,
              password: passwordController.text,
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
              exceptionString.indexOf(' '), exceptionString.length)),
        );
    }
  }

  Future<void> _registerWithPhone() async {
    _isLoading = true;

    try {
      AuthResponse response = await AuthService().registerWithPhone(
        phoneController.text,
        passwordController.text,
      );

      _isLoading = false;

      if (response.requestSucceed == "true") {
        if (!context.mounted) return;

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OtpVerificationScreen(
              sessionType: SessionType.registration,
              phone: phoneController.text,
              password: passwordController.text,
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
          buildParkioSnackBar(e
              .toString()
              .substring(exceptionString.indexOf(' '), exceptionString.length)),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: parkioBackgroundGradient),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          scrolledUnderElevation: 0.0,
        ),
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        body: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                      start: 24.0,
                      top: 0.0,
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
                                AppLocalizations.of(context)!.signInTitle,
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
                        Container(height: 24.0),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
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
                        Text(
                          AppLocalizations.of(context)!.password,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 6, bottom: 18),
                          child: PasswordTextField(
                            controller: passwordController,
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: TextWithLink(
                                text:
                                    '{${AppLocalizations.of(context)!.forgotPassword}}',
                                onTap: (text) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ForgotPasswordScreen()),
                                  );
                                },
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  height: null,
                                ),
                              ),
                            )
                          ],
                        ),
                        Container(height: 20.0),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(24.0, 6.0, 24.0, 32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24.0),
                        child: ParkioButton(
                          text: AppLocalizations.of(context)!.getStarted,
                          onPressed: () {
                            if (!_isPhoneInput &&
                                emailController.text.isEmpty) {
                              ScaffoldMessenger.of(context)
                                ..removeCurrentSnackBar()
                                ..showSnackBar(
                                  buildParkioSnackBar(
                                    AppLocalizations.of(context)!
                                        .errorEmailEmpty,
                                  ),
                                );
                            } else if (_isPhoneInput &&
                                phoneController.text.isEmpty) {
                              ScaffoldMessenger.of(context)
                                ..removeCurrentSnackBar()
                                ..showSnackBar(
                                  buildParkioSnackBar(
                                    AppLocalizations.of(context)!
                                        .errorPhoneEmpty,
                                  ),
                                );
                            } else if (passwordController.text.isEmpty) {
                              ScaffoldMessenger.of(context)
                                ..removeCurrentSnackBar()
                                ..showSnackBar(
                                  buildParkioSnackBar(
                                    AppLocalizations.of(context)!
                                        .errorPasswordEmpty,
                                  ),
                                );
                            } else {
                              _isPhoneInput
                                  ? _registerWithPhone()
                                  : _logInWithEmail();
                            }
                          },
                        ),
                      ),
                      DividerWithText(
                        text: AppLocalizations.of(context)!.orContinueWith,
                      ),
                      const SizedBox(height: 10.0),
                      const ThirdPartyAuthButtons(),
                      const SizedBox(height: 20.0),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.dontHaveAccount,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              color: Color(0xD8EEEEF6),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          TextWithLink(
                            text: '{${AppLocalizations.of(context)!.signUp}}',
                            style: const TextStyle(
                              color: Color(0xFFFFD077),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                            gradient: parkioGradient,
                            onTap: (text) {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const CreateAccountScreen(),
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
