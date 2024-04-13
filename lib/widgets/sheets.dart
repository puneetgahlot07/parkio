import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:parkio/model/area/get_areas.dart' as get_areas;
import 'package:parkio/model/area/search_area.dart';
import 'package:parkio/model/payment/payment_card.dart';
import 'package:parkio/service/area_service.dart';
import 'package:parkio/service/payment_service.dart';
import 'package:parkio/util/color.dart';
import 'package:parkio/util/const.dart';
import 'package:parkio/widgets/buttons.dart';
import 'package:parkio/widgets/inputs.dart';
import 'package:parkio/widgets/loading.dart';
import 'package:parkio/widgets/parking/area_code.dart';
import 'package:parkio/widgets/parking_area.dart';
import 'package:parkio/widgets/payment_list_item.dart';
import 'package:parkio/widgets/snackbar.dart';
import 'package:parkio/widgets/text.dart';
import 'package:parkio/widgets/vehicles/vehicle_list_item.dart';

import '../model/area/get_area.dart';
import '../model/parking_session/permit_preview.dart';
import '../model/vehicles/get_vehicle.dart';
import '../screens/parking/session/add_parking.dart';
import '../service/vehicle_service.dart';
import '../util/text.dart';
import 'icons.dart';

class ModalBottomSheetContainer extends StatelessWidget {
  final String iconAsset;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color contentColor;
  final Widget? child;

  const ModalBottomSheetContainer({
    super.key,
    required this.iconAsset,
    this.backgroundColor = const Color(0xFFFFFAEB),
    this.foregroundColor = const Color(0xFFFEF0C7),
    this.contentColor = const Color(0xFFDC6803),
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 14.0),
              child: ModalHeaderLogo(
                asset: iconAsset,
                backgroundColor: backgroundColor,
                foregroundColor: foregroundColor,
                contentColor: contentColor,
              ),
            ),
            if (child != null) Flexible(flex: 1, child: child!),
          ],
        ),
      ),
    );
  }
}

/// A bottom sheet with area information
class AreaInformationSheet extends StatefulWidget {
  final int id;
  final bool isParkioButtonVisible;
  final Function()? onClick;

  const AreaInformationSheet({
    super.key,
    required this.id,
    required this.isParkioButtonVisible,
    this.onClick,
  });

  @override
  State<AreaInformationSheet> createState() => _AreaInformationSheetState();
}

class _AreaInformationSheetState extends State<AreaInformationSheet> {
  late Future<GetAreaResponse> _areaFuture;

  Future<GetAreaResponse> _getAreaInfo() async {
    try {
      final sessionPreview = await AreaService().getArea(widget.id);

      return sessionPreview;
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _areaFuture = _getAreaInfo();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: parkioBackgroundGradient,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: FutureBuilder(
              future: _areaFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    final areaInfo = snapshot.data;

                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(
                            AppLocalizations.of(context)!.area_info,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 32.0),
                          _buildAreaBasicInfo(
                            areaInfo?.code ?? 0,
                            areaInfo?.address ?? '',
                            areaInfo?.name ?? '',
                            areaInfo?.type ?? '',
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24.0),
                            child: Container(
                              color: const Color(0xD9EFEEF6),
                              height: 1.0,
                              width: double.infinity,
                            ),
                          ),
                          _buildTimeSplitsInfo(areaInfo?.timeSplit),
                        ],
                      ),
                    );
                  } else {
                    return _buildErrorMessage(
                      context,
                      snapshot.error.toString(),
                    );
                  }
                } else {
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
          // Indication that shows that this sheet is draggable
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              width: 50,
              height: 4,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2.50),
                ),
              ),
            ),
          ),
        ],
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
              onTap: (_) => _areaFuture = _getAreaInfo(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAreaBasicInfo(
    int code,
    String address,
    String name,
    String type,
  ) {
    String typeString = type;
    switch (type) {
      case 'off_street':
        typeString = AppLocalizations.of(context)!.off_street;
        break;
      case 'on_street':
        typeString = AppLocalizations.of(context)!.on_street;
        break;
      default:
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AreaCode(areaCode: code),
            const SizedBox(width: 12.0),
            Text(
              address,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16.0),
        Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/ic_dest.svg', height: 24.0),
            const SizedBox(width: 12.0),
            Text(
              typeString,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimeSplitsInfo(TimeSplit? timeSplit) {
    List<Widget> daysTextList = List.empty(growable: true);
    List<Widget> hoursTextList = List.empty(growable: true);
    List<Widget> costTextList = List.empty(growable: true);

    // Days Info Column
    daysTextList.add(
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset('assets/ic_days.svg'),
          const SizedBox(width: 6.0),
          Text(
            AppLocalizations.of(context)!.days,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );

    daysTextList.add(const SizedBox(height: 20.0));

    // Hours info column
    hoursTextList.add(
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset('assets/ic_days.svg'),
          const SizedBox(width: 6.0),
          Text(
            AppLocalizations.of(context)!.hours,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );

    hoursTextList.add(const SizedBox(height: 20.0));

    // Cost info column
    costTextList.add(
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset('assets/ic_banknote.svg'),
          const SizedBox(width: 6.0),
          Text(
            AppLocalizations.of(context)!.cost,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );

    costTextList.add(const SizedBox(height: 20.0));

    // Fill the columns
    if (timeSplit?.splits != null) {
      for (final split in timeSplit!.splits!) {
        for (final dayOfWeek in split.daysOfWeek!) {
          // Add info to days column
          daysTextList.add(
            Text(
              getDayOfWeekNameByOrder(dayOfWeek, context) ?? '',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
          daysTextList.add(const SizedBox(height: 12.0));

          // Add info to hours column
          hoursTextList.add(
            Text(
              '${split.startHour}:00-${split.endHour}:00',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
          hoursTextList.add(const SizedBox(height: 12.0));

          // Add info to cost column
          costTextList.add(
            Text(
              formatCurrency((split.price ?? 0) / 100),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
          costTextList.add(const SizedBox(height: 12.0));
        }
      }
      hoursTextList.removeLast();
      daysTextList.add(
        Text(
          AppLocalizations.of(context)!.rest_of_time,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
      costTextList.add(
        Text(
          formatCurrency((timeSplit.defaultPrice ?? 0) / 100),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: daysTextList,
          ),
        ),
        Flexible(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: hoursTextList,
          ),
        ),
        Flexible(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: costTextList,
          ),
        )
      ],
    );
  }
}

class CarConfirmModalSheet extends StatefulWidget {
  final String registrationNumber;
  final String carName;
  final Function() onConfirm;
  final Function() onBack;

  const CarConfirmModalSheet({
    super.key,
    required this.registrationNumber,
    required this.carName,
    required this.onConfirm,
    required this.onBack,
  });

  @override
  State<CarConfirmModalSheet> createState() => _CarConfirmModalSheetState();
}

class _CarConfirmModalSheetState extends State<CarConfirmModalSheet> {
  @override
  Widget build(BuildContext context) {
    return ModalBottomSheetContainer(
      iconAsset: 'assets/ic_car.svg',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppLocalizations.of(context)!.confirmCar,
            style: const TextStyle(
              color: Color(0xFF101828),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 14.0),
          Text(
            widget.registrationNumber.toUpperCase(),
            style: const TextStyle(
              color: Color(0xFF101828),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 14.0),
          Text(
            widget.carName.toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF667085),
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 48.0),
          ParkioButton(
            text: AppLocalizations.of(context)!.confirm,
            onPressed: widget.onConfirm,
          ),
          const SizedBox(height: 24.0),
          ParkioButton(
            text: AppLocalizations.of(context)!.otherNumber,
            type: ButtonType.neutral,
            onPressed: widget.onBack,
          )
        ],
      ),
    );
  }
}

class CarDeleteModalSheet extends StatefulWidget {
  final String registrationNumber;
  final String carBrand;
  final String carModel;
  final Function() onDelete;
  final Function() onBack;

  const CarDeleteModalSheet({
    super.key,
    required this.registrationNumber,
    required this.carBrand,
    required this.carModel,
    required this.onDelete,
    required this.onBack,
  });

  @override
  State<CarDeleteModalSheet> createState() => _CarDeleteModalSheetState();
}

class _CarDeleteModalSheetState extends State<CarDeleteModalSheet> {
  @override
  Widget build(BuildContext context) {
    return ModalBottomSheetContainer(
      backgroundColor: const Color(0xFFFEF3F2),
      foregroundColor: const Color(0xFFFEE4E2),
      contentColor: const Color(0xFFD92D20),
      iconAsset: 'assets/ic_car_outlined.svg',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppLocalizations.of(context)!.deleteVehicle,
            style: const TextStyle(
              color: Color(0xFF101828),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 14.0),
          Text(
            AppLocalizations.of(context)!.deleteVehicleModalSubtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF667085)),
          ),
          const SizedBox(height: 14.0),
          Text(
            widget.registrationNumber.toUpperCase(),
            style: const TextStyle(
              color: Color(0xFF101828),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 14.0),
          Text(
            '${widget.carBrand}\n${widget.carModel}'.toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF667085)),
          ),
          const SizedBox(height: 24.0),
          Row(
            children: [
              Flexible(
                flex: 1,
                child: ParkioButton(
                  text: AppLocalizations.of(context)!.cancel,
                  type: ButtonType.neutral,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                flex: 2,
                child: ParkioButton(
                  text: AppLocalizations.of(context)!.delete,
                  type: ButtonType.negative,
                  onPressed: widget.onDelete,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CardDeleteModalSheet extends StatefulWidget {
  final Function() onDelete;
  final Function() onBack;

  const CardDeleteModalSheet({
    super.key,
    required this.onDelete,
    required this.onBack,
  });

  @override
  State<CardDeleteModalSheet> createState() => _CardDeleteModalSheetState();
}

class _CardDeleteModalSheetState extends State<CardDeleteModalSheet> {
  @override
  Widget build(BuildContext context) {
    return ModalBottomSheetContainer(
      backgroundColor: const Color(0xFFFEF3F2),
      foregroundColor: const Color(0xFFFEE4E2),
      contentColor: const Color(0xFFD92D20),
      iconAsset: 'assets/ic_payments_outline.svg',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppLocalizations.of(context)!.deleteCard,
            style: const TextStyle(
              color: Color(0xFF101828),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 14.0),
          Text(
            AppLocalizations.of(context)!.deleteCardModalSubtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF667085)),
          ),
          const SizedBox(height: 24.0),
          Row(
            children: [
              Flexible(
                flex: 1,
                child: ParkioButton(
                  text: AppLocalizations.of(context)!.cancel,
                  type: ButtonType.neutral,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                flex: 2,
                child: ParkioButton(
                  text: AppLocalizations.of(context)!.delete,
                  type: ButtonType.negative,
                  onPressed: widget.onDelete,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LogOutModalSheet extends StatefulWidget {
  final Function() onLogOut;

  const LogOutModalSheet({super.key, required this.onLogOut});

  @override
  State<LogOutModalSheet> createState() => _LogOutModalSheetState();
}

class _LogOutModalSheetState extends State<LogOutModalSheet> {
  @override
  Widget build(BuildContext context) {
    return ModalBottomSheetContainer(
      iconAsset: 'assets/ic_log_out.svg',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppLocalizations.of(context)!.logOut,
            style: const TextStyle(
              color: Color(0xFF101828),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Container(height: 14.0),
          Text(
            AppLocalizations.of(context)!.logOutModalSubtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF667085)),
          ),
          Container(height: 24.0),
          Row(
            children: [
              Flexible(
                flex: 1,
                child: ParkioButton(
                  text: AppLocalizations.of(context)!.cancel,
                  type: ButtonType.neutral,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                flex: 2,
                child: ParkioButton(
                  text: AppLocalizations.of(context)!.logOut,
                  onPressed: widget.onLogOut,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class DeleteAccountModalSheet extends StatefulWidget {
  final Function() onDelete;

  const DeleteAccountModalSheet({super.key, required this.onDelete});

  @override
  State<DeleteAccountModalSheet> createState() =>
      _DeleteAccountModalSheetState();
}

class _DeleteAccountModalSheetState extends State<DeleteAccountModalSheet> {
  @override
  Widget build(BuildContext context) {
    return ModalBottomSheetContainer(
      backgroundColor: const Color(0xFFFEF3F2),
      foregroundColor: const Color(0xFFFEE4E2),
      contentColor: const Color(0xFFD92D20),
      iconAsset: 'assets/ic_alert.svg',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppLocalizations.of(context)!.delete,
            style: const TextStyle(
              color: Color(0xFF101828),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Container(height: 14.0),
          Text(
            AppLocalizations.of(context)!.deleteAccountModalSubtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF667085)),
          ),
          Container(height: 24.0),
          Row(
            children: [
              Flexible(
                flex: 1,
                child: ParkioButton(
                  text: AppLocalizations.of(context)!.cancel,
                  type: ButtonType.neutral,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                flex: 2,
                child: ParkioButton(
                  text: AppLocalizations.of(context)!.delete,
                  type: ButtonType.negative,
                  onPressed: widget.onDelete,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ChangeEmailModalSheet extends StatefulWidget {
  final Function(String) onContinue;

  const ChangeEmailModalSheet({super.key, required this.onContinue});

  @override
  State<ChangeEmailModalSheet> createState() => _ChangeEmailModalSheetState();
}

class _ChangeEmailModalSheetState extends State<ChangeEmailModalSheet> {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ModalBottomSheetContainer(
      iconAsset: 'assets/ic_mail.svg',
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context)!.changeEmail,
              style: const TextStyle(
                color: Color(0xFF101828),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 14.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.email,
                  style: const TextStyle(
                    color: Color(0xFF101828),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6.0),
                MailTextField(
                  controller: emailController,
                  autofillHints: const [AutofillHints.email],
                  inactiveTextColor: const Color(0xFF101828),
                  inactiveIconColor: const Color(0xFF667085),
                ),
              ],
            ),
            const SizedBox(height: 24.0),
            Row(
              children: [
                Flexible(
                  flex: 2,
                  child: ParkioButton(
                    text: AppLocalizations.of(context)!.cancel,
                    type: ButtonType.neutral,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 12),
                Flexible(
                  flex: 3,
                  child: ParkioButton(
                    text: AppLocalizations.of(context)!.continueButton,
                    onPressed: () => widget.onContinue(emailController.text),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ChangePhoneModalSheet extends StatefulWidget {
  final Function(String) onContinue;

  const ChangePhoneModalSheet({super.key, required this.onContinue});

  @override
  State<ChangePhoneModalSheet> createState() => _ChangePhoneModalSheetState();
}

class _ChangePhoneModalSheetState extends State<ChangePhoneModalSheet> {
  final TextEditingController phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ModalBottomSheetContainer(
      iconAsset: 'assets/ic_phone.svg',
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context)!.changePhone,
              style: const TextStyle(
                color: Color(0xFF101828),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 14.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.phoneNumber,
                  style: const TextStyle(
                    color: Color(0xFF101828),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6.0),
                PhoneTextField(
                  controller: phoneNumberController,
                  autofillHints: const [AutofillHints.telephoneNumber],
                  inactiveTextColor: const Color(0xFF101828),
                  inactiveIconColor: const Color(0xFF667085),
                ),
              ],
            ),
            const SizedBox(height: 24.0),
            Row(
              children: [
                Flexible(
                  flex: 2,
                  child: ParkioButton(
                    text: AppLocalizations.of(context)!.cancel,
                    type: ButtonType.neutral,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 12),
                Flexible(
                  flex: 3,
                  child: ParkioButton(
                    text: AppLocalizations.of(context)!.continueButton,
                    onPressed: () =>
                        widget.onContinue(phoneNumberController.text),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ParkingAreasSheet extends StatefulWidget {
  final List<get_areas.Area> parkingAreaList;

  final double initialSize;

  const ParkingAreasSheet({
    super.key,
    required this.parkingAreaList,
    required this.initialSize,
  });

  @override
  State<ParkingAreasSheet> createState() => _ParkingAreasSheetState();
}

class _ParkingAreasSheetState extends State<ParkingAreasSheet> {
  final _sheet = GlobalKey();
  final _controller = DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onChanged);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  DraggableScrollableSheet get sheet =>
      (_sheet.currentWidget as DraggableScrollableSheet);

  void _onChanged() {
    final currentSize = _controller.size;
    if (currentSize <= 0.05) _collapse();
  }

  void _collapse() => _animateSheet(sheet.snapSizes!.first);

  void _anchor() => _animateSheet(sheet.snapSizes!.last);

  void _expand() => _animateSheet(sheet.maxChildSize);

  void _hide() => _animateSheet(sheet.minChildSize);

  void _animateSheet(double size) {
    _controller.animateTo(
      size,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _showAreaInfoSheet(int areaId, int areaCode) => showModalBottomSheet(
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
          builder: (context, scrollController) => AreaInformationSheet(
            id: areaId,
            isParkioButtonVisible: true,
            onClick: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddParkingScreen(
                    areaId: areaId,
                    areaCode: areaCode,
                  ),
                ),
              );
            },
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final sheetMaxHeight =
        screenHeight - MediaQueryData.fromView(View.of(context)).padding.top;

    return DraggableScrollableSheet(
      key: _sheet,
      initialChildSize: widget.initialSize,
      maxChildSize: sheetMaxHeight / screenHeight,
      minChildSize: widget.initialSize,
      expand: false,
      snap: true,
      snapSizes: [widget.initialSize],
      controller: _controller,
      builder: (BuildContext context, ScrollController scrollController) {
        return DecoratedBox(
          decoration: const BoxDecoration(
            gradient: parkioBackgroundGradient,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Stack(
            alignment: AlignmentDirectional.topCenter,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ListView.separated(
                  controller: scrollController,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12.0),
                  itemCount: widget.parkingAreaList.length,
                  itemBuilder: (context, index) {
                    var parkingArea = widget.parkingAreaList[index];

                    // Set the padding for the first & last items of list
                    EdgeInsetsGeometry padding = EdgeInsets.zero;
                    if (index == 0 &&
                        index == widget.parkingAreaList.length - 1) {
                      padding = const EdgeInsets.symmetric(vertical: 32.0);
                    } else if (index == 0) {
                      padding = const EdgeInsets.only(top: 32.0);
                    } else if (index == widget.parkingAreaList.length - 1) {
                      padding = const EdgeInsets.only(bottom: 32.0);
                    }
                    return Padding(
                      padding: padding,
                      child: ParkingAreaInfo(
                        id: parkingArea.id ?? 0,
                        code: parkingArea.code ?? 0,
                        address: parkingArea.address ?? '',
                        description: parkingArea.name ?? '',
                        onInfoButtonClick: (id) {
                          _showAreaInfoSheet(id, parkingArea.code ?? 0);
                        },
                        onClick: (id, areaCode, address) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AddParkingScreen(
                                areaId: id,
                                areaCode: areaCode,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              // Indication that shows that this sheet is draggable
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  width: 50,
                  height: 4,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2.50),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class SearchAreasSheet extends StatefulWidget {
  final Function() onClose;

  const SearchAreasSheet({
    super.key,
    required this.onClose,
  });

  @override
  State<SearchAreasSheet> createState() => _SearchAreasSheetState();
}

class _SearchAreasSheetState extends State<SearchAreasSheet> {
  final _searchController = TextEditingController();
  Future<SearchAreaResponse>? _searchFuture;

  @override
  void initState() {
    super.initState();
  }

  Future<SearchAreaResponse> _searchAreas() async {
    try {
      final sessionPreview =
          await AreaService().searchAreas(_searchController.text);

      return sessionPreview;
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: sheetMaxHeight,
      decoration: const ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 14.0),
        child: Column(
          children: [
            SearchTextField(
              controller: _searchController,
              autofocus: true,
              onFieldSubmit: () => _searchFuture = _searchAreas(),
            ),
            Expanded(child: _buildSearchResultList()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResultList() {
    return _searchFuture == null
        ? _buildPlaceholder()
        : FutureBuilder(
            future: _searchFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  final addresses = snapshot.data!.addresses;
                  final parkingAreas = snapshot.data!.parkingAreas;

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 14.0),
                        if (addresses?.isNotEmpty == true)
                          _buildResultGroup(
                            true,
                            addresses!,
                          ),
                        if (addresses?.isNotEmpty == true &&
                            parkingAreas?.isNotEmpty == true)
                          const SizedBox(height: 24.0),
                        if (parkingAreas?.isNotEmpty == true)
                          _buildResultGroup(
                            false,
                            parkingAreas!,
                          ),
                      ],
                    ),
                  );
                } else {
                  return _buildErrorMessage();
                }
              } else {
                return Center(child: buildLoadingPlaceholder(context));
              }
            },
          );
  }

  Widget _buildResultGroup(bool isAddresses, List<ParkingArea> areas) {
    List<Widget> widgetList = List.empty(growable: true);
    for (final area in areas) {
      widgetList.add(_buildSearchResultItem(isAddresses, area));
      widgetList.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Container(height: 1.0, color: const Color(0xD9EFEEF6)),
        ),
      );
    }
    if (widgetList.isNotEmpty) widgetList.removeLast(); // Remove last separator

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isAddresses
              ? AppLocalizations.of(context)!.addresses
              : AppLocalizations.of(context)!.parkingAreas,
          style: const TextStyle(
            color: Color(0xFF101828),
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12.0),
        Column(children: widgetList),
      ],
    );
  }

  Widget _buildSearchResultItem(bool isAddress, ParkingArea area) {
    return GestureDetector(
      onTap: () => {
        if (area.code != null && area.id != null)
          {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => AddParkingScreen(
                  areaId: area.id!,
                  areaCode: area.code!,
                ),
              ),
            )
          }
      },
      child: Row(
        children: [
          SvgPicture.asset(
            isAddress ? 'assets/ic_location.svg' : 'assets/ic_dest.svg',
            width: 42.0,
            height: 42.0,
          ),
          const SizedBox(width: 8.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (area.code != null) _buildAreaCode(area.code!),
                  if (area.code != null) const SizedBox(width: 4.0),
                  Text(
                    isAddress ? area.address ?? '' : area.name ?? '',
                    style: const TextStyle(
                      color: Color(0xFF101828),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4.0),
              Text(
                isAddress ? area.name ?? '' : area.address ?? '',
                style: const TextStyle(color: Color(0xFF667085)),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAreaCode(int code) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: ShapeDecoration(
        color: const Color(0xD9EFEEF6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      child: Text(
        code.toString(),
        style: const TextStyle(
          color: Color(0xFF667085),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 64.0),
          Text(AppLocalizations.of(context)!.errorMessage),
          const SizedBox(height: 6.0),
          TextWithLink(
            text: '{${AppLocalizations.of(context)!.retry}}',
            onTap: (_) => _searchFuture = _searchAreas(),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 64.0),
          SvgPicture.asset('assets/ic_search_32.svg'),
          const SizedBox(height: 14.0),
          Text(
            AppLocalizations.of(context)!.areaSearchPlaceholder,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF101828),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class CarSelectModalSheet extends StatefulWidget {
  final Function(int) onContinue;
  final ScrollController scrollController;

  const CarSelectModalSheet({
    super.key,
    required this.onContinue,
    required this.scrollController,
  });

  @override
  State<CarSelectModalSheet> createState() => _CarSelectModalSheetState();
}

class _CarSelectModalSheetState extends State<CarSelectModalSheet> {
  bool _isLoading = false;
  final TextEditingController _numberPlateController = TextEditingController();
  final TextEditingController _vehicleNameController = TextEditingController();

  late Future<List<GetVehicleResponse>> _vehiclesFuture;

  Future<List<GetVehicleResponse>> _getVehicles() async {
    try {
      setState(() => _isLoading = true);

      final vehicles = await VehicleService().getVehicles();

      setState(() => _isLoading = false);

      return vehicles;
    } catch (e) {
      setState(() => _isLoading = false);

      return Future.error(e);
    }
  }

  Future<void> _setMainVehicle(int id) async {
    setState(() => _isLoading = true);

    try {
      final response = await VehicleService().setMainVehicle(id);

      setState(() => _isLoading = false);

      if (response.requestSucceed == 'true') {
        if (response.mainVehicle != null) {
          widget.onContinue(response.mainVehicle!);
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);

      return Future.error(e);
    }
  }

  Future<void> _addVehicle() async {
    setState(() => _isLoading = true);

    try {
      // We want for new vehicle to be set as main so it will be picked automatically on the main screen
      final response = await VehicleService().addVehicle(
        _vehicleNameController.text,
        _numberPlateController.text,
        true,
      );

      setState(() => _isLoading = false);

      widget.onContinue(response.id!);
    } catch (e) {
      setState(() => _isLoading = false);

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
  }

  @override
  void initState() {
    super.initState();
    _vehiclesFuture = _getVehicles();
  }

  @override
  Widget build(BuildContext context) {
    return ModalBottomSheetContainer(
      iconAsset: 'assets/ic_car.svg',
      child: _isLoading
          ? Center(child: buildLoadingPlaceholder(context))
          : FutureBuilder(
              future: _vehiclesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    // Show error message with retry button
                    return _buildErrorMessage();
                  } else {
                    // Show list of vehicles if there are any
                    if (snapshot.data?.isNotEmpty == true) {
                      return _buildVehicleList(snapshot.data!);
                    } else {
                      return _buildAddVehicle();
                    }
                  }
                } else {
                  // Show loading placeholder
                  return Center(child: buildLoadingPlaceholder(context));
                }
              },
            ),
    );
  }

  Widget _buildTitle({required String title, String? subtitle}) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF101828),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (subtitle != null) const SizedBox(height: 14.0),
        if (subtitle != null)
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF667085)),
          ),
        const SizedBox(height: 24.0),
      ],
    );
  }

  Widget _buildErrorMessage() {
    return Column(
      children: [
        Text(
          AppLocalizations.of(context)!.errorMessage,
          style: const TextStyle(color: Color(0xFF101828)),
        ),
        const SizedBox(height: 6.0),
        TextWithLink(
          text: "{${AppLocalizations.of(context)!.retry}}",
          onTap: (_) => _vehiclesFuture = _getVehicles(),
        ),
      ],
    );
  }

  Widget _buildVehicleList(List<GetVehicleResponse> vehicles) {
    return Column(
      children: [
        //Title
        _buildTitle(title: AppLocalizations.of(context)!.selectVehicle),
        // Vehicle list
        Flexible(
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: const Color(0xFFD0D5DD),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: ListView.separated(
              controller: widget.scrollController,
              shrinkWrap: true,
              itemCount: vehicles.length,
              separatorBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  height: 1.0,
                  decoration: const BoxDecoration(gradient: parkioGradient),
                ),
              ),
              itemBuilder: (context, index) {
                final vehicle = vehicles[index];

                return VehicleListItem(
                  isDarkTheme: false,
                  id: vehicle.id!,
                  isMain: vehicle.mainVehicle == true,
                  numberPlate: vehicle.licencePlate!,
                  carName: vehicle.name,
                  onRadioClick: (id) => _setMainVehicle(id),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddVehicle() {
    return Column(
      children: [
        _buildTitle(
          title: AppLocalizations.of(context)!.addVehicleTitle,
          subtitle: AppLocalizations.of(context)!.addVehicleSubtitle,
        ),
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              controller: widget.scrollController,
              child: Column(
                children: [
                  _buildTextFieldWithHint(
                    hint: AppLocalizations.of(context)!.numberPlate,
                    controller: _numberPlateController,
                  ),
                  const SizedBox(height: 20.0),
                  _buildTextFieldWithHint(
                    hint: AppLocalizations.of(context)!.vehicleName,
                    controller: _vehicleNameController,
                  ),
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 24.0),
        ParkioButton(
          text: AppLocalizations.of(context)!.confirm,
          onPressed: _addVehicle,
        ),
      ],
    );
  }

  Widget _buildTextFieldWithHint({
    required String hint,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          hint,
          style: const TextStyle(
            color: Color(0xFF101828),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6.0),
        ParkioTextField(
          controller: controller,
          hint: hint,
          inactiveTextColor: const Color(0xFF101828),
          inactiveIconColor: const Color(0xFF667085),
        ),
      ],
    );
  }
}

class PaymentSelectModalSheet extends StatefulWidget {
  final Function(int) onContinue;
  final ScrollController scrollController;

  const PaymentSelectModalSheet({
    super.key,
    required this.onContinue,
    required this.scrollController,
  });

  @override
  State<PaymentSelectModalSheet> createState() => _PaymentSelectModalState();
}

class _PaymentSelectModalState extends State<PaymentSelectModalSheet> {
  bool _isLoading = false;

  late Future<List<PaymentCard>> paymentsFuture;

  Future<List<PaymentCard>> _getPaymentMethods() async {
    try {
      setState(() => _isLoading = true);

      final paymentMethods = await PaymentService().getPaymentMethods();

      setState(() => _isLoading = false);

      return paymentMethods;
    } catch (e) {
      setState(() => _isLoading = false);

      return Future.error(e);
    }
  }

  Future<void> _setMainPaymentMethod(String token) async {
    setState(() => _isLoading = true);

    try {
      final response = await PaymentService().setMainPaymentMethod(token);

      setState(() => _isLoading = false);

      if (response == true) {
        widget.onContinue(0);
      }
    } catch (e) {
      setState(() => _isLoading = false);

      return Future.error(e);
    }
  }

  @override
  void initState() {
    super.initState();
    paymentsFuture = _getPaymentMethods();
  }

  @override
  Widget build(BuildContext context) {
    return ModalBottomSheetContainer(
      iconAsset: 'assets/ic_card.svg',
      child: _isLoading
          ? Center(child: buildLoadingPlaceholder(context))
          : FutureBuilder(
              future: paymentsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    // Show error message with retry button
                    return _buildErrorMessage();
                  } else {
                    // Show list of vehicles if there are any
                    if (snapshot.data?.isNotEmpty == true) {
                      return _buildPaymentMethodsList(snapshot.data!);
                    } else {
                      return Container(); // TODO: Replace with 'Add payment method' functionality
                    }
                  }
                } else {
                  // Show loading placeholder
                  return Center(child: buildLoadingPlaceholder(context));
                }
              },
            ),
    );
  }

  Widget _buildTitle({required String title, String? subtitle}) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF101828),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (subtitle != null) const SizedBox(height: 14.0),
        if (subtitle != null)
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF667085)),
          ),
        const SizedBox(height: 24.0),
      ],
    );
  }

  Widget _buildErrorMessage() {
    return Column(
      children: [
        Text(
          AppLocalizations.of(context)!.errorMessage,
          style: const TextStyle(color: Color(0xFF101828)),
        ),
        const SizedBox(height: 6.0),
        TextWithLink(
          text: "{${AppLocalizations.of(context)!.retry}}",
          onTap: (_) => paymentsFuture = _getPaymentMethods(),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodsList(List<PaymentCard> paymentMethods) {
    return Column(
      children: [
        // Title
        _buildTitle(title: AppLocalizations.of(context)!.selectPaymentMethod),
        // Payment methods list
        Flexible(
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: const Color(0xFFD0D5DD),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: ListView.separated(
              controller: widget.scrollController,
              shrinkWrap: true,
              itemCount: paymentMethods.length,
              separatorBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  height: 1.0,
                  decoration: const BoxDecoration(gradient: parkioGradient),
                ),
              ),
              itemBuilder: (context, index) {
                final paymentMethod = paymentMethods[index];

                return PaymentListItem(
                  isDarkTheme: false,
                  token: paymentMethod.token!,
                  isMain: paymentMethod.main == true,
                  lastDigits:
                      '••• ${paymentMethod.card?.substring(paymentMethod.card!.length - 4)}',
                  type: "VISA", // TODO: Replace with real info from response
                  onRadioClick: (id) => _setMainPaymentMethod(id),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class PermitOptionSelectModalSheet extends StatefulWidget {
  final List<PermitOption> permitOptions;
  final int mainOptionId;
  final Function(int) onContinue;
  final ScrollController scrollController;

  const PermitOptionSelectModalSheet({
    super.key,
    required this.permitOptions,
    required this.mainOptionId,
    required this.onContinue,
    required this.scrollController,
  });

  @override
  State<PermitOptionSelectModalSheet> createState() =>
      _PermitSelectModalState();
}

class _PermitSelectModalState extends State<PermitOptionSelectModalSheet> {
  @override
  Widget build(BuildContext context) {
    return ModalBottomSheetContainer(
      iconAsset: 'assets/ic_check.svg',
      child: _buildPermitOptionsList(widget.permitOptions),
    );
  }

  Widget _buildTitle({required String title, String? subtitle}) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF101828),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (subtitle != null) const SizedBox(height: 14.0),
        if (subtitle != null)
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF667085)),
          ),
        const SizedBox(height: 24.0),
      ],
    );
  }

  Widget _buildPermitOptionsList(List<PermitOption> permitOptions) {
    return Column(
      children: [
        // Title
        _buildTitle(title: AppLocalizations.of(context)!.selectPermitOption),
        // Payment methods list
        Flexible(
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: const Color(0xFFD0D5DD),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: ListView.separated(
              controller: widget.scrollController,
              shrinkWrap: true,
              itemCount: permitOptions.length,
              separatorBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  height: 1.0,
                  decoration: const BoxDecoration(gradient: parkioGradient),
                ),
              ),
              itemBuilder: (context, index) {
                final permitOption = permitOptions[index];

                return _buildListItem(
                  permitOption,
                  widget.mainOptionId,
                  (id) => widget.onContinue(id),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListItem(
    PermitOption item,
    int mainOptionId,
    Function(int) onRadioButtonClick,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 24,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: item.duration == null
                    ? Container()
                    : Text(
                        AppLocalizations.of(context)!.nMonths(item.duration!),
                        style: const TextStyle(
                          color: Color(0xFF101828),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
              ),
              // Radio button of main payment method
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    formatCurrency((item.price ?? 0) / 100),
                    style: const TextStyle(color: Color(0xFF667085)),
                  ),
                  const SizedBox(width: 12.0),
                  ParkioRadioButton(
                    isChecked: (item.id ?? 0) == widget.mainOptionId,
                    onClick: () => onRadioButtonClick(item.id ?? 0),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
