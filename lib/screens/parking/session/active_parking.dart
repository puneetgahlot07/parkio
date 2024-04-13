import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:parkio/model/parking_session/ongoing_session_preview.dart';
import 'package:parkio/model/parking_session/session_cost.dart';
import 'package:parkio/screens/parking/session/add_parking.dart';
import 'package:parkio/service/parking_service.dart';
import 'package:parkio/util/color.dart';
import 'package:parkio/widgets/app_bar.dart';
import 'package:parkio/widgets/loading.dart';
import 'package:parkio/widgets/parking/rotary_time_picker.dart';

import '../../../util/payment.dart';
import '../../../util/text.dart';
import '../../../widgets/buttons.dart';
import '../../../widgets/dialogs.dart';
import '../../../widgets/logo.dart';
import '../../../widgets/snackbar.dart';

class ActiveParkingScreen extends StatefulWidget {
  final int sessionId;

  const ActiveParkingScreen({
    super.key,
    required this.sessionId,
  });

  @override
  State<ActiveParkingScreen> createState() => _ActiveParkingScreenState();
}

class _ActiveParkingScreenState extends State<ActiveParkingScreen> {
  bool _isLoading = false;

  int _parkingTotalCost = 0; // The price is counted in oren
  int areaId = 0;
  int areaCode = 0;
  int _initialTimeMinutes = 0;
  int _extraTimeMinutes = 0;
  Vehicle? _vehicle;

  late Future<OngoingSessionPreviewResponse> _sessionFuture;
  Future<SessionCostResponse>? _costFuture;

  Future<void> _stopParkingSession() async {
    setState(() => _isLoading = true);

    try {
      final response = await ParkingService().stopParkingSession(
        widget.sessionId,
      );

      setState(() => _isLoading = false);

      if (response == true) {
        if (!context.mounted) return;

        await Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => AddParkingScreen(
              areaId: areaId,
              areaCode: areaCode,
            ),
          ),
        );
      }
    } catch (e) {
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

  Future<void> _extendParkingSession() async {
    try {
      final response = await ParkingService().extendParkingSession(
          widget.sessionId,
          _extraTimeMinutes * 60 // Convert extra time to seconds
          );

      if (response == true) {
        if (!context.mounted) return;

        _sessionFuture = _getSessionPreview();
      }
    } catch (e) {
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
      builder: (BuildContext context) => ParkioAlertDialog(
        title: AppLocalizations.of(context)!.parkingStopped,
        onClick: () {
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => ActiveParkingScreen(sessionId: sessionId),
            ),
          );
        },
      ),
    );
  }

  Future<OngoingSessionPreviewResponse> _getSessionPreview() async {
    try {
      final sessionPreview = await ParkingService().getOngoingSessionPreview(
        widget.sessionId,
      );

      if (sessionPreview.requestSucceed == 'true') {
        setState(() {
          _initialTimeMinutes = (sessionPreview.duration ?? 0) ~/ 60;
          areaId = sessionPreview.area?.id ?? 0;
          areaCode = sessionPreview.area?.code ?? 0;
          _vehicle = sessionPreview.vehicle;
          _recalculateCost();
        });
      }

      return sessionPreview;
    } catch (e) {
      return Future.error(e);
    }
  }

  // TODO: Change recalculation from total to extra time only using cost from ongoing-session-preview request
  Future<SessionCostResponse> _recalculateCost() async {
    try {
      final response = await ParkingService().getSessionCost(
        areaId,
        (_initialTimeMinutes + _extraTimeMinutes) * 60,
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

  @override
  void initState() {
    super.initState();
    _sessionFuture = _getSessionPreview();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: parkioBackgroundGradient),
      child: Scaffold(
        appBar: ActiveParkingAppBar(
          title: areaCode == 0 ? '' : areaCode.toString(),
        ),
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        body: SafeArea(
          top: true,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 32.0),
            child: Stack(
              children: [
                FutureBuilder<OngoingSessionPreviewResponse>(
                  future: _sessionFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        // Show the error message
                        return Text(snapshot.error.toString());
                      } else {
                        // Show screen content
                        final sessionPreview = snapshot.data;

                        return _buildActiveParkingScreen(
                            area: sessionPreview?.area,
                            vehicle: _vehicle,
                            paymentMethod: sessionPreview?.card,
                            startTime: "${sessionPreview?.startTime}");
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
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActiveParkingScreen({
    required Area? area,
    required Vehicle? vehicle,
    required String? paymentMethod,
    required String startTime,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  const ParkioInfoButton(),
                  const SizedBox(width: 8.0),
                  Flexible(
                    child: Text(
                      area?.address ?? '',
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
          ],
        ),
        const SizedBox(height: 32.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTimer(),
            _buildEndTimeAndCost(startTime),
          ],
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Stack(
              children: [
                RotaryTimePicker(
                  onPanEnd: () => _costFuture = _recalculateCost(),
                  onTimeUpdate: (value) {
                    // Add haptic feedback only if total minutes > 0
                    if (_extraTimeMinutes != value) {
                      if (value > 0) HapticFeedback.lightImpact();
                      // Update value only if it differs from current
                      setState(() => _extraTimeMinutes = value);
                    }
                  },
                ),
                Center(
                  child: ParkioStartStopButton(
                    text: _extraTimeMinutes == 0
                        ? AppLocalizations.of(context)!.stop
                        : AppLocalizations.of(context)!.extend,
                    onPressed: () => _extraTimeMinutes == 0
                        ? _stopParkingSession()
                        : _extendParkingSession(),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Car picker
            Expanded(
              child: ParkioFilledButton(
                asset: 'assets/ic_car_horizontal_gradient.svg',
                text: vehicle?.name?.isNotEmpty == true
                    ? vehicle!.name!
                    : vehicle?.licencePlate ?? '',
                onPressed: () => {/* Do nothing */},
              ),
            ),
            const SizedBox(width: 24.0),
            // Payment type picker
            Expanded(
              child: paymentMethod == null
                  ? ParkioFilledButton(
                      text: AppLocalizations.of(context)!.addMethod,
                      onPressed: () {},
                    )
                  : ParkioFilledButton(
                      asset: assetFromPaymentType("VISA"), // TODO: Replace
                      text:
                          '••• ${paymentMethod.substring(paymentMethod.length - 4)}',
                      onPressed: () {},
                    ),
            ),
          ],
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
          formatTime(context, (_initialTimeMinutes + _extraTimeMinutes)),
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
  Widget _buildEndTimeAndCost(String startTime) {
    final startDateTime = DateTime.parse(startTime);
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
                    startDateTime.add(Duration(
                      minutes: (_initialTimeMinutes + _extraTimeMinutes),
                    )),
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
                        fontSize: 14,
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
                  const SizedBox(
                    width: 4.0,
                  ),
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
