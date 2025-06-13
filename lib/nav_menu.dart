import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'controllers/notifications/message_notification_controller.dart';
import 'controllers/services/notification_badge_service.dart';
import 'screens/home/home.dart';
import 'screens/jobs/jobs_screen.dart';
import 'screens/messages/chat.dart';
import 'screens/service/service_profile.dart';
import 'utils/constants/custom_colors.dart';
import 'utils/constants/sizes.dart';
import 'utils/helpers/helper_function.dart';

final selectedIndexProvider = StateProvider<int>((ref) => 0);

class NavigationMenu extends ConsumerStatefulWidget {
  const NavigationMenu({super.key});

  @override
  ConsumerState<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends ConsumerState<NavigationMenu> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final container = ProviderScope.containerOf(context);
      final badgeService = NotificationBadgeService(container: container);
      badgeService.init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final darkMode = HelperFunction.isDarkMode(context);
    final selectedIndex = ref.watch(selectedIndexProvider);
    final unreadCount = ref.watch(unreadMessageProvider);
    Widget currentScreen() {
      switch (selectedIndex) {
        case 0:
          return const HomeScreen();
        case 1:
          return const JobsPage();
        case 2:
          return ChatScreen(key: UniqueKey());
        case 3:
          return const ServiceProfileScreen();
        default:
          return const HomeScreen();
      }
    }

    return Scaffold(
      body: currentScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          ref.read(selectedIndexProvider.notifier).state = index;
        },
        backgroundColor: darkMode ? CustomColors.dark : CustomColors.light,
        selectedItemColor: CustomColors.primary,
        unselectedItemColor: darkMode ? CustomColors.darkGrey : CustomColors.darkerGrey,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Iconsax.home, size: Sizes.iconM),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.cases_rounded, size: Sizes.iconM),
            label: 'Jobs',
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              height: 24,
              width: 24,
              child:
                  unreadCount > 0
                      ? badges.Badge(
                        position: badges.BadgePosition.topEnd(top: -6, end: -4),
                        badgeContent: Text(
                          unreadCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                        child: const Icon(Iconsax.message, size: Sizes.iconM),
                      )
                      : const Icon(Iconsax.message, size: Sizes.iconM),
            ),
            label: 'Chat',
          ),

          const BottomNavigationBarItem(
            icon: Icon(Iconsax.user, size: Sizes.iconM),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
