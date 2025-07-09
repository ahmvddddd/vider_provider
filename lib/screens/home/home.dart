// ignore_for_file: deprecated_member_use, use_build_context_synchronously, unused_result

// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:vider_provider/controllers/services/firebase_service.dart';
// import '../../controllers/notifications/add_notification_controller.dart';
import '../../controllers/notifications/send_fcm_controller.dart';
import '../../controllers/services/notification_badge_service.dart';
import '../../models/notification/add_notification_model.dart';
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
  NotificationBadgeService? _badgeService;
   Future<void> refreshProvider() async{
                      await ref.refresh(providerDashboardProvider.future);
                      await ref.refresh(transactionProvider(4).future);
                    }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_badgeService == null) {
      final container = ProviderScope.containerOf(context);
      _badgeService = NotificationBadgeService(container: container);
      _badgeService!.init(); // ✅ Safe to call here
    }

    saveFcmTokenToBackend();
  }

  @override
  Widget build(BuildContext context) {
    final dashboardAsync = ref.watch(providerDashboardProvider);
    final transactionsAsync = ref.watch(transactionProvider(3));
    double screenHeight = MediaQuery.of(context).size.height;
    final unreadCount = ref.watch(unreadNotificationsProvider);
    final dark = HelperFunction.isDarkMode(context);
    return Scaffold(
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
                  ProviderDashboardScreen(
                    onPressed: refreshProvider,
                    dashboardAsync: dashboardAsync),
                  RecentTransactions(transactionsAsync: transactionsAsync),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SendNotificationButton extends ConsumerWidget {
  final AddNotificationModel model;

  const SendNotificationButton({super.key, required this.model});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sendNotificationProvider);

    return ElevatedButton(
      onPressed:
          state is AsyncLoading
              ? null
              : () async {
                await ref
                    .read(sendNotificationProvider.notifier)
                    .sendNotification(model);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Notification sent')),
                );
              },
      child:
          state is AsyncLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text('Send Notification'),
    );
  }
}
