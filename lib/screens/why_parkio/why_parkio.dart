import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parkio/util/color.dart';
import 'package:parkio/widgets/app_bar.dart';

import '../fragment/why_parkio.dart';

class WhyParkioScreen extends StatefulWidget {
  const WhyParkioScreen({super.key});

  @override
  State<WhyParkioScreen> createState() => _WhyParkioScreenState();
}

class _WhyParkioScreenState extends State<WhyParkioScreen> {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: parkioBackgroundGradient),
      child: Scaffold(
        appBar: ParkioAppBarWithLogo(
          asset: 'assets/ic_why_parkio.svg',
          title: AppLocalizations.of(context)!.menuWhyParkioTitle,
        ),
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        body: const SafeArea(
          top: true,
          child: SizedBox(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [Expanded(child: WhyParkioFragment(showLogo: false))],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
