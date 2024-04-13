import 'package:flutter/material.dart';
import 'package:parkio/util/color.dart';

import 'logo.dart';

class ParkioSwitch extends StatefulWidget {
  final bool value;
  final bool isLoading;
  final Function(bool)? onChange;
  final List<Color> activeColors;
  final List<Color> inactiveColors;

  const ParkioSwitch({
    super.key,
    required this.value,
    this.isLoading = false,
    required this.onChange,
    this.activeColors = parkioGradientColors,
    this.inactiveColors = const [Color(0xFFF2F3F6), Color(0xFFF2F3F6)],
  });

  @override
  State<ParkioSwitch> createState() => _ParkioSwitchState();
}

class _ParkioSwitchState extends State<ParkioSwitch>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isLoading
          ? null
          : widget.onChange == null
              ? null
              : () => widget.onChange!(!widget.value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: 36.0,
        height: 20.0,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          gradient: LinearGradient(
            begin: const Alignment(-1.00, -0.03),
            end: const Alignment(1, 0.03),
            colors: widget.value ? widget.activeColors : widget.inactiveColors,
          ),
        ),
        child: AnimatedAlign(
          alignment:
              widget.value ? Alignment.centerRight : Alignment.centerLeft,
          duration: const Duration(milliseconds: 100),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: widget.isLoading
                ? const SizedBox(height: 16.0, child: ParkioLogo())
                : Container(
                    width: 16.0,
                    height: 16.0,
                    decoration: const ShapeDecoration(
                      color: Colors.white,
                      shape: OvalBorder(),
                      shadows: [
                        BoxShadow(
                          color: Color(0x0F101828),
                          blurRadius: 2,
                          offset: Offset(0, 1),
                          spreadRadius: 0,
                        ),
                        BoxShadow(
                          color: Color(0x19101828),
                          blurRadius: 3,
                          offset: Offset(0, 1),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
