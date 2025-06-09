// ignore_for_file: use_build_context_synchronously, unused_result

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/transactions/payout_controller.dart';

class PayoutPage extends ConsumerStatefulWidget {
  const PayoutPage({super.key});

  @override
  ConsumerState<PayoutPage> createState() => _PayoutPageState();
}

class _PayoutPageState extends ConsumerState<PayoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _amountController = TextEditingController();
  final _currencyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Send Crypto")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: "Recipient Address"),
                validator: (value) => value == null || value.isEmpty ? "Address required" : null,
              ),
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(labelText: "Amount"),
                keyboardType: TextInputType.number,
                validator: (value) => double.tryParse(value ?? '') == null ? "Enter valid amount" : null,
              ),
              TextFormField(
                controller: _currencyController,
                decoration: InputDecoration(labelText: "Currency (e.g. BTC)"),
                validator: (value) => value == null || value.isEmpty ? "Currency required" : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final payload = {
                      "address": _addressController.text.trim(),
                      "amount": double.parse(_amountController.text),
                      "currency": _currencyController.text.trim(),
                    };

                    final provider = payoutProvider(payload);

                    try {
                      await ref.read(provider.future);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Payout sent!")),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error: ${e.toString()}")),
                      );
                    }
                  }
                },
                child: Text("Send Payout"),
              )
            ],
          ),
        ),
      ),
    );
  }
}


