import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../common/widgets/layouts/listvew.dart';
import '../../common/widgets/products/products_cards/recent_card.dart';
import '../../common/widgets/texts/section_heading.dart';
import '../../utils/constants/custom_colors.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/helpers/helper_function.dart';
import 'components/recent_transactions_shimmer.dart';
import 'transaction_history.dart';

class RecentTransactions extends ConsumerStatefulWidget {
  final AsyncValue transactionsAsync;
  const RecentTransactions({super.key, required this.transactionsAsync});

  @override
  ConsumerState<RecentTransactions> createState() => _RecentTransactionsState();
}

class _RecentTransactionsState extends ConsumerState<RecentTransactions> {
  @override
  Widget build(BuildContext context) {
    return widget.transactionsAsync.when(
      data: (transactions) {
        if (transactions.isEmpty) {
          return SizedBox.shrink();
        }
        return Column(
          children: [

            const SizedBox(height: Sizes.spaceBtwItems),
            TSectionHeading(
              title: 'Recent Transactions',
              showActionButton: true,
              onPressed: () {
                HelperFunction.navigateScreen(context, TransactionHistory());
              },
            ),

            const SizedBox(height: Sizes.spaceBtwItems),
            HomeListView(
              seperatorBuilder:
                  (context, index) => const SizedBox(height: Sizes.xs),
              scrollDirection: Axis.vertical,
              scrollPhysics: const NeverScrollableScrollPhysics(),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                String amount = NumberFormat(
                  '#,##0.00',
                ).format(transaction.amount);
                IconData transactionIcon;
                switch (transaction.transactionType.toLowerCase()) {
                  case 'debit':
                    transactionIcon = Icons.arrow_upward;
                    break;
                  case 'credit':
                    transactionIcon = Icons.arrow_downward;
                    break;
                  default:
                    transactionIcon = Icons.receipt;
                }

                Color iconColor;

                switch (transaction.transactionType.toLowerCase()) {
                  case 'debit':
                    iconColor = Colors.red;
                    break;
                  case 'credit':
                    iconColor = Colors.green;
                    break;
                  default:
                    iconColor = CustomColors.primary;
                }
                return RecentCard(
                  transactionIcon: transactionIcon,
                  iconColor: iconColor,
                  transactionType: transaction.transactionType,
                  description: transaction.description,
                  amount: amount,
                );
              },
            ),
          ],
        );
      },
      loading: () => const Center(child: RecentTransactionsShimmer()),
      error: (error, stack) => SizedBox.shrink(),
    );
  }
}
