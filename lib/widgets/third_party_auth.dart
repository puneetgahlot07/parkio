import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:parkio/widgets/buttons.dart';
import 'package:parkio/widgets/snackbar.dart';

/// The scopes required by this application.
const List<String> scopes = <String>['email', 'profile', 'openid'];

GoogleSignIn _googleSignIn = GoogleSignIn(
  clientId: Platform.isIOS
      ? '905815715716-mrfkap1aj8osl6s7s5he4f5sr9vc27fu.apps.googleusercontent.com'
      : '905815715716-55bfjirf8fri0dv7gpfties8t4relpmp.apps.googleusercontent.com',
  scopes: scopes,
);

class ThirdPartyAuthButtons extends StatefulWidget {
  const ThirdPartyAuthButtons({super.key});

  @override
  State<ThirdPartyAuthButtons> createState() => _ThirdPartyAuthButtonsState();
}

class _ThirdPartyAuthButtonsState extends State<ThirdPartyAuthButtons> {
  GoogleSignInAccount? _currentUser;
  String? _idToken;
  String? _accessToken;
  bool _isAuthorized = false; // has granted permissions?

  @override
  void initState() {
    super.initState();

    _googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount? account) async {
      // In mobile, being authenticated means being authorized...
      bool isAuthorized = account != null;

      setState(() {
        _currentUser = account;
        _isAuthorized = isAuthorized;
      });

      // Now that we know that the user can access the required scopes, the app
      // can call the REST API.
      if (isAuthorized) {
        // unawaited(_handleGetContact(account!));
      }
    });

    // It is recommended by Google Identity Services to render both the One Tap UX
    // and the Google Sign In button together to "reduce friction and improve
    // sign-in rates" ([docs](https://developers.google.com/identity/gsi/web/guides/display-button#html)).
    _googleSignIn.signInSilently();
  }

  // This is the on-click handler for the Sign In button that is rendered by Flutter.
  //
  // On the web, the on-click handler of the Sign In button is owned by the JS
  // SDK, so this method can be considered mobile only.
  Future<void> _signInWithGoogle() async {
    try {
      await _googleSignIn.signIn().then((result) {
        result?.authentication.then((googleKey) {
          setState(() {
            _accessToken = googleKey.accessToken;
            _idToken = googleKey.idToken;
          });
        });
      });
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          buildParkioSnackBar(e.toString()),
        );
    }
  }

  Future<void> _signOutWithGoogle() => _googleSignIn.disconnect();

  void signInWithFacebook() {}

  void signInWithApple() {}

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ParkioIconButton(
              asset: 'assets/ic_google.svg',
              onPressed: _signInWithGoogle,
            ),
            const SizedBox(width: 13),
            ParkioIconButton(
              asset: 'assets/ic_facebook.svg',
              onPressed: signInWithFacebook,
            ),
            const SizedBox(width: 13),
            ParkioIconButton(
              asset: 'assets/ic_apple.svg',
              onPressed: signInWithApple,
            ),
          ],
        ),
      ],
    );
  }
}
