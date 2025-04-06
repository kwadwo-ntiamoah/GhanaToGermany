import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ghana_to_germany/Application/Abstractions/Services/INavigationService.dart';
import 'package:ghana_to_germany/Application/Providers/posts.provider.dart';
import 'package:ghana_to_germany/Application/Providers/shared/form_status.dart';
import 'package:ghana_to_germany/Application/Providers/tags.provider.dart';
import 'package:ghana_to_germany/Presentation/common/chip.dart';
import 'package:ghana_to_germany/Presentation/config/router.dart';
import 'package:ghana_to_germany/Presentation/config/service_locator.dart'
    as sl;
import 'package:ghana_to_germany/Presentation/theme/colors.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatelessWidget {
  const AddPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(55),
        child: Container(
          decoration: const BoxDecoration(
              border: Border.symmetric(horizontal: BorderSide(width: .1))),
          child: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => sl.getIt<INavigationService>().pop(),
                    child: Text("Cancel",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: GGSwatch.textPrimary)),
                  ),
                  Consumer2<PostsViewModel, TagsViewModel>(
                      builder: (context, state, tagState, _) {
                    if (state.addPostStatus == FormStatus.SUCCESSFUL) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        sl
                            .getIt<INavigationService>()
                            .replace(AppRoutes.landing);
                        state.resetState();
                      });
                    }

                    return GestureDetector(
                      onTap: tagState.selectedTag!.isNotEmpty
                          ? () => state.addPost(tagState.selectedTag!)
                          : () {},
                      child: Text("Add Post",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent)),
                    );
                  }),
                ],
              )),
        ),
      ),
      body: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0, left: 16, right: 16),
                child: Text("Tags",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.grey)),
              ),
              const SizedBox(height: 5),
              Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Consumer<TagsViewModel>(builder: (context, state, _) {
                    return Wrap(
                      spacing: 8,
                      children: state.tags
                          .map((tag) => TagChip(value: tag.name))
                          .toList(),
                    );
                  })),
              const SizedBox(height: 10),
              const Divider(
                thickness: .1,
              )
            ],
          ),
          Expanded(
            child: Consumer<PostsViewModel>(builder: (context, state, _) {
              return TextField(
                controller: state.contentController,
                cursorColor: GGSwatch.textSecondary,
                maxLines: null, // Allows the TextField to expand vertically
                expands: true, // Expands to take up all available space
                keyboardType: TextInputType.multiline,
                textAlignVertical: TextAlignVertical.top,
                textCapitalization: TextCapitalization.sentences,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontSize: 18),
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  hintText: 'What is on your mind? Share Post',
                  hintStyle: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontSize: 18, color: Colors.grey),
                  border: InputBorder
                      .none, // Optional: Add a border around the TextField
                ),
              );
            }),
          ),
          SafeArea(
            bottom: true,
            top: false,
            left: false,
            right: false,
            child: Container(
              height: 56,
              decoration: const BoxDecoration(
                  border: Border(top: BorderSide(width: .1))),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          CupertinoIcons.photo_camera,
                          color: Colors.grey,
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          CupertinoIcons.photo,
                          color: Colors.grey,
                        )),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
