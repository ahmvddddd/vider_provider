import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../controllers/user/wallet_controller.dart';
import '../../../utils/constants/custom_colors.dart';
import '../../../utils/constants/sizes.dart';
import 'package:intl/intl.dart';

import '../../../utils/helpers/helper_function.dart';

class AccountInfo extends ConsumerStatefulWidget {
  const AccountInfo({super.key});

  @override
  ConsumerState<AccountInfo> createState() => _AccountInfoState();
}

class _AccountInfoState extends ConsumerState<AccountInfo> {
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(walletProvider.notifier).fetchBalance());
  }

  @override
  Widget build(BuildContext context) {
    final walletController = ref.watch(walletProvider);
    return walletController.when(
      data: (wallet) {
        return WalletDetails(balance: '\$${NumberFormat('#,##0.00').format(wallet.balance)}', subscriptionPlan: wallet.subscriptionPlan);
      },
      loading:
          () => WalletDetails(balance: '\$0.00', subscriptionPlan: 'Free'),
      error: (err, _) => Center(child: Text('Error: Failed to fetch balance')),
    );
  }
}

class WalletDetails extends StatelessWidget {
  final String balance;
  final String subscriptionPlan;
  const WalletDetails({super.key,
  required this.balance,
  required this.subscriptionPlan
  });

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunction.isDarkMode(context);
    return RoundedContainer(
      width: MediaQuery.of(context).size.width * 0.90,
      backgroundColor:
          dark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.1),
      padding: const EdgeInsets.all(Sizes.spaceBtwItems),
      showBorder: true,
      borderColor: CustomColors.primary,
      radius: Sizes.cardRadiusMd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(balance, style: Theme.of(context).textTheme.headlineMedium),
          Text('Wallet balance', style: Theme.of(context).textTheme.labelSmall),

          const SizedBox(height: Sizes.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(width: 2,),
              Text(
                subscriptionPlan,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall!.copyWith(color: CustomColors.primary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
