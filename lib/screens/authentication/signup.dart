import 'package:flutter/material.dart';
import '../../utils/constants/custom_colors.dart';
import '../../utils/constants/sizes.dart';
import 'widgets/form_divider.dart';
import 'widgets/signup_form.dart';

class SignupScreen extends StatelessWidget {
  final VoidCallback toggleScreen;
  const SignupScreen({super.key, required this.toggleScreen});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Sizes.spaceBtwItems),
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.05),
                Text(
                  'Create Your Account',
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: CustomColors.primary,
                  ),
                ),
                SizedBox(
                  width: screenWidth * 0.70,
                  child: Text(
                    'Enter your personal details to signup',
                    style: Theme.of(context).textTheme.bodySmall,
                    softWrap: true,
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: Sizes.spaceBtwItems),
                const SignupUserForm(),

                const SizedBox(height: Sizes.spaceBtwItems),
                const FormDivider(dividerText: 'Already a user ?'),

                //signup button
                const SizedBox(height: Sizes.spaceBtwItems),
                Padding(
                  padding: const EdgeInsets.all(Sizes.spaceBtwItems),
                  child: SizedBox(
                    width: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: CustomColors.primary),
                        borderRadius: BorderRadius.circular(
                          Sizes.borderRadiusLg,
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: toggleScreen,
                        child: Text(
                          'Sign in',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SignupForm {
  const SignupForm();
}
