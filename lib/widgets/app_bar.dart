import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:parkio/util/color.dart';
import 'package:parkio/widgets/text.dart';

import 'buttons.dart';
import 'end_drawer.dart';
import 'logo.dart';

class ParkioAppBar extends StatefulWidget implements PreferredSizeWidget {
  const ParkioAppBar({super.key}) : preferredSize = const Size.fromHeight(84.0);

  @override
  final Size preferredSize; // default is 56.0

  @override
  State<ParkioAppBar> createState() => _ParkioAppBarState();
}

class _ParkioAppBarState extends State<ParkioAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      scrolledUnderElevation: 0.0,
      toolbarHeight: 84.0,
      title: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ParkioBackButton(
              asset: 'assets/ic_back.svg',
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ParkioAppBarWithLogo extends StatefulWidget
    implements PreferredSizeWidget {
  final String? asset;
  final String title;

  const ParkioAppBarWithLogo({
    super.key,
    this.asset,
    required this.title,
  }) : preferredSize = const Size.fromHeight(90.0);

  @override
  final Size preferredSize; // default is 56.0

  @override
  State<ParkioAppBarWithLogo> createState() => _ParkioAppBarWithLogoState();
}

class _ParkioAppBarWithLogoState extends State<ParkioAppBarWithLogo> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      scrolledUnderElevation: 0.0,
      toolbarHeight: 90.0,
      title: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ParkioBackButton(
              asset: 'assets/ic_back.svg',
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            DrawerMenuElement(
              asset: widget.asset,
              text: widget.title,
            ),
            const ParkioLogo(),
          ],
        ),
      ),
    );
  }
}

class ActiveParkingAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String? asset;
  final String title;

  const ActiveParkingAppBar({
    super.key,
    this.asset,
    required this.title,
  }) : preferredSize = const Size.fromHeight(90.0);

  @override
  final Size preferredSize; // default is 56.0

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      scrolledUnderElevation: 0.0,
      toolbarHeight: 90.0,
      title: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ParkioBackButton(
              asset: 'assets/ic_back.svg',
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (asset != null)
                  SvgPicture.asset(
                    asset!,
                    height: 30.0,
                    colorFilter:
                        const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                if (asset != null) const SizedBox(width: 8.0),
                GradientText(
                  title,
                  gradient: parkioGoldenGradient,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const ParkioLogo(),
          ],
        ),
      ),
    );
  }
}
