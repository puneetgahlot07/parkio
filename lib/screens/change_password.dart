import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parkio/model/password.dart';
import 'package:parkio/screens/home.dart';
import 'package:parkio/service/auth_service.dart';
import 'package:parkio/util/color.dart';
import 'package:parkio/widgets/app_bar.dart';
import 'package:parkio/widgets/buttons.dart';
import 'package:parkio/widgets/inputs.dart';
import 'package:parkio/widgets/logo.dart';
import 'package:parkio/widgets/snackbar.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();
  bool _isButtonEnabled = false;

  // Values for password inputs

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  Future<void> _createNewPassword() async {
    setState(() {
      _isLoading = true;
    });

    try {
      UpdatePasswordResponse response =
          await AuthService().updatePassword(_passwordController.text);

      setState(() {
        _isLoading = false;
      });

      if (response.requestSucceed == "true") {
        if (!context.mounted) return;

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ParkioHomeScreen(),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      final exceptionString = e.toString();
      final editedMessage = exceptionString.substring(
          exceptionString.indexOf(' '), exceptionString.length);
      if (!context.mounted) return;

      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          buildParkioSnackBar(editedMessage),
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
                          AppLocalizations.of(context)!.createNewPasswordTitle,
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
                        AppLocalizations.of(context)!.createNewPasswordSubtitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    onChanged: () => setState(() =>
                        _isButtonEnabled = _formKey.currentState!.validate()),
                    child: AutofillGroup(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.password,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 6, bottom: 20),
                            child: PasswordTextField(
                              controller: _passwordController,
                              autofillHints: const [AutofillHints.newPassword],
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return AppLocalizations.of(context)!
                                      .errorPasswordEmpty;
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          Text(
                            AppLocalizations.of(context)!.confirmPassword,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 6, bottom: 20),
                            child: PasswordTextField(
                              controller: _confirmPasswordController,
                              hint:
                                  AppLocalizations.of(context)!.confirmPassword,
                              autofillHints: const [AutofillHints.newPassword],
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return AppLocalizations.of(context)!
                                      .errorPasswordEmpty;
                                } else if (value != _passwordController.text) {
                                  return AppLocalizations.of(context)!
                                      .errorPasswordsShouldMatch;
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
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
                    text: AppLocalizations.of(context)!.confirm,
                    onPressed: _isButtonEnabled
                        ? () {
                            _createNewPassword();
                          }
                        : null,
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
