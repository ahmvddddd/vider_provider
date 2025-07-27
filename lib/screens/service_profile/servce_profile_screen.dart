import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vider_provider/controllers/user/user_controller.dart';
import 'package:vider_provider/utils/helpers/capitalize_text.dart';
import '../../common/widgets/appbar/appbar.dart';
import '../../common/widgets/layouts/listvew.dart';
import '../../common/widgets/texts/section_heading.dart';
import '../../repository/user/user_local_storage.dart';
import '../../utils/constants/custom_colors.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/helpers/helper_function.dart';
import '../settings/settings_screen.dart';
import 'widgets/profile_image.dart';
import 'widgets/services.dart';

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
            style: IconButton.styleFrom(
              backgroundColor: CustomColors.primary
            ),
            icon: Icon(Icons.settings, size: Sizes.iconM, color: Colors.white,),
          ),
        ],
      ),
      body: userProfile.when(
        data: (user) {
          return RefreshIndicator(
            onRefresh: () async {
              await ref.read(userProvider.notifier).fetchUserDetails();
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ProfileImage(
                    imageAvatar: user.profileImage,
                    fullname:
                        '${user.firstname.capitalizeEachWord()} ${user.lastname.capitalizeEachWord()}',
                    ratingColor: Colors.brown,
                    rating: 2,
                    service: user.service,
                    hourlyRate: 100,
                  ),

                  const SizedBox(height: Sizes.sm),
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
                        HomeListView(
                          sizedBoxHeight:
                              MediaQuery.of(context).size.height * 0.06,
                          scrollDirection: Axis.horizontal,
                          seperatorBuilder:
                              (context, index) =>
                                  const SizedBox(width: Sizes.sm),
                          itemCount: user.skills.length,
                          itemBuilder:
                              (context, index) => Services(
                                service: user.skills[index],
                              )
                        ),

                        const SizedBox(height: Sizes.spaceBtwSections),
                        SectionHeading(title: 'About', showActionButton: false),
                        const SizedBox(height: Sizes.sm),
                        Text(
                          user.bio,
                          style: Theme.of(context).textTheme.bodySmall!
                              .copyWith(fontWeight: FontWeight.bold),
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
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(
                                Sizes.borderRadiusLg,
                              ),
                              child: Image.network(
                                user.portfolioImages[index],
                                width:
                                    MediaQuery.of(context).size.height * 0.40,
                                height:
                                    MediaQuery.of(context).size.height * 0.30,
                                fit: BoxFit.cover,
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



//https://res.cloudinary.com/dueykz4hi/image/upload/v1750296090/profile_images/wazxd1rgmdark6w1ktaz.jpg