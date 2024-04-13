import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'buttons.dart';

class ParkingAreaInfo extends StatefulWidget {
  final int id;
  final int code;
  final String address;
  final String description;
  final Function(int)? onInfoButtonClick;
  final Function(int, int, String)? onClick;

  const ParkingAreaInfo({
    super.key,
    required this.id,
    required this.code,
    required this.address,
    required this.description,
    this.onInfoButtonClick,
    this.onClick,
  });

  @override
  State<ParkingAreaInfo> createState() => _ParkingAreaInfoState();
}

class _ParkingAreaInfoState extends State<ParkingAreaInfo>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.onClick != null
          ? widget.onClick!(widget.id, widget.code, widget.address)
          : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: ShapeDecoration(
          color: const Color(0x1AFFFFFF),
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Color(0x1AFFFFFF)),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: ShapeDecoration(
                          color: const Color(0x1AFFFFFF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: Text(
                          widget.code.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          widget.address,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                ParkioInfoButton(
                  onClick: widget.onInfoButtonClick == null
                      ? null
                      : () {
                          widget.onInfoButtonClick!(widget.id);
                        },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/ic_dest.svg', height: 24.0),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    widget.description,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
