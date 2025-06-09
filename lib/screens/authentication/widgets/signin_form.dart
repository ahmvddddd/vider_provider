import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../repository/user/username_local_storage.dart';
import '../../../utils/constants/custom_colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_function.dart';
import '../../../controllers/auth/signin_controller.dart';
import '../../../utils/validators/validation.dart';
import 'build_textfield.dart';

class SigninForm extends ConsumerStatefulWidget {
  const SigninForm({super.key});

  @override
  ConsumerState<SigninForm> createState() => _SigninFormState();
}

class _SigninFormState extends ConsumerState<SigninForm> {
  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final hidePassword = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    _loadSavedUsername();
  }

  Future<void> _loadSavedUsername() async {
    final savedUsername = await UsernameLocalStorage.getSavedUsername();
    if (savedUsername != null) {
      usernameController.text = savedUsername;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginControllerProvider);
    final loginController = ref.read(loginControllerProvider.notifier);
    final dark = HelperFunction.isDarkMode(context);

    return RoundedContainer(
      padding: const EdgeInsets.all(Sizes.sm),
      backgroundColor:
          dark ? Colors.white.withAlpha(25) : Colors.black.withAlpha(25),
      showBorder: true,
      borderColor: CustomColors.primary,
      radius: Sizes.cardRadiusMd,
      child: Form(
        key: formKey,
        child: Column(
          children: [
            const SizedBox(height: Sizes.spaceBtwItems),

            // Username field
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

            // Password field
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
                      Validator.validateTextField(value);
                      return null;
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: Sizes.spaceBtwSections),

            // Sign-in button
            loginState.isLoading
                ?  Center(child: CircularProgressIndicator(
  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue), // color
  strokeWidth: 6.0, // thickness of the line
  backgroundColor: dark ? Colors.white : Colors.black, // background circle color
)
)
                : Padding(
                  padding: const EdgeInsets.all(Sizes.spaceBtwItems),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: CustomColors.primary,
                      ),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          await loginController.login(
                            context,
                            usernameController.text.trim(),
                            passwordController.text,
                          );
                        }
                      },

                      child: Text(
                        'Sign in',
                        style: Theme.of(
                          context,
                        ).textTheme.labelSmall!.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),

            if (loginState.error != null)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  loginState.error!,
                  style: Theme.of(
                    context,
                  ).textTheme.labelMedium!.copyWith(color: Colors.red[900]),
                  textAlign: TextAlign.center,
                ),
              ),

            const SizedBox(height: Sizes.spaceBtwItems),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    hidePassword.dispose();
    super.dispose();
  }
}
