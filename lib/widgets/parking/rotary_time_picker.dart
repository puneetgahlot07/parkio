import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:parkio/util/color.dart';

class RotaryTimePicker extends StatefulWidget {
  final int? maxTime;
  final Function(int)? onTimeUpdate;
  final Function()? onPanEnd;

  const RotaryTimePicker({
    super.key,
    this.maxTime,
    this.onTimeUpdate,
    this.onPanEnd,
  });

  @override
  State<RotaryTimePicker> createState() => _RotaryTimePickerState();
}

class _RotaryTimePickerState extends State<RotaryTimePicker> {
  /// The current drag offset of the rotary dial.
  var _currentDragOffset = Offset.zero;

  /// The starting angle offset of the rotary dial.
  var _startAngleOffset = 0.0;

  double _startingDegree = 0.0;

  double _currentDegree = 0.0;

  /// The total amount of minutes
  int _minutesTotal = 0;

  /// The amount of minutes across one pan gesture
  int _minutesTemporary = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        return GestureDetector(
          onPanStart: (details) => _onPanStart(
            details,
            centerOffset(size(width)),
          ),
          onPanUpdate: (details) => _onPanUpdate(
            details,
            centerOffset(size(width)),
          ),
          onPanEnd: _onPanEnd,
          child: Stack(
            children: [
              Container(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                decoration: const ShapeDecoration(
                  shape: CircleBorder(),
                  gradient: parkioGradient,
                ),
              ),
              const Center(
                child: Image(image: AssetImage('assets/rotary_shadow.webp')),
              ),
              Transform.rotate(
                angle: math.atan2(
                  _currentDragOffset.dy,
                  _currentDragOffset.dx,
                ),
                child: const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Stack(
                      children: [
                        Image(image: AssetImage('assets/clock_marks.webp')),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onPanStart(DragStartDetails details, Offset centerOffset) {
    // calculate the initial drag offset.
    _currentDragOffset = details.localPosition - centerOffset;

    _startingDegree = math.atan2(_currentDragOffset.dy, _currentDragOffset.dx) *
        180 /
        math.pi;
  }

  void _onPanUpdate(DragUpdateDetails details, Offset centerOffset) {
    // Calculate the previous and current drag offsets.
    final previousOffset = _currentDragOffset;
    _currentDragOffset += details.delta;

    // Calculate and update the current rotation in degrees
    _currentDegree = math.atan2(_currentDragOffset.dy, _currentDragOffset.dx) *
        180 /
        math.pi;

    // Calculate the current and previous drag directions.
    final currentDirection = _currentDragOffset.direction;
    final previousDirection = previousOffset.direction;

    // Update the minutes counter with the new value
    final degreeDifference = _currentDegree - _startingDegree;
    if ((currentDirection - previousDirection).abs() > math.pi) {
      if (widget.onTimeUpdate != null) {
        currentDirection - previousDirection > 0
            ? _minutesTotal += ((-180 - _startingDegree) / 6).floor()
            : _minutesTotal += ((180 - _startingDegree) / 6).floor();
        _currentDegree > 0 ? _startingDegree = 180 : _startingDegree = -180;
        widget.onTimeUpdate!(_minutesTotal + _minutesTemporary);
      }
    } else {
      if (widget.onTimeUpdate != null) {
        _minutesTemporary = (degreeDifference / 6).floor();
        widget.onTimeUpdate!(_minutesTotal + _minutesTemporary);
      }
    }

    // If the minutes counter goes sub-zero, stop the spinner
    if (_minutesTotal + _minutesTemporary < 0) {
      setState(() => _minutesTotal = 0);

      if (widget.onTimeUpdate != null) {
        widget.onTimeUpdate!(_minutesTotal);
      }
      return;
    }

    // If the minutes counter goes over time limit, stop the spinner
    if (widget.maxTime != null) {
      if (_minutesTotal + _minutesTemporary > widget.maxTime!) {
        setState(() => _minutesTotal = widget.maxTime!);

        if (widget.onTimeUpdate != null) {
          widget.onTimeUpdate!(_minutesTotal);
        }
        return;
      }
    }

    // Calculate the new angle based on the current and previous
    // drag directions.
    final angle = _startAngleOffset + currentDirection - previousDirection;

    // Update the start angle offset to the new angle.
    setState(() => _startAngleOffset = angle);
  }

  void _onPanEnd(DragEndDetails details) {
    // Make the pan result permanent
    setState(() => _minutesTotal += _minutesTemporary);
    if (widget.onPanEnd != null) widget.onPanEnd!();
  }

  /// Computes the size of the rotary dial input based on the given width.
  Size size(double width) => Size(width, width);

  /// Computes the offset of the center of the rotary dial input based
  /// on its size.
  Offset centerOffset(Size size) => size.centerOffset;
}

/// An extension on [Size] providing utility methods related to size
/// and positioning.
extension SizeX on Size {
  /// Returns the center point of this [Size] as an [Offset].
  Offset get centerOffset => Offset(width / 2, height / 2);
}
