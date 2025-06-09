// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import '../../common/widgets/appbar/appbar.dart';
import '../../common/widgets/custom_shapes/containers/button_container.dart';
import '../../utils/constants/custom_colors.dart';
import '../../utils/constants/sizes.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final List<String> _pin = ["", "", "", ""]; // Stores each digit of the PIN
  int _currentIndex = 0; // Tracks the currently active box
  bool _isKeyboardVisible = false; // Controls keyboard visibility

  // Handle number input
  void _onKeyPressed(String value) {
    if (_currentIndex < 4) {
      setState(() {
        _pin[_currentIndex] = value;
        _currentIndex++;
      });
    }
  }

  // Handle delete button
  void _onDeletePressed() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _pin[_currentIndex] = "";
      });
    }
  }

  // Show or hide the custom keyboard
  void _toggleKeyboard(bool show) {
    setState(() {
      _isKeyboardVisible = show;
    });
  }

  // Submit PIN after validation
  void _submitPin() {
    String pinCode = _pin.join();
    if (pinCode.length == 4) {
      print("Success PIN created successfully: $pinCode");
      // Implement navigation or API calls here if needed
    } else {
      print("Error Please complete the 4-digit PIN.");
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double tabIconHeight = screenHeight * 0.055;
    return GestureDetector(
      onTap: () {
        // Hide custom keyboard on outside tap
        _toggleKeyboard(false);
      },
      child: Scaffold(
        appBar: const TAppBar(
          showBackArrow: true,
        ),
        bottomNavigationBar: ButtonContainer(
          text: 'Pay',
          onPressed: _submitPin,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Enter a 4-digit PIN',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) {
                  return GestureDetector(
                    onTap: () {
                      // Show keyboard when tapping on any box
                      _toggleKeyboard(true);
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    child: Container(
                      width: tabIconHeight,
                      height: tabIconHeight,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: CustomColors.primary.withValues(alpha: 0.8)),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        _pin[index]
                        .isEmpty
                              ? "-"
                              : "*",
                        style: Theme.of(context).textTheme.labelMedium!.copyWith(color: CustomColors.primary, fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: Sizes.spaceBtwSections + 8),
              if (_isKeyboardVisible) _buildKeypad(),
              const SizedBox(height: Sizes.sm),
              
            ],
          ),
        ),
      ),
    );
  }

  // Custom numeric keypad widget
  Widget _buildKeypad() {
    double screenWidth = MediaQuery.of(context).size.width;
    return GridView.builder(
      shrinkWrap: true,
      itemCount: 12,
      gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
      mainAxisExtent: screenWidth * 0.15,
      crossAxisCount: 3
      ),
      itemBuilder: (context, index) {
        String buttonText;
        if (index < 9) {
          buttonText = (index + 1).toString();
        } else if (index == 9) {
          buttonText = ""; // Empty cell
        } else if (index == 10) {
          buttonText = "0";
        } else {
          buttonText = "<"; // Delete button
        }

        return GestureDetector(
          onTap: () {
            if (buttonText == "<") {
              _onDeletePressed();
            } else if (buttonText.isNotEmpty) {
              _onKeyPressed(buttonText);
            }
          },
          child: Container(
            margin: const EdgeInsets.all(8.0),
            height: screenWidth * 0.15,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: buttonText == "<" ? Colors.red[900] : CustomColors.primary.withValues(alpha: 0.8),
            ),
            child: Center(
              child: Text(
                buttonText,
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: buttonText == "<" ? Colors.red : Colors.white)
              ),
            ),
          ),
        );
      },
    );
  }
}