import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parkio/widgets/slider.dart';
import 'package:parkio/widgets/switches.dart';

class SettingsPanel extends StatefulWidget {
  final String title;
  final String? description;
  final String switchText;
  final bool isEnabled;
  final Function(bool) onToggle;
  final Widget? child;

  const SettingsPanel({
    super.key,
    required this.title,
    this.description,
    required this.switchText,
    required this.isEnabled,
    required this.onToggle,
    this.child,
  });

  @override
  State<SettingsPanel> createState() => _SettingsPanelState();
}

class _SettingsPanelState extends State<SettingsPanel> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6.0),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          decoration: ShapeDecoration(
            color: const Color(0x1AFFFFFF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Column(
            children: [
              if (widget.description != null)
                Text(
                  widget.description!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              // If panel has a child, show it inside padding
              // Show empty box otherwise
              widget.child != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: widget.child,
                    )
                  : const SizedBox(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.switchText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(start: 16.0),
                    child: ParkioSwitch(
                      value: widget.isEnabled,
                      onChange: (value) => widget.onToggle(value),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SettingsPanelWithSlider extends StatefulWidget {
  final String title;
  final String? description;
  final int sliderMinValue;
  final int sliderMaxValue;
  final int sliderValue;
  final Function(int) onSliderValueChange;
  final Function(int)? onSliderValueChangeEnd;
  final String switchText;
  final bool isEnabled;
  final Function(bool) onToggle;
  final Widget? child;

  const SettingsPanelWithSlider({
    super.key,
    required this.title,
    this.description,
    required this.sliderMinValue,
    required this.sliderMaxValue,
    required this.sliderValue,
    required this.onSliderValueChange,
    this.onSliderValueChangeEnd,
    required this.switchText,
    required this.isEnabled,
    required this.onToggle,
    this.child,
  });

  @override
  State<SettingsPanelWithSlider> createState() =>
      _SettingsPanelWithSliderState();
}

class _SettingsPanelWithSliderState extends State<SettingsPanelWithSlider> {
  @override
  Widget build(BuildContext context) {
    return SettingsPanel(
      title: widget.title,
      description: widget.description,
      switchText: widget.switchText,
      isEnabled: widget.isEnabled,
      onToggle: widget.onToggle,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MediaQuery.removePadding(
            context: context,
            child: Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  overlayShape: SliderComponentShape.noThumb,
                  trackHeight: 8.0,
                  inactiveTrackColor: const Color(0xFFEAECF0),
                  thumbColor: Colors.white,
                  thumbShape: SliderThumbImage(),
                  trackShape: const GradientRectSliderTrackShape(),
                ),
                child: Slider(
                  // Set value to widget's value if it meet the criteria
                  // Set to widget's min value otherwise
                  value: widget.sliderValue >= widget.sliderMinValue &&
                          widget.sliderValue <= widget.sliderMaxValue
                      ? widget.sliderValue.toDouble()
                      : widget.sliderMinValue.toDouble(),
                  min: widget.sliderMinValue.toDouble(),
                  max: widget.sliderMaxValue.toDouble(),
                  divisions: 6,
                  onChangeEnd: widget.onSliderValueChangeEnd != null
                      ? (value) => widget.onSliderValueChangeEnd!(value.toInt())
                      : null,
                  onChanged: (value) =>
                      widget.onSliderValueChange(value.toInt()),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 16.0),
            child: Text(
              AppLocalizations.of(context)!.nMinutes(widget.sliderValue),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
