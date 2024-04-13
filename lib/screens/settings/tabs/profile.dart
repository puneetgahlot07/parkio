import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parkio/model/settings/update_profile.dart';
import 'package:parkio/screens/home.dart';
import 'package:parkio/screens/settings/verification.dart';
import 'package:parkio/service/user_settings_service.dart';
import 'package:parkio/util/const.dart';
import 'package:parkio/widgets/buttons.dart';
import 'package:parkio/widgets/divider.dart';
import 'package:parkio/widgets/inputs.dart';
import 'package:parkio/widgets/sheets.dart';
import 'package:parkio/widgets/snackbar.dart';

import '../../../service/auth_service.dart';
import '../../../widgets/text.dart';

class ProfileTab extends StatefulWidget {
  final Function(bool) onLoadingStateChange;
  final Function onProfileReload;
  final String firstName;
  final String lastName;
  final String address;
  final int? postCode;
  final String city;
  final String phoneNumber;
  final String email;

  const ProfileTab({
    super.key,
    required this.onLoadingStateChange,
    required this.onProfileReload,
    this.firstName = '',
    this.lastName = '',
    this.address = '',
    this.postCode,
    this.city = '',
    this.phoneNumber = '',
    this.email = '',
  });

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final TextStyle hintTextStyle = const TextStyle(
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  final _formKey = GlobalKey<FormState>();
  bool _isButtonEnabled = false;

  // Values for email, phone and password inputs

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Fill text field controllers with texts from the constructor
    firstNameController.text = widget.firstName;
    lastNameController.text = widget.lastName;
    addressController.text = widget.address;
    postalCodeController.text = widget.postCode?.toString() ?? '';
    cityController.text = widget.city;
    phoneNumberController.text = widget.phoneNumber;
    emailController.text = widget.email;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _updateProfile() async {
    widget.onLoadingStateChange(true);

    try {
      UpdateProfileResponse response =
          await UserSettingsService().updateProfile(
        firstNameController.text,
        lastNameController.text,
        addressController.text,
        postalCodeController.text,
        cityController.text,
      );

      widget.onLoadingStateChange(false);
      widget.onProfileReload();

      if (!context.mounted) return;
      if (response.requestSucceed == 'true') {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(
            buildParkioSnackBar(
              AppLocalizations.of(context)!.profileUpdatedSuccessfully,
            ),
          );
      }
    } catch (e) {
      widget.onLoadingStateChange(false);

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

  Future<void> _changePhoneNumber(String phoneNumber) async {
    widget.onLoadingStateChange(true);

    try {
      final response = await UserSettingsService().changePhoneNumber(
        phoneNumber,
      );

      widget.onLoadingStateChange(false);

      if (response.requestSucceed == 'true') {
        if (!context.mounted) return;

        Navigator.of(context).pop();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DataChangeVerificationScreen(
              phone: phoneNumber,
              token: response.verificationToken ?? '',
              target: response.target ?? '',
              sessionType: ChangeSessionType.changePhone,
            ),
          ),
        );
      }
    } catch (e) {
      widget.onLoadingStateChange(false);

      final exceptionString = e.toString();
      final editedMessage = exceptionString.substring(
          exceptionString.indexOf(' '), exceptionString.length);
      if (!context.mounted) return;

      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          buildParkioSnackBar(editedMessage),
        );

      Navigator.of(context).pop();
    }
  }

  Future<void> _changeEmail(String email) async {
    widget.onLoadingStateChange(true);

    try {
      final response = await UserSettingsService().changeEmail(email);

      widget.onLoadingStateChange(false);

      if (response.requestSucceed == 'true') {
        if (!context.mounted) return;

        Navigator.of(context).pop();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DataChangeVerificationScreen(
              email: email,
              token: response.verificationToken ?? '',
              target: response.target ?? '',
              sessionType: ChangeSessionType.changeEmail,
            ),
          ),
        );
      }
    } catch (e) {
      widget.onLoadingStateChange(false);

      final exceptionString = e.toString();
      final editedMessage = exceptionString.substring(
          exceptionString.indexOf(' '), exceptionString.length);
      if (!context.mounted) return;

      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          buildParkioSnackBar(editedMessage),
        );

      Navigator.of(context).pop();
    }
  }

  Future<void> _logOut() async {
    widget.onLoadingStateChange(true);

    try {
      await AuthService().logOut();

      widget.onLoadingStateChange(false);

      if (!context.mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const ParkioHomeScreen(),
          ),
          (Route<dynamic> route) => false);
    } catch (e) {
      widget.onLoadingStateChange(false);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(buildParkioSnackBar(e.toString()));
    }
  }

  Future<void> _deleteAccount() async {
    widget.onLoadingStateChange(true);

    try {
      await UserSettingsService().deleteProfile();

      widget.onLoadingStateChange(false);

      if (!context.mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const ParkioHomeScreen(),
          ),
          (Route<dynamic> route) => false);
    } catch (e) {
      widget.onLoadingStateChange(false);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(buildParkioSnackBar(e.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPersonalDataForm(),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32.0),
              child: Divider(
                height: 20,
                thickness: 0.5,
                indent: 0,
                endIndent: 0,
                color: Color(0xD8EEEEF6),
              ),
            ),
            _buildAccountDataColumn(),
            Padding(
              padding: const EdgeInsets.only(top: 32.0),
              child: _buildAccountActionButtons(),
            ),
          ],
        ),
      ),
    );
  }

  Form _buildPersonalDataForm() => Form(
        key: _formKey,
        onChanged: () => setState(
            () => _isButtonEnabled = _formKey.currentState!.validate()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutofillGroup(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.firstName,
                    style: hintTextStyle,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6, bottom: 20),
                    child: ParkioTextField(
                      controller: firstNameController,
                      hint: AppLocalizations.of(context)!.firstName,
                      keyboardType: TextInputType.name,
                      autofillHints: const [AutofillHints.givenName],
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)!.lastName,
                    style: hintTextStyle,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6, bottom: 20),
                    child: ParkioTextField(
                      controller: lastNameController,
                      hint: AppLocalizations.of(context)!.lastName,
                      keyboardType: TextInputType.name,
                      autofillHints: const [AutofillHints.familyName],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.postalCode,
                        style: hintTextStyle,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: ParkioTextField(
                          controller: postalCodeController,
                          hint: AppLocalizations.of(context)!.postalCode,
                          keyboardType: TextInputType.text,
                          autofillHints: const [AutofillHints.postalCode],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.city,
                        style: hintTextStyle,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: ParkioTextField(
                          controller: cityController,
                          hint: AppLocalizations.of(context)!.city,
                          keyboardType: TextInputType.streetAddress,
                          autofillHints: const [AutofillHints.sublocality],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Text(
              AppLocalizations.of(context)!.address,
              style: hintTextStyle,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6, bottom: 20),
              child: ParkioTextField(
                controller: addressController,
                hint: AppLocalizations.of(context)!.address,
                keyboardType: TextInputType.streetAddress,
                autofillHints: const [AutofillHints.streetAddressLine1],
              ),
            ),
            ParkioButton(
              text: AppLocalizations.of(context)!.saveChanges,
              onPressed: _isButtonEnabled ? _updateProfile : null,
            ),
          ],
        ),
      );

  Column _buildAccountDataColumn() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.phoneNumber,
            style: hintTextStyle,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6, bottom: 6),
            child: IgnorePointer(
              child: PhoneTextField(
                controller: phoneNumberController,
                showSuffixButton: false,
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: TextWithLink(
                  text: '{${AppLocalizations.of(context)!.changePhone}}',
                  onTap: (_) => {
                    showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return ChangePhoneModalSheet(
                          onContinue: (phone) => _changePhoneNumber(phone),
                        );
                      },
                    )
                  },
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 20.0),
          Text(
            AppLocalizations.of(context)!.email,
            style: hintTextStyle,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6, bottom: 6),
            child: IgnorePointer(
              child: MailTextField(
                controller: emailController,
                showSuffixButton: false,
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: TextWithLink(
                  text: '{${AppLocalizations.of(context)!.changeEmail}}',
                  onTap: (_) => {
                    showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return ChangeEmailModalSheet(
                          onContinue: (email) => _changeEmail(email),
                        );
                      },
                    )
                  },
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 20.0),
          Text(
            AppLocalizations.of(context)!.password,
            style: hintTextStyle,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6, bottom: 6),
            child: IgnorePointer(
              child: PasswordTextField(
                controller: TextEditingController(text: 'password'),
                showSuffixButton: false,
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: TextWithLink(
                  text: '{${AppLocalizations.of(context)!.changePassword}}',
                  onTap: (_) {},
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            ],
          ),
        ],
      );

  Column _buildAccountActionButtons() => Column(
        children: [
          DividerWithText(text: AppLocalizations.of(context)!.account),
          const SizedBox(height: 10.0),
          ParkioProceedButton(
            text: AppLocalizations.of(context)!.logOut,
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                builder: (context) {
                  return LogOutModalSheet(
                    onLogOut: _logOut,
                  );
                },
              );
            },
          ),
          const SizedBox(height: 20.0),
          ParkioProceedButton(
            text: AppLocalizations.of(context)!.deleteAccount,
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                builder: (context) {
                  return DeleteAccountModalSheet(
                    onDelete: _deleteAccount,
                  );
                },
              );
            },
          ),
        ],
      );
}
