import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:parkio/widgets/switches.dart';
import 'package:parkio/widgets/vehicles/number_plate.dart';

import '../../util/text.dart';

class OngoingPermitInfoCard extends StatefulWidget {
  final int id;
  final int areaCode;
  final String address;
  final String areaName;
  final String startDate;
  final String endDate;
  final String? carName;
  final String numberPlate;
  final int totalCost;
  final bool renewalEnabled;
  final Function(bool) onRadioSwitch;

  const OngoingPermitInfoCard({
    super.key,
    required this.id,
    required this.areaCode,
    required this.address,
    required this.areaName,
    required this.startDate,
    required this.endDate,
    this.carName,
    required this.numberPlate,
    required this.totalCost,
    required this.renewalEnabled,
    required this.onRadioSwitch,
  });

  @override
  State<OngoingPermitInfoCard> createState() => _OngoingPermitInfoCardState();
}

class _OngoingPermitInfoCardState extends State<OngoingPermitInfoCard>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12.0),
      onTap: () => widget.onRadioSwitch(!widget.renewalEnabled),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Container(height: 1.0, color: const Color(0xD9EFEEF6)),
            ),
            _buildTimeInfo(),
            const SizedBox(height: 24.0),
            _buildCarInfo(),
            const SizedBox(height: 24.0),
            _buildCostInfo(),
            const SizedBox(height: 24.0),
            _buildRenewalSwitch(),
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
                  widget.areaCode.toString(),
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
      ],
    );
  }

  /// Parking icon & parking area name
  Widget _buildAreaName() {
    return Row(
      children: [
        SvgPicture.asset('assets/ic_dest.svg', height: 24.0),
        const SizedBox(width: 6.0),
        Text(
          widget.areaName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// Clock icon with end date and time
  Widget _buildTimeInfo() {
    return Column(
      children: [
        // Start date
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.permitFrom,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              widget.startDate,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18.0),
        // End date
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.permitUntil,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              widget.endDate,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppLocalizations.of(context)!.monthlyRate,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        Row(
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
        ),
      ],
    );
  }

  /// Switch that indicates whether tacit renewal is enabled or not. User can click it to change its state
  Widget _buildRenewalSwitch() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppLocalizations.of(context)!.tacitRenewal,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        ParkioSwitch(
          value: widget.renewalEnabled,
          onChange: widget.onRadioSwitch,
        ),
      ],
    );
  }
}
