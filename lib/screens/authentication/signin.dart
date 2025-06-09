import 'package:flutter/material.dart';
import '../../utils/constants/custom_colors.dart';
import '../../utils/constants/image_strings.dart';
import '../../utils/constants/sizes.dart';
import 'widgets/form_divider.dart';
import 'widgets/signin_form.dart';

class SigninScreen extends StatelessWidget {
  final VoidCallback toggleScreen;
  const SigninScreen({super.key, required this.toggleScreen});

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
                SizedBox(height: Sizes.spaceBtwSections),
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(Images.loginIcon,
                  height: screenHeight * 0.10,),
                ),

                const SizedBox(height: Sizes.spaceBtwItems,),
                Text(
                  'Welcome',
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: CustomColors.primary,
                  ),
                ),
                SizedBox(
                  width: screenWidth * 0.90,
                  child: Text(
                    'Enter your username and password to signin',
                    style: Theme.of(context).textTheme.bodySmall,
                    softWrap: true,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: Sizes.spaceBtwItems),
                const SigninForm(),

                const SizedBox(height: Sizes.spaceBtwItems),
                const FormDivider(dividerText: 'Create an account'),

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
                          'Sign up',
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
