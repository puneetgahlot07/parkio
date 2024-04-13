import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parkio/model/payment/payment_card.dart';
import 'package:parkio/screens/payment/add_payment_method.dart';
import 'package:parkio/service/payment_service.dart';
import 'package:parkio/util/color.dart';
import 'package:parkio/widgets/loading.dart';
import 'package:parkio/widgets/slidable.dart';
import 'package:parkio/widgets/text.dart';

import '../../widgets/app_bar.dart';
import '../../widgets/buttons.dart';
import '../../widgets/payment_list_item.dart';
import '../../widgets/sheets.dart';
import '../../widgets/snackbar.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;

  late Future<List<PaymentCard>> _paymentsFuture;

  Future<List<PaymentCard>> _getPaymentMethods() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final paymentMethods = await PaymentService().getPaymentMethods();

      setState(() {
        _isLoading = false;
      });

      return paymentMethods;
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      return Future.error(e);
    }
  }

  Future<void> _setMainPaymentMethod(String token) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await PaymentService().setMainPaymentMethod(token);

      setState(() {
        _isLoading = false;
      });

      if (response == true) {
        setState(() {
          _paymentsFuture = _getPaymentMethods();
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      return Future.error(e);
    }
  }

  void _showPaymentMethodDeleteModalSheet(String token) => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return CardDeleteModalSheet(
            onDelete: () async {
              try {
                setState(() {
                  _isLoading = false;
                });

                bool deletedSuccessfully = await _deletePaymentMethod(token);

                if (!context.mounted) return;

                if (deletedSuccessfully) {
                  Navigator.pop(context); // Close the modal sheet
                  _paymentsFuture =
                      _getPaymentMethods(); // Reload vehicles list
                }
              } catch (e) {
                final exceptionString = e.toString();
                if (!context.mounted) return;

                Navigator.pop(context);

                ScaffoldMessenger.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(
                    buildParkioSnackBar(exceptionString.substring(
                        exceptionString.indexOf(' '), exceptionString.length)),
                  );
              }
            },
            onBack: () {
              Navigator.pop(context);
            },
          );
        },
      );

  Future<bool> _deletePaymentMethod(String token) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await PaymentService().deletePaymentMethod(token);

      setState(() {
        _isLoading = false;
      });

      return response;
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      return Future.error(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _paymentsFuture = _getPaymentMethods();
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
          top: true,
          child: FutureBuilder<List<PaymentCard>>(
            future: _paymentsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  !_isLoading) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isEmpty) {
                    // Show message that user has no payments and button 'Add payment method'
                    return _buildNoPaymentsPlaceholder();
                  } else {
                    // Show the list of payments if list is not empty
                    final payments = snapshot.data!;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 14.0, bottom: 6.0),
                            child: Text(
                              AppLocalizations.of(context)!.paymentMethods,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 0,
                            child: Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: ShapeDecoration(
                                color: const Color(0x1AFFFFFF),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: ListView.separated(
                                shrinkWrap: true,
                                itemCount: payments.length,
                                separatorBuilder: (context, index) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Container(
                                    height: 1.0,
                                    color: const Color(0xEFEEF6D9),
                                  ),
                                ),
                                itemBuilder: (context, index) {
                                  final payment = payments[index];
                                  return ParkioSlidable(
                                    child: PaymentListItem(
                                      token: payment.token!,
                                      isMain: payment.main == true,
                                      lastDigits: "${payment.card}",
                                      type:
                                          "VISA", // TODO: Change to response field
                                      onRadioClick: (token) =>
                                          _setMainPaymentMethod(token),
                                    ),
                                    onRemove: () {
                                      // TODO: Change 0 to real token when request is ready
                                      _showPaymentMethodDeleteModalSheet(
                                        "${payment.token}",
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Align(
                                alignment: Alignment.bottomCenter,
                                child: _buildAddPaymentMethodButton()),
                          )
                        ],
                      ),
                    );
                  }
                } else {
                  // Error message
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 32.0,
                      horizontal: 24.0,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(snapshot.error.toString()),
                          const SizedBox(height: 6.0),
                          TextWithLink(
                            text: '{${AppLocalizations.of(context)!.retry}}',
                            onTap: (_) {
                              _paymentsFuture = _getPaymentMethods();
                            },
                          )
                        ],
                      ),
                    ),
                  );
                }
              } else {
                // Loading
                return Center(
                  child: buildLoadingPlaceholder(
                    context,
                    textColor: Colors.white,
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Padding _buildAddPaymentMethodButton() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0),
        child: ParkioProceedButton(
          text: AppLocalizations.of(context)!.addNewPaymentMethod,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AddPaymentMethodScreen(),
              ),
            );
          },
        ),
      );

  Widget _buildNoPaymentsPlaceholder() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 14.0),
                  Text(
                    AppLocalizations.of(context)!.noPaymentMethodsMessage,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            _buildAddPaymentMethodButton(),
          ],
        ),
      );
}
