import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:ghana_to_germany/Application/Abstractions/Services/INavigationService.dart';
import 'package:ghana_to_germany/Application/Providers/news.provider.dart';
import 'package:ghana_to_germany/Application/Providers/posts.provider.dart';
import 'package:ghana_to_germany/Application/Providers/profile.provider.dart';
import 'package:ghana_to_germany/Application/Providers/tags.provider.dart';
import 'package:ghana_to_germany/Application/Providers/wikis.provider.dart';
import 'package:ghana_to_germany/Domain/Profile/profile.dart';
import 'package:ghana_to_germany/Presentation/config/router.dart';
import 'package:ghana_to_germany/Presentation/config/service_locator.dart'
    as sl;
import 'package:ghana_to_germany/Presentation/pages/bookmarks/bookmarks.dart';
import 'package:ghana_to_germany/Presentation/pages/news/news.dart';
import 'package:ghana_to_germany/Presentation/pages/posts/posts.dart';
import 'package:ghana_to_germany/Presentation/pages/wikis/wikis.dart';
import 'package:ghana_to_germany/Presentation/theme/colors.dart';
import 'package:provider/provider.dart';

class FeedsScreen extends StatefulWidget {
  const FeedsScreen({super.key});

  @override
  State<FeedsScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<FeedsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        context.read<PostsViewModel>().getPosts();
        context.read<WikisViewModel>().getWikis();
        context.read<NewsViewModel>().getNews();
        context.read<TagsViewModel>().getTags();
        context.read<ProfileViewModel>().getProfile();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(55),
          child: Container(
            decoration: const BoxDecoration(
                border: Border.symmetric(horizontal: BorderSide(width: .1))),
            child: AppBar(
              backgroundColor: Colors.white,
              toolbarHeight: 0,
              elevation: 0,
              automaticallyImplyLeading: false,
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: Colors.transparent,
                dividerColor: Colors.transparent,
                padding: const EdgeInsets.only(left: 50.0),
                splashFactory: NoSplash.splashFactory,
                labelColor: GGSwatch.textPrimary,
                labelStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: GGSwatch.textPrimary,
                    fontSize: 16),
                unselectedLabelColor: GGSwatch.disabled,
                enableFeedback: true,
                tabs: const [
                  Tab(text: 'Posts'),
                  Tab(text: 'Wiki'),
                  Tab(text: 'News'),
                  Tab(
                      child: Icon(
                    CupertinoIcons.bookmark,
                    size: 20,
                  ))
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            PostsScreen(),
            WikiScreen(),
            NewsScreen(),
            BookmarksScreen()
          ],
        ),
        floatingActionButton: SpeedDial(
          overlayColor: GGSwatch.disabled.withOpacity(.2),
          elevation: 0,
          icon: Icons.add, // Custom main icon
          activeIcon: Icons.close, // Icon when the SpeedDial is expanded
          backgroundColor: GGSwatch.textSecondary, // Main FAB background color
          foregroundColor: Colors.white, // Main FAB icon color
          activeBackgroundColor:
              AppColors.secondary, // Main FAB background when active
          activeForegroundColor: Colors.white, // Icon color when active
          children: [
            SpeedDialChild(
              elevation: 0,
              shape: const CircleBorder(),
              child: const Icon(
                CupertinoIcons.quote_bubble,
                color: Colors.white,
                size: 18,
              ),
              label: 'Ask Question',
              labelStyle: Theme.of(context).textTheme.bodyLarge,
              backgroundColor: GGSwatch.textSecondary,
              onTap: () =>
                  sl.getIt<INavigationService>().push(AppRoutes.addWiki),
            ),
            SpeedDialChild(
              elevation: 0,
              shape: const CircleBorder(),
              child: const Icon(
                CupertinoIcons.doc,
                color: Colors.white,
                size: 18,
              ),
              label: 'Add Post',
              labelStyle: Theme.of(context).textTheme.bodyLarge,
              backgroundColor: GGSwatch.textSecondary,
              onTap: () =>
                  sl.getIt<INavigationService>().push(AppRoutes.addPost),
            ),
          ],
        ));
  }
}
