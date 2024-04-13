import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:parkio/model/auth.dart';
import 'package:parkio/model/verification.dart';
import 'package:parkio/screens/change_password.dart';
import 'package:parkio/screens/home.dart';
import 'package:parkio/service/auth_service.dart';
import 'package:parkio/util/color.dart';
import 'package:parkio/util/const.dart';
import 'package:parkio/widgets/buttons.dart';
import 'package:parkio/widgets/inputs.dart';
import 'package:parkio/widgets/logo.dart';
import 'package:parkio/widgets/text.dart';
import 'package:parkio/widgets/third_party_auth.dart';

import '../widgets/app_bar.dart';
import '../widgets/snackbar.dart';
import 'onboarding/add_vehicle.dart';

class OtpVerificationScreen extends StatefulWidget {
  final SessionType sessionType;
  final String? phone;
  final String? email;
  final String? password;
  final String token;

  const OtpVerificationScreen({
    super.key,
    required this.sessionType,
    this.phone,
    this.email,
    this.password,
    required this.token,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  late String _verificationToken;
  TextEditingController otpController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _verificationToken = widget.token;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _verify() async {
    setState(() {
      _isLoading = true;
    });

    try {
      VerificationResponse response = await AuthService().verify(
        widget.token,
        otpController.text,
        widget.sessionType.value,
      );

      setState(() {
        _isLoading = false;
      });

      if (response.requestSucceed == 'true') {
        if (!context.mounted) return;

        // Change behavior depending on session type that requires OTP verification
        switch (widget.sessionType) {
          case SessionType.registration:
            {
              await storage.write(
                key: StorageKey.accessToken.value,
                value: response.authTokens!.accessToken!,
              );
              await storage.write(
                key: StorageKey.refreshToken.value,
                value: response.authTokens!.refreshToken!,
              );

              if (!context.mounted) return;

              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const AddVehiclePage(),
                  ),
                  (Route<dynamic> route) => false);
            }
          case SessionType.login:
            {
              await storage.write(
                key: StorageKey.accessToken.value,
                value: response.authTokens!.accessToken!,
              );
              await storage.write(
                key: StorageKey.refreshToken.value,
                value: response.authTokens!.refreshToken!,
              );

              if (!context.mounted) return;

              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const ParkioHomeScreen(),
                  ),
                  (Route<dynamic> route) => false);
            }
          case SessionType.forgotPassword:
            {
              await storage.write(
                key: StorageKey.accessToken.value,
                value: response.authTokens!.accessToken!,
              );
              await storage.write(
                key: StorageKey.refreshToken.value,
                value: response.authTokens!.refreshToken!,
              );

              if (!context.mounted) return;

              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const ChangePasswordScreen(),
                ),
              );
            }
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (!context.mounted) return;

      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(buildParkioSnackBar(e.toString()));
    }
  }

  Future<void> _resendCode() async {
    setState(() {
      _isLoading = true;
    });

    try {
      late AuthResponse response;
      switch (widget.sessionType) {
        case SessionType.registration:
          {
            if ((widget.email ?? '').isEmpty) {
              response = await AuthService().registerWithPhone(
                widget.phone ?? '',
                widget.password ?? '',
              );
            } else {
              response = await AuthService().registerWithEmail(
                widget.email ?? '',
                widget.password ?? '',
              );
            }
          }
        case SessionType.login:
          {
            if ((widget.email ?? '').isEmpty) {
              response = await AuthService().logInWithPhone(
                widget.phone ?? '',
                widget.password ?? '',
              );
            } else {
              response = await AuthService().logInWithEmail(
                widget.email ?? '',
                widget.password ?? '',
              );
            }
          }
        case SessionType.forgotPassword:
          {
            if ((widget.email ?? '').isEmpty) {
              response = await AuthService().resetPasswordWithPhone(
                widget.phone ?? '',
              );
            } else {
              response = await AuthService().resetPasswordWithEmail(
                widget.email ?? '',
              );
            }
          }
      }

      setState(() {
        _isLoading = false;
      });

      if (response.requestSucceed == 'true') {
        if (response.verificationToken != null) {
          _verificationToken = response.verificationToken!;
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (!context.mounted) return;

      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(buildParkioSnackBar(e.toString()));
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
        body: SafeArea(
          top: true,
          child: SizedBox(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: 24.0,
                    top: 38.0,
                    end: 24.0,
                    bottom: 32.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .otpVerificationTitle,
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
                          SizedBox(
                            child: TextWithLink(
                              // Email shouldn't be null if phone == null, but for null-safety we double-check
                              text: widget.phone == null
                                  ? AppLocalizations.of(context)!
                                      .enterCodeFromEmail(
                                      widget.email == null ? '' : widget.email!,
                                    )
                                  : AppLocalizations.of(context)!
                                      .enterCodeFromPhone(
                                      widget.phone == null ? '' : widget.phone!,
                                    ),
                              gradient: parkioGoldenGradient,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              onTap: (_) {/*No action needed*/},
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 24.0, bottom: 14.0),
                            child: ParkioOtpTextField(
                              controller: otpController,
                            ),
                          ),
                          Center(
                            child: Text(
                              AppLocalizations.of(context)!.didntReceiveTheCode,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 2.0),
                          Center(
                            child: TextWithLink(
                              text: '{${AppLocalizations.of(context)!.resend}}',
                              onTap: (_) {
                                _resendCode();
                              },
                            ),
                          ),
                          Container(height: 58.0),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: ParkioButton(
                  text: AppLocalizations.of(context)!.verify,
                  onPressed: (){
                     Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const ParkioHomeScreen(),
                  ),
                  (Route<dynamic> route) => false);
                  },
                  // Old Code
                  // onPressed: _verify,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  children: [
                    const Expanded(
                      child: Divider(
                        height: 20,
                        thickness: 0.5,
                        indent: 0,
                        endIndent: 0,
                        color: Color(0xD8EEEEF6),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text(
                        AppLocalizations.of(context)!.orContinueWith,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Divider(
                        height: 20,
                        thickness: 0.5,
                        indent: 0,
                        endIndent: 0,
                        color: Color(0xD8EEEEF6),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10.0),
              const ThirdPartyAuthButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
