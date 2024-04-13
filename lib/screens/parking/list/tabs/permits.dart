import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:parkio/service/parking_service.dart';
import 'package:parkio/widgets/parking/ongoing_permit.dart';

import '../../../../model/parking_session/ongoing_permits.dart';
import '../../../../widgets/loading.dart';
import '../../../../widgets/text.dart';

class PermitsTab extends StatefulWidget {
  const PermitsTab({super.key});

  @override
  State<PermitsTab> createState() => _PermitsTabState();
}

class _PermitsTabState extends State<PermitsTab> {
  late Future<List<OngoingPermitResponse>> _ongoingPermitsFuture;

  Future<List<OngoingPermitResponse>> _getOngoingPermits() async {
    try {
      final permits = await ParkingService().getOngoingPermits();

      return permits;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<bool> _setRenewalState(int permitId) async {
    try {
      final renewalStatus = await ParkingService().setPermitRenewal(permitId);

      return renewalStatus;
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _ongoingPermitsFuture = _getOngoingPermits();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<OngoingPermitResponse>>(
      future: _ongoingPermitsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            // Show tabs with data
            return snapshot.data?.isNotEmpty == true
                ? _buildOngoingPermitsList(snapshot.data!)
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
                _ongoingPermitsFuture = _getOngoingPermits();
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildOngoingPermitsList(List<OngoingPermitResponse> list) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32.0),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: list.length ?? 0,
        separatorBuilder: (context, index) => const SizedBox(height: 8.0),
        itemBuilder: (context, index) {
          final permit = list[index];

          final DateTime? startDate = permit.from != null
              ? DateFormat("dd/MM/yy, HH:mm").parse(permit.from!)
              : null;
          final DateTime? endDate = permit.endDate != null
              ? DateFormat("dd/MM/yy, HH:mm'").parse(permit.endDate!)
              : null;

          return OngoingPermitInfoCard(
            id: permit.id!,
            areaCode: 0,
            address: 'Address',
            areaName: 'Area name',
            startDate: startDate != null
                ? DateFormat("dd/MM/yy HH:mm").format(startDate)
                : '',
            endDate: endDate != null
                ? DateFormat("dd/MM/yy HH:mm").format(endDate)
                : '',
            carName: 'Car name',
            numberPlate: 'Plate',
            totalCost: permit.monthlyRate ?? 0,
            renewalEnabled: permit.renewal ?? false,
            onRadioSwitch: (_) => _setRenewalState(permit.id ?? 0),
          );
        },
      ),
    );
  }

  // TODO: Replace with translation
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
