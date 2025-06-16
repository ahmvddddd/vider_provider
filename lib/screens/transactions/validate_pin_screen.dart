import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/widgets/appbar/appbar.dart';
import '../../common/widgets/inputs/custom_keypad.dart';
import '../../common/widgets/pop_up/custom_snackbar.dart';
import '../../controllers/user/validate_pin_controller.dart';
import '../../utils/constants/custom_colors.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/helpers/helper_function.dart';
import '../settings/components/subscription_plan_screen.dart';

class ValidatePinScreen extends ConsumerStatefulWidget {
  const ValidatePinScreen({super.key});

  @override
  ConsumerState<ValidatePinScreen> createState() => _ValidatePinScreenState();
}

class _ValidatePinScreenState extends ConsumerState<ValidatePinScreen> {
  List<String> currentPin = ['', '', '', ''];
  String? error;

  void _enterDigit(String digit) {
    setState(() {
      for (int i = 0; i < 4; i++) {
        if (currentPin[i].isEmpty) {
          currentPin[i] = digit;
          break;
        }
      }

      if (!currentPin.contains('')) {
        _submitPin();
      }
    });
  }

  void _removeDigit() {
    setState(() {
      for (int i = 3; i >= 0; i--) {
        if (currentPin[i].isNotEmpty) {
          currentPin[i] = '';
          break;
        }
      }
    });
  }

  Future<void> _submitPin() async {
    final controller = ref.read(validatePinControllerProvider);
    final result = await controller.validatePin(currentPin: currentPin.join());

    if (result == null) {
      if (mounted) {
        HelperFunction.navigateScreen(
          context,
          SubscriptionPlanScreen(),
        ); 
      }
    } else {
      setState(() {
        error = result;
        currentPin = ['', '', '', ''];
      });
        CustomSnackbar.show(
          context: context,
          title: 'Error',
          message: result,
          icon: Icons.error_outline,
          backgroundColor: CustomColors.error,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: TAppBar(
          title: Text(
            'Transaction PIN',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          showBackArrow: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Enter Your Transaction PIN",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: Sizes.spaceBtwItems),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:
                    currentPin.map((digit) {
                      return Container(
                        margin: const EdgeInsets.all(8),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            digit.isEmpty ? "•" : "*",
                            style: Theme.of(
                              context,
                            ).textTheme.headlineLarge!.copyWith(fontSize: 30),
                          ),
                        ),
                      );
                    }).toList(),
              ),
              if (error != null) ...[
                const SizedBox(height: Sizes.spaceBtwItems),
                Text(error!, style: const TextStyle(color: Colors.red)),
              ],
              const SizedBox(height: Sizes.spaceBtwItems),
              CustomKeypad(onDigitPressed: _enterDigit, onBackspace: _removeDigit),
            ],
          ),
        ),
      ),
    );
  }
}
