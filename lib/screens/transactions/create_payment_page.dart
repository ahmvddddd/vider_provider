// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controllers/services/user_id_controller.dart';
import '../../controllers/transactions/payment_controller.dart';
import '../../utils/constants/sizes.dart';
import 'send_payout_page.dart';

class PaymentPage extends ConsumerStatefulWidget {
  const PaymentPage({super.key});

  @override
  ConsumerState<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends ConsumerState<PaymentPage> {
  String? currentUserId;
  final UserIdService userIdService = UserIdService();
  String? selectedCurrency;
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.watch(currenciesProvider));
    getCurrentUserId();
  }

  Future<void> getCurrentUserId() async {
    final userId = await userIdService.getCurrentUserId();
    setState(() {
      currentUserId = userId;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currenciesAsync = ref.watch(currenciesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text("Pay with Crypto")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              currenciesAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text("Error: $e")),
                data:
                    (currencies) => DropdownButtonFormField<String>(
                      menuMaxHeight: 300,
                      value: selectedCurrency,
                      items:
                          currencies
                              .map(
                                (currency) => DropdownMenuItem(
                                  value: currency,
                                  child: Text(currency),
                                ),
                              )
                              .toList(),
                      onChanged:
                          (value) => setState(() => selectedCurrency = value),
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? "Select a currency"
                                  : null,
                      decoration: const InputDecoration(labelText: "Currency"),
                    ),
              ),

              const SizedBox(height: Sizes.spaceBtwItems),
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  hintText: "Amount in USD",
                  hintStyle: Theme.of(context).textTheme.labelSmall,
                ),
                keyboardType: TextInputType.number,
                validator:
                    (value) =>
                        double.tryParse(value ?? '') == null
                            ? "Enter a valid number"
                            : null,
              ),

              const SizedBox(height: Sizes.spaceBtwItems),
              // TextFormField(
              //   controller: _currencyController,
              //   decoration:
              //        InputDecoration(labelText: "Currency",
              //   labelStyle: Theme.of(context).textTheme.labelSmall,
              //   hintText: "Currency (e.g. BTC)",
              //   hintStyle: Theme.of(context).textTheme.labelSmall,),
              //   validator: (value) => value == null || value.trim().isEmpty
              //       ? "Enter a currency"
              //       : null,
              // ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final payload = {
                      "amount": double.parse(_amountController.text),
                      "currency": selectedCurrency!,
                      "userId": currentUserId,
                    };

                    try {
                      final data = await ref.read(
                        paymentProvider(payload).future,
                      );

                      final urlString = data['invoice_url'] ?? '';
                      if (urlString.isEmpty) {
                        throw Exception("No valid payment URL received");
                      }

                      final url = Uri.parse(urlString);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url, webOnlyWindowName: '_blank');
                      } else {
                        throw Exception("Could not launch payment URL");
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text("Error: $e")));
                    }
                  }
                },
                child: const Text("Pay"),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PayoutPage()),
                  );
                },
                child: Text(
                  'Payout',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
