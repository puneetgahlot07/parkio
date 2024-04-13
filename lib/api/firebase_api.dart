import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:parkio/service/notification_service.dart';

import '../util/const.dart';

class FirebaseApi {
  /// An instance of FirebaseMessaging
  final _fcm = FirebaseMessaging.instance;
  final storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  /// Initialize notifications
  Future<void> initNotifications() async {
    /// Prompt user to allow push notifications for this app
    await _fcm.requestPermission(provisional: true);

    /// Access token, that is being stored on device
    String? accessToken = await storage.read(key: StorageKey.accessToken.value);

    /// Fetch the FCM token for a particular device
    _fcm.getToken().then((token) {
      // If token is not null, send it to the server
      if (token != null && accessToken != null) {
        try {
          NotificationService().sendToken(token);
        } catch (e) {
          if (kDebugMode) print(e.toString());
        }
      }
    });
  }
}
