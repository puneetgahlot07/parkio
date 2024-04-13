import 'dart:io';

import 'package:flutter/material.dart';

String baseUrl =
    Platform.isAndroid ? 'http://192.168.3.4:4000' : 'http://localhost:4000';

String paymentCancelEndpoint = '/payment/verification/cancel';
String paymentSuccessEndpoint = '/payment/verification/accept';
String termsAndConditionsEndpoint = 'terms-and-conditions';
String privacyPolicyEndpoint = 'private-policy';
String faqEndpoint = 'faq';

enum SessionType {
  registration('registration'),
  login('login'),
  forgotPassword('forget_password');

  const SessionType(this.value);
  final String value;
}

enum ChangeSessionType {
  changePassword('change_password'),
  changeEmail('change_email'),
  changePhone('change_phone');

  const ChangeSessionType(this.value);
  final String value;
}

// Storage keys
enum StorageKey {
  accessToken('access_token'),
  refreshToken('refresh_token');

  const StorageKey(this.value);
  final String value;
}

// Type of button, that will change appearance of it
enum ButtonType { positive, neutral, negative }

final ThemeData parkioTheme = ThemeData(
  useMaterial3: true,
  fontFamily: 'Mabry Pro',
  brightness: Brightness.dark,
);

final ThemeData parkioLightTheme = ThemeData(
  useMaterial3: true,
  fontFamily: 'Mabry Pro',
  brightness: Brightness.light,
);
