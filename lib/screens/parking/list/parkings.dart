import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parkio/util/color.dart';

import '../../../widgets/app_bar.dart';
import '../../../widgets/tab_bar.dart';
import '../../../widgets/text.dart';
import 'tabs/history.dart';
import 'tabs/ongoing.dart';
import 'tabs/permits.dart';

class ParkingScreen extends StatefulWidget {
  final int tabIndex;
  const ParkingScreen({super.key, this.tabIndex = 0});

  @override
  State<ParkingScreen> createState() => _ParkingScreenState();
}

class _ParkingScreenState extends State<ParkingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _index = 0;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _tabController.animateTo(widget.tabIndex);
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  void _handleTabSelection() {
    setState(() => _index = _tabController.index);
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: parkioBackgroundGradient),
      child: Scaffold(
        appBar: ParkioAppBarWithLogo(
          asset: 'assets/ic_parking.svg',
          title: AppLocalizations.of(context)!.menuParkingTitle,
        ),
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        body: SafeArea(
          bottom: false,
          child: _buildTabs(),
        ),
      ),
    );
  }

  ParkioTabBar _buildTabBar() {
    return ParkioTabBar(
      controller: _tabController,
      tabs: [
        Tab(
          child: _index == 0
              ? GradientText(
                  AppLocalizations.of(context)!.tabOngoing,
                  gradient: parkioGradient,
                  style: const TextStyle(fontSize: 16.0),
                )
              : Text(
                  AppLocalizations.of(context)!.tabOngoing,
                  style: const TextStyle(fontSize: 16.0),
                ),
        ),
        Tab(
          child: _index == 1
              ? GradientText(
                  AppLocalizations.of(context)!.tabHistory,
                  gradient: parkioGradient,
                  style: const TextStyle(fontSize: 16.0),
                )
              : Text(
                  AppLocalizations.of(context)!.tabHistory,
                  style: const TextStyle(fontSize: 16.0),
                ),
        ),
        Tab(
          child: _index == 2
              ? GradientText(
                  AppLocalizations.of(context)!.tabPermit,
                  gradient: parkioGradient,
                  style: const TextStyle(fontSize: 16.0),
                )
              : Text(
                  AppLocalizations.of(context)!.tabPermit,
                  style: const TextStyle(fontSize: 16.0),
                ),
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 32.0),
            child: _buildTabBar(),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                OngoingTab(),
                HistoryTab(),
                PermitsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
