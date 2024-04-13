import 'package:flutter/material.dart';
import 'package:parkio/util/color.dart';

class TextWithLink extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Gradient gradient;
  static final regex = RegExp("(?={)|(?<=})");
  final Function(String)? onTap;

  const TextWithLink({
    super.key,
    required this.text,
    this.style = const TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    this.gradient = parkioGradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final split = text.split(regex);
    return RichText(
      text: TextSpan(
        children: <InlineSpan>[
          for (String text in split)
            text.startsWith('{')
                ? WidgetSpan(
                    alignment: PlaceholderAlignment.top,
                    child: GestureDetector(
                      onTap: onTap == null
                          ? null
                          : () => onTap!(text.substring(1, text.length - 1)),
                      child: GradientText(
                        text.substring(1, text.length - 1),
                        gradient: onTap == null
                            ? const LinearGradient(
                                colors: [
                                  Color(0xFF7F8186),
                                  Color(0xFF7F8186),
                                ],
                              )
                            : gradient,
                        style: style,
                      ),
                    ),
                  )
                : TextSpan(text: text, style: style),
        ],
      ),
    );
  }
}

class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    super.key,
    required this.gradient,
    this.style,
  });

  final String text;
  final TextStyle? style;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text, style: style?.copyWith(height: null)),
    );
  }
}
