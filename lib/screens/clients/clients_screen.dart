import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../common/widgets/appbar/appbar.dart';
import '../../common/widgets/custom_shapes/containers/button_container.dart';
import '../../common/widgets/layouts/listvew.dart';
import '../../common/widgets/list_tile/settings_menu_tile.dart';
import '../../common/widgets/pop_up/custom_alert_dialog.dart';
import '../../common/widgets/texts/section_heading.dart';
import '../../controllers/user/report_issue_controller.dart';
import '../../utils/constants/custom_colors.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/helpers/helper_function.dart';

class ClientsScreen extends StatelessWidget {
  final String employerName;
  final List<dynamic> jobs;
  final String employerImage;

  const ClientsScreen({
    super.key,
    required this.employerName,
    required this.jobs,
    required this.employerImage,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double horizontalCardHeight = screenHeight * 0.20;
    final dark = HelperFunction.isDarkMode(context);
    return Scaffold(
      appBar: TAppBar(
        title: Text(
          employerName,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        showBackArrow: true,
      ),
      bottomNavigationBar: ButtonContainer(
        text: 'Report',
        onPressed: () async {
          final confirm = await showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return CustomAlertDialog(
                title: 'Report User',
                message: 'Are you sure you want to report this user?',
                onCancel: () => Navigator.of(context).pop(false),
                onConfirm: () => Navigator.of(context).pop(true),
              );
            },
          );

          if (confirm == true) {
            ReportIssueController.launchGmailCompose('Report $employerName');
          }
        },
        backgroundColor: const Color.fromARGB(255, 206, 26, 13),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.spaceBtwItems),
          child: Column(
            children: [
              //avatar and name
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Container(
                  width: horizontalCardHeight * 0.50,
                  height: horizontalCardHeight * 0.50,
                  decoration: BoxDecoration(
                    color: dark ? Colors.black : Colors.white,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Image.network(employerImage, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: Sizes.spaceBtwItems),
              const SectionHeading(
                title: 'Recent Transactions',
                showActionButton: false,
              ),

              const SizedBox(height: Sizes.spaceBtwItems),
              HomeListView(
                seperatorBuilder:
                    (context, index) => const Padding(
                      padding: EdgeInsets.all(Sizes.spaceBtwItems),
                      child: Divider(color: CustomColors.primary),
                    ),
                scrollDirection: Axis.vertical,
                scrollPhysics: const NeverScrollableScrollPhysics(),
                itemCount: jobs.length,
                itemBuilder: (_, index) {
                  final job = jobs[index];
                  final DateTime startDate = DateTime.parse(job.startTime);
                  final String formattedDate = DateFormat(
                    'dd/MM/yy',
                  ).format(startDate);
                  return SettingsMenuTile(
                    iconSize: Sizes.iconM,
                    icon: Icons.circle,
                    title: '${job.jobTitle}',
                    subTitle: formattedDate,
                    trailing: Text(
                      '\$${NumberFormat('#,##0.00').format(job.pay)}',
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        color: Colors.green[500],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
