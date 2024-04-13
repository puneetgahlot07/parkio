import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parkio/screens/onboarding/why_parkio.dart';
import 'package:parkio/util/color.dart';
import 'package:parkio/util/const.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../service/payment_service.dart';
import '../../widgets/buttons.dart';
import '../../widgets/logo.dart';
import '../../widgets/onboarding_progress_indicator.dart';
import '../../widgets/snackbar.dart';

class AddCardPage extends StatefulWidget {
  const AddCardPage({
    super.key,
  });

  @override
  State<AddCardPage> createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> {
  bool _isLoading = false;
  late final WebViewController _controller;
  String _currentUrl = '';

  void _skip() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const WhyParkioPage(),
      ),
    );
  }

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
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const WhyParkioPage(),
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
        appBar: AppBar(
          toolbarHeight: 66.0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          scrolledUnderElevation: 0.0,
          title: const Padding(
            padding: EdgeInsets.only(top: 18.0),
            child: OnboardingProgressIndicator(pageIndex: 1),
          ),
        ),
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        body: SafeArea(
          top: true,
          bottom: true,
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
                    _buildTitle(),
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
                    _buildFooterButton(),
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

  Widget _buildTitle() => Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 6.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                AppLocalizations.of(context)!.addCardTitle,
                softWrap: true,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const ParkioLogo(),
          ],
        ),
      );

  Widget _buildFooterButton() => Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(24.0, 6.0, 24.0, 32.0),
        child: _currentUrl.contains(paymentSuccessEndpoint)
            ? ParkioButton(
                text: AppLocalizations.of(context)!.continueButton,
                onPressed: _skip,
              )
            : ParkioButton(
                text: AppLocalizations.of(context)!.skip,
                type: ButtonType.neutral,
                onPressed: _skip,
              ),
      );
}
