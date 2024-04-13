import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:parkio/widgets/vehicles/number_plate.dart';

import '../../util/text.dart';
import '../buttons.dart';

class OngoingParkingInfoCard extends StatefulWidget {
  final int id;
  final int code;
  final String address;
  final String name;
  final String endDate;
  final String? carName;
  final String numberPlate;
  final int totalCost;
  final Function(int)? onClick;

  const OngoingParkingInfoCard({
    super.key,
    required this.id,
    required this.code,
    required this.address,
    required this.name,
    required this.endDate,
    this.carName,
    required this.numberPlate,
    required this.totalCost,
    this.onClick,
  });

  @override
  State<OngoingParkingInfoCard> createState() => _OngoingParkingInfoCardState();
}

class _OngoingParkingInfoCardState extends State<OngoingParkingInfoCard>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12.0),
      onTap: () => widget.onClick != null ? widget.onClick!(widget.id) : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: ShapeDecoration(
          color: const Color(0x1AFFFFFF),
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1.0, color: Color(0x1AFFFFFF)),
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        child: Column(
          children: [
            _buildAreaInfo(),
            const SizedBox(height: 24.0),
            _buildAreaName(),
            const SizedBox(height: 24.0),
            _buildEndTime(),
            const SizedBox(height: 24.0),
            _buildCarInfo(),
            const SizedBox(height: 24.0),
            _buildCostInfo(),
          ],
        ),
      ),
    );
  }

  /// Row with info about parking area, such as code and address
  Widget _buildAreaInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          onClick:
              widget.onClick == null ? null : () => widget.onClick!(widget.id),
        ),
      ],
    );
  }

  /// Parking icon & parking area name
  Widget _buildAreaName() {
    return Row(
      children: [
        SvgPicture.asset('assets/ic_dest.svg', height: 24.0),
        const SizedBox(width: 6.0),
        Expanded(
          child: Text(
            widget.name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }

  /// Clock icon with end date and time
  Widget _buildEndTime() {
    DateTime tempDate =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(widget.endDate);
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SvgPicture.asset('assets/ic_clock_24.svg'),
        Text(
          AppLocalizations.of(context)!.parkingEndsOn(
            DateFormat("dd/MM/yy HH:mm").format(tempDate),
          ),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// Row which consists of car icon, car's name & car's number plate
  Widget _buildCarInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              SvgPicture.asset('assets/ic_car_horizontal_gradient.svg'),
              const SizedBox(width: 6.0),
              // Show car's name if it's not blank or null
              if (widget.carName?.isNotEmpty == true)
                Flexible(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(end: 16.0),
                    child: Text(
                      widget.carName!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
            ],
          ),
        ),
        NumberPlate(numberPlateSymbols: widget.numberPlate),
      ],
    );
  }

  /// Money icon and total cost of parking session
  Widget _buildCostInfo() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SvgPicture.asset('assets/ic_banknote.svg', width: 24.0),
        const SizedBox(width: 6.0),
        Text(
          formatCurrency(widget.totalCost / 100),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
