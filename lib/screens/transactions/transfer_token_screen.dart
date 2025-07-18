import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/widgets/appbar/appbar.dart';
import '../../common/widgets/custom_shapes/containers/button_container.dart';
import '../../common/widgets/pop_up/custom_snackbar.dart';
import '../../common/widgets/texts/title_and_description.dart';
import '../../controllers/transactions/transfer_token_controller.dart';
import '../../utils/constants/custom_colors.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/helpers/helper_function.dart';
import 'validate_pin_screen.dart';

class TransferTokenScreen extends ConsumerStatefulWidget {
  final double usdcBalance;
  const TransferTokenScreen({super.key, required this.usdcBalance});

  @override
  ConsumerState<TransferTokenScreen> createState() => _TransferTokenPageState();
}

class _TransferTokenPageState extends ConsumerState<TransferTokenScreen> {
  final _addressController = TextEditingController();
  final _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> confirmPinAndTransfer(
    BuildContext context,
    WidgetRef ref,
    String address,
    String amount,
  ) async {
    final isPinValid = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const ValidatePinDialog(),
    );

    if (isPinValid == true) {
      await ref
          .read(transferTokenProvider.notifier)
          .sendToken(
            context: context,
            destinationAddress: address,
            amount: amount,
            ref: ref,
          );
    } else {
      CustomSnackbar.show(
        context: context,
        title: 'Invalid PIN',
        message: 'Transaction failed',
        icon: Icons.error_outline,
        backgroundColor: CustomColors.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final transferState = ref.watch(transferTokenProvider);
    final isDark = HelperFunction.isDarkMode(context);

    return Scaffold(
      appBar: TAppBar(
        title: Text(
          'Withdraw Token',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        showBackArrow: true,
      ),
      bottomNavigationBar: ButtonContainer(
        text: 'Submit',
        onPressed: () async {
          if (_formKey.currentState?.validate() ?? false) {
            final address = _addressController.text.trim();
            final amount = _amountController.text.trim();
            await confirmPinAndTransfer(context, ref, address, amount);
          }
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.spaceBtwItems),
          child:
              transferState.isLoading
                  ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      strokeWidth: 4.0,
                      backgroundColor: isDark ? Colors.white : Colors.black,
                    ),
                  )
                  : Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TitleAndDescription(
                          textAlign: TextAlign.left,
                          title: 'Destination Address',
                          description:
                              'Enter a valid Crypto address to receive USDC',
                        ),
                        const SizedBox(height: Sizes.spaceBtwItems),
                        TextFormField(
                          controller: _addressController,
                          decoration: InputDecoration(
                            hintText: 'Destination Address',
                            hintStyle: Theme.of(context).textTheme.labelSmall,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter the destination address';
                            }
                            final address = value.trim().toLowerCase();
                            final isValid = RegExp(
                              r'^0x[a-fA-F0-9]{40}$',
                            ).hasMatch(address);
                            if (!isValid) {
                              return 'Enter a valid Ethereum address';
                            }
                            return null;
                          },
                        ),

                        //amount
                        const SizedBox(height: Sizes.spaceBtwItems),
                        const TitleAndDescription(
                          textAlign: TextAlign.left,
                          title: 'Amount',
                          description: 'Enter desired amount to be withdrawn',
                        ),
                        const SizedBox(height: Sizes.spaceBtwItems),
                        TextFormField(
                          controller: _amountController,
                          decoration: InputDecoration(
                            hintText: 'Amount (USDC)',
                            hintStyle: Theme.of(context).textTheme.labelSmall,
                          ),
                          keyboardType: TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter an amount';
                            }
                            final amount = double.tryParse(value.trim());
                            if (amount == null || amount <= 0) {
                              return 'Please enter a valid amount';
                            }
                            if (amount > widget.usdcBalance) {
                              return 'Insufficient balance: ${widget.usdcBalance} USDC available';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
        ),
      ),
    );
  }
}
// '0x69f89aced55f6438e7dd94675608d13f6bc258d1';