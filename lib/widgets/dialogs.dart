import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parkio/widgets/logo.dart';
import 'package:parkio/widgets/text.dart';

class ParkioAlertDialog extends StatelessWidget {
  const ParkioAlertDialog({
    super.key,
    required this.title,
    this.style,
    this.onClick,
  });

  final String title;
  final TextStyle? style;
  final Function()? onClick;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 2, color: Color(0xD8EEEEF6)),
            borderRadius: BorderRadius.circular(12),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x07101828),
              blurRadius: 8,
              offset: Offset(0, 8),
              spreadRadius: -4,
            ),
            BoxShadow(
              color: Color(0x14101828),
              blurRadius: 24,
              offset: Offset(0, 20),
              spreadRadius: -4,
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [ParkioLogo()],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF101828),
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            TextWithLink(
              text: '{${AppLocalizations.of(context)!.continueButton}}',
              style: const TextStyle(
                color: Color(0xFF101828),
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              onTap: (_) {
                onClick == null ? null : onClick!();
              },
            ),
          ],
        ),
      ),
    );
  }
}
