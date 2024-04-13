import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parkio/util/color.dart';
import 'package:parkio/widgets/app_bar.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: parkioBackgroundGradient),
      child: Scaffold(
        appBar: ParkioAppBarWithLogo(
          title: AppLocalizations.of(context)!.faqTitle,
        ),
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        body: const SafeArea(
          top: true,
          child: SizedBox(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Center(
                child: Text('FAQ content'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
