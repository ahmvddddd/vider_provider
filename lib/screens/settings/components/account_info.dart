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
        return WalletDetails(
          onPressed: () async {
            await Future.wait([
    Future(() => ref.refresh(walletProvider)),
            ]);
          },
          balance: '\$${NumberFormat('#,##0.00').format(wallet.balance)}',
          subscriptionPlan: wallet.subscriptionPlan,
        );
      },
      loading: () => WalletDetails(
          onPressed: () async {
            await Future.wait([
    Future(() => ref.refresh(walletProvider)),
            ]);
          },
          balance: '\$0.00', subscriptionPlan: 'Free'),
      error: (err, _) => WalletDetails(
          onPressed: () async {
            await Future.wait([
    Future(() => ref.refresh(walletProvider)),
            ]);
          },balance: '\$0.00', subscriptionPlan: 'Free'),
    );
  }
}

class WalletDetails extends StatelessWidget {
  final VoidCallback? onPressed;
  final String balance;
  final String subscriptionPlan;

  const WalletDetails({
    super.key,
    required this.onPressed,
    required this.balance,
    required this.subscriptionPlan,
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
      padding: const EdgeInsets.all(Sizes.sm),
      radius: Sizes.cardRadiusMd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Balance', style: Theme.of(context).textTheme.labelSmall),
              Text(balance, style: Theme.of(context).textTheme.headlineSmall),
                ],
              ),
              IconButton(onPressed: onPressed, icon: Icon(Icons.refresh, size: Sizes.iconSm,))
            ],
          ),
      
          const SizedBox(height: Sizes.xs),   
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              
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
