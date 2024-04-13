import 'package:flutter/material.dart';

SnackBar buildParkioSnackBar(String text) {
  return SnackBar(
    content: Text(text),
    behavior: SnackBarBehavior.floating,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12.0)),
    ),
  );
}
