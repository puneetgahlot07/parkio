import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:parkio/util/color.dart';

class BonusCounter extends StatelessWidget {
  final bool isActive;

  const BonusCounter({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: isActive ? Colors.white : const Color(0x1AFFFFFF),
        shape: isActive
            ? GradientOutlineInputBorder(
                gradient: parkioGradient,
                borderRadius: BorderRadius.circular(12.0),
              )
            : RoundedRectangleBorder(
                side: const BorderSide(width: 1, color: Colors.white),
                borderRadius: BorderRadius.circular(12.0),
              ),
      ),
      child: ShaderMask(
        shaderCallback: (rect) {
          return isActive
              ? parkioGradient.createShader(rect)
              : const LinearGradient(
                  colors: [Colors.transparent, Colors.transparent],
                  begin: Alignment.center,
                  end: Alignment.center,
                ).createShader(rect);
        },
        blendMode: BlendMode.srcIn,
        child: SvgPicture.asset(
          'assets/ic_check_round.svg',
          height: 26.0,
          width: 26.0,
        ),
      ),
    );
  }
}
