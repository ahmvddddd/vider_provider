import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:vider_provider/screens/authentication/auth_screen.dart';
import '../../utils/constants/custom_colors.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/helpers/helper_function.dart';

// Riverpod state provider for current index
final currentIndexProvider = StateProvider<int>((ref) => 0);

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();

  final List<Map<String, dynamic>> _pages = [
    {
      'words': ['Appear', 'In Map', 'Search'],
      'text': 'Get clients within your location',
    },
    {
      'words': ['Accept', 'Jobs', 'Effortlessly '],
      'text': 'Get contacted and hired without hassle',
    },
    {
      'words': ['Execute Job', 'And', 'Get Paid'],
      'text': 'Receive crypto payouts after job completion',
    },
  ];

  final List<Map<String, dynamic>> pageTexts = [
    {
      'pageText': 'Clients can search for you on the map. Make sure to switch on your location in profile settings. Set up your profile so it is eye catching and attractive to clients'
    },
    {
      'pageText': 'Clients can message you to get more information on services you provide. Check your messages reqularly so you do not miss potential clients'
    },
    {
      'pageText': 'Your payments reflect in your wallet as soon as a job is completed. Withrawals are auto credited to your crypto wallet. Make sure to provide correct wallet address when submitting in your details'
    }
  ] ;

  void _nextPage() {
    final currentIndex = ref.read(currentIndexProvider);
    if (currentIndex < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      ref.read(currentIndexProvider.notifier).state++;
    } else {
      HelperFunction.navigateScreen(context, const AuthScreen());
    }
  }

  Widget _buildIndicator(int index, int currentIndex) {
    final isActive = index == currentIndex;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: isActive ? 24.0 : 8.0,
      decoration: BoxDecoration(
        color: isActive ? CustomColors.primary : Colors.grey,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(currentIndexProvider);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              onPageChanged: (index) =>
                  ref.read(currentIndexProvider.notifier).state = index,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: screenHeight * 0.60,
                      width: screenWidth,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: CustomColors.primary.withValues(alpha: 0.05),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(Sizes.xl),
                          bottomRight: Radius.circular(Sizes.xl),
                        ),
                      ),
                      child: currentIndex == index
                          ? AnimatedTextKit(
                              animatedTexts: (_pages[index]['words'] as List<String>)
                                  .map((word) => TyperAnimatedText(
                                        word,
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .headlineLarge!
                                            .copyWith(
                                              color: CustomColors.primary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                        speed: const Duration(milliseconds: 120),
                                      ))
                                  .toList(),
                              isRepeatingAnimation: true,
                              repeatForever: true,
                            )
                          : Text(
                              _pages[index]['words'][0],
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge!
                                  .copyWith(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                    ),
                    const SizedBox(height: Sizes.spaceBtwItems),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Sizes.sm),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _pages[index]['text'],
                            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  color: CustomColors.primary,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: Sizes.sm),
                          SizedBox(
                            width: screenWidth * 0.80,
                            child: Text(
                             pageTexts[index]['pageText'],
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(fontWeight: FontWeight.bold),
                              softWrap: true,
                              maxLines: 3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: List.generate(
                    _pages.length,
                    (index) => _buildIndicator(index, currentIndex),
                  ),
                ),
                TextButton(
                  onPressed: _nextPage,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(Sizes.xs),
                    backgroundColor: CustomColors.primary,
                  ),
                  child: Text(
                    currentIndex == _pages.length - 1 ? 'Finish' : 'Next',
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
