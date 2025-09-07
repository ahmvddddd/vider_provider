import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vider_provider/controllers/user/user_controller.dart';
import 'package:vider_provider/utils/helpers/capitalize_text.dart';
import '../../common/widgets/appbar/appbar.dart';
import '../../common/widgets/image/full_screen_image_view.dart';
import '../../common/widgets/layouts/listvew.dart';
import '../../common/widgets/texts/section_heading.dart';
import '../../repository/user/user_local_storage.dart';
import '../../utils/constants/custom_colors.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/helpers/helper_function.dart';
import '../settings/settings_screen.dart';
import 'widgets/profile_image.dart';
import 'widgets/services.dart';
import 'widgets/verification_pop_up_container.dart';

class ServiceProfileScreen extends ConsumerStatefulWidget {
  const ServiceProfileScreen({super.key});

  @override
  ConsumerState<ServiceProfileScreen> createState() =>
      _ServiceProfileScreenState();
}

class _ServiceProfileScreenState extends ConsumerState<ServiceProfileScreen> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    // Check local storage, and only fetch from API if not found
    Future.microtask(() async {
      final localUser = await UserLocalStorage.getUserProfile();
      if (localUser == null) {
        ref.read(userProvider.notifier).fetchUserDetails();
      } else {
        ref.read(userProvider.notifier).state = AsyncData(localUser);
      }
      setState(() => _initialized = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProvider);
    final dark = HelperFunction.isDarkMode(context);

    if (!_initialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: TAppBar(
        title: Text(
          'Service Profile',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        actions: [
          IconButton(
            onPressed: () {
              HelperFunction.navigateScreen(context, SettingsScreen());
            },
            style: IconButton.styleFrom(backgroundColor: CustomColors.primary),
            icon: Icon(Icons.settings, size: Sizes.iconM, color: Colors.white),
          ),
        ],
      ),
      body: userProfile.when(
        data: (user) {
          Color ratingColor = Colors.brown;

          if (user.rating < 1.66) {
            ratingColor = Colors.brown; // Low rating
          } else if (user.rating < 3.33) {
            ratingColor = CustomColors.silver; // Medium rating
          } else if (user.rating >= 3.33) {
            ratingColor = CustomColors.gold; // High rating
          }
          return RefreshIndicator(
            onRefresh: () async {
              await ref.read(userProvider.notifier).fetchUserDetails();
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  user.isIdVerified == true
                      ? const SizedBox.shrink()
                      : Column(
                        children: [
                          VerificationPopUpContainer(),
                          const SizedBox(height: Sizes.spaceBtwItems,)
                        ],
                      ),
                  ProfileImage(
                    imageAvatar: user.profileImage,
                    fullname:
                        '${user.firstname.capitalizeEachWord()} ${user.lastname.capitalizeEachWord()}',
                    ratingColor: ratingColor,
                    rating: user.rating,
                    service: user.service,
                    hourlyRate: user.hourlyRate,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Sizes.spaceBtwItems,
                    ),
                    child: HomeListView(
                      sizedBoxHeight: MediaQuery.of(context).size.height * 0.06,
                      scrollDirection: Axis.horizontal,
                      seperatorBuilder:
                          (context, index) => Padding(
                            padding: const EdgeInsets.all(Sizes.sm),
                            child: const VerticalDivider(
                              color: CustomColors.primary,
                            ),
                          ),
                      itemCount: user.skills.length,
                      itemBuilder:
                          (context, index) =>
                              Services(service: user.skills[index]),
                    ),
                  ),

                  const SizedBox(height: Sizes.spaceBtwItems),
                  Container(
                    padding: const EdgeInsets.all(Sizes.spaceBtwItems),
                    decoration: BoxDecoration(
                      color:
                          dark
                              ? Colors.white.withValues(alpha: 0.1)
                              : Colors.black.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: Sizes.spaceBtwItems),
                        SectionHeading(title: 'About', showActionButton: false),
                        const SizedBox(height: Sizes.sm),
                        Text(
                          user.bio,
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall!.copyWith(
                            color: dark ? Colors.white : Colors.black,
                          ),
                          softWrap: true,
                        ),

                        const SizedBox(height: Sizes.spaceBtwSections),
                        SectionHeading(
                          title: 'Portfolio',
                          showActionButton: false,
                        ),
                        const SizedBox(height: Sizes.sm),
                        HomeListView(
                          sizedBoxHeight:
                              MediaQuery.of(context).size.height * 0.40,
                          scrollDirection: Axis.horizontal,
                          seperatorBuilder:
                              (context, index) =>
                                  const SizedBox(width: Sizes.sm),
                          itemCount: user.portfolioImages.length,
                          itemBuilder: (context, index) {
                            final images = user.portfolioImages;
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => FullScreenImageView(
                                          images: images, // Pass all images
                                          initialIndex:
                                              index, // Start from tapped image
                                        ),
                                  ),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  Sizes.borderRadiusLg,
                                ),
                                child: Image.network(
                                  user.portfolioImages[index],
                                  width:
                                      MediaQuery.of(context).size.width * 0.55,
                                  height:
                                      MediaQuery.of(context).size.height * 0.30,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: Sizes.spaceBtwSections),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (err, _) => Center(
              child: Text(
                'Unable to load user details right now. Try again later',
                style: Theme.of(context).textTheme.labelMedium,
                softWrap: true,
              ),
            ),
      ),
    );
  }
}
