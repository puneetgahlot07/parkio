import 'package:flutter/material.dart';

class DividerWithText extends StatelessWidget {
  final String text;

  const DividerWithText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          const Expanded(
            child: Divider(
              height: 20,
              thickness: 0.5,
              indent: 0,
              endIndent: 0,
              color: Color(0xD8EEEEF6),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Expanded(
            child: Divider(
              height: 20,
              thickness: 0.5,
              indent: 0,
              endIndent: 0,
              color: Color(0xD8EEEEF6),
            ),
          ),
        ],
      ),
    );
  }
}

class DividerWithWidget extends StatelessWidget {
  final Widget child;

  const DividerWithWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Expanded(
            child: Divider(
              height: 20,
              thickness: 0.5,
              indent: 0,
              endIndent: 0,
              color: Color(0xD8EEEEF6),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: child,
          ),
          const Expanded(
            child: Divider(
              height: 20,
              thickness: 0.5,
              indent: 0,
              endIndent: 0,
              color: Color(0xD8EEEEF6),
            ),
          ),
        ],
      ),
    );
  }
}
