import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parkio/screens/payment/payments.dart';
import 'package:parkio/service/payment_service.dart';
import 'package:parkio/util/const.dart';
import 'package:parkio/widgets/logo.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../util/color.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/snackbar.dart';

class AddPaymentMethodScreen extends StatefulWidget {
  const AddPaymentMethodScreen({
    super.key,
  });

  @override
  State<AddPaymentMethodScreen> createState() => _AddPaymentMethodScreenState();
}

class _AddPaymentMethodScreenState extends State<AddPaymentMethodScreen> {
  bool _isLoading = false;
  String _currentUrl = '';

  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'VerifyCallback',
        onMessageReceived: (JavaScriptMessage message) {
          if (kDebugMode) {
            print(message.message);
          }
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const PaymentScreen(),
            ),
          );
        },
      )
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {
            setState(() => _isLoading = true);
          },
          onPageFinished: (String url) {
            setState(() => _isLoading = false);

            // Check if fully loaded page is the response from verify-callback request
            if (url.contains(paymentSuccessEndpoint)) {
              _controller.runJavaScript(
                '(function(){VerifyCallback.postMessage(window.document.body.outerHTML)})();',
              );
            }
          },
          onNavigationRequest: (navigation) {
            if (navigation.url.contains(paymentCancelEndpoint)) {
              NavigationDecision.prevent;
              Navigator.of(context).pop();
            }
            return NavigationDecision.navigate;
          },
          onUrlChange: (UrlChange urlChange) {
            setState(() {
              _currentUrl = urlChange.url ?? '';
            });
          },
        ),
      );

    _loadPaymentLink();
  }

  Future<void> _loadPaymentLink() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String paymentUri =
          await PaymentService().getVerificationPaymentUri() ?? '';

      setState(() {
        _isLoading = false;
      });

      _controller.loadRequest(Uri.parse(paymentUri));
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      final exceptionString = e.toString();
      final editedMessage = exceptionString.substring(
          exceptionString.indexOf(' '), exceptionString.length);
      if (!context.mounted) return;

      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          buildParkioSnackBar(editedMessage),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: parkioBackgroundGradient),
      child: Scaffold(
        appBar: ParkioAppBarWithLogo(
          asset: 'assets/ic_payments_outline.svg',
          title: AppLocalizations.of(context)!.menuPaymentTitle,
        ),
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Column(
                  children: [
                    // TODO: Remove debug info
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Container(
                    //     decoration: const ShapeDecoration(
                    //       color: Color(0x1AFFFFFF),
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.all(
                    //           Radius.circular(12.0),
                    //         ),
                    //       ),
                    //     ),
                    //     child: Padding(
                    //       padding: const EdgeInsets.all(8.0),
                    //       child: TextWithLink(
                    //         text: '{$_currentUrl}',
                    //         style: const TextStyle(
                    //           overflow: TextOverflow.ellipsis,
                    //         ),
                    //         onTap: (_) {
                    //           Clipboard.setData(
                    //             ClipboardData(text: _currentUrl),
                    //           );
                    //         },
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            color: Colors.white,
                          ),
                          WebViewWidget(controller: _controller),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (_isLoading)
                Container(
                  color: const Color(0x1A000000),
                  child: const Center(child: ParkioLogo()),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
