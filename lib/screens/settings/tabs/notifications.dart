import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parkio/widgets/buttons.dart';
import 'package:parkio/widgets/settings/notifications/settings_panel.dart';

import '../../../model/settings/get_profile.dart';
import '../../../model/settings/update_profile.dart';
import '../../../service/user_settings_service.dart';
import '../../../widgets/snackbar.dart';

class NotificationsTab extends StatefulWidget {
  final NotificationsSettings? settings;
  final Function(bool) onLoadingStateChange;
  final Function onProfileReload;

  const NotificationsTab({
    super.key,
    required this.settings,
    required this.onLoadingStateChange,
    required this.onProfileReload,
  });

  @override
  State<NotificationsTab> createState() => _NotificationsTabState();
}

class _NotificationsTabState extends State<NotificationsTab> {
  bool _activeParkingSessionEnabled = false;
  bool _parkingAboutToEndEnabled = false;
  bool _endOfParkingEnabled = false;
  bool _receiptsEnabled = false;

  int _activeParkingSessionSliderValue = 900 ~/ 60;
  int _parkingAboutToEndSliderValue = 300 ~/ 60;

  Future<void> _submitSettings() async {
    widget.onLoadingStateChange(true);

    try {
      UpdateProfileResponse response =
          await UserSettingsService().updateNotification(
        _activeParkingSessionSliderValue * 60,
        _parkingAboutToEndSliderValue * 60,
        _activeParkingSessionEnabled,
        _parkingAboutToEndEnabled,
        _endOfParkingEnabled,
        _receiptsEnabled,
      );

      widget.onLoadingStateChange(false);
      widget.onProfileReload();

      if (!context.mounted) return;
      if (response.requestSucceed == 'true') {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(
            buildParkioSnackBar(
              AppLocalizations.of(context)!.profileUpdatedSuccessfully,
            ),
          );
      }
    } catch (e) {
      widget.onLoadingStateChange(false);

      final exceptionString = e.toString();
      final editedMessage = exceptionString.substring(
          exceptionString.indexOf(' '), exceptionString.length);
      if (!context.mounted) return;

      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          buildParkioSnackBar(editedMessage),
        );
    }
  }

  @override
  void initState() {
    super.initState();

    NotificationsSettings? settings = widget.settings;

    if (settings != null) {
      _activeParkingSessionEnabled = settings.activeSessionNotification == true;
      _parkingAboutToEndEnabled = settings.endingSessionNotification == true;
      _endOfParkingEnabled = settings.endOfSessionNotification == true;
      _receiptsEnabled = settings.receiveReceipt == true;

      _activeParkingSessionSliderValue =
          (settings.activeSessionInterval ?? 0) ~/ 60;
      _parkingAboutToEndSliderValue =
          (settings.endingSessionInterval ?? 0) ~/ 60;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 24.0),
        child: Column(
          children: [
            SettingsPanelWithSlider(
              title:
                  AppLocalizations.of(context)!.panelActiveParkingSessionTitle,
              description: AppLocalizations.of(context)!
                  .panelActiveParkingSessionDescription,
              switchText: AppLocalizations.of(context)!.pushNotification,
              isEnabled: _activeParkingSessionEnabled,
              onToggle: (value) => {
                setState(() {
                  _activeParkingSessionEnabled = value;
                })
              },
              sliderMinValue: 15, // 15 minutes
              sliderMaxValue: 4 * 60, // 4 hours
              sliderValue: _activeParkingSessionSliderValue ?? 0,
              onSliderValueChange: (value) => {
                setState(() {
                  _activeParkingSessionSliderValue = value;
                })
              },
            ),
            const SizedBox(height: 24.0),
            SettingsPanelWithSlider(
              title: AppLocalizations.of(context)!.panelAboutToEndTitle,
              description:
                  AppLocalizations.of(context)!.panelAboutToEndDescription,
              switchText: AppLocalizations.of(context)!.pushNotification,
              isEnabled: _parkingAboutToEndEnabled,
              onToggle: (value) => {
                setState(() {
                  _parkingAboutToEndEnabled = value;
                })
              },
              sliderMinValue: 15, // 15 minutes
              sliderMaxValue: 4 * 60, // 4 hours
              sliderValue: _parkingAboutToEndSliderValue,
              onSliderValueChange: (value) =>
                  setState(() => _parkingAboutToEndSliderValue = value),
            ),
            const SizedBox(height: 24.0),
            SettingsPanel(
              title: AppLocalizations.of(context)!.panelParkingEndedTitle,
              description:
                  AppLocalizations.of(context)!.panelParkingEndedDescription,
              switchText: AppLocalizations.of(context)!.pushNotification,
              isEnabled: _endOfParkingEnabled,
              onToggle: (value) => setState(() => _endOfParkingEnabled = value),
            ),
            const SizedBox(height: 24.0),
            SettingsPanel(
              title: AppLocalizations.of(context)!.panelReceiptsTitle,
              description:
                  AppLocalizations.of(context)!.panelReceiptsDescription,
              switchText: AppLocalizations.of(context)!.email,
              isEnabled: _receiptsEnabled,
              onToggle: (value) => setState(() => _receiptsEnabled = value),
            ),
            const SizedBox(height: 24.0),
            ParkioButton(
              text: AppLocalizations.of(context)!.saveChanges,
              onPressed: () => _submitSettings(),
            ),
          ],
        ),
      ),
    );
  }
}
