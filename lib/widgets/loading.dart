import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'logo.dart';

Widget buildLoadingPlaceholder(
  BuildContext context, {
  Color textColor = const Color(0xFF101828),
  bool isVertical = true,
}) =>
    isVertical
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const ParkioLogo(),
              const SizedBox(height: 14.0),
              Text(
                AppLocalizations.of(context)!.loading,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const ParkioLogo(),
              const SizedBox(width: 14.0),
              Text(
                AppLocalizations.of(context)!.loading,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          );
