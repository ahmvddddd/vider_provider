import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../repository/user/username_local_storage.dart';
import '../../../utils/constants/custom_colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_function.dart';
import '../../../controllers/auth/sign_in_controller.dart';
import '../../../utils/helpers/reponsive_size.dart';
import '../../../utils/validators/validation.dart';
import '../reset_password/enter_email.dart';
import 'build_textfield.dart';

class SignInForm extends ConsumerStatefulWidget {
  const SignInForm({super.key});

  @override
  ConsumerState<SignInForm> createState() => _SigninFormState();
}

class _SigninFormState extends ConsumerState<SignInForm> {
  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final hidePassword = ValueNotifier<bool>(true);
  bool _dialogShown = false;
  bool _submitted = false;

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
    double screenHeight = MediaQuery.of(context).size.height;
    final username = usernameController.text.trim();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_dialogShown &&
          loginState.error != null &&
          loginState.error!.toLowerCase().contains('suspended')) {
        _dialogShown = true; // ✅ prevent reopening
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Text(
                  "Account @$username Suspended",
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: CustomColors.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: Text(
                  loginState.error!,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                actions: [
                  TextButton(
                    onPressed: () async {
                      final Uri emailLaunchUri = Uri(
                        scheme: 'mailto',
                        path: 'vider_support@gmail.com',
                        query: Uri.encodeQueryComponent(
                          'subject=Account Suspension Appeal&body=Hello, my account @$username was suspended and I would like to appeal.',
                        ),
                      );
                      await launchUrl(emailLaunchUri);
                    },
                    child: Text(
                      'File Complaint',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
        );
        ref.read(loginControllerProvider.notifier).clearError();
      }
    });

    return Form(
      key: formKey,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            SizedBox(height: responsiveSize(context, Sizes.spaceBtwItems)),

            // Username field
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
                color: dark ? CustomColors.dark : CustomColors.light,
              ),
              child: BuildTextfield(
                controller: usernameController,
                icon: Iconsax.user,
                hint: 'username',
                validator: (value) {
                  return Validator.validateTextField(value);
                },
              ),
            ),

            SizedBox(height: responsiveSize(context, Sizes.spaceBtwItems)),

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
                      return Validator.validateTextField(value);
                    },
                  );
                },
              ),
            ),

            SizedBox(height: responsiveSize(context, Sizes.spaceBtwSections)),

            // Sign-in button
            loginState.isLoading
                ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    strokeWidth: 4.0,
                    backgroundColor: dark ? Colors.white : Colors.black,
                  ),
                )
                : SizedBox(
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      if (formKey.currentState!.validate()) {
                        if (mounted) {
                          setState(() {
                            _submitted = true;
                          });
                        }
                        await loginController.login(
                          context,
                          usernameController.text.trim(),
                          passwordController.text,
                        );

                        if (mounted) {
                          setState(() {
                            _submitted = false;
                          });
                        }
                      }
                    },
                    child: RoundedContainer(
                      height: screenHeight * 0.06,
                      padding: EdgeInsets.all(responsiveSize(context, Sizes.sm)),
                      backgroundColor: CustomColors.primary,
                      child: Center(
                        child: Text(
                          'Sign in',
                          style: Theme.of(
                            context,
                          ).textTheme.labelSmall!.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),

            if (!_submitted && loginState.error != null)
              Padding(
                padding: EdgeInsets.only(top: responsiveSize(context, 20)),
                child: Text(
                  loginState.error!,
                  style: Theme.of(
                    context,
                  ).textTheme.labelMedium!.copyWith(color: Colors.red[900]),
                  textAlign: TextAlign.center,
                ),
              ),

            SizedBox(height: responsiveSize(context, Sizes.sm)),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  HelperFunction.navigateScreen(context, EnterEmailScreen());
                },
                child: Text(
                  'Forgot Password?',
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: CustomColors.primary,
                  ),
                ),
              ),
            ),
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
