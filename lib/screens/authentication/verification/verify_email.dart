// ignore_for_file: unused_field

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../../common/widgets/appbar/appbar.dart';
import '../../../common/widgets/custom_shapes/containers/button_container.dart';
import '../../../common/widgets/pop_up/custom_snackbar.dart';
import '../../../common/widgets/texts/title_and_description.dart';
import '../../../controllers/verification_controllers/otp_timer_controller.dart';
import '../../../controllers/verification_controllers/send_otp_controller.dart';
import '../../../controllers/verification_controllers/verify_otp_controller.dart';
import '../../../utils/constants/custom_colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_function.dart';
import '../../../utils/helpers/token_secure_storage.dart';
import '../../transactions/create_pin.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(sendOtpProvider.notifier).sendOtp();
    });
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunction.isDarkMode(context);
    final TextEditingController otpController = TextEditingController();
    final sendOtpState = ref.watch(sendOtpProvider);
    final verifyOtpState = ref.watch(verifyOtpProvider);
    final secondsLeft = ref.watch(otpTimerProvider);

    return SafeArea(
      child: Scaffold(
        appBar: TAppBar(
          title: Text(
            'Verify Email',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          showBackArrow: true,
        ),

        bottomNavigationBar: ButtonContainer(
          text: verifyOtpState.isLoading ? 'Verifying...' : 'Proceed',
          onPressed:
              verifyOtpState.isLoading
                  ? null
                  : () async {
                    final code = otpController.text.trim();
                    await ref
                        .read(verifyOtpProvider.notifier)
                        .verifyOtp(code, context, ref);
                    final result = ref.read(verifyOtpProvider);
                    result.whenOrNull(
                      data:
                          (_) => HelperFunction.navigateScreen(
                            context,
                            CreatePinScreen(),
                          ),
                      error:
                          (e, _) => CustomSnackbar.show(
                            context: context,
                            title: 'An error occured',
                            message: e.toString(),
                            icon: Icons.error_outline,
                            backgroundColor: CustomColors.error,
                          ),
                    );
                  },
        ),

        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Sizes.spaceBtwItems),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: Sizes.spaceBtwItems),

                const TitleAndDescription(
                  textAlign: TextAlign.left,
                  title: 'Almost There',
                  description:
                      'Please enter the verification code sent to your email. Check your spam folder if you can not find the OTP email',
                ),

                const SizedBox(height: Sizes.spaceBtwSections),

                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
                    color: dark ? CustomColors.dark : CustomColors.light,
                  ),
                  child: TextFormField(
                    controller: otpController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: 'Enter verification code',
                      hintStyle: Theme.of(context).textTheme.labelSmall,
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Iconsax.security_user,
                        size: Sizes.iconSm,
                        color: dark ? CustomColors.light : CustomColors.dark,
                      ),
                      contentPadding: const EdgeInsets.all(2),
                    ),
                  ),
                ),

                const SizedBox(height: Sizes.spaceBtwItems),

                secondsLeft > 0
                    ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Code expires in',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        const SizedBox(width: Sizes.xs),
                        Text(
                          _formatTime(secondsLeft),
                          style: Theme.of(context).textTheme.labelSmall!
                              .copyWith(color: Colors.red[900]),
                        ),
                      ],
                    )
                    : TextButton(
                      onPressed:
                          sendOtpState.isLoading
                              ? null
                              : () async {

                                await TokenSecureStorage.checkToken(context: context, ref: ref);
                                
                                await ref
                                    .read(sendOtpProvider.notifier)
                                    .sendOtp();
                                final result = ref.read(sendOtpProvider);
                                result.whenOrNull(
                                  error:
                                      (e, _) => ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(content: Text(e.toString())),
                                      ),
                                );
                                ref
                                    .read(otpTimerProvider.notifier)
                                    .start(); // restart timer
                              },
                      child: Text(
                        sendOtpState.isLoading ? 'Sending...' : 'Send OTP',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),

                const SizedBox(height: Sizes.spaceBtwItems),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
