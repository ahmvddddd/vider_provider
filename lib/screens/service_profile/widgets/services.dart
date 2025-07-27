import 'package:flutter/material.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_function.dart';

class Services extends StatelessWidget {
  final String service;
  const Services({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunction.isDarkMode(context);
    return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    Sizes.cardRadiusSm,
                                  ),
                                  color: dark ? Colors.black : Colors.white,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                  horizontal: Sizes.xs + 1,
                                ),
                                child: Center(
                                  child: Text(
                                    service,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelLarge!.copyWith(
                                      color: dark ? Colors.white : Colors.black,
                                    ),
                                    softWrap: true,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
  }
}
