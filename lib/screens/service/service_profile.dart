// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vider_provider/common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../common/widgets/image/full_screen_image_view.dart';
import '../../common/widgets/layouts/listvew.dart';
import '../../controllers/user/user_controller.dart';
import '../../models/user/user_profile_model.dart';
import '../../repository/user/user_local_storage.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/helpers/helper_function.dart';
import 'components/service_profile_shimmer.dart';
// import 'widgets/certification_title.dart';
import 'widgets/user_bio.dart';
import 'widgets/user_info.dart';
import 'widgets/cover_image.dart';
import 'widgets/services.dart';

final userLocalFutureProvider = FutureProvider<UserProfileModel?>((ref) async {
  return await UserLocalStorage.getUserProfile();
});

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
    final dark = HelperFunction.isDarkMode(context);
    final userProfile = ref.watch(userProvider);
    double screenHeight = MediaQuery.of(context).size.height;
    double horizontalCardHeight = screenHeight * 0.20;

    if (!_initialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return SafeArea(
      child: Scaffold(
        body: userProfile.when(
          data: (user) {
            return RefreshIndicator(
              onRefresh: () async {
                await ref.read(userProvider.notifier).fetchUserDetails();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CoverImage(
                      coverImageString: user.profileImage,
                      profileImage: user.profileImage,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(Sizes.spaceBtwItems),
                      child: Column(
                        children: [
                          const SizedBox(height: Sizes.spaceBtwSections + 4),
                          RoundedContainer(
                            padding: const EdgeInsets.all(Sizes.sm),
                            backgroundColor:
                                dark
                                    ? Colors.white.withValues(alpha: 0.1)
                                    : Colors.black.withValues(alpha: 0.1),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                UserInfo(
                                  fullname:
                                      '${user.firstname} ${user.lastname}',
                                  username: user.username,
                                  service: user.service,
                                  rating: 5.0,
                                  category: user.category,
                                  hourlyRate: user.hourlyRate,
                                ),

                                const SizedBox(height: Sizes.spaceBtwSections + 4),
                                user.portfolioImages.isEmpty
                                    ? const SizedBox.shrink()
                                    : HomeListView(
                                      sizedBoxHeight:
                                          horizontalCardHeight * 0.50,
                                      scrollDirection: Axis.horizontal,
                                      seperatorBuilder:
                                          (context, index) =>
                                              const SizedBox(width: Sizes.sm),
                                      itemCount: user.portfolioImages.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap:
                                              () =>
                                                  HelperFunction.navigateScreen(
                                                    context,
                                                    FullScreenImageView(
                                                      images:
                                                          user.portfolioImages,
                                                      initialIndex: index,
                                                    ),
                                                  ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              Sizes.borderRadiusLg,
                                            ),
                                            child: Image.network(
                                              user.portfolioImages[index],
                                              width:
                                                  horizontalCardHeight * 0.50,
                                              height:
                                                  horizontalCardHeight * 0.60,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      },
                                    ),

                                    const SizedBox(height: Sizes.spaceBtwItems,)
                              ],
                            ),
                          ),

                          const SizedBox(height: Sizes.spaceBtwItems),
                          RoundedContainer(
                            padding: const EdgeInsets.all(Sizes.sm),
                            backgroundColor:
                                dark
                                    ? Colors.white.withValues(alpha: 0.1)
                                    : Colors.black.withValues(alpha: 0.1),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                UserBio(bio: user.bio),

                                const SizedBox(height: Sizes.spaceBtwSections),
                                HomeListView(
                                  sizedBoxHeight: screenHeight * 0.06,
                                  scrollDirection: Axis.horizontal,
                                  seperatorBuilder:
                                      (context, index) =>
                                          const SizedBox(width: Sizes.sm),
                                  itemCount: user.skills.length,
                                  itemBuilder:
                                      (context, index) =>
                                          Services(service: user.skills[index]),
                                ),

                                const SizedBox(height: Sizes.spaceBtwItems,)
                              ],
                            ),
                          ),
                          const SizedBox(height: Sizes.spaceBtwItems),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          loading: () => const Center(child: ServiceProfileShimmer()),
          error:
              (err, _) => Center(
                child: Text(
                  'Unable to load user details right now. Try again later',
                  style: Theme.of(context).textTheme.labelMedium,
                  softWrap: true,
                ),
              ),
        ),
      ),
    );
  }
}
