import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class CreditCard extends StatelessWidget {
  const CreditCard({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    String month = DateFormat('MM').format(now);
    String year = DateFormat('yy').format(now);

    return Container(
      padding: const EdgeInsets.all(24),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white.withOpacity(0.10000000149011612),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 27,
                  height: 22,
                  child: SvgPicture.asset('assets/ic_card_chip.svg'),
                ),
                const SizedBox(width: 174),
                Container(
                  width: 27,
                  height: 18,
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignCenter,
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  child: SvgPicture.asset('assets/ic_credit_card.svg'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '•••',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.90,
                  ),
                ),
                TextSpan(
                  text: '  ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.90,
                  ),
                ),
                TextSpan(
                  text: '•••  •••',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.90,
                  ),
                ),
                TextSpan(
                  text: '  1234',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.90,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.expirationDate,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '$month/$year',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Text(
                  'CVV',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            AppLocalizations.of(context)!.cardholderName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
