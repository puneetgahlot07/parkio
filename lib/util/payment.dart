import 'dart:io' show Platform;

String? assetFromPaymentType(String? type) {
  String? result;

  switch (type?.toLowerCase()) {
    case 'visa':
      result = 'assets/ic_visa.svg';
    case 'mastercard':
      result = 'assets/ic_mastercard.svg';
    default:
      Platform.isIOS
          ? result = 'assets/ic_apple_pay.svg'
          : result = 'assets/ic_google_pay.svg';
  }

  return result;
}
