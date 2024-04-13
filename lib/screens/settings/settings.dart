import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parkio/model/settings/get_profile.dart';
import 'package:parkio/screens/settings/tabs/profile.dart';
import 'package:parkio/service/user_settings_service.dart';
import 'package:parkio/util/color.dart';
import 'package:parkio/widgets/app_bar.dart';

import '../../widgets/loading.dart';
import '../../widgets/tab_bar.dart';
import '../../widgets/text.dart';
import 'tabs/notifications.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _index = 0;
  bool _isLoading = false;
  late Future<Profile> _profileFuture;

  Future<Profile> _getProfile() async {
    try {
      final profile = await UserSettingsService().getProfile();

      return profile;
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _profileFuture = _getProfile();

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
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
          asset: 'assets/ic_settings.svg',
          title: AppLocalizations.of(context)!.menuSettingsTitle,
        ),
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        body: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              FutureBuilder<Profile>(
                future: _profileFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      // Show tabs with data
                      return _buildTabs(snapshot.data);
                    } else {
                      // Error message with 'Retry' button
                      return _buildErrorMessage();
                    }
                  } else {
                    // Loading placeholder
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
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
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
    );
  }

  Widget _buildErrorMessage() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 32.0,
        horizontal: 24.0,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppLocalizations.of(context)!.errorMessage),
            const SizedBox(height: 6.0),
            TextWithLink(
              text: '{${AppLocalizations.of(context)!.retry}}',
              onTap: (_) {
                _profileFuture = _getProfile();
              },
            )
          ],
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
                  AppLocalizations.of(context)!.tabProfile,
                  gradient: parkioGradient,
                  style: const TextStyle(fontSize: 16.0),
                )
              : Text(
                  AppLocalizations.of(context)!.tabProfile,
                  style: const TextStyle(fontSize: 16.0),
                ),
        ),
        Tab(
          child: _index == 1
              ? GradientText(
                  AppLocalizations.of(context)!.tabNotifications,
                  gradient: parkioGradient,
                  style: const TextStyle(fontSize: 16.0),
                )
              : Text(
                  AppLocalizations.of(context)!.tabNotifications,
                  style: const TextStyle(fontSize: 16.0),
                ),
        ),
      ],
    );
  }

  Widget _buildTabs(Profile? data) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(24.0, 8.0, 24.0, 0.0),
          child: _buildTabBar(),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // Initialize 'Profile' tab with all the data from getProfile request
              ProfileTab(
                firstName: data?.firstName ?? '',
                lastName: data?.secondName ?? '',
                address: data?.residencePlace?.streetAddress ?? '',
                postCode: data?.residencePlace?.postCode,
                city: data?.residencePlace?.suburb ?? '',
                phoneNumber: data?.phone ?? '',
                email: data?.email ?? '',
                onProfileReload: () => _profileFuture = _getProfile(),
                onLoadingStateChange: (state) {
                  setState(() => _isLoading = state);
                },
              ),
              NotificationsTab(
                settings: data?.notificationsSettings,
                onProfileReload: () => _profileFuture = _getProfile(),
                onLoadingStateChange: (state) {
                  setState(() => _isLoading = state);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
