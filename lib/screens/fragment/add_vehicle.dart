import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parkio/util/color.dart';

import '../../widgets/inputs.dart';
import '../../widgets/logo.dart';
import '../../widgets/switches.dart';
import '../../widgets/text.dart';

class AddVehicleFragment extends StatefulWidget {
  final bool isLoading;
  final bool showLogo;
  // Values for number plate & vehicle name inputs
  final TextEditingController numberPlateController;
  final TextEditingController vehicleNameController;
  final Function(bool) onSetMainVehicleChange;

  const AddVehicleFragment({
    super.key,
    required this.isLoading,
    this.showLogo = true,
    required this.numberPlateController,
    required this.vehicleNameController,
    required this.onSetMainVehicleChange,
  });

  @override
  State<AddVehicleFragment> createState() => _AddVehicleFragmentState();
}

class _AddVehicleFragmentState extends State<AddVehicleFragment> {
  bool _saveAsMainVehicle = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTitleAndSubtitle(),
        const SizedBox(height: 24.0),
        _buildNumberPlateTextField(),
        const SizedBox(height: 20.0),
        _buildVehicleNameTextField(),
        const SizedBox(height: 24.0),
        _buildMainVehicleSwitch(),
      ],
    );
  }

  Widget _buildTitleAndSubtitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                AppLocalizations.of(context)!.addVehicleTitle,
                softWrap: true,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (widget.showLogo) const ParkioLogo(),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 14.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              AppLocalizations.of(context)!.addVehicleSubtitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNumberPlateTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.numberPlate,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: ParkioTextField(
            controller: widget.numberPlateController,
            hint: AppLocalizations.of(context)!.numberPlate,
          ),
        ),
      ],
    );
  }

  Widget _buildVehicleNameTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.vehicleName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6, bottom: 6),
          child: ParkioTextField(
            controller: widget.vehicleNameController,
            hint: AppLocalizations.of(context)!.vehicleName,
          ),
        ),
        SizedBox(
          child: TextWithLink(
            text: '{${AppLocalizations.of(context)!.optional}}',
            gradient: parkioGoldenGradient,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
            onTap: (_) {/*No action needed*/},
          ),
        ),
      ],
    );
  }

  Widget _buildMainVehicleSwitch() {
    return Row(
      children: [
        ParkioSwitch(
          value: _saveAsMainVehicle,
          onChange: (value) {
            setState(() => _saveAsMainVehicle = value);
            widget.onSetMainVehicleChange(value);
          },
        ),
        const SizedBox(width: 12.0),
        Text(
          AppLocalizations.of(context)!.saveAsMainVehicle,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
