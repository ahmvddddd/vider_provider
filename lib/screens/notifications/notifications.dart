import 'package:flutter/material.dart';
import '../../common/widgets/appbar/appbar.dart';
import '../../common/widgets/layouts/listvew.dart';
import '../../common/widgets/pop_up/custom_alert_dialog.dart';
import '../../common/widgets/pop_up/custom_snackbar.dart';
import '../../controllers/jobs/accept_job_controller.dart';
import '../../controllers/notifications/delete_notification_controller.dart';
import '../../controllers/notifications/notification_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/notifications/read_notification_controller.dart';
import '../../nav_menu.dart';
import '../../utils/constants/custom_colors.dart';
import '../../utils/helpers/helper_function.dart';
import '../messages/components/chat_shimmer.dart';
import 'notification_view_screen.dart';
import 'widgets/job_request_notification.dart';
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

                  if (isRefreshing) const ChatShimmer();

                  if (notif.type == 'job_request' && notif.jobDetails != null) {
                    final job = notif.jobDetails!;
                    return JobRequestNotification(
                      date: notif.createdAt,
                      borderColor:
                          notif.isRead
                              ? Colors.transparent
                              : CustomColors.primary,
                      title: notif.title,
                      employerImage: job.employerImage,
                      employerName: job.employerName,
                      jobTitle: job.jobTitle,
                      pay: job.pay * job.duration,
                      duration: job.duration,
                      onDecline: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (BuildContext context) {
                            return CustomAlertDialog(
                              title: 'Decline Job Request',
                              message:
                                  'Are you sure you want to decline this job request ?',
                              onCancel: () => Navigator.of(context).pop(false),
                              onConfirm: () => Navigator.of(context).pop(true),
                            );
                          },
                        );

                        if (confirm == true) {
                          ref.read(deleteNotificationProvider(notif.id));
                        }
                      },
                      onAccept: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (BuildContext context) {
                            return CustomAlertDialog(
                              title: 'Accept Job',
                              message:
                                  'The job timer starts immediately you click on accept. You must finish the job before the timer ends to avoid violating the job contract.',
                              onCancel: () => Navigator.of(context).pop(false),
                              onConfirm: () => Navigator.of(context).pop(true),
                            );
                          },
                        );

                        if (confirm == true) {
                          final now = DateTime.now();
                          final jobStartTime = job.startTime;

                          if (now.isAfter(
                            jobStartTime.add(const Duration(minutes: 10)),
                          )) {
                            CustomSnackbar.show(
                              context: context,
                              title: 'Could not accept job request',
                              message:
                                  'The job has expired after 10 minutes of no response',
                              backgroundColor: CustomColors.error,
                              icon: Icons.cancel,
                            );
                            ref.read(deleteNotificationProvider(notif.id));
                          } else {
                            await ref
                                .read(addJobControllerProvider.notifier)
                                .addJob(
                                  context: context,
                                  employerId: job.employerId,
                                  providerId: job.providerId,
                                  employerImage: job.employerImage,
                                  providerImage: job.providerImage,
                                  employerName: job.employerName,
                                  providerName: job.providerName,
                                  jobTitle: job.jobTitle,
                                  pay: job.pay,
                                  duration: job.duration,
                                );

                            await ref.read(
                              deleteNotificationProvider(notif.id).future,
                            );

                            ref.read(selectedIndexProvider.notifier).state = 1;
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const NavigationMenu(),
                              ),
                            );
                          }
                        }
                      },
                    );
                  }

                  return NotificationCard(
                    borderColor:
                        notif.isRead
                            ? Colors.transparent
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
                        notif.isRead ? Colors.white : CustomColors.primary,
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
                  child: const ChatShimmer(),
                ),
            error:
                (err, _) => Padding(
                  padding: const EdgeInsets.all(Sizes.spaceBtwItems),
                  child: Column(
                    children: [
                      const SizedBox(height: 200),
                      Text(
                        'Could not load screen, check your internet connection',
                        style: Theme.of(context).textTheme.bodySmall,
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
