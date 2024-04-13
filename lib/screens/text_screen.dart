import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parkio/service/policy_service.dart';
import 'package:parkio/util/color.dart';
import 'package:parkio/widgets/app_bar.dart';
import 'package:parkio/widgets/loading.dart';
import 'package:parkio/widgets/logo.dart';

import '../widgets/text.dart';

class PlainTextPage extends StatefulWidget {
  final String title;
  final String address;

  const PlainTextPage({
    super.key,
    this.title = '',
    required this.address,
  });

  @override
  State<PlainTextPage> createState() => _PlainTextPageState();
}

class _PlainTextPageState extends State<PlainTextPage> {
  late Future<String> _textFuture;

  Future<String> _getText() async {
    try {
      final text = await PolicyService().getPolicyText(
        widget.address,
      );

      return text;
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  void initState() {
    super.initState();

    _textFuture = _getText();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: parkioBackgroundGradient),
      child: Scaffold(
        appBar: const ParkioAppBar(),
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        body: SafeArea(
          top: true,
          child: SizedBox(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: 24.0,
                  top: 38.0,
                  end: 24.0,
                  bottom: 32.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                widget.title,
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
                        const SizedBox(height: 24.0),
                        _buildScreenContent(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScreenContent() {
    return FutureBuilder(
      future: _textFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return Row(
              children: [
                Flexible(
                  child: Text(
                    snapshot.data!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            );
          } else {
            return _buildErrorMessage(context, snapshot.error.toString());
          }
        } else {
          return Center(
            child: buildLoadingPlaceholder(context, textColor: Colors.white),
          );
        }
      },
    );
  }

  Widget _buildErrorMessage(BuildContext context, String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 32.0,
        horizontal: 24.0,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message),
            const SizedBox(height: 6.0),
            TextWithLink(
              text: '{${AppLocalizations.of(context)!.retry}}',
              onTap: (_) => _textFuture = _getText(),
            ),
          ],
        ),
      ),
    );
  }
}
