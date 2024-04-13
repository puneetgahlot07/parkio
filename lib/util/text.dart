import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

String formatCurrency(double sum) {
  return NumberFormat.currency(locale: 'sv_SE', symbol: 'SEK').format(sum);
}

String formatTime(BuildContext context, int minutes) {
  int displayHours = 0;
  int displayMinutes = minutes;

  if (minutes / 60 >= 1) {
    displayHours = (minutes / 60).floor();
    displayMinutes = minutes - displayHours * 60;
  }

  if (displayHours == 0) {
    return AppLocalizations.of(context)!.nMinutes(displayMinutes);
  } else {
    String formattedHours =
        displayHours < 10 ? "0$displayHours" : displayHours.toString();
    String formattedMinutes =
        displayMinutes < 10 ? "0$displayMinutes" : displayMinutes.toString();

    return AppLocalizations.of(context)!.nHoursMinutes(
      formattedHours,
      formattedMinutes,
    );
  }
}

String? getDayOfWeekNameByOrder(int order, BuildContext context) {
  switch (order) {
    case 1:
      return AppLocalizations.of(context)!.monday;
    case 2:
      return AppLocalizations.of(context)!.tuesday;
    case 3:
      return AppLocalizations.of(context)!.wednesday;
    case 4:
      return AppLocalizations.of(context)!.thursday;
    case 5:
      return AppLocalizations.of(context)!.friday;
    case 6:
      return AppLocalizations.of(context)!.saturday;
    case 7:
      return AppLocalizations.of(context)!.sunday;
    default:
      return null;
  }
}
