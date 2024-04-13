import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:parkio/screens/bonus.dart';
import 'package:parkio/screens/business/business.dart';
import 'package:parkio/screens/help/help.dart';
import 'package:parkio/screens/parking/list/parkings.dart';
import 'package:parkio/screens/payment/payments.dart';
import 'package:parkio/screens/settings/settings.dart';
import 'package:parkio/screens/sharing.dart';
import 'package:parkio/screens/why_parkio/why_parkio.dart';

import '../screens/vehicles/vehicles.dart';
import '../util/color.dart';
import 'buttons.dart';
import 'logo.dart';

class DrawerMenuElement extends StatefulWidget {
  final String? asset;
  final String text;
  final MainAxisAlignment mainAxisAlignment;
  final Function()? onClick;

  const DrawerMenuElement({
    super.key,
    this.asset,
    required this.text,
    this.onClick,
    this.mainAxisAlignment = MainAxisAlignment.end,
  });

  @override
  State<DrawerMenuElement> createState() => _DrawerMenuElementState();
}

class _DrawerMenuElementState extends State<DrawerMenuElement> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onClick,
      child: Row(
        mainAxisAlignment: widget.mainAxisAlignment,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (widget.asset != null)
            SvgPicture.asset(
              widget.asset!,
              height: 30.0,
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
          if (widget.asset != null) const SizedBox(width: 8.0),
          Text(
            widget.text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class ParkioEndDrawer extends StatefulWidget {
  final Function() closeEndDrawer;

  const ParkioEndDrawer({super.key, required this.closeEndDrawer});

  @override
  State<ParkioEndDrawer> createState() => _ParkioEndDrawerState();
}

class _ParkioEndDrawerState extends State<ParkioEndDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.only(
          topStart: Radius.circular(18.0),
        ),
      ),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: const ShapeDecoration(
          gradient: parkioBackgroundGradient,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.only(
              topStart: Radius.circular(18.0),
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(24.0, 60.0, 24.0, 32.0),
          child: Stack(
            children: [
              ListView(
                children: [
                  const SizedBox(height: 24.0),
                  const SizedBox(height: 16.0),
                  DrawerMenuElement(
                    asset: 'assets/ic_parking.svg',
                    text: AppLocalizations.of(context)!.menuParkingTitle,
                    onClick: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ParkingScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16.0),
                  DrawerMenuElement(
                    asset: 'assets/ic_settings.svg',
                    text: AppLocalizations.of(context)!.menuSettingsTitle,
                    onClick: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SettingsScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16.0),
                  DrawerMenuElement(
                    asset: 'assets/ic_payments_outline.svg',
                    text: AppLocalizations.of(context)!.menuPaymentTitle,
                    onClick: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const PaymentScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16.0),
                  DrawerMenuElement(
                    asset: 'assets/ic_car_outlined.svg',
                    text: AppLocalizations.of(context)!.menuVehiclesTitle,
                    onClick: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const VehiclesScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16.0),
                  DrawerMenuElement(
                    asset: 'assets/ic_business.svg',
                    text: AppLocalizations.of(context)!.menuBusinessTitle,
                    onClick: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const BusinessScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16.0),
                  DrawerMenuElement(
                    asset: 'assets/ic_star.svg',
                    text: AppLocalizations.of(context)!.menuSharingTitle,
                    onClick: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SharingScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16.0),
                  DrawerMenuElement(
                    asset: 'assets/ic_why_parkio.svg',
                    text: AppLocalizations.of(context)!.menuWhyParkioTitle,
                    onClick: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const WhyParkioScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16.0),
                  DrawerMenuElement(
                    asset: 'assets/ic_bonus.svg',
                    text: AppLocalizations.of(context)!.menuBonusTitle,
                    onClick: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const BonusScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16.0),
                  DrawerMenuElement(
                    asset: 'assets/ic_help.svg',
                    text: AppLocalizations.of(context)!.menuHelpTitle,
                    onClick: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const HelpScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const ParkioLogo(),
                  ParkioBackButton(
                    asset: 'assets/ic_close.svg',
                    onPressed: widget.closeEndDrawer,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
