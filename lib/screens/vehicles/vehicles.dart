import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parkio/model/vehicles/get_vehicle.dart';
import 'package:parkio/screens/vehicles/add_vehicle.dart';
import 'package:parkio/service/vehicle_service.dart';
import 'package:parkio/util/color.dart';
import 'package:parkio/widgets/loading.dart';
import 'package:parkio/widgets/sheets.dart';
import 'package:parkio/widgets/slidable.dart';
import 'package:parkio/widgets/text.dart';
import 'package:parkio/widgets/vehicles/vehicle_list_item.dart';

import '../../widgets/app_bar.dart';
import '../../widgets/buttons.dart';
import '../../widgets/snackbar.dart';

class VehiclesScreen extends StatefulWidget {
  const VehiclesScreen({super.key});

  @override
  State<VehiclesScreen> createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends State<VehiclesScreen>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  late Future<List<GetVehicleResponse>> _vehiclesFuture;

  void _showCarDeleteModalSheet(
    int id,
    String registrationNumber,
    String carBrand,
    String carModel,
  ) =>
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return CarDeleteModalSheet(
            registrationNumber: registrationNumber,
            carBrand: carBrand,
            carModel: carModel,
            onDelete: () async {
              try {
                setState(() {
                  _isLoading = false;
                });

                bool deletedSuccessfully = await _deleteVehicle(id);

                if (!context.mounted) return;

                if (deletedSuccessfully) {
                  Navigator.pop(context); // Close the modal sheet
                  _vehiclesFuture = _getVehicles(); // Reload vehicles list
                }
              } catch (e) {
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
            onBack: () {
              Navigator.pop(context);
            },
          );
        },
      );

  Future<List<GetVehicleResponse>> _getVehicles() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final vehicles = await VehicleService().getVehicles();

      setState(() {
        _isLoading = false;
      });

      return vehicles;
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      return Future.error(e);
    }
  }

  Future<bool> _deleteVehicle(int id) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await VehicleService().removeVehicle(id);

      setState(() {
        _isLoading = false;
      });

      return response.requestSucceed == 'true' ? true : false;
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      return Future.error(e);
    }
  }

  Future<void> _setMainVehicle(int id) async {
    setState(() => _isLoading = true);

    try {
      final response = await VehicleService().setMainVehicle(id);

      setState(() => _isLoading = false);

      if (response.requestSucceed == 'true') {
        _vehiclesFuture = _getVehicles();
      }
    } catch (e) {
      setState(() => _isLoading = false);

      return Future.error(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _vehiclesFuture = _getVehicles();
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
          child: FutureBuilder<List<GetVehicleResponse>>(
            future: _vehiclesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  !_isLoading) {
                if (snapshot.hasData) {
                  if (snapshot.data?.isNotEmpty == true) {
                    // Show the list of vehicles if list is not empty
                    return _buildVehicleList(snapshot.data!);
                  } else {
                    // Show message that user has no vehicles and button 'Add car'
                    return _buildNoVehiclesMessage();
                  }
                } else {
                  // Show error message
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 32.0,
                      horizontal: 24.0,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(snapshot.error.toString()),
                          const SizedBox(height: 6.0),
                          TextWithLink(
                            text: '{${AppLocalizations.of(context)!.retry}}',
                            onTap: (_) => _vehiclesFuture = _getVehicles(),
                          )
                        ],
                      ),
                    ),
                  );
                }
              } else {
                // Show loading placeholder
                return Center(
                  child: buildLoadingPlaceholder(
                    context,
                    textColor: Colors.white,
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Padding _buildAddVehicleButton() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0),
        child: ParkioProceedButton(
          text: AppLocalizations.of(context)!.addNewVehicle,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AddVehicleScreen(),
              ),
            );
          },
        ),
      );

  Widget _buildVehicleList(List<GetVehicleResponse> vehicles) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 14.0, bottom: 6.0),
            child: Text(
              AppLocalizations.of(context)!.vehicles,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Flexible(
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: const Color(0x1AFFFFFF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: vehicles.length,
                separatorBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Container(
                    height: 1.0,
                    color: const Color(0xEFEEF6D9),
                  ),
                ),
                itemBuilder: (context, index) {
                  final vehicle = vehicles[index];

                  return ParkioSlidable(
                    child: VehicleListItem(
                      id: vehicle.id!,
                      isMain: vehicle.mainVehicle == true,
                      numberPlate: vehicle.licencePlate!,
                      carName: vehicle.name,
                      onRadioClick: (id) => _setMainVehicle(id),
                    ),
                    onRemove: () {
                      _showCarDeleteModalSheet(
                        vehicle.id!,
                        vehicle.licencePlate!,
                        'Car brand', // TODO: Replace this with actual brand from API
                        'Car model', // TODO: Replace this with actual model from API
                      );
                    },
                  );
                },
              ),
            ),
          ),
          _buildAddVehicleButton(),
        ],
      ),
    );
  }

  Widget _buildNoVehiclesMessage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // TODO: Replace plain text message with proper placeholder
                const SizedBox(height: 14.0),
                Text(
                  AppLocalizations.of(context)!.noVehiclesMessage,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          _buildAddVehicleButton(),
        ],
      ),
    );
  }
}
