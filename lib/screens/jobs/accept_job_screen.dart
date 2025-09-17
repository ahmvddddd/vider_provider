import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../../utils/helpers/capitalize_text.dart';
import '../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../common/widgets/custom_shapes/divider/custom_divider.dart';
import 'package:intl/intl.dart';
import '../../../controllers/jobs/job_verification_controller.dart';
import '../../../controllers/notifications/delete_notification_controller.dart';
import '../../../nav_menu.dart';
import '../../../utils/constants/custom_colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_function.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../common/widgets/appbar/appbar.dart';
import '../../common/widgets/image/full_screen_image_view.dart';
import '../../common/widgets/pop_up/custom_alert_dialog.dart';
import '../../common/widgets/pop_up/custom_snackbar.dart';
import '../../common/widgets/texts/title_and_description.dart';
import '../../controllers/jobs/accept_job_controller.dart';
import '../../controllers/jobs/pending_jobs_controller.dart';
import '../../controllers/notifications/add_notification_controller.dart';
import '../../models/notification/add_notification_model.dart';

class AcceptJobScreen extends ConsumerStatefulWidget {
  final String id;
  final Color borderColor;
  final String title;
  final String employerId;
  final String providerId;
  final String employerImage;
  final String providerImage;
  final String employerName;
  final String providerName;
  final String jobTitle;
  final double pay;
  final int duration;
  final DateTime date;
  final double latitude;
  final double longitude;
  final String vvid;

  const AcceptJobScreen({
    super.key,
    required this.id,
    required this.borderColor,
    required this.title,
    required this.employerId,
    required this.providerId,
    required this.employerImage,
    required this.providerImage,
    required this.employerName,
    required this.providerName,
    required this.jobTitle,
    required this.pay,
    required this.duration,
    required this.date,
    required this.latitude,
    required this.longitude,
    required this.vvid,
  });

  @override
  ConsumerState<AcceptJobScreen> createState() =>
      _JobRequestNotificationState();
}

class _JobRequestNotificationState extends ConsumerState<AcceptJobScreen> {
  LatLng? currentUserLocation;
  late final MapController _mapController;

  final List<TextEditingController> _codeControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _getCurrentUserLocation();
  }

  Future<void> _getCurrentUserLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      currentUserLocation = LatLng(position.latitude, position.longitude);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fitMapToBounds();
    });
  }

  void _fitMapToBounds() {
    if (currentUserLocation == null) return;
    final profileLocation = LatLng(widget.latitude, widget.longitude);

    final bounds = LatLngBounds.fromPoints([
      currentUserLocation!,
      profileLocation,
    ]);

    _mapController.fitBounds(
      bounds,
      options: const FitBoundsOptions(padding: EdgeInsets.all(50)),
    );
  }

  Future<void> _submitCode() async {
    FocusScope.of(context).unfocus();
    final code = _codeControllers.map((c) => c.text).join();

    if (code.length != 6) {
      CustomSnackbar.show(
        context: context,
        title: 'Invalid code',
        message: 'Please enter all 6 digits',
        icon: Icons.error_outline,
        backgroundColor: CustomColors.error
      );
      return;
    }

    try {
      final jobCheck = await ref.read(
        pendingJobsProvider(widget.providerId).future,
      );

      if (jobCheck.hasPendingJob) {
        CustomSnackbar.show(
          context: context,
          title: 'Pending Job',
          message:
              'You already have a job in progress. Complete it before accepting a new one.',
          icon: Icons.warning_amber_outlined,
          backgroundColor: CustomColors.warning,
        );
        return; // 🚫 stop execution
      }

      // 2️⃣ If no pending job, proceed with verification
      final result = await ref.read(
        jobVerifyProvider({"code": code, "vvid": widget.vvid}).future,
      );

      if (result) {
        // 3️⃣ Add job if verification passed
        await ref
            .read(addJobControllerProvider.notifier)
            .addJob(
              context: context,
              employerId: widget.employerId,
              providerId: widget.providerId,
              employerImage: widget.employerImage,
              providerImage: widget.providerImage,
              employerName: widget.employerName,
              providerName: widget.providerName,
              jobTitle: widget.jobTitle,
              pay: widget.pay,
              duration: widget.duration,
            );

        // 4️⃣ Send notification
        await ref
            .read(addNotificationControllerProvider.notifier)
            .addNotification(
              AddNotificationModel(
                type: 'generic',
                title: 'Job Accepted',
                message:
                    'Your job has been accepted by the provider and countdown timer has started',
                recipientId: widget.employerId,
              ),
            );

        // 5️⃣ Delete notification
        ref.read(deleteNotificationProvider(widget.id));

        CustomSnackbar.show(
          context: context,
          title: 'Success',
          message: 'Job accepted and countdown timer has started',
          icon: Icons.check_circle,
          backgroundColor: CustomColors.success,
        );

        // 6️⃣ Navigate to home
        ref.read(selectedIndexProvider.notifier).state = 1;
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const NavigationMenu()),
          );
        });
      }
    } catch (e) {
      CustomSnackbar.show(
        context: context,
        title: 'An error occurred.',
        message: 'Verification failed',
        icon: Icons.error_outline,
        backgroundColor: CustomColors.error,
      );
    }
  }

  void _showAcceptDialog() {
    showDialog(
      context: context,
      builder:
          (ctx) => CustomAlertDialog(
            title: "Accept Job",
            message:
                "Are you sure you want to accept this job? Failure to fulfill the job requirements may result in job cancellation and could lead to account suspension.",
            confirmText: "Yes",
            cancelText: "No",
            onConfirm: () {
              Navigator.of(ctx).pop(); // close dialog
              _submitCode();
            },
            onCancel: () => Navigator.of(ctx).pop(),
          ),
    );
  }

  void _showDeclineDialog() {
    showDialog(
      context: context,
      builder:
          (ctx) => CustomAlertDialog(
            title: "Decline Job",
            message: "Are you sure you want to decline this job?",
            confirmText: "Yes",
            cancelText: "No",
            onConfirm: () async {
              Navigator.of(ctx).pop(); // close dialog
              await ref.read(deleteNotificationProvider(widget.id).future);
              ref.read(selectedIndexProvider.notifier).state = 0;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const NavigationMenu()),
              );
            },
            onCancel: () => Navigator.of(ctx).pop(),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunction.isDarkMode(context);
    final profileLocation = LatLng(widget.latitude, widget.longitude);
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: TAppBar(
        title: Text(
          'Accept Job',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        showBackArrow: true,
      ),
      bottomNavigationBar: buttonsContainer(
        context,
        _showDeclineDialog,
        _showAcceptDialog,
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(Sizes.spaceBtwItems),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1 / 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Sizes.cardRadiusMd),
                    child: FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        center: currentUserLocation ?? profileLocation,
                        zoom: 15,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.myapp',
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: profileLocation,
                              width: 40,
                              height: 40,
                              builder:
                                  (ctx) => const Icon(
                                    Icons.location_on,
                                    color: CustomColors.primary,
                                    size: 30,
                                  ),
                            ),
                            if (currentUserLocation != null)
                              Marker(
                                point: currentUserLocation!,
                                width: 40,
                                height: 40,
                                builder:
                                    (ctx) => const Icon(
                                      Icons.location_on,
                                      color: Colors.red,
                                      size: 30,
                                    ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: Sizes.spaceBtwItems),

                /// Job details
                RoundedContainer(
                  width: screenWidth * 0.90,
                  backgroundColor:
                      dark
                          ? Colors.white.withValues(alpha: 0.1)
                          : Colors.black.withValues(alpha: 0.1),
                  padding: const EdgeInsets.all(Sizes.sm),
                  showBorder: true,
                  borderColor: widget.borderColor,
                  radius: Sizes.cardRadiusMd,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                        ),
                        softWrap: true,
                        maxLines: 3,
                      ),

                      const SizedBox(height: Sizes.xs),
                      Text(
                        DateFormat('dd/MM/yy HH:mm:ss').format(widget.date),
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      CustomDivider(padding: EdgeInsets.all(Sizes.sm)),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => FullScreenImageView(
                                        images: [
                                          widget.employerImage,
                                        ], // Pass all images
                                        initialIndex:
                                            0, // Start from tapped image
                                      ),
                                ),
                              );
                            },
                            child: CircleAvatar(
                              radius: 18,
                              backgroundImage: NetworkImage(
                                widget.employerImage,
                              ),
                            ),
                          ),
                          const SizedBox(width: Sizes.sm),
                          Text(
                            widget.employerName.capitalizeEachWord(),
                            style: Theme.of(context).textTheme.bodySmall!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: Sizes.sm),
                      Row(
                        children: [
                          Text(
                            'Service Needed:',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                          const SizedBox(width: Sizes.md),
                          Text(
                            widget.jobTitle.capitalizeEachWord(),
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall!.copyWith(
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold,
                              color: dark ? Colors.white : Colors.black,
                            ),
                            softWrap: true,
                            maxLines: 3,
                          ),
                        ],
                      ),
                      const SizedBox(height: Sizes.xs),
                      Row(
                        children: [
                          Text(
                            'PAY:',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                          const SizedBox(width: Sizes.md),
                          Text(
                            '\$${widget.pay}',
                            style: Theme.of(
                              context,
                            ).textTheme.labelLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Sizes.xs),
                      Row(
                        children: [
                          Text(
                            'Duration:',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                          const SizedBox(width: Sizes.md),
                          Text(
                            '${widget.duration} Hour(s)',
                            style: Theme.of(context).textTheme.labelLarge!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: Sizes.spaceBtwSections),

                TitleAndDescription(
                  title: 'Verification Code',
                  description:
                      'Please enter 6 digit verification code provided by the employer into the input fields bellow',
                  textAlign: TextAlign.left,
                ),

                const SizedBox(height: Sizes.spaceBtwItems),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    6,
                    (index) => RoundedContainer(
                      width: screenWidth * 0.12,
                      radius: Sizes.cardRadiusMd,
                      backgroundColor:
                          dark
                              ? Colors.white.withOpacity(0.1)
                              : Colors.black.withOpacity(0.1),
                      child: Center(
                        child: TextField(
                          controller: _codeControllers[index],
                          keyboardType: TextInputType.phone,
                          maxLength: 1,
                          textAlign: TextAlign.center,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        
                          decoration: const InputDecoration(
                            counterText: "",
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            if (value.isNotEmpty && index < 5) {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buttonsContainer(
    BuildContext context,
    VoidCallback onPressed1,
    VoidCallback onPressed2,
  ) {
    final dark = HelperFunction.isDarkMode(context);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: double.infinity,
      child: Container(
        padding: const EdgeInsets.all(Sizes.spaceBtwItems),
        color:
            dark
                ? CustomColors.white.withValues(alpha: 0.1)
                : CustomColors.black.withValues(alpha: 0.1),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: onPressed1,
                child: RoundedContainer(
                  height: screenHeight * 0.05,
                  width: screenWidth * 0.43,
                  padding: const EdgeInsets.all(Sizes.xs),
                  backgroundColor: CustomColors.error,
                  child: Center(
                    child: Text(
                      'Decline',
                      style: Theme.of(
                        context,
                      ).textTheme.labelSmall!.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),

              GestureDetector(
                onTap: onPressed2,
                child: RoundedContainer(
                  height: screenHeight * 0.05,
                  width: screenWidth * 0.43,
                  padding: const EdgeInsets.all(Sizes.xs),
                  backgroundColor: CustomColors.success,
                  child: Center(
                    child: Text(
                      'Accept',
                      style: Theme.of(
                        context,
                      ).textTheme.labelSmall!.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
