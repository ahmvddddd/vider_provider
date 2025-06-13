import 'package:flutter/material.dart';
import 'main.dart';
import 'repository/user/username_local_storage.dart';
import 'screens/authentication/auth_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'utils/helpers/helper_function.dart';
import 'utils/theme/theme.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  Widget? _initialScreen;

  @override
  void initState() {
    super.initState();
    _loadInitialScreen();
  }

  Future<void> _loadInitialScreen() async {
    final username = await UsernameLocalStorage.getSavedUsername();
    setState(() {
      _initialScreen = username != null ? const AuthScreen() : const OnboardingScreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunction.isDarkMode(context);
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      home: _initialScreen ??  Scaffold( // Show splash/loader while checking
        body: Center(child: CircularProgressIndicator(
          
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.blue,
                  ), // color
                  strokeWidth: 6.0, // thickness of the line
                  backgroundColor:
                      dark
                          ? Colors.white
                          : Colors.black,
        )),
      ),
    );
  }
}
