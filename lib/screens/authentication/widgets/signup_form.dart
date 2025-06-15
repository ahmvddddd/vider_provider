import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../controllers/auth/signup_controller.dart';
import '../../../utils/constants/custom_colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_function.dart';
import '../../../utils/validators/validation.dart';
import 'build_textfield.dart';

class SignupUserForm extends ConsumerWidget {
  const SignupUserForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double screenHeight = MediaQuery.of(context).size.height;
    final signinState = ref.watch(signupControllerProvider);
    final signupController = ref.read(signupControllerProvider.notifier);
    final dark = HelperFunction.isDarkMode(context);
    final formKey = GlobalKey<FormState>();
    final firstnameController = TextEditingController();
    final lastnameController = TextEditingController();
    final usernameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final hidePassword = ValueNotifier<bool>(true);
    final hideConfirmPassword = ValueNotifier<bool>(true);

    return Form(
      key: formKey,
      child: Column(
        children: [
          // username field
          const SizedBox(height: Sizes.spaceBtwItems),
          BuildTextfield(
            controller: firstnameController,
            icon: Iconsax.user,
            hint: 'firstname',
            validator: (value) {
              Validator.validateTextField(value);
              return null;
            },
          ),
    
          //lastname
          const SizedBox(height: Sizes.spaceBtwItems),
          BuildTextfield(
            controller: lastnameController,
            icon: Iconsax.user,
            hint: 'lastname',
            validator: (value) {
              Validator.validateTextField(value);
              return null;
            },
          ),
    
          const SizedBox(height: Sizes.spaceBtwItems),
          // Username Field
          BuildTextfield(
            controller: usernameController,
            icon: Iconsax.user,
            hint: 'username',
            validator: (value) {
              Validator.validateTextField(value);
              return null;
            },
          ),
          const SizedBox(height: Sizes.spaceBtwItems),
          // Email Field
          BuildTextfield(
            controller: emailController,
            icon: Iconsax.direct,
            hint: 'email',
            isEmail: true,
            validator: (value) {
              Validator.validateEmail(value);
              return null;
            },
          ),
    
          // Password field
          const SizedBox(height: Sizes.spaceBtwItems),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
              color: dark ? CustomColors.dark : CustomColors.light,
            ),
            child: ValueListenableBuilder<bool>(
              valueListenable: hidePassword,
              builder: (context, value, child) {
                return TextFormField(
                  controller: passwordController,
                  obscureText: value,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: const Icon(Iconsax.password_check),
                    hintText: 'password',
                    hintStyle: Theme.of(context).textTheme.labelSmall,
                    suffixIcon: IconButton(
                      onPressed: () => hidePassword.value = !value,
                      icon: Icon(value ? Iconsax.eye_slash : Iconsax.eye),
                    ),
                  ),
                  validator: (value) {
                    Validator.validatePassword(value);
                    return null;
                  },
                );
              },
            ),
          ),
    
          // Confirm Password field
          const SizedBox(height: Sizes.spaceBtwItems),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
              color: dark ? CustomColors.dark : CustomColors.light,
            ),
            child: ValueListenableBuilder<bool>(
              valueListenable: hideConfirmPassword,
              builder: (context, value, child) {
                return TextFormField(
                  controller: confirmPasswordController,
                  obscureText: value,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: const Icon(Iconsax.password_check),
                    hintText: 'password',
                    hintStyle: Theme.of(context).textTheme.labelSmall,
                    suffixIcon: IconButton(
                      onPressed: () => hideConfirmPassword.value = !value,
                      icon: Icon(value ? Iconsax.eye_slash : Iconsax.eye),
                    ),
                  ),
                  validator: (value) {
                    if (value != passwordController.text) {
                      return 'passwords do not match';
                    }
                    return null;
                  },
                );
              },
            ),
          ),
    
          const SizedBox(height: Sizes.spaceBtwItems),
          TextButton(
            onPressed: () {},
            child: Text(
              'Terms And Conditions',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
    
          // Sign-in button
          const SizedBox(height: Sizes.spaceBtwItems),
          signinState.isLoading
              ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.blue,
                  ), // color
                  strokeWidth: 4.0, // thickness of the line
                  backgroundColor:
                      dark
                          ? Colors.white
                          : Colors.black, // background circle color
                ),
              )
              : SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      signupController.signup(
                        context,
                        firstnameController.text,
                        lastnameController.text,
                        usernameController.text,
                        emailController.text,
                        passwordController.text,
                      );
                    }
                  },
                  child: RoundedContainer(
                    height: screenHeight * 0.06,
                    padding: const EdgeInsets.all(Sizes.sm),
                    backgroundColor: CustomColors.primary,
                    child: Center(
                      child: Text(
                        'Sign up',
                        style: Theme.of(
                          context,
                        ).textTheme.labelSmall!.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
          if (signinState.error != null)
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                signinState.error!,
                style: Theme.of(
                  context,
                ).textTheme.labelMedium!.copyWith(color: Colors.red[900]),
                textAlign: TextAlign.center,
              ),
            ),
    
          const SizedBox(height: Sizes.spaceBtwItems),
        ],
      ),
    );
  }
}
