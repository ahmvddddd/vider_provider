import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../common/widgets/shimmer/shimmer_widget.dart';
import '../../../controllers/user/wallet_controller.dart';
import '../../../utils/constants/custom_colors.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';
import 'package:intl/intl.dart';
import '../../../utils/helpers/helper_function.dart';
import '../../transactions/transfer_token_screen.dart';

class AccountInfo extends ConsumerStatefulWidget {
  const AccountInfo({super.key});

  @override
  ConsumerState<AccountInfo> createState() => _AccountInfoState();
}

class _AccountInfoState extends ConsumerState<AccountInfo> {
  final storage = const FlutterSecureStorage();
  bool isRefreshing = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(walletProvider.notifier).fetchBalance());
  }

  @override
  Widget build(BuildContext context) {
    final walletController = ref.watch(walletProvider);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return walletController.when(
      data: (wallet) {
        return isRefreshing
            ? ShimmerWidget(
              width: screenWidth * 0.90,
              height: screenHeight * 0.13,
              radius: Sizes.cardRadiusSm,
            )
            : WalletDetails(
              onPressed: () async {
                setState(() => isRefreshing = true);
                await Future.wait([Future(() => ref.refresh(walletProvider))]);
                setState(() => isRefreshing = false);
              },
              balance:
                  '\$${NumberFormat('#,##0.00').format(wallet.usdcBalance)}',
              onTap:
                  (wallet.usdcBalance <= 1.00)
                      ? null
                      : () async {
                        HelperFunction.navigateScreen(
                          context,
                          TransferTokenScreen(usdcBalance: wallet.usdcBalance),
                        );
                      },
              backgroundColor:
                  (wallet.usdcBalance <= 1.00)
                      ? CustomColors.darkerGrey
                      : CustomColors.success,
              subscriptionPlan: wallet.subscriptionPlan,
            );
      },
      loading:
          () => ShimmerWidget(
            width: screenWidth * 0.90,
            height: screenHeight * 0.13,
            radius: Sizes.cardRadiusSm,
          ),
      error:
          (err, _) => WalletDetails(
            onPressed: () async {
              setState(() => isRefreshing = true);
              await Future.wait([Future(() => ref.refresh(walletProvider))]);
              setState(() => isRefreshing = false);
            },
            balance: 'Could not fetch balance',
            backgroundColor: CustomColors.darkerGrey,
            subscriptionPlan: '',
          ),
    );
  }
}

class WalletDetails extends StatelessWidget {
  final VoidCallback? onPressed;
  final String balance;
  final String subscriptionPlan;
  final VoidCallback? onTap;
  final Color backgroundColor;

  const WalletDetails({
    super.key,
    required this.onPressed,
    required this.balance,
    required this.subscriptionPlan,
    this.onTap,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.90,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Images.bg2),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(Sizes.cardRadiusMd),
      ),
      padding: const EdgeInsets.all(Sizes.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Balance',
                    style: Theme.of(
                      context,
                    ).textTheme.labelSmall!.copyWith(color: Colors.white),
                  ),
                  Text(
                    balance,
                    style: Theme.of(
                      context,
                    ).textTheme.headlineSmall!.copyWith(color: Colors.white),
                  ),
                ],
              ),
              IconButton(
                onPressed: onPressed,
                icon: Icon(
                  Icons.refresh,
                  size: Sizes.iconMd,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          const SizedBox(height: Sizes.sm + 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                subscriptionPlan,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall!.copyWith(color: Colors.white),
              ),

              GestureDetector(
                onTap: onTap,
                child: RoundedContainer(
                  width: MediaQuery.of(context).size.width * 0.30,
                  height: MediaQuery.of(context).size.height * 0.05,
                  radius: Sizes.cardRadiusSm,
                  padding: const EdgeInsets.all(Sizes.sm),
                  backgroundColor: backgroundColor,
                  child: Center(
                    child: Text(
                      'Withdraw',
                      style: Theme.of(
                        context,
                      ).textTheme.labelSmall!.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: Sizes.sm + 2),
        ],
      ),
    );
  }
}
