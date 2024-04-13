import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parkio/util/color.dart';
import 'package:parkio/widgets/app_bar.dart';
import 'package:parkio/widgets/text.dart';

import '../widgets/divider.dart';
import '../widgets/snackbar.dart';

class SharingScreen extends StatefulWidget {
  const SharingScreen({super.key});

  @override
  State<SharingScreen> createState() => _SharingScreenState();
}

class _SharingScreenState extends State<SharingScreen> {
  final promoCode = 'PARKIO001'; // TODO: Replace with fetched code

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: parkioBackgroundGradient),
      child: Scaffold(
        appBar: ParkioAppBarWithLogo(
          asset: 'assets/ic_star.svg',
          title: AppLocalizations.of(context)!.menuSharingTitle,
        ),
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
                            children: [
                              Flexible(
                                child: Text(
                                  'Give 5 SEK, take 100 SEK',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(height: 14.0),
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  'Share your promo code with friends and they’ll get 100 SEK to park with when they sign up!',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          DividerWithWidget(
                            child: TextWithLink(
                              text: '{$promoCode}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                              ),
                              onTap: (_) async {
                                await Clipboard.setData(
                                        ClipboardData(text: promoCode))
                                    .then((_) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    buildParkioSnackBar(
                                      "Code copied to clipboard",
                                    ),
                                  );
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
