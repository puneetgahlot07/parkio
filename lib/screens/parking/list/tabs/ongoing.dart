import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parkio/service/parking_service.dart';

import '../../../../model/parking_session/ongoing.dart';
import '../../../../widgets/loading.dart';
import '../../../../widgets/parking/ongoing_parking.dart';
import '../../../../widgets/text.dart';
import '../../session/active_parking.dart';

class OngoingTab extends StatefulWidget {
  const OngoingTab({super.key});

  @override
  State<OngoingTab> createState() => _OngoingTabState();
}

class _OngoingTabState extends State<OngoingTab> {
  late Future<OngoingSessionResponse> _ongoingSessionFuture;

  Future<OngoingSessionResponse> _getOngoingSessions() async {
    try {
      final ongoingSessions = await ParkingService().getOngoingSessions();

      return ongoingSessions;
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _ongoingSessionFuture = _getOngoingSessions();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<OngoingSessionResponse>(
      future: _ongoingSessionFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            // Show tabs with data
            return snapshot.data?.parkings?.isNotEmpty == true
                ? _buildOngoingParkingList(snapshot.data!)
                : _buildNoOngoingParkingMessage();
          } else {
            // Error message with 'Retry' button
            return _buildErrorMessage();
          }
        } else {
          // Loading placeholder
          return Center(
            child: buildLoadingPlaceholder(
              context,
              textColor: Colors.white,
            ),
          );
        }
      },
    );
  }

  Widget _buildErrorMessage() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 32.0,
        horizontal: 24.0,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppLocalizations.of(context)!.errorMessage),
            const SizedBox(height: 6.0),
            TextWithLink(
              text: '{${AppLocalizations.of(context)!.retry}}',
              onTap: (_) {
                _ongoingSessionFuture = _getOngoingSessions();
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildOngoingParkingList(OngoingSessionResponse data) {
    final parkingList = data.parkings;

    return Padding(
      padding: const EdgeInsets.only(bottom: 32.0),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: parkingList?.length ?? 0,
        separatorBuilder: (context, index) => const SizedBox(height: 8.0),
        itemBuilder: (context, index) {
          final parking = parkingList?[index];
          final area = parking?.area;
          final vehicle = parking?.vehicle;

          return parking == null || area == null || vehicle == null
              ? null
              : OngoingParkingInfoCard(
                  id: parking.id!,
                  code: area.code ?? 0,
                  address: area.address ?? '',
                  name: area.name ?? '',
                  endDate: parking.endTime ?? '',
                  carName: vehicle.name,
                  numberPlate: vehicle.licencePlate ?? '',
                  totalCost: parking.cost ?? 0,
                  onClick: (id) async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ActiveParkingScreen(
                          sessionId: parking.id ?? 0,
                        ),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }

  Widget _buildNoOngoingParkingMessage() {
    return Center(
      child: Text(
        'Currently you have no active parking sessions',
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
