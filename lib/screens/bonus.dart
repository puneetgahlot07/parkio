import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parkio/model/parking_session/bonus_counter.dart';
import 'package:parkio/service/parking_service.dart';
import 'package:parkio/util/color.dart';
import 'package:parkio/widgets/bonus/bonus_counter.dart';
import 'package:parkio/widgets/loading.dart';
import 'package:parkio/widgets/switches.dart';

import '../../widgets/app_bar.dart';
import '../model/parking_session/set_reminder.dart';
import '../widgets/text.dart';

class BonusScreen extends StatefulWidget {
  const BonusScreen({super.key});

  @override
  State<BonusScreen> createState() => _BonusScreenState();
}

class _BonusScreenState extends State<BonusScreen> {
  bool _isEnabled = false;
  bool _switchLoading = false;

  late Future<GetBonusCounterResponse> _bonusFuture;
  Future<SetReminderResponse>? _reminderFuture;

  Future<GetBonusCounterResponse> _getBonusCounter() async {
    try {
      final response = await ParkingService().getBonusCounter();

      if (response.requestSucceed == 'true') {
        if (response.enabled != null) _isEnabled = response.enabled!;
        return response;
      } else {
        throw Error();
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<SetReminderResponse> _setBonusReminder(bool value) async {
    setState(() => _switchLoading = true);

    try {
      final response = await ParkingService().setBonusReminder(value);
      setState(() => _switchLoading = false);

      if (response.requestSucceed == 'true') {
        if (response.receiveReminder != null) {
          setState(() => _isEnabled = response.receiveReminder!);
        }
        return response;
      } else {
        throw Error();
      }
    } catch (e) {
      setState(() => _switchLoading = false);

      return Future.error(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _bonusFuture = _getBonusCounter();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: parkioBackgroundGradient),
      child: Scaffold(
        appBar: ParkioAppBarWithLogo(
          asset: 'assets/ic_bonus.svg',
          title: AppLocalizations.of(context)!.menuBonusTitle,
        ),
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        body: SafeArea(
          top: true,
          child: FutureBuilder<GetBonusCounterResponse>(
            future: _bonusFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // Show Error message with retry button
                if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 32.0,
                    ),
                    child: _buildErrorMessage(),
                  );
                } else {
                  // Show counter if everything is okay
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 32.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Buy your fourth single ticket by Saturday and get ${snapshot.data!.bonusDiscount}% bonus',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 24.0),
                        Flexible(
                          child: _buildBonusCounter(
                            counter: snapshot.data?.bonusCounterCurrent ?? 0,
                            max: snapshot.data?.bonusCounterMax ?? 0,
                          ),
                        ),
                      ],
                    ),
                  );
                }
              } else {
                // Loading
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

  Widget _buildErrorMessage() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(AppLocalizations.of(context)!.errorMessage),
          const SizedBox(height: 6.0),
          TextWithLink(
            text: '{${AppLocalizations.of(context)!.retry}}',
            onTap: (_) {
              _bonusFuture = _getBonusCounter();
            },
          )
        ],
      ),
    );
  }

  Widget _buildBonusCounter({required int counter, required int max}) {
    List<BonusCounter> bonusCounters = List.empty(growable: true);

    for (int i = 0; i < counter; i++) {
      bonusCounters.add(const BonusCounter(isActive: true));
    }
    for (int i = 0; i < max - counter; i++) {
      bonusCounters.add(const BonusCounter(isActive: false));
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: bonusCounters,
        ),
        const SizedBox(height: 16.0),
        Row(
          children: [
            FutureBuilder(
              future: _reminderFuture,
              builder: (context, snapshot) {
                bool isLoading =
                    snapshot.connectionState == ConnectionState.waiting ||
                        snapshot.connectionState == ConnectionState.active;

                return ParkioSwitch(
                  value: _isEnabled,
                  isLoading: isLoading,
                  onChange: (value) =>
                      _reminderFuture = _setBonusReminder(value),
                );
              },
            ),
            const SizedBox(width: 12.0),
            Text(
              AppLocalizations.of(context)!.bonusSwitchText,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
