import 'package:flutter/material.dart';

const List<Color> parkioGradientColors = [
  Color(0xFFD18EE8),
  Color(0xFFD18EE8),
  Color(0xFFFFA1A2),
  Color(0xFFFFD077)
];
List<Color> parkioDisabledGradientColors = [
  const Color(0xFFD18EE8).withOpacity(0.3),
  const Color(0xFFD18EE8).withOpacity(0.3),
  const Color(0xFFFFA1A2).withOpacity(0.3),
  const Color(0xFFFFD077).withOpacity(0.3)
];
const List<Color> parkioGoldenColors = [
  Color(0xFFFFEB86),
  Color(0xFFFBBF62),
  Color(0xFFFDB074),
  Color(0xFFF8F04E)
];
const List<Color> parkioBackgroundColors = [
  Color(0xFF33363A),
  Color(0xFF1F2022)
];

const parkioGradient = LinearGradient(
  begin: Alignment(-1.00, -0.03),
  end: Alignment(1.00, 0.03),
  colors: parkioGradientColors,
);
Gradient parkioDisabledGradient = LinearGradient(
  begin: const Alignment(-1.00, -0.03),
  end: const Alignment(1.00, 0.03),
  colors: parkioDisabledGradientColors,
);
const Gradient parkioGoldenGradient = LinearGradient(
  begin: Alignment(-1.00, -0.03),
  end: Alignment(1, 0.03),
  colors: parkioGoldenColors,
);
const Gradient parkioBackgroundGradient = LinearGradient(
  begin: Alignment(0.69, -0.73),
  end: Alignment(-0.69, 0.73),
  colors: parkioBackgroundColors,
);

const Color outgoingMessageColor = Color(0xFF667085);
const Color incomingMessageColor = Color(0x33FFFFFF);
