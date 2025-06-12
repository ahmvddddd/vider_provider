import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:vider_provider/common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../common/widgets/layouts/grid_layout.dart';
import '../../../common/widgets/layouts/listvew.dart';
import '../../../common/widgets/products/products_cards/client_card.dart';
import '../../../common/widgets/texts/section_heading.dart';
import '../../../utils/constants/custom_colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_function.dart';
import '../../clients/all_clients_screen.dart';
import '../../clients/clients_screen.dart';
import 'job_dashboard_shimmer.dart';
import '../widgets/job_duration_and_status.dart';
import '../widgets/total_earnings.dart';

class ProviderDashboardScreen extends ConsumerWidget {
  final AsyncValue dashboardAsync;
  const ProviderDashboardScreen({super.key, required this.dashboardAsync});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double screenHeight = MediaQuery.of(context).size.height;
    final isDark = HelperFunction.isDarkMode(context);

    return dashboardAsync.when(
      data: (dashboard) {
        final Map<DateTime, int> heatmapData = {};
        for (var earning in dashboard.earningsByDay) {
          final date = DateTime.parse(earning.date);
          heatmapData[date] = earning.count;
        }

        Color starColor;

        if (dashboard.totalCreditedEarnings < 100000) {
          starColor = Colors.brown;
        } else if (dashboard.totalCreditedEarnings >= 100000 &&
            dashboard.totalCreditedEarnings < 500000) {
          starColor = CustomColors.silver;
        } else if (dashboard.totalCreditedEarnings > 500000) {
          starColor = CustomColors.gold;
        } else {
          starColor = Colors.brown;
        }

        String star;
        if (dashboard.totalCreditedEarnings < 100000) {
          star = 'Bronze';
        } else if (dashboard.totalCreditedEarnings >= 100000 &&
            dashboard.totalCreditedEarnings < 500000) {
          star = 'Silver';
        } else {
          star = 'Gold';
        }

        // Prepare status chart data
        final statusData =
            dashboard.statusBreakdown
                .map((s) => _StatusData(s.status, s.count))
                .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TotalEarnings(
              totalPay: dashboard.totalCreditedEarnings,
              starColor: starColor,
              star: star,
            ),
            const SizedBox(height: Sizes.spaceBtwItems),

            JobDurationAndStatus(
              averageDuration: dashboard.averageDuration,
              chart: 
              statusData.isEmpty
              ? Center(
                child: Text('No Jobs Data Yet',
                style: Theme.of(context).textTheme.labelMedium,
                softWrap: true,
                maxLines: 3,),
              )
              : SfCircularChart(
                legend: Legend(
                  isVisible: true,
                  overflowMode: LegendItemOverflowMode.wrap,
                  position: LegendPosition.bottom,
                  iconHeight: 12,
                  iconWidth: 12,
                ),
                series: <CircularSeries<dynamic, String>>[
                  PieSeries<_StatusData, String>(
                    dataSource: statusData,
                    xValueMapper: (e, _) => e.status,
                    yValueMapper: (e, _) => e.count,
                    radius: '55%',
                    dataLabelMapper: (e, _) => '${e.status} (${e.count})',
                    pointColorMapper: (e, _) {
                      switch (e.status) {
                        case 'Credited':
                          return Colors.green[900];
                        case 'Pending':
                          return Colors.orange[900];
                        default:
                          return CustomColors.primary;
                      }
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: Sizes.spaceBtwItems),
            RoundedContainer(
              padding: const EdgeInsets.all(Sizes.xs),
              backgroundColor: isDark ? Colors.white.withValues(alpha: 0.1) 
          : Colors.black.withValues(alpha: 0.1),
          radius: Sizes.cardRadiusSm,
              child: HeatMap(
                datasets: heatmapData,
                colorMode: ColorMode.color,
                size: 12,
                fontSize: 10,
                showText: false,
                scrollable: true,
                showColorTip: true,
                defaultColor:
                    CustomColors.primary.withValues(alpha: 0.15),
                textColor: isDark ? Colors.white : Colors.black,
                colorsets: {
                  1: CustomColors.primary.withValues(alpha: 0.25),
                  2: CustomColors.primary.withValues(alpha: 0.5),
                  3: CustomColors.primary.withValues(alpha: 0.75),
                  4: CustomColors.primary,
                },
                margin: const EdgeInsets.all(2),
              ),
            ),

            const SizedBox(height: Sizes.spaceBtwItems),
            dashboard.topEmployers.isEmpty
            ? const SizedBox.shrink()
            : TSectionHeading(
              title: 'Clients',
              showActionButton: true,
              onPressed: () {
                HelperFunction.navigateScreen(context, AllClientsScreen(
                  childWidget: GridLayout(
                mainAxisExtent: screenHeight * 0.25,
                itemCount: dashboard.topEmployers.length,
                itemBuilder: (context, index) {
                final employer = dashboard.topEmployers[index];
                  return ClientCard(
                  profileImage: employer.employerImage,
                  profileName: employer.employerName,
                  jobsLength: employer.totalJobs,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => ClientsScreen(
                              employerName: employer.employerName,
                              employerImage: employer.employerImage,
                              jobs: employer.jobs,
                            ),
                      ),
                    );
                  },
                );
                },
              )
                ));
              },
            ),

            const SizedBox(height: Sizes.sm),
            dashboard.topEmployers.isEmpty
            ? const SizedBox.shrink()
            : HomeListView(
              sizedBoxHeight: screenHeight * 0.25,
              scrollDirection: Axis.horizontal,
              seperatorBuilder:
                  (context, index) => const SizedBox(width: Sizes.sm),
              itemCount: dashboard.topEmployers.length > 3 ? 3 : dashboard.topEmployers.length,
              itemBuilder: (context, index) {
                final employer = dashboard.topEmployers[index];
                return ClientCard(
                  profileImage: employer.employerImage,
                  profileName: employer.employerName,
                  jobsLength: employer.totalJobs,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => ClientsScreen(
                              employerName: employer.employerName,
                              employerImage: employer.employerImage,
                              jobs: employer.jobs,
                            ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        );
      },
      loading: () => const Center(child: JobsDashBoardShimmer()),
      error: (e, _) => Center(child: Text("Error: $e")),
    );
  }
}

class _StatusData {
  final String status;
  final int count;
  _StatusData(this.status, this.count);
}
