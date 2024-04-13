import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parkio/util/color.dart';
import 'package:parkio/widgets/onboarding_progress_indicator.dart';

import '../../widgets/buttons.dart';
import '../fragment/why_parkio.dart';
import '../home.dart';

class WhyParkioPage extends StatefulWidget {
  const WhyParkioPage({super.key});

  @override
  State<WhyParkioPage> createState() => _WhyParkioPageState();
}

class _WhyParkioPageState extends State<WhyParkioPage> {
  @override
  void initState() => super.initState();

  @override
  void dispose() => super.dispose();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: parkioBackgroundGradient),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 66.0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          scrolledUnderElevation: 0.0,
          title: const Padding(
            padding: EdgeInsets.only(top: 18.0),
            child: OnboardingProgressIndicator(pageIndex: 2),
          ),
        ),
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        body: SafeArea(
          top: true,
          child: SizedBox(
            child: Padding(
              padding: const EdgeInsetsDirectional.only(
                start: 24.0,
                end: 24.0,
                bottom: 32.0,
              ),
              child: Column(
                children: [
                  const Expanded(child: WhyParkioFragment()),
                  Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Column(
                      children: [
                        ParkioButton(
                          text: AppLocalizations.of(context)!.continueButton,
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => const ParkioHomeScreen(),
                              ),
                              (route) => false,
                            );
                          },
                        ),
                      ],
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
