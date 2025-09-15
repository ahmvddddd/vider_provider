import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../screens/jobs/components/jobs_screen_shimmer.dart';
import '../../common/widgets/appbar/appbar.dart';
import '../../common/widgets/layouts/listvew.dart';
import '../../controllers/notifications/notification_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/notifications/read_notification_controller.dart';
import '../../utils/constants/custom_colors.dart';
import '../../utils/helpers/helper_function.dart';
import '../jobs/accept_job_screen.dart';
import '../transactions/transaction_history.dart';
import 'notification_view_screen.dart';
import 'widgets/notification_card.dart';
import '../../utils/constants/sizes.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  bool isRefreshing = false;

  @override
  Widget build(BuildContext context) {
    final notificationsAsync = ref.watch(notificationsProvider);
    final dark = HelperFunction.isDarkMode(context);
    return Scaffold(
      appBar: TAppBar(
        title: Text(
          'Notifications',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.spaceBtwItems),
          child: notificationsAsync.when(
            data: (notifications) {
              if (notifications.isEmpty) {
                return Center(child: Text('No notifications'));
              }

              return HomeListView(
                scrollDirection: Axis.vertical,
                scrollPhysics: const NeverScrollableScrollPhysics(),
                seperatorBuilder:
                    (context, index) =>
                        const SizedBox(height: Sizes.spaceBtwItems),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notif = notifications[index];

                  if (isRefreshing) const JobsScreenShimmer();

                  if (notif.type == 'job_request' && notif.jobDetails != null) {
                    final job = notif.jobDetails!;
                    return NotificationCard(
                      icon: Icons.cases_rounded,
                      borderColor:
                          notif.isRead
                              ? CustomColors.darkGrey
                              : dark
                              ? CustomColors.alternate
                              : CustomColors.primary,
                      onTap: () async {
                        await ref.read(
                          readNotificationProvider(notif.id).future,
                        );
                        HelperFunction.navigateScreen(
                          context,
                          AcceptJobScreen(
                            id: notif.id,
                            employerId: job.employerId,
                            providerId: job.providerId,
                            employerImage: job.employerImage,
                            providerImage: job.providerImage,
                            date: notif.createdAt,
                            borderColor:
                                notif.isRead
                                    ? Colors.transparent
                                    : CustomColors.primary,
                            title: notif.title,
                            employerName: job.employerName,
                            providerName: job.providerName,
                            jobTitle: job.jobTitle,
                            pay: job.pay * job.duration,
                            duration: job.duration,
                            latitude: job.latitude,
                            longitude: job.longitude,
                            vvid: job.vvid,
                          ),
                        );
                      },
                      iconColor:
                          notif.isRead ?  Colors.white
                          : dark ? CustomColors.primary : CustomColors.alternate,
                      title: notif.title,
                      message: notif.message,
                      date: notif.createdAt,
                    );
                  }

                  if (notif.type == 'transaction') {
                    return NotificationCard(
                      icon: Iconsax.bank,
                      borderColor:
                          notif.isRead
                              ? CustomColors.darkGrey
                              : dark
                              ? CustomColors.alternate
                              : CustomColors.primary,
                      onTap: () async {
                        await ref.read(
                          readNotificationProvider(notif.id).future,
                        );
                        HelperFunction.navigateScreen(
                          context,
                          TransactionHistory(),
                        );
                      },
                      iconColor:
                          notif.isRead ?  Colors.white
                          : dark ? CustomColors.primary : CustomColors.alternate,
                      title: notif.title,
                      message: notif.message,
                      date: notif.createdAt,
                    );
                  }

                  return NotificationCard(
                    icon: Icons.notifications,
                    borderColor:
                        notif.isRead
                            ? CustomColors.darkGrey
                            : dark
                            ? CustomColors.alternate
                            : CustomColors.primary,
                    onTap: () async {
                      await ref.read(readNotificationProvider(notif.id).future);
                      HelperFunction.navigateScreen(
                        context,
                        NotificationViewScreen(
                          title: notif.title,
                          message: notif.message,
                          date: notif.createdAt,
                        ),
                      );
                    },
                      iconColor:
                          notif.isRead ?  Colors.white
                          : dark ? CustomColors.primary : CustomColors.alternate,
                    title: notif.title,
                    message: notif.message,
                    date: notif.createdAt,
                  );
                },
              );
            },
            loading:
                () => SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: const JobsScreenShimmer(),
                ),
            error:
                (err, _) => Padding(
                  padding: const EdgeInsets.all(Sizes.spaceBtwItems),
                  child: Column(
                    children: [
                      const SizedBox(height: 200),
                      Text(
                        'Could not load screen, check your internet connection',
                        style: Theme.of(context).textTheme.labelMedium,
                        softWrap: true,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: Sizes.spaceBtwItems),
                      IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: CustomColors.primary,
                          padding: const EdgeInsets.all(Sizes.sm),
                        ),
                        icon: const Icon(Icons.refresh, color: Colors.white),
                        onPressed: () {
                          setState(() => isRefreshing = true);
                          ref.refresh(notificationsProvider);
                          setState(() => isRefreshing = false);
                        },
                      ),
                    ],
                  ),
                ),
          ),
        ),
      ),
    );
  }
}
