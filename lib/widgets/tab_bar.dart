import 'package:flutter/material.dart';

class ParkioTabBar extends StatefulWidget {
  final TabController controller;
  final List<Tab> tabs;

  const ParkioTabBar({
    super.key,
    required this.controller,
    required this.tabs,
  });

  @override
  State<ParkioTabBar> createState() => _ParkioTabBarState();
}

class _ParkioTabBarState extends State<ParkioTabBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      height: 48.0,
      decoration: BoxDecoration(
        color: const Color(0x1AFFFFFF),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TabBar(
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: const EdgeInsets.all(8.0),
        indicatorWeight: 0.0,
        controller: widget.controller,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: const Color(0x4DFFFFFF),
        ),
        unselectedLabelColor: Colors.white,
        tabs: widget.tabs,
        splashFactory: NoSplash.splashFactory,
        splashBorderRadius: BorderRadius.circular(10.0),
      ),
    );
  }
}
