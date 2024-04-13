import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:parkio/screens/home.dart';
import 'package:parkio/util/const.dart';

import 'api/firebase_api.dart';
// import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    // options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseApi().initNotifications();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: parkioTheme,
      child: MaterialApp(
        theme: parkioTheme,
        darkTheme: parkioTheme,
        themeMode: ThemeMode.dark,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'), // English
          Locale('sv'), // Swedish
        ],
        home: const ParkioHomeScreen(),
      ),
    );
  }
}
