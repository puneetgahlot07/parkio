import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:parkio/model/parking_session/session_cost.dart';
import 'package:parkio/model/parking_session/session_preview.dart';
import 'package:parkio/screens/parking/session/buy_permit.dart';
import 'package:parkio/service/parking_service.dart';
import 'package:parkio/util/color.dart';
import 'package:parkio/widgets/app_bar.dart';
import 'package:parkio/widgets/dialogs.dart';
import 'package:parkio/widgets/loading.dart';
import 'package:parkio/widgets/parking/rotary_time_picker.dart';
import 'package:parkio/widgets/sheets.dart';
import 'package:parkio/widgets/text.dart';

import '../../../util/payment.dart';
import '../../../util/text.dart';
import '../../../widgets/buttons.dart';
import '../../../widgets/logo.dart';
import '../../../widgets/snackbar.dart';
import 'active_parking.dart';

class AddParkingScreen extends StatefulWidget {
  final int areaId;
  final int areaCode;

  const AddParkingScreen({
    super.key,
    required this.areaId,
    required this.areaCode,
  });

  @override
  State<AddParkingScreen> createState() => _AddParkingScreenState();
}

class _AddParkingScreenState extends State<AddParkingScreen> {
  bool _isLoading = false;

  int _parkingTotalCost = 0; // The price is counted in oren
  int _parkingTimeMinutes = 0;
  Vehicle? _vehicle;

  late Future<SessionPreviewResponse> _sessionFuture;
  late Future<SessionCostResponse> _costFuture;

  Future<void> _startParkingSession() async {
    setState(() => _isLoading = true);

    try {
      final response = await ParkingService().startParkingSession(
        _parkingTimeMinutes * 60, // convert minutes into seconds
        _vehicle?.id ?? 0,
        widget.areaId,
      );

      setState(() => _isLoading = false);

      if (response.requestSucceed == 'true') {
        _showSuccessDialog(response.session?.id ?? 0);
      }
    } catch (e) {
      setState(() => _isLoading = false);

      final exceptionString = e.toString();
      if (!context.mounted) return;

      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          buildParkioSnackBar(exceptionString.substring(
              exceptionString.indexOf(' '), exceptionString.length)),
        );
    }
  }

  Future<void> _showSuccessDialog(int sessionId) async {
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
              title: AppLocalizations.of(context)!.parkingStarted,
              onClick: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) =>
                        ActiveParkingScreen(sessionId: sessionId),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<SessionPreviewResponse> _getSessionPreview() async {
    try {
      final sessionPreview = await ParkingService().getSessionPreview(
        widget.areaId,
      );

      setState(() => _vehicle = sessionPreview.vehicle);

      return sessionPreview;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<SessionCostResponse> _recalculateCost() async {
    try {
      final response = await ParkingService().getSessionCost(
        widget.areaId,
        _parkingTimeMinutes * 60,
        _vehicle?.id ?? 0,
      );
      if (response.requestSucceed == 'true') {
        setState(() => _parkingTotalCost = response.cost ?? 0);
      }

      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

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
              _sessionFuture = _getSessionPreview(); // Reload session preview
            },
          ),
        ),
      );

  void _showPickPaymentModalSheet() => showModalBottomSheet(
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
            onContinue: (paymentMethodId) {
              Navigator.pop(context);
              _sessionFuture = _getSessionPreview(); // Reload session preview
            },
          ),
        ),
      );

  void _buyPermit() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BuyPermitScreen(
          areaId: widget.areaId,
          areaCode: widget.areaCode,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _sessionFuture = _getSessionPreview();
    _costFuture = _recalculateCost();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: parkioBackgroundGradient),
      child: Scaffold(
        appBar: ParkioAppBarWithLogo(title: widget.areaCode.toString()),
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        body: SafeArea(
          top: true,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 32.0),
            child: Stack(
              children: [
                FutureBuilder<SessionPreviewResponse>(
                  future: _sessionFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        // Show screen content
                        final sessionPreview = snapshot.data;
                        _vehicle = sessionPreview?.vehicle;

                        return _buildAddParkingScreen(
                          area: sessionPreview?.area,
                          vehicle: _vehicle,
                          paymentMethod: sessionPreview?.card,
                          isPermitAvailable:
                              sessionPreview?.permitAvailable ?? false,
                        );
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
                                  text:
                                      '{${AppLocalizations.of(context)!.retry}}',
                                  onTap: (_) => _getSessionPreview(),
                                )
                              ],
                            ),
                          ),
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
                if (_isLoading)
                  Center(
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
                            children: [
                              buildLoadingPlaceholder(context),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddParkingScreen({
    required Area? area,
    required Vehicle? vehicle,
    required String? paymentMethod,
    required bool isPermitAvailable,
  }) {
    return Column(
      children: [
        if (area != null) _buildAreaInfo(area, isPermitAvailable),
        const SizedBox(height: 32.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTimer(),
            _buildEndTimeAndCost(),
          ],
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Stack(
              children: [
                RotaryTimePicker(
                  maxTime: area?.maxTime == null ? null : area!.maxTime! ~/ 60,
                  onPanEnd: () => _costFuture = _recalculateCost(),
                  onTimeUpdate: (value) {
                    // Update value only if it differs from current
                    if (_parkingTimeMinutes != value) {
                      if (value > 0) {
                        // If area has no time limits, provide haptic feedback as long as value is > 0
                        if (area?.maxTime == null || area?.maxTime == 0) {
                          HapticFeedback.lightImpact();
                        } else {
                          // If area has time limits and value has exceeded it, provide no haptic feedback
                          if (value < area!.maxTime!) {
                            HapticFeedback.lightImpact();
                          }
                        }
                      }
                      setState(() => _parkingTimeMinutes = value);
                    }
                  },
                ),
                Center(
                  child: ParkioStartStopButton(
                    text: AppLocalizations.of(context)!.start,
                    onPressed: () => _startParkingSession(),
                  ),
                ),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Car picker
            Expanded(
              child: vehicle == null
                  ? ParkioFilledButton(
                      text: AppLocalizations.of(context)!.addVehicle,
                      onPressed: _showPickVehicleModalSheet,
                    )
                  : ParkioFilledButton(
                      asset: 'assets/ic_car_horizontal_gradient.svg',
                      text: vehicle.name?.isNotEmpty == true
                          ? vehicle.name!
                          : vehicle.licencePlate ?? '',
                      onPressed: _showPickVehicleModalSheet,
                    ),
            ),
            const SizedBox(width: 24.0),
            // Payment type picker
            Expanded(
              child: paymentMethod == null
                  ? ParkioFilledButton(
                      text: AppLocalizations.of(context)!.addMethod,
                      onPressed: _showPickPaymentModalSheet,
                    )
                  : ParkioFilledButton(
                      asset: assetFromPaymentType(
                          "VISA"), // TODO: Replace with actual data from backend
                      text:
                          '••• ${paymentMethod.substring(paymentMethod.length - 4)}',
                      onPressed: _showPickPaymentModalSheet,
                    ),
            ),
          ],
        ),
      ],
    );
  }

  /// Area address and 'Buy permit' button
  Widget _buildAreaInfo(Area area, bool isPermitAvailable) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              const ParkioInfoButton(),
              const SizedBox(width: 8.0),
              Flexible(
                child: Text(
                  area.address ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 24.0),
          child: TextWithLink(
            text: '{${AppLocalizations.of(context)!.buyPermit}}',
            onTap: isPermitAvailable ? (_) => _buyPermit() : null,
          ),
        ),
      ],
    );
  }

  /// Timer text with parking duration
  Widget _buildTimer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.timer,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12.0),
        Text(
          formatTime(context, _parkingTimeMinutes),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// Clock with parking session end time and parking cost
  Widget _buildEndTimeAndCost() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Time by which parking will end
        Row(
          children: [
            SvgPicture.asset('assets/ic_clock.svg'),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
              ),
              child: StreamBuilder(
                stream: Stream.periodic(const Duration(seconds: 1)),
                builder: (context, snapshot) => Text(
                  DateFormat('HH:mm').format(
                    DateTime.now().add(Duration(minutes: _parkingTimeMinutes)),
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 46,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
        // Parking cost info
        FutureBuilder<SessionCostResponse>(
          future: _costFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                // Show error message
                // TODO: Implement custom retry message with icon button
                return Row(
                  children: [
                    SvgPicture.asset('assets/ic_banknote.svg'),
                    const SizedBox(width: 4.0),
                    Text(
                      formatCurrency(_parkingTotalCost / 100),
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                );
              } else {
                // Show the cost of the parking session
                return Row(
                  children: [
                    SvgPicture.asset('assets/ic_banknote.svg'),
                    const SizedBox(width: 4.0),
                    Text(
                      formatCurrency(_parkingTotalCost / 100),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                );
              }
            } else {
              return Row(
                children: [
                  const SizedBox(
                    height: 16.0,
                    width: 16.0,
                    child: ParkioLogo(),
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    formatCurrency(_parkingTotalCost / 100),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ],
    );
  }
}
