import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:parkio/model/parking_session/permit_preview.dart';
import 'package:parkio/screens/parking/list/parkings.dart';
import 'package:parkio/service/parking_service.dart';
import 'package:parkio/util/color.dart';
import 'package:parkio/widgets/app_bar.dart';
import 'package:parkio/widgets/buttons.dart';
import 'package:parkio/widgets/dialogs.dart';
import 'package:parkio/widgets/loading.dart';
import 'package:parkio/widgets/text.dart';

import '../../../util/payment.dart';
import '../../../widgets/parking/area_code.dart';
import '../../../widgets/sheets.dart';

class BuyPermitScreen extends StatefulWidget {
  final int areaId;
  final int areaCode;

  const BuyPermitScreen({
    super.key,
    required this.areaId,
    required this.areaCode,
  });

  @override
  State<BuyPermitScreen> createState() => _BuyPermitScreenState();
}

class _BuyPermitScreenState extends State<BuyPermitScreen> {
  bool _isLoading = false;

  late Future<PermitPreviewResponse> _permitFuture;
  Vehicle? _vehicle;
  List<PermitOption>? _permitOptions;
  int? _chosenOptionId;

  Future<PermitPreviewResponse> _getPermitPreview() async {
    try {
      final sessionPreview = await ParkingService().getPermitPreview(
        widget.areaId,
      );

      setState(() {
        _vehicle = sessionPreview.vehicle;
        _permitOptions = sessionPreview.possiblePermits;

        // Sort options by their duration, so user sees the shortest one first
        if (_permitOptions != null) {
          _permitOptions!.sort(
            (a, b) => (a.duration ?? 0).compareTo(b.duration ?? 0),
          );

          // If chosen option ID is null or it is not present in options list, overwrite it
          if (_chosenOptionId == null ||
              _permitOptions!
                  .where((it) => it.id != null && it.id == _chosenOptionId)
                  .isEmpty) {
            _chosenOptionId = _permitOptions!.firstOrNull?.id;
          }
        }
      });

      return sessionPreview;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<void> _buyPermit() async {
    setState(() => _isLoading = true);

    try {
      final response = await ParkingService().buyPermit(
        0, // TODO: Replace with actual payment id
        _vehicle?.id ?? 0,
        _chosenOptionId ?? 0,
      );

      setState(() => _isLoading = false);

      if (response == true) {
        _showSuccessDialog();
      }
    } catch (e) {
      setState(() => _isLoading = false);

      // final exceptionString = e.toString();
      // if (!context.mounted) return;
      //
      // ScaffoldMessenger.of(context)
      //   ..removeCurrentSnackBar()
      //   ..showSnackBar(
      //     buildParkioSnackBar(exceptionString.substring(
      //         exceptionString.indexOf(' '), exceptionString.length)),
      //   );
      _showSuccessDialog();
    }
  }

  Future<void> _showSuccessDialog() async {
    if (!context.mounted) return;

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
            child: ParkioAlertDialog(
              title: AppLocalizations.of(context)!.permitSuccessMessage,
              onClick: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ParkingScreen(tabIndex: 2),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _showPickPermitOptionModalSheet() => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        constraints: BoxConstraints.loose(
          Size(
            double.infinity,
            MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top,
          ),
        ),
        builder: (BuildContext context) => DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.5,
          maxChildSize: (MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top) /
              MediaQuery.of(context).size.height,
          minChildSize: 0.5,
          builder: (context, scrollController) => PermitOptionSelectModalSheet(
            permitOptions: _permitOptions ?? List.empty(),
            mainOptionId: _chosenOptionId ?? 0,
            scrollController: scrollController,
            onContinue: (optionId) {
              Navigator.pop(context);
              // Set new chosen option Id
              setState(() => _chosenOptionId = optionId);
            },
          ),
        ),
      );

  void _showSelectPaymentModalSheet() => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        constraints: BoxConstraints.loose(
          Size(
            double.infinity,
            MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top,
          ),
        ),
        builder: (BuildContext context) => DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.5,
          maxChildSize: (MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top) /
              MediaQuery.of(context).size.height,
          minChildSize: 0.5,
          builder: (context, scrollController) => PaymentSelectModalSheet(
            scrollController: scrollController,
            onContinue: (token) {
              Navigator.pop(context);
              _permitFuture = _getPermitPreview(); // Reload permit preview
            },
          ),
        ),
      );

  void _showPickVehicleModalSheet() => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        constraints: BoxConstraints.loose(
          Size(
            double.infinity,
            MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top,
          ),
        ),
        builder: (BuildContext context) => DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.5,
          maxChildSize: (MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top) /
              MediaQuery.of(context).size.height,
          minChildSize: 0.5,
          builder: (context, scrollController) => CarSelectModalSheet(
            scrollController: scrollController,
            onContinue: (vehicleId) {
              Navigator.pop(context);
              _permitFuture = _getPermitPreview(); // Reload permit preview
            },
          ),
        ),
      );

  @override
  void initState() {
    super.initState();
    _permitFuture = _getPermitPreview();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: parkioBackgroundGradient),
      child: Scaffold(
        appBar: ParkioAppBarWithLogo(
          title: AppLocalizations.of(context)!.permitTitle,
        ),
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        body: SafeArea(
          top: true,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 32.0),
            child: Stack(
              children: [
                FutureBuilder<PermitPreviewResponse>(
                  future: _permitFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        // Show screen content
                        final sessionPreview = snapshot.data;
                        _vehicle = sessionPreview?.vehicle;
                        _permitOptions = sessionPreview?.possiblePermits;
                        _chosenOptionId ??= _permitOptions?.first.id;

                        return _buildBuyPermitScreen(
                          sessionPreview?.area,
                          "${sessionPreview?.card}",
                        );
                      } else {
                        // Show error message
                        return _buildErrorMessage(
                          context,
                          snapshot.error.toString(),
                        );
                      }
                    } else {
                      // Show loading indicator
                      return Center(
                        child: buildLoadingPlaceholder(
                          context,
                          textColor: Colors.white,
                        ),
                      );
                    }
                  },
                ),
                if (_isLoading) _buildLoadingPlaceholder(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Error message with 'Retry' button
  Widget _buildErrorMessage(BuildContext context, String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 32.0,
        horizontal: 24.0,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message),
            const SizedBox(height: 6.0),
            TextWithLink(
              text: '{${AppLocalizations.of(context)!.retry}}',
              onTap: (_) => _permitFuture = _getPermitPreview(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingPlaceholder() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [buildLoadingPlaceholder(context)],
            ),
          ),
        ),
      ),
    );
  }

  /// 'Buy permit' screen's content
  Widget _buildBuyPermitScreen(Area? area, String card) {
    final chosenOption = _permitOptions?.singleWhere(
      (option) => option.id == _chosenOptionId,
    );

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // If area info isn't null, show 'Area info' block and divider
                if (area != null) _buildAreaInfo(area),
                if (area != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child:
                        Container(height: 1.0, color: const Color(0xD9EFEEF6)),
                  ),
                if (chosenOption != null) _buildPermitOption(chosenOption),
                const SizedBox(height: 18.0),
                _buildPaymentMethod(card),
                const SizedBox(height: 18.0),
                _buildVehicle(_vehicle),
                const SizedBox(height: 18.0),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: ParkioButton(
            text: AppLocalizations.of(context)!.buyPermit,
            onPressed: _buyPermit,
          ),
        ),
      ],
    );
  }

  /// Block of info about parking area, such as code, address and name
  Widget _buildAreaInfo(Area area) {
    const textStyle = TextStyle(
      color: Colors.white,
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AreaCode(areaCode: widget.areaCode),
            const SizedBox(width: 12.0),
            if (area.address != null) Text(area.address!, style: textStyle),
          ],
        ),
        const SizedBox(height: 16.0),
        if (area.name != null)
          Row(
            children: [
              SvgPicture.asset('assets/ic_dest.svg', height: 24.0),
              const SizedBox(width: 12.0),
              Text(area.name!, style: textStyle),
            ],
          ),
      ],
    );
  }

  /// Button with permit option's price and duration
  Widget _buildPermitOption(PermitOption permitOption) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.permitOption,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4.0),
        ParkioProceedButton(
          text: permitOption.duration == null || permitOption.price == null
              ? "" // Show empty string if fields are null
              : AppLocalizations.of(context)!.nMonthForXSek(
                  permitOption.duration ?? 0,
                  (permitOption.price ?? 0) / 100,
                ),
          textAlign: TextAlign.start,
          onPressed: _showPickPermitOptionModalSheet,
        ),
      ],
    );
  }

  /// Button with permit option's price and duration
  // TODO: Add functionality
  Widget _buildPaymentMethod(String card) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.paymentMethod,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4.0),
        ParkioProceedButton(
          colorFilter: null,
          asset: assetFromPaymentType("VISA"), // TODO: Replace with actual data
          text: card == "null" || card.isEmpty
              ? AppLocalizations.of(context)!.addMethod
              : '••• ${card.substring(card.length - 4)}',
          textAlign: TextAlign.start,
          onPressed: () => _showSelectPaymentModalSheet(),
        ),
      ],
    );
  }

  /// Button with permit option's price and duration
  Widget _buildVehicle(Vehicle? vehicle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.vehicle,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4.0),
        ParkioProceedButton(
          asset: 'assets/ic_car_horizontal_gradient.svg',
          colorFilter: null,
          text: vehicle == null
              ? AppLocalizations.of(context)!.addVehicle
              : vehicle.name?.isNotEmpty == true
                  ? vehicle.name!
                  : vehicle.licensePlate ?? '',
          textAlign: TextAlign.start,
          onPressed: _showPickVehicleModalSheet,
        ),
      ],
    );
  }
}
