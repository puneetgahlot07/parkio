import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:parkio/util/payment.dart';
import 'package:parkio/widgets/buttons.dart';

class PaymentListItem extends StatefulWidget {
  final bool isDarkTheme;

  final String token;
  final bool isMain;
  final String lastDigits;
  final String type;
  final Function(String) onRadioClick;

  const PaymentListItem({
    super.key,
    this.isDarkTheme = true,
    required this.token,
    required this.isMain,
    required this.lastDigits,
    required this.type,
    required this.onRadioClick,
  });

  @override
  State<PaymentListItem> createState() => _PaymentListItemState();
}

class _PaymentListItemState extends State<PaymentListItem> {
  @override
  Widget build(BuildContext context) {
    String? paymentTypeAsset = assetFromPaymentType(widget.type);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 24,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (paymentTypeAsset != null)
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 16.0),
                  child: SizedBox(
                    height: 24.0,
                    child: SvgPicture.asset(
                      paymentTypeAsset,
                      height: 24.0,
                    ),
                  ),
                ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        '••• ${widget.lastDigits.substring(widget.lastDigits.length - 4)}',
                        style: TextStyle(
                          color: widget.isDarkTheme
                              ? Colors.white
                              : const Color(0xFF101828),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              // Radio button of main payment method
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ParkioRadioButton(
                      isChecked: widget.isMain,
                      onClick: () => widget.onRadioClick(widget.token),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
