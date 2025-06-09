// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:iconsax/iconsax.dart';
import '../../utils/constants/sizes.dart';
import '../../common/widgets/appbar/appbar.dart';
import '../../utils/helpers/helper_function.dart';

class DepositPage extends StatefulWidget {
  const DepositPage({super.key});

  @override
  _DepositPageState createState() => _DepositPageState();
}

class _DepositPageState extends State<DepositPage> {
  // double _balance = 0.0;
  final _cardNumberController = TextEditingController();
  final _cvvController = TextEditingController();
  final _expiryMonthController = TextEditingController();
  final _expiryYearController = TextEditingController();
  final _amountController = TextEditingController();
  final storage = const FlutterSecureStorage();
  bool _isLoading = false;
  String? _responseMessage;

  @override
  void initState() {
    super.initState();
    // _fetchWallet();
  }

  // Future<void> _fetchWallet() async {
  //   final token = await storage.read(key: 'token'); // Assuming the token is stored with this key

  //   if (token != null) {
  //     final response = await http.get(
  //       Uri.parse('http://localhost:3000/api/wallet'), // Replace with your actual API URL
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);
  //       setState(() {
  //         _balance = data['balance'];

  //       });
  //     } else {
  //       // Handle error response
  //       print('Failed to fetch balance: ${response.body}');
  //     }
  //   } else {
  //     print('Token not found');
  //   }
  // }

  Future<void> _makeDeposit() async {
    setState(() {
      _isLoading = true;
      _responseMessage = null;
    });

    // Fetch JWT token from secure storage
    final token = await storage.read(key: 'token');

    if (token == null) {
      setState(() {
        _isLoading = false;
        _responseMessage = 'User not authenticated';
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(
            'http://localhost:3000/api/deposit'), // Replace with your actual API URL
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'card_number': _cardNumberController.text,
          'cvv': _cvvController.text,
          'expiry_month': _expiryMonthController.text,
          'expiry_year': _expiryYearController.text,
          'amount': _amountController.text,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Check if the response contains a redirect URL
        if (data['redirectUrl'] != null) {
          final redirectUrl = data['redirectUrl'];

          // Open the redirect URL in the same or a new browser tab (Flutter web)
          if (await canLaunchUrl(redirectUrl)) {
            await launchUrl(
              redirectUrl,
              webOnlyWindowName: '_self', // Opens in a new tab
            );
            setState(() {
              _responseMessage = 'Redirecting for payment...';
            });
          } else {
            setState(() {
              _responseMessage = 'Could not launch redirect URL';
            });
          }
        } else {
          setState(() {
            _responseMessage = 'Deposit Successful: $data';
          });
        }
      } else {
        final error = jsonDecode(response.body);
        setState(() {
          _responseMessage = 'Deposit Failed: ${error['message']}';
        });
      }
    } catch (e) {
      setState(() {
        _responseMessage = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunction.isDarkMode(context);
    // String accountBalance = NumberFormat('#,##0.00').format(_balance);
    return SingleChildScrollView(
      child: Scaffold(
        appBar: TAppBar(
          title: Text('Deposit',
          style: Theme.of(context).textTheme.headlineSmall),
          showBackArrow: true
        ),
        body: Column(
          children: [

             //header
                  // TPrimaryHeaderContainer(
                  //   child: Column(
                  //     children: [
                  //       TAppBar(
                  //         title: Text('Deposit',
                  //             style: Theme.of(context)
                  //                 .textTheme
                  //                 .headlineMedium!
                  //                 .apply(color: TColors.white)),
                  //         showBackArrow: true,
                  //       ),
                  //       const SizedBox(height: TSizes.spaceBtwSections),
                  //       //Acount Balance
                  //       TRoundedContainer(
                  //         padding: const EdgeInsets.all(TSizes.defaultSpace),
                  //         width: 300,
                  //         backgroundColor: TColors.dark.withOpacity(0.8),
                  //         child: Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             //Texts
                  //             Text('\$$accountBalance',
                  //                 style: Theme.of(context)
                  //                     .textTheme
                  //                     .headlineLarge!
                  //                     .apply(
                  //                         color:
                  //                             dark ? TColors.white : TColors.dark)),
                  //             Text(TTexts.accountText,
                  //                 style: Theme.of(context)
                  //                     .textTheme
                  //                     .labelMedium!
                  //                     .apply(
                  //                         color:
                  //                             dark ? TColors.white : TColors.dark)),
                  //           ],
                  //         ),
                  //       ),
                  //       const SizedBox(height: Sizes.spaceBtwSections)
                  //     ],
                  //   ),
                  // ),


            //CARD DETAILS
            Padding(
              padding: const EdgeInsets.all(Sizes.spaceBtwItems),
              child: Column(
                children: [
                  
                  const SizedBox(height: Sizes.spaceBtwSections,),
                  //card number
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                        border: Border.all(color: dark ? Colors.white : Colors.black),
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 0.0),
                      child: TextField(
                        controller: _cardNumberController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Iconsax.card,
                            size: Sizes.iconSm,
                          ),
                          hintText: 'Card Number',
                          hintStyle: Theme.of(context).textTheme.labelSmall,
                        ),
                      ),
                    ),
                  ),
                    
                  //cvv
                  const SizedBox(height: Sizes.spaceBtwItems),
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                        border: Border.all(color: dark ? Colors.white : Colors.black),
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 0.0),
                      child: TextField(
                        controller: _cvvController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Iconsax.card,
                            size: Sizes.iconSm,
                          ),
                          hintText: 'CVV',
                          hintStyle: Theme.of(context).textTheme.labelSmall,
                        ),
                      ),
                    ),
                  ),
                    
                  // expiry date
                  const SizedBox(height: Sizes.spaceBtwItems),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: dark ? Colors.white : Colors.black),
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0.0),
                            child: TextFormField(
                              expands: false,
                              controller: _expiryMonthController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: const Icon(
                                  Iconsax.calendar,
                                  size: Sizes.iconSm,
                                ),
                                hintText: 'Expiry Month',
                                hintStyle: Theme.of(context).textTheme.labelSmall,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: Sizes.spaceBtwInputFields),
                      Expanded(
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: dark ? Colors.white : Colors.black),
                            borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0.0),
                            child: TextFormField(
                              expands: false,
                              controller: _expiryYearController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: const Icon(
                                  Iconsax.calendar,
                                  size: Sizes.iconSm,
                                ),
                                hintText: 'Expiry Year',
                                hintStyle: Theme.of(context).textTheme.labelSmall,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                    
                  //amount
                  const SizedBox(height: Sizes.spaceBtwItems),
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                        border: Border.all(color: dark ? Colors.white : Colors.black),
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 0.0),
                      child: TextFormField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.money,
                            size: Sizes.iconSm,
                          ),
                          hintText: 'Amount',
                          hintStyle: Theme.of(context).textTheme.labelSmall,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: Sizes.spaceBtwItems),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : _makeDeposit,
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          :  Text('Make Deposit',
                          style: Theme.of(context).textTheme.bodyMedium),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_responseMessage != null) Text(_responseMessage!),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
