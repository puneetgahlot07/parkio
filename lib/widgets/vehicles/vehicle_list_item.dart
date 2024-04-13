import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:parkio/widgets/buttons.dart';

import 'number_plate.dart';

class VehicleListItem extends StatefulWidget {
  final bool isDarkTheme;
  final int id;
  final bool isMain;
  final String carModel;
  final String? carName;
  final String numberPlate;
  final Function(int) onRadioClick;

  const VehicleListItem({
    super.key,
    this.isDarkTheme = true,
    required this.id,
    required this.isMain,
    this.carModel =
        '', // TODO: Replace when there will car recognition API integration
    this.carName,
    required this.numberPlate,
    required this.onRadioClick,
  });

  @override
  State<VehicleListItem> createState() => _VehicleListItemState();
}

class _VehicleListItemState extends State<VehicleListItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 24,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Row of car icon and car name/model
              _buildCarIcon(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: _buildCarName(),
                ),
              ),
              // Row of number plate symbols and radio button of main vehicle
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  NumberPlate(
                    numberPlateSymbols: widget.numberPlate,
                    isDarkTheme: widget.isDarkTheme,
                  ),
                  const SizedBox(width: 12.0),
                  ParkioRadioButton(
                    isChecked: widget.isMain,
                    onClick: () => widget.onRadioClick(widget.id),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCarIcon() {
    return SizedBox(
      height: 32.0,
      width: 32.0,
      child: widget.isDarkTheme
          ? Transform.rotate(
              angle: math.pi / 2,
              alignment: AlignmentDirectional.center,
              child: SvgPicture.asset(
                'assets/ic_car_topdown.svg',
                height: 32.0,
                width: 32.0,
              ),
            )
          : SvgPicture.asset(
              'assets/ic_car_horizontal_gradient.svg',
              height: 32.0,
              width: 32.0,
            ),
    );
  }

  Widget _buildCarName() {
    return Text(
      widget.carName ?? widget.carModel,
      style: TextStyle(
        color: widget.isDarkTheme ? Colors.white : const Color(0xFF101828),
        fontSize: 16,
        fontWeight: FontWeight.w500,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
