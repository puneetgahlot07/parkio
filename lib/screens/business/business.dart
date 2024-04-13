import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parkio/util/color.dart';
import 'package:parkio/widgets/buttons.dart';
import 'package:parkio/widgets/inputs.dart';

import '../../widgets/app_bar.dart';

class BusinessScreen extends StatefulWidget {
  const BusinessScreen({
    super.key,
  });

  @override
  State<BusinessScreen> createState() => _BusinessScreenState();
}

class _BusinessScreenState extends State<BusinessScreen> {
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();
  bool _isButtonEnabled = false;

  // Values for inputs
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _continue() {
    // TODO: Add 'Continue' button functionality
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: parkioBackgroundGradient),
      child: Scaffold(
        appBar: ParkioAppBarWithLogo(
          asset: 'assets/ic_business.svg',
          title: AppLocalizations.of(context)!.menuBusinessTitle,
        ),
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        body: SafeArea(
          top: true,
          bottom: true,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          24.0, 6.0, 24.0, 20.0),
                      child: Column(
                        children: [
                          Text(
                            AppLocalizations.of(context)!.businessSubtitle,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 24.0),
                          Form(
                            key: _formKey,
                            onChanged: () => setState(() => _isButtonEnabled =
                                _formKey.currentState!.validate()),
                            child: AutofillGroup(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // First name Input
                                  Text(
                                    AppLocalizations.of(context)!.firstName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 6, bottom: 20),
                                    child: ParkioTextField(
                                      controller: _firstNameController,
                                      hint: AppLocalizations.of(context)!
                                          .firstName,
                                      autofillHints: const [
                                        AutofillHints.givenName
                                      ],
                                      keyboardType: TextInputType.name,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return AppLocalizations.of(context)!
                                              .errorFirstNameEmpty;
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                  ),
                                  // last name Input
                                  Text(
                                    AppLocalizations.of(context)!.lastName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 6, bottom: 20),
                                    child: ParkioTextField(
                                      controller: _lastNameController,
                                      hint: AppLocalizations.of(context)!
                                          .lastName,
                                      autofillHints: const [
                                        AutofillHints.familyName
                                      ],
                                      keyboardType: TextInputType.name,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return AppLocalizations.of(context)!
                                              .errorLastNameEmpty;
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                  ),
                                  // Company name Input
                                  Text(
                                    AppLocalizations.of(context)!.companyName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 6, bottom: 20),
                                    child: ParkioTextField(
                                      controller: _companyNameController,
                                      hint: AppLocalizations.of(context)!
                                          .companyName,
                                      keyboardType: TextInputType.text,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return AppLocalizations.of(context)!
                                              .errorCompanyNameEmpty;
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                  ),
                                  // Email Input
                                  Text(
                                    AppLocalizations.of(context)!.email,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 6, bottom: 20),
                                    child: ParkioTextField(
                                      controller: _emailController,
                                      hint: AppLocalizations.of(context)!.email,
                                      autofillHints: const [
                                        AutofillHints.email
                                      ],
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return AppLocalizations.of(context)!
                                              .errorEmailEmpty;
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(24.0, 6.0, 24.0, 32.0),
                child: ParkioButton(
                  text: AppLocalizations.of(context)!.continueButton,
                  onPressed: _isButtonEnabled ? _continue : null,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
