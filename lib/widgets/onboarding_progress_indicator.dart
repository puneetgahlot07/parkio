import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:parkio/util/color.dart';

class OnboardingProgressIndicator extends StatelessWidget {
  final int pageIndex;

  const OnboardingProgressIndicator({super.key, this.pageIndex = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: ShapeDecoration(
        color: const Color(0x1AFFFFFF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Row(children: [
            Expanded(
              flex: pageIndex + 1,
              child: Container(
                height: 32,
                decoration: ShapeDecoration(
                  color: const Color(0x4DFFFFFF),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
            Expanded(
              flex: 2 - pageIndex,
              child: Container(
                color: Colors.transparent,
              ),
            )
          ]),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: ShaderMask(
                  shaderCallback: (rect) {
                    return parkioGradient.createShader(rect);
                  },
                  blendMode: BlendMode.srcIn,
                  child: SvgPicture.asset(
                    'assets/ic_car.svg',
                    height: 18.0,
                  ),
                ),
              ),
              Expanded(
                child: ShaderMask(
                  shaderCallback: (rect) {
                    return pageIndex > 0
                        ? parkioGradient.createShader(rect)
                        : const LinearGradient(
                            colors: [Colors.white, Colors.white],
                            begin: Alignment.center,
                            end: Alignment.center,
                          ).createShader(rect);
                  },
                  blendMode: BlendMode.srcIn,
                  child: SvgPicture.asset(
                    'assets/ic_card.svg',
                    height: 18.0,
                  ),
                ),
              ),
              Expanded(
                child: ShaderMask(
                  shaderCallback: (rect) {
                    return pageIndex > 1
                        ? parkioGradient.createShader(rect)
                        : const LinearGradient(
                            colors: [Colors.white, Colors.white],
                            begin: Alignment.center,
                            end: Alignment.center,
                          ).createShader(rect);
                  },
                  blendMode: BlendMode.srcIn,
                  child: SvgPicture.asset(
                    'assets/ic_check_round.svg',
                    height: 18.0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
