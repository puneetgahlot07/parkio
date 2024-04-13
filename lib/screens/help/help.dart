import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parkio/screens/help/faq.dart';
import 'package:parkio/util/color.dart';
import 'package:parkio/widgets/app_bar.dart';
import 'package:parkio/widgets/buttons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/snackbar.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final String phoneNumber = '+43 123 1234';
  final String email = 'support@parkio.com';

  Future<void> _callSupport() async {
    Uri numberUri = Uri(scheme: 'tel', path: phoneNumber);

    try {
      if (await canLaunchUrl(numberUri)) {
        await launchUrl(numberUri);
      } else {
        throw Future.error('Unable to make a call');
      }
    } catch (e) {
      final exceptionString = e.toString();
      final editedMessage = exceptionString.substring(
          exceptionString.indexOf(' '), exceptionString.length);
      if (!context.mounted) return;

      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          buildParkioSnackBar(
              'Unable to make a call'), // TODO: Add localized message
        );
    }
  }

  Future<void> _sendEmail() async {
    Uri emailUri = Uri(scheme: 'mailto', path: email);

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        throw Future.error('Unable to send an email');
      }
    } catch (e) {
      final exceptionString = e.toString();
      final editedMessage = exceptionString.substring(
          exceptionString.indexOf(' '), exceptionString.length);
      if (!context.mounted) return;

      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          buildParkioSnackBar(
              'Unable to send an email'), // TODO: Add localized message
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: parkioBackgroundGradient),
      child: Scaffold(
        appBar: ParkioAppBarWithLogo(
          asset: 'assets/ic_help.svg',
          title: AppLocalizations.of(context)!.menuHelpTitle,
        ),
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        body: SafeArea(
          top: true,
          child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(
                            AppLocalizations.of(context)!.helpSubtitle,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 24.0),
                          ParkioProceedButton(
                            asset: 'assets/ic_phone.svg',
                            text: phoneNumber,
                            textAlign: TextAlign.start,
                            onPressed: _callSupport,
                          ),
                          const SizedBox(height: 20.0),
                          ParkioProceedButton(
                            asset: 'assets/ic_mail.svg',
                            text: email,
                            textAlign: TextAlign.start,
                            onPressed: _sendEmail,
                          ),
                          const SizedBox(height: 20.0),
                          ParkioProceedButton(
                            asset: 'assets/ic_chat.svg',
                            text:
                                AppLocalizations.of(context)!.chatWithAssistant,
                            textAlign: TextAlign.start,
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32.0),
                    child: ParkioProceedButton(
                      text: AppLocalizations.of(context)!.faqTitle,
                      textAlign: TextAlign.start,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const FaqScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
