import 'package:flutter/material.dart';

class NumberPlate extends StatelessWidget {
  final String numberPlateSymbols;
  final bool isDarkTheme;

  const NumberPlate({
    super.key,
    required this.numberPlateSymbols,
    this.isDarkTheme = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: ShapeDecoration(
        color: isDarkTheme ? const Color(0x1AFFFFFF) : const Color(0xFFD0D5DD),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            numberPlateSymbols,
            style: TextStyle(
              color: isDarkTheme ? Colors.white : const Color(0xFF667085),
              fontWeight: isDarkTheme ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
