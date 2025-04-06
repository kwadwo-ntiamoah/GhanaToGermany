import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ghana_to_germany/Application/Abstractions/Services/INavigationService.dart';
import 'package:ghana_to_germany/Application/Providers/posts.provider.dart';
import 'package:ghana_to_germany/Application/Providers/shared/form_status.dart';
import 'package:ghana_to_germany/Presentation/common/card.dart';
import 'package:ghana_to_germany/Presentation/config/router.dart';
import 'package:ghana_to_germany/Presentation/theme/colors.dart';
import 'package:provider/provider.dart';
import 'package:ghana_to_germany/Presentation/config/service_locator.dart'
    as sl;

class PostsScreen extends StatelessWidget {
  const PostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PostsViewModel>(builder: (context, state, _) {
      if (state.status == FormStatus.LOADING) {
        return Center(
            child: SizedBox(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(
                  color: AppColors.secondary,
                )));
      }

      if (state.logout) {
        sl.getIt<INavigationService>().go(AppRoutes.login);
      }

      if (state.posts.isEmpty) {
        return Center(
          child: Icon(CupertinoIcons.folder_open,
              color: GGSwatch.disabled.withOpacity(.2), size: 80),
        );
      }

      return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView.builder(
            itemCount: state.posts.length, // Adjust item count for separators
            itemBuilder: (context, index) {
              return Column(
                children: [
                  GGCard(post: state.posts[index]),
                  index.isOdd
                      ? const SizedBox.shrink()
                      : const Divider(thickness: .2)
                ],
              );
            },
          ));
    });
  }
}
