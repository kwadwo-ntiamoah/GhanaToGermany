
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ghana_to_germany/Application/Abstractions/Services/IPostWsService.dart';
import 'package:ghana_to_germany/Application/Providers/login.provider.dart';
import 'package:ghana_to_germany/Application/Providers/register.provider.dart';
import 'package:ghana_to_germany/Presentation/config/service_locator.dart' as sl;
import 'package:ghana_to_germany/Presentation/pages/communities/communities.dart';
import 'package:ghana_to_germany/Presentation/pages/feeds/feeds.dart';
import 'package:ghana_to_germany/Presentation/pages/profile/profile.dart';
import 'package:ghana_to_germany/Presentation/pages/search/search.dart';
import 'package:ghana_to_germany/Presentation/theme/colors.dart';
import 'package:provider/provider.dart';


class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    sl.getIt<IPostWsService>().onNewPostReceived();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<LoginViewModel>().resetState();
        context.read<RegisterViewModel>().resetState();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _toHome() {
    setState(() {
      _selectedIndex = 0;
    });

    _pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );// You can use animateToPage for smooth animation
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );// You can use animateToPage for smooth animation
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          const FeedsScreen(),
          SearchScreen(goBack: _toHome),
          CommunitiesScreen(goBack: _toHome),
          ProfileScreen(goBack: _toHome)
        ],
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashFactory: NoSplash
              .splashFactory, // Remove splash effect only for this BottomNavigationBar
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 0.5,
              color: GGSwatch.disabled,
            ),
            BottomNavigationBar(
              backgroundColor: GGSwatch.light,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              enableFeedback: false,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              selectedItemColor: GGSwatch.textSecondary,
              unselectedItemColor: GGSwatch.disabled,
              iconSize: 20,
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              items: const [
                BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.house),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                    icon: FaIcon(FontAwesomeIcons.magnifyingGlass),
                    label: "Search"),
                BottomNavigationBarItem(
                    icon: FaIcon(FontAwesomeIcons.message), label: "Messages"),
                BottomNavigationBarItem(
                    icon: FaIcon(FontAwesomeIcons.user), label: "Profile"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
