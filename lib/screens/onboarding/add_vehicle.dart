import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:parkio/model/vehicles/add_vehicle.dart';
import 'package:parkio/screens/fragment/add_vehicle.dart';
import 'package:parkio/screens/onboarding/add_card.dart';
import 'package:parkio/util/color.dart';
import 'package:parkio/util/const.dart';
import 'package:parkio/widgets/buttons.dart';
import 'package:parkio/widgets/sheets.dart';

import '../../service/vehicle_service.dart';
import '../../widgets/onboarding_progress_indicator.dart';
import '../../widgets/snackbar.dart';

class AddVehiclePage extends StatefulWidget {
  const AddVehiclePage({
    super.key,
  });

  @override
  State<AddVehiclePage> createState() => _AddVehiclePageState();
}

class _AddVehiclePageState extends State<AddVehiclePage> {
  final storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  bool _isLoading = false;

  // Values for number plate & vehicle name inputs
  TextEditingController numberPlateController = TextEditingController();
  TextEditingController vehicleNameController = TextEditingController();

  bool _saveAsMainVehicle = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _skip() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const AddCardPage(),
      ),
    );
  }

  Future<void> _checkVehicle() async {
    setState(() => _isLoading = true);

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return CarConfirmModalSheet(
          registrationNumber: numberPlateController.text,
          carName: vehicleNameController.text,
          onConfirm: (){
               Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const AddCardPage()));
          },
          // Old Code
          // onConfirm: () async {
          //   try {
          //     setState(() => _isLoading = false);

          //     AddVehicleResponse response = await VehicleService().addVehicle(
          //       vehicleNameController.text,
          //       numberPlateController.text,
          //       _saveAsMainVehicle,
          //     );

          //     if (!context.mounted) return;

          //     Navigator.of(context).pushReplacement(
          //       MaterialPageRoute(builder: (context) => const AddCardPage()),
          //     );
          //   } catch (e) {
          //     setState(() => _isLoading = false);

          //     final exceptionString = e.toString();
          //     if (!context.mounted) return;

          //     Navigator.pop(context);

          //     ScaffoldMessenger.of(context)
          //       ..removeCurrentSnackBar()
          //       ..showSnackBar(
          //         buildParkioSnackBar(exceptionString.substring(
          //             exceptionString.indexOf(' '), exceptionString.length)),
          //       );
          //   }
          // },
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
        appBar: AppBar(
          toolbarHeight: 66.0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          scrolledUnderElevation: 0.0,
          title: const Padding(
            padding: EdgeInsets.only(top: 18.0),
            child: OnboardingProgressIndicator(pageIndex: 0),
          ),
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
                        top: 56.0,
                        end: 24.0,
                        bottom: 20.0,
                      ),
                      child: AddVehicleFragment(
                        isLoading: _isLoading,
                        numberPlateController: numberPlateController,
                        vehicleNameController: vehicleNameController,
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: ParkioButton(
                            text: AppLocalizations.of(context)!.skip,
                            type: ButtonType.neutral,
                            onPressed: _skip,
                          ),
                        ),
                        Container(width: 12),
                        Flexible(
                          flex: 2,
                          child: ParkioButton(
                            text: AppLocalizations.of(context)!.continueButton,
                            onPressed: _checkVehicle,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
