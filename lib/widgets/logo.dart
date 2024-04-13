import 'package:flutter/material.dart';

class ParkioLogo extends StatefulWidget {
  const ParkioLogo({super.key});

  @override
  State<ParkioLogo> createState() => _ParkioLogoState();
}

class _ParkioLogoState extends State<ParkioLogo> with TickerProviderStateMixin {
  late AnimationController _controller;

  late Animation _firstCircleSize;
  late Animation _secondCircleSize;

  late Animation<Color?> _firstCircleColor;
  late Animation _secondCircleColor;

  final _firstCircleColorTweenSequence = TweenSequence([
    TweenSequenceItem(
      tween: ColorTween(
              begin: const Color(0xFFFFC384), end: const Color(0xFFFFC384))
          .chain(CurveTween(curve: Curves.easeInOut)),
      weight: 500,
    ),
    TweenSequenceItem(
      tween: ColorTween(
              begin: const Color(0xFFFFC384), end: const Color(0x66FFC384))
          .chain(CurveTween(curve: Curves.easeInOut)),
      weight: 500,
    ),
    TweenSequenceItem(
      tween: ColorTween(
              begin: const Color(0x66FFC384), end: const Color(0x66FFC384))
          .chain(CurveTween(curve: Curves.easeInOut)),
      weight: 500,
    ),
    TweenSequenceItem(
      tween: ColorTween(
              begin: const Color(0x66FFC384), end: const Color(0x66FFC384))
          .chain(CurveTween(curve: Curves.easeInOut)),
      weight: 200,
    ),
  ]);
  final _secondCircleColorTweenSequence = TweenSequence([
    TweenSequenceItem(
      tween: ColorTween(
              begin: const Color(0xFFFFC384), end: const Color(0x19FFC384))
          .chain(CurveTween(curve: Curves.easeInOut)),
      weight: 500,
    ),
    TweenSequenceItem(
      tween: ColorTween(
              begin: const Color(0x19FFC384), end: const Color(0x19FFC384))
          .chain(CurveTween(curve: Curves.easeInOut)),
      weight: 500,
    ),
    TweenSequenceItem(
      tween: ColorTween(begin: const Color(0x19FFC384), end: Colors.transparent)
          .chain(CurveTween(curve: Curves.easeInOut)),
      weight: 500,
    ),
    TweenSequenceItem(
      tween: ColorTween(begin: Colors.transparent, end: Colors.transparent)
          .chain(CurveTween(curve: Curves.easeInOut)),
      weight: 200,
    ),
  ]);

  final _firstCircleTweenSequence = TweenSequence([
    TweenSequenceItem(
      tween: Tween(begin: 14.0, end: 14.0)
          .chain(CurveTween(curve: Curves.easeInOut)),
      weight: 500.0,
    ),
    TweenSequenceItem(
      tween: Tween(begin: 14.0, end: 32.0)
          .chain(CurveTween(curve: Curves.easeInOut)),
      weight: 500.0,
    ),
    TweenSequenceItem(
      tween: Tween(begin: 32.0, end: 54.0)
          .chain(CurveTween(curve: Curves.easeInOut)),
      weight: 500.0,
    ),
    TweenSequenceItem(
      tween: Tween(begin: 54.0, end: 14.0)
          .chain(CurveTween(curve: Curves.easeInOut)),
      weight: 200.0,
    ),
  ]);
  final _secondCircleTweenSequence = TweenSequence([
    TweenSequenceItem(
      tween: Tween(begin: 14.0, end: 32.0)
          .chain(CurveTween(curve: Curves.easeInOut)),
      weight: 500.0,
    ),
    TweenSequenceItem(
      tween: Tween(begin: 32.0, end: 54.0)
          .chain(CurveTween(curve: Curves.easeInOut)),
      weight: 500.0,
    ),
    TweenSequenceItem(
      tween: Tween(begin: 54.0, end: 0.0)
          .chain(CurveTween(curve: Curves.easeInOut)),
      weight: 500.0,
    ),
    TweenSequenceItem(
      tween: Tween(begin: 0.0, end: 14.0)
          .chain(CurveTween(curve: Curves.easeInOut)),
      weight: 200.0,
    ),
  ]);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1700),
      vsync: this,
    );
    _firstCircleSize = _firstCircleTweenSequence.animate(_controller);
    _secondCircleSize = _secondCircleTweenSequence.animate(_controller);

    _firstCircleColor = _firstCircleColorTweenSequence.animate(_controller);
    _secondCircleColor = _secondCircleColorTweenSequence.animate(_controller);

    _controller
      ..repeat()
      ..addListener(() {
        if (mounted) {
          setState(() {
            if (_controller.isDismissed) {
              _controller.forward();
            }
          });
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 54.0,
      height: 54.0,
      child: Stack(
        children: [
          Center(
            child: Container(
              width: _firstCircleSize.value,
              height: _firstCircleSize.value,
              decoration: ShapeDecoration(
                color: _firstCircleColor.value,
                shape: const OvalBorder(),
              ),
            ),
          ),
          Center(
            child: Container(
              width: _secondCircleSize.value,
              height: _secondCircleSize.value,
              decoration: ShapeDecoration(
                color: _secondCircleColor.value,
                shape: const OvalBorder(),
              ),
            ),
          ),
          Center(
            child: Container(
              width: 14,
              height: 14,
              decoration: ShapeDecoration(
                color: const Color(0xFFFFC384),
                shape: OvalBorder(
                  side: BorderSide(
                    width: 0.50,
                    color: Colors.white.withOpacity(0.6000000238418579),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
