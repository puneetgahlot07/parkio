import 'package:flutter/material.dart';

class AreaCode extends StatelessWidget {
  final int areaCode;
  final bool isDarkTheme;

  const AreaCode({
    super.key,
    required this.areaCode,
    this.isDarkTheme = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24.0,
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: ShapeDecoration(
        color: isDarkTheme ? const Color(0x1AFFFFFF) : const Color(0xFFD0D5DD),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            areaCode.toString(),
            style: TextStyle(
              color: isDarkTheme ? Colors.white : const Color(0xFF667085),
              fontSize: 14,
              fontWeight: isDarkTheme ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
