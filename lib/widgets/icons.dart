import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ModalHeaderLogo extends StatelessWidget {
  final String asset;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color contentColor;

  const ModalHeaderLogo({
    super.key,
    required this.asset,
    this.backgroundColor = const Color(0xFFFFFAEB),
    this.foregroundColor = const Color(0xFFFEF0C7),
    this.contentColor = const Color(0xFFDC6803),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      padding: const EdgeInsets.all(4),
      decoration: ShapeDecoration(
        color: foregroundColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 4,
            strokeAlign: BorderSide.strokeAlignCenter,
            color: backgroundColor,
          ),
          borderRadius: BorderRadius.circular(28),
        ),
      ),
      child: Center(
        child: SvgPicture.asset(
          asset,
          height: 16.0,
          width: 16.0,
          colorFilter: ColorFilter.mode(
            contentColor,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
