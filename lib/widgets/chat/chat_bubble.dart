import 'package:flutter/material.dart';
import 'package:parkio/util/color.dart';

class ChatBubble extends StatelessWidget {
  final bool isIncoming;
  final String text;

  const ChatBubble({super.key, required this.isIncoming, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isIncoming ? incomingMessageColor : outgoingMessageColor,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: ShapeDecoration(
          color: isIncoming ? incomingMessageColor : outgoingMessageColor,
          shape: RoundedRectangleBorder(
            // Set border radius for both incoming and outgoing messages
            borderRadius: BorderRadiusDirectional.only(
              topEnd: isIncoming ? const Radius.circular(8) : Radius.zero,
              bottomEnd: isIncoming ? const Radius.circular(8) : Radius.zero,
              topStart: !isIncoming ? const Radius.circular(8) : Radius.zero,
              bottomStart: !isIncoming ? const Radius.circular(8) : Radius.zero,
            ),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
