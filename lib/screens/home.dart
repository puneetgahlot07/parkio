import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:parkio/widgets/logo.dart';

import '../util/const.dart';
import 'create_account.dart';
import 'map_screen.dart';

class ParkioHomeScreen extends StatefulWidget {
  final storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  const ParkioHomeScreen({super.key});

  @override
  State<ParkioHomeScreen> createState() => _ParkioHomeScreenState();
}

class _ParkioHomeScreenState extends State<ParkioHomeScreen> {
  late Future<String> _tokenFuture;
  Future<String> _getToken() async {
    String token =
        await widget.storage.read(key: StorageKey.accessToken.value) ?? '';
    await Future.delayed(const Duration(milliseconds: 1700)); // TODO: Remove
    return token;
  }

  @override
  void initState() {
    super.initState();
    _tokenFuture = _getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: FutureBuilder<String>(
        future: _tokenFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return const CreateAccountScreen();
            } else {
              return const MapScreen();
            }
          } else {
            return const Center(child: ParkioLogo());
          }
        },
      ),
    );
  }
}
