import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:parkio/screens/fragment/add_vehicle.dart';
import 'package:parkio/screens/vehicles/vehicles.dart';
import 'package:parkio/util/color.dart';
import 'package:parkio/widgets/buttons.dart';
import 'package:parkio/widgets/sheets.dart';

import '../../service/vehicle_service.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/snackbar.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({
    super.key,
  });

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  bool _isLoading = false;

  // Values for number plate & vehicle name inputs
  final TextEditingController _numberPlateController = TextEditingController();
  final TextEditingController _vehicleNameController = TextEditingController();

  bool _saveAsMainVehicle = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _checkVehicle() async {
    setState(() => _isLoading = true);

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return CarConfirmModalSheet(
          registrationNumber: _numberPlateController.text,
          carName: _vehicleNameController.text,
          onConfirm: () async {
            try {
              setState(() => _isLoading = false);

              final response = await VehicleService().addVehicle(
                _vehicleNameController.text,
                _numberPlateController.text,
                _saveAsMainVehicle,
              );

              if (!context.mounted) return;

              Navigator.pop(context);
              Navigator.pop(context);

              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const VehiclesScreen()),
              );
            } catch (e) {
              setState(() => _isLoading = false);

              final exceptionString = e.toString();
              if (!context.mounted) return;

              Navigator.pop(context);

              ScaffoldMessenger.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(
                  buildParkioSnackBar(exceptionString.substring(
                      exceptionString.indexOf(' '), exceptionString.length)),
                );
            }
          },
          onBack: () => Navigator.pop(context),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: parkioBackgroundGradient),
      child: Scaffold(
        appBar: ParkioAppBarWithLogo(
          asset: 'assets/ic_car_outlined.svg',
          title: AppLocalizations.of(context)!.menuVehiclesTitle,
        ),
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        body: SafeArea(
          top: true,
          bottom: true,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                        start: 24.0,
                        top: 38.0,
                        end: 24.0,
                        bottom: 20.0,
                      ),
                      child: AddVehicleFragment(
                        isLoading: _isLoading,
                        showLogo: false,
                        numberPlateController: _numberPlateController,
                        vehicleNameController: _vehicleNameController,
                        onSetMainVehicleChange: (value) =>
                            setState(() => _saveAsMainVehicle = value),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(24.0, 6.0, 24.0, 32.0),
                child: ParkioButton(
                  text: AppLocalizations.of(context)!.continueButton,
                  onPressed: _checkVehicle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
