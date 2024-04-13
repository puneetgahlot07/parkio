import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:parkio/util/color.dart';
import 'package:parkio/widgets/text.dart';

import '../util/const.dart';

class ParkioButton extends StatefulWidget {
  final String text;
  final ButtonType type;
  final void Function()? onPressed;

  const ParkioButton({
    super.key,
    this.text = '',
    this.type = ButtonType.positive,
    required this.onPressed,
  });

  @override
  State<ParkioButton> createState() => _ParkioButtonState();
}

class _ParkioButtonState extends State<ParkioButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If the button is non-clickable
    // (or disabled by nullifying its onPressed method),
    // set buttonColor to gray 0xD8EEEEF6, otherwise determine it by button type
    final buttonColor = widget.onPressed == null
        ? const Color(0xD8EEEEF6)
        : {
            ButtonType.neutral: const Color(0xD9EFEEF6),
            ButtonType.negative: const Color(0xFFFB9EA0),
          }[widget.type];
    // If the button is non-clickable
    // (or disabled by nullifying its onPressed method),
    // set buttonColor to gray 0xFF667085, otherwise determine it by button type
    final textColor = widget.onPressed == null
        ? const Color(0xFF667085)
        : {
            ButtonType.neutral: const Color(0xFF2E3133),
            ButtonType.negative: Colors.white,
            ButtonType.positive: Colors.white,
          }[widget.type];
    final Gradient? buttonGradient =
        widget.onPressed == null ? null : parkioGradient;

    return FilledButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
      onPressed: widget.onPressed,
      child: Container(
        height: 58,
        decoration: ShapeDecoration(
          color: buttonColor,
          gradient: widget.type == ButtonType.positive ? buttonGradient : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: SizedBox(
          child: Center(
            child: Text(
              widget.text,
              style: TextStyle(
                color: textColor,
                fontSize: 20,
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ParkioIconButton extends StatefulWidget {
  final String asset;
  final VoidCallback onPressed;
  final Color backgroundColor;

  const ParkioIconButton({
    super.key,
    required this.asset,
    required this.onPressed,
    this.backgroundColor = const Color(0x1AFFFFFF),
  });

  @override
  State<ParkioIconButton> createState() => _ParkioIconButtonState();
}

class _ParkioIconButtonState extends State<ParkioIconButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all<Color>(widget.backgroundColor),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
      onPressed: widget.onPressed,
      child: Center(child: SvgPicture.asset(widget.asset)),
    );
  }
}

class MapIconButton extends StatefulWidget {
  final String asset;
  final VoidCallback onPressed;
  final Color backgroundColor;

  const MapIconButton({
    super.key,
    required this.asset,
    required this.onPressed,
    this.backgroundColor = const Color(0x1AFFFFFF),
  });

  @override
  State<MapIconButton> createState() => _MapIconButtonState();
}

class _MapIconButtonState extends State<MapIconButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      splashColor: Colors.white,
      focusColor: Colors.white,
      splashFactory: InkSplash.splashFactory,
      child: Container(
        width: 48.0,
        height: 48.0,
        decoration: ShapeDecoration(
          color: widget.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        child: Center(
          child: SvgPicture.asset(
            widget.asset,
          ),
        ),
      ),
    );
  }
}

class ParkioBackButton extends StatefulWidget {
  final String asset;
  final VoidCallback onPressed;

  const ParkioBackButton({
    super.key,
    required this.asset,
    required this.onPressed,
  });

  @override
  State<ParkioBackButton> createState() => _ParkioBackButtonState();
}

class _ParkioBackButtonState extends State<ParkioBackButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all<Color>(const Color(0x1AFFFFFF)),
        minimumSize: MaterialStateProperty.all<Size>(const Size(48.0, 48.0)),
        maximumSize: MaterialStateProperty.all<Size>(const Size(48.0, 48.0)),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.all(0.0)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
      onPressed: widget.onPressed,
      child: Center(
          child: SvgPicture.asset(
        widget.asset,
        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
      )),
    );
  }
}

class ParkioProceedButton extends StatefulWidget {
  final String? asset;
  final ColorFilter? colorFilter;
  final String text;
  final TextAlign textAlign;
  final VoidCallback onPressed;

  const ParkioProceedButton({
    super.key,
    this.asset,
    this.colorFilter = const ColorFilter.mode(Colors.white, BlendMode.srcIn),
    required this.text,
    this.textAlign = TextAlign.center,
    required this.onPressed,
  });

  @override
  State<ParkioProceedButton> createState() => _ParkioProceedButtonState();
}

class _ParkioProceedButtonState extends State<ParkioProceedButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all<Color>(const Color(0x1AFFFFFF)),
        minimumSize:
            MaterialStateProperty.all<Size>(const Size.fromHeight(48.0)),
        maximumSize:
            MaterialStateProperty.all<Size>(const Size.fromHeight(48.0)),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
      onPressed: widget.onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Show start picture if the asset address is not null
          if (widget.asset != null)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 8.0),
              child: SvgPicture.asset(
                widget.asset!,
                colorFilter: widget.colorFilter,
              ),
            ),
          Expanded(
            child: Text(
              widget.text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: widget.textAlign,
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 8.0),
            child: SvgPicture.asset('assets/ic_forward.svg'),
          )
        ],
      ),
    );
  }
}

class ParkioFilledButton extends StatefulWidget {
  final String? asset;
  final String text;
  final TextAlign textAlign;
  final VoidCallback onPressed;

  const ParkioFilledButton({
    super.key,
    this.asset,
    required this.text,
    this.textAlign = TextAlign.center,
    required this.onPressed,
  });

  @override
  State<ParkioFilledButton> createState() => _ParkioFilledButtonState();
}

class _ParkioFilledButtonState extends State<ParkioFilledButton> {
  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all<Color>(const Color(0x1AFFFFFF)),
        minimumSize:
            MaterialStateProperty.all<Size>(const Size.fromHeight(48.0)),
        maximumSize:
            MaterialStateProperty.all<Size>(const Size.fromHeight(48.0)),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
      onPressed: widget.onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Show start picture if the asset address is not null
          if (widget.asset != null)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 8.0),
              child: SvgPicture.asset(widget.asset!),
            ),
          Flexible(
            child: Text(
              widget.text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.ellipsis,
              ),
              textAlign: widget.textAlign,
            ),
          ),
        ],
      ),
    );
  }
}

class ParkioStartStopButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  const ParkioStartStopButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  State<ParkioStartStopButton> createState() => _ParkioStartStopButtonState();
}

class _ParkioStartStopButtonState extends State<ParkioStartStopButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: widget.onPressed,
      icon: SizedBox(
        width: 142.0,
        height: 142.0,
        child: Stack(
          children: [
            SvgPicture.asset('assets/start_stop_button.svg'),
            Center(
              child: GradientText(
                widget.text.toUpperCase(),
                gradient: parkioGradient,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ParkioRadioButton extends StatelessWidget {
  final bool isChecked;
  final Function() onClick;

  const ParkioRadioButton({
    super.key,
    required this.isChecked,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => isChecked ? null : onClick(),
      borderRadius: BorderRadius.circular(50.0),
      child: Container(
        width: 20,
        height: 20,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: isChecked ? null : Colors.white,
          gradient: isChecked ? parkioGradient : null,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Color(0xFFCFD4DC)),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Center(
          child: SvgPicture.asset('assets/ic_check.svg'),
        ),
      ),
    );
  }
}

class ParkioInfoButton extends StatelessWidget {
  final Function()? onClick;

  const ParkioInfoButton({
    super.key,
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 18.0,
      height: 18.0,
      child: IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        icon: SvgPicture.asset('assets/ic_info.svg', height: 18.0),
        onPressed: onClick,
      ),
    );
  }
}
