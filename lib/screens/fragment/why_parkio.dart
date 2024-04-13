import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parkio/widgets/logo.dart';
import 'package:parkio/widgets/marked_list.dart';

class WhyParkioFragment extends StatefulWidget {
  final bool showLogo;

  const WhyParkioFragment({super.key, this.showLogo = true});

  @override
  State<WhyParkioFragment> createState() => _WhyParkioFragmentState();
}

class _WhyParkioFragmentState extends State<WhyParkioFragment> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.showLogo)
                  // Show PARKIO logo alongside 'Why PARKIO' title
                  Padding(
                    padding: const EdgeInsets.only(top: 56.0, bottom: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            AppLocalizations.of(context)!.whyParkioTitle,
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
                  )
                else
                  const SizedBox(height: 32.0),
                Column(
                  children: [
                    MarkedListElement(
                      text: AppLocalizations.of(context)!.whyParkioListElement1,
                    ),
                    const SizedBox(height: 20.0),
                    MarkedListElement(
                      text: AppLocalizations.of(context)!.whyParkioListElement2,
                    ),
                    const SizedBox(height: 20.0),
                    MarkedListElement(
                      text: AppLocalizations.of(context)!.whyParkioListElement3,
                    ),
                    const SizedBox(height: 20.0),
                    MarkedListElement(
                      text: AppLocalizations.of(context)!.whyParkioListElement4,
                    ),
                    const SizedBox(height: 20.0),
                    MarkedListElement(
                      text: AppLocalizations.of(context)!.whyParkioListElement5,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32.0),
            Text(
              AppLocalizations.of(context)!.whyParkioSubtitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 18.0),
            Text(
              AppLocalizations.of(context)!.whyParkioContent,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24.0),
          ],
        ),
      ],
    );
  }
}
