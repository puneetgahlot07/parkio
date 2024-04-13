import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:parkio/model/settings/change_sensitive_data.dart';
import 'package:parkio/model/settings/verify_update.dart';
import 'package:parkio/screens/settings/settings.dart';
import 'package:parkio/service/user_settings_service.dart';
import 'package:parkio/util/color.dart';
import 'package:parkio/util/const.dart';
import 'package:parkio/widgets/buttons.dart';
import 'package:parkio/widgets/inputs.dart';
import 'package:parkio/widgets/text.dart';

import '../../widgets/app_bar.dart';
import '../../widgets/snackbar.dart';

class DataChangeVerificationScreen extends StatefulWidget {
  final ChangeSessionType sessionType;
  final String target;
  final String? phone;
  final String? email;
  final String? password;
  final String token;

  const DataChangeVerificationScreen({
    super.key,
    required this.sessionType,
    required this.target,
    this.phone,
    this.email,
    this.password,
    required this.token,
  });

  @override
  State<DataChangeVerificationScreen> createState() =>
      _DataChangeVerificationScreenState();
}

class _DataChangeVerificationScreenState
    extends State<DataChangeVerificationScreen> {
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
      VerifyUpdateResponse response = await UserSettingsService().verifyUpdate(
        _verificationToken,
        otpController.text,
        widget.sessionType.value,
      );

      setState(() {
        _isLoading = false;
      });

      if (response.requestSucceed == 'true') {
        // Show snack bar about successful update...
        if (!context.mounted) return;

        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(buildParkioSnackBar(
              AppLocalizations.of(context)!.profileUpdatedSuccessfully));

        // ...Then navigate back and "refresh" Settings screen
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const SettingsScreen()),
        );
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
      late ChangeProfileDataResponse response;
      switch (widget.sessionType) {
        case ChangeSessionType.changeEmail:
          {
            response =
                await UserSettingsService().changeEmail(widget.email ?? '');
          }
        case ChangeSessionType.changePhone:
          {
            response = await UserSettingsService()
                .changePhoneNumber(widget.phone ?? '');
          }
        case ChangeSessionType.changePassword:
          {
            response = await UserSettingsService()
                .changePassword(widget.password ?? '');
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
        appBar: ParkioAppBarWithLogo(
          title: AppLocalizations.of(context)!.otpVerificationTitle,
        ),
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        body: SafeArea(
          top: true,
          child: Padding(
            padding: const EdgeInsetsDirectional.only(
              start: 24.0,
              top: 14.0,
              end: 24.0,
              bottom: 32.0,
            ),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                child: TextWithLink(
                                  // Email shouldn't be null if phone == null, but for null-safety we double-check
                                  text: AppLocalizations.of(context)!
                                      .enterCodeFromUnknownTargetType(
                                          widget.target),
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
                                padding: const EdgeInsets.only(
                                    top: 24.0, bottom: 14.0),
                                child: ParkioOtpTextField(
                                  controller: otpController,
                                ),
                              ),
                              Center(
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .didntReceiveTheCode,
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
                                  text:
                                      '{${AppLocalizations.of(context)!.resend}}',
                                  onTap: (_) {
                                    _resendCode();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: ParkioButton(
                    text: AppLocalizations.of(context)!.verify,
                    onPressed: () => _verify(),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
