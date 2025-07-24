import 'package:vider_provider/controllers/services/firebase_service.dart';
import '../../controllers/services/notification_badge_service.dart';
import '../../controllers/user/save_location_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/jobs/jobs_dashboard_controller.dart';
import '../../controllers/notifications/unread_notifications_controller.dart';
import '../../controllers/transactions/fetch_transactions_controller.dart';
import '../../repository/user/location_state_storage.dart';
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
  bool _didListen = false;
  Future<void> refreshProvider() async {
    setState(() {
      isRefreshing = true;
    });
    await ref.refresh(providerDashboardProvider.future);
    await ref.refresh(transactionProvider(4).future);
    setState(() {
      isRefreshing = false;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_badgeService == null) {
      final container = ProviderScope.containerOf(context);
      _badgeService = NotificationBadgeService(container: container);
      _badgeService!.init();
    }

    saveFcmTokenToBackend();
  }

  @override
  Widget build(BuildContext context) {
    if (!_didListen) {
      _didListen = true;
      ref.listen<bool>(persistentLocationSwitchProvider, (previous, next) {
        if (next == true) {
          final saveLocation = ref.read(saveSimpleLocationProvider);
          saveLocation.saveUserLocation(context);
        }
      });
    }
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
                    dashboardAsync: dashboardAsync,
                  ),
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
