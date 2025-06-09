import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:iconsax/iconsax.dart';
import '../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../controllers/user/wallet_controller.dart';
import '../../../utils/constants/custom_colors.dart';
import '../../../utils/constants/sizes.dart';
import 'package:intl/intl.dart';

class AccountInfo extends ConsumerStatefulWidget {
  const AccountInfo({super.key});

  @override
  ConsumerState<AccountInfo> createState() => _AccountInfoState();
}

class _AccountInfoState extends ConsumerState<AccountInfo> {
  bool isBlurred = true;
  final storage = const FlutterSecureStorage();

  void _toggleBlur() {
    setState(() {
      isBlurred = !isBlurred;
    });
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(walletProvider.notifier).fetchBalance());
  }

  @override
  Widget build(BuildContext context) {
    final walletController = ref.watch(walletProvider);
    double screenWidth = MediaQuery.of(context).size.width;
    return walletController.when(
      data: (wallet) {
        return RoundedContainer(
          width: screenWidth * 0.90,
          linearGradient: CustomColors.linearGradient,
          padding: const EdgeInsets.all(Sizes.sm),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //account balance
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      isBlurred
                          ? ClipRRect(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 5.0,
                                sigmaY: 5.0,
                              ),
                              child: Container(
                                color: CustomColors.primary.withValues(alpha: 0.1),
                                width: screenWidth * 0.30,
                              ),
                            ),
                          )
                          : SizedBox(
                            width: screenWidth * 0.30,
                            child: Text(
                              '\$${NumberFormat('#,##0.00').format(wallet.balance)}',
                              style: Theme.of(
                                context,
                              ).textTheme.headlineSmall!.copyWith(
                                fontFamily: 'JosefinSans',
                                color: Colors.white,
                              ),
                            ),
                          ),
                      const SizedBox(width: 2),
                      IconButton(
                        onPressed: _toggleBlur,
                        icon: const Icon(
                          Iconsax.eye_slash,
                          color: Colors.white,
                          size: Sizes.iconSm,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Balance',
                    style: Theme.of(
                      context,
                    ).textTheme.labelSmall!.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        );
      },
      loading: () =>  RoundedContainer(
          width: screenWidth * 0.90,
          linearGradient: CustomColors.linearGradient,
          padding: const EdgeInsets.all(Sizes.sm),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //account balance
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      isBlurred
                          ? ClipRRect(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 5.0,
                                sigmaY: 5.0,
                              ),
                              child: Container(
                                color: CustomColors.primary.withValues(alpha: 0.1),
                                width: screenWidth * 0.30,
                              ),
                            ),
                          )
                          : SizedBox(
                            width: screenWidth * 0.30,
                            child: Text(
                              '\$0.00',
                              style: Theme.of(
                                context,
                              ).textTheme.headlineSmall!.copyWith(
                                fontFamily: 'JosefinSans',
                                color: Colors.white,
                              ),
                            ),
                          ),
                      const SizedBox(width: 2),
                      IconButton(
                        onPressed: _toggleBlur,
                        icon: const Icon(
                          Iconsax.eye_slash,
                          color: Colors.white,
                          size: Sizes.iconSm,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Balance',
                    style: Theme.of(
                      context,
                    ).textTheme.labelSmall!.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      error: (err, _) => Center(child: Text('Error: Failed to fetch balance')),
    );
  }
}
