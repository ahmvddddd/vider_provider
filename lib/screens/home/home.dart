// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/jobs/jobs_dashboard_controller.dart';
import '../../controllers/notifications/unread_notifications_controller.dart';
import '../../controllers/transactions/fetch_transactions_controller.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/helpers/helper_function.dart';
import '../jobs/components/job_dashboard_shimmer.dart';
import '../jobs/components/jobs_dashboard.dart';
import '../transactions/components/recent_transactions_shimmer.dart';
import '../transactions/recent_transactions.dart';
import 'widgets/home_appbar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool isRefreshing = false;

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final type = message.data['type'];

      if (type == 'notification') {
        // Refresh unread count
        ref.read(unreadNotificationsProvider.notifier).refresh();

        // Optionally show a visual notification (e.g., snack bar)
        if (message.notification != null) {
          final title = message.notification!.title ?? '';
          final body = message.notification!.body ?? '';

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$title\n$body'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashboardAsync = ref.watch(providerDashboardProvider);
    final transactionsAsync = ref.watch(transactionProvider(3));
    double screenHeight = MediaQuery.of(context).size.height;
    final unreadCount = ref.watch(unreadNotificationsProvider);
    final dark = HelperFunction.isDarkMode(context);
    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (_, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                automaticallyImplyLeading: false,
                pinned: true,
                floating: true,
                expandedHeight: screenHeight * 0.09,
                backgroundColor: dark ? Colors.black : Colors.white,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.all(Sizes.sm),
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [HomeAppBar(unreadCount: unreadCount)],
                  ),
                ),
              ),
            ];
          },
          body: RefreshIndicator(
            onRefresh: () async {
              setState(() => isRefreshing = true);
              await Future.wait([
                ref.refresh(providerDashboardProvider.future),
                ref.refresh(transactionProvider(4).future),
              ]);
              setState(() => isRefreshing = false);
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(Sizes.spaceBtwItems),
                child: Column(
                  children: [
                    if (isRefreshing)
                      Column(
                        children: [
                          JobsDashBoardShimmer(),
                          const SizedBox(height: Sizes.spaceBtwItems),
                          RecentTransactionsShimmer(),
                        ],
                      ),
                    SizedBox(height: Sizes.spaceBtwItems),
                    ProviderDashboardScreen(dashboardAsync: dashboardAsync),

                    SizedBox(height: Sizes.spaceBtwItems),
                    RecentTransactions(transactionsAsync: transactionsAsync),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
