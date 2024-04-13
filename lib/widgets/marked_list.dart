import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../util/color.dart';

class MarkedListElement extends StatelessWidget {
  final String text;

  const MarkedListElement({super.key, this.text = ''});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShaderMask(
          shaderCallback: (rect) {
            return parkioGradient.createShader(rect);
          },
          blendMode: BlendMode.srcIn,
          child: SvgPicture.asset(
            'assets/ic_check_round.svg',
            height: 32.0,
          ),
        ),
        Container(width: 8.0),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        )
      ],
    );
  }
}
