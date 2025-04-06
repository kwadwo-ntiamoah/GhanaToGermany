import 'package:flutter/material.dart';
import 'package:ghana_to_germany/Application/Abstractions/Services/INavigationService.dart';
import 'package:ghana_to_germany/Application/Providers/shared/form_status.dart';
import 'package:ghana_to_germany/Application/Providers/tags.provider.dart';
import 'package:ghana_to_germany/Application/Providers/wikis.provider.dart';
import 'package:ghana_to_germany/Presentation/common/chip.dart';
import 'package:ghana_to_germany/Presentation/config/router.dart';
import 'package:ghana_to_germany/Presentation/config/service_locator.dart'
    as sl;
import 'package:ghana_to_germany/Presentation/theme/colors.dart';
import 'package:provider/provider.dart';

class AddWikiScreen extends StatelessWidget {
  const AddWikiScreen({super.key});

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
                  Consumer2<TagsViewModel, WikisViewModel>(builder: (context, tagState, wikiState, _) {
                    if (wikiState.addWikiStatus == FormStatus.SUCCESSFUL) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        sl.getIt<INavigationService>().replace(AppRoutes.landing);
                        wikiState.resetState();
                      });
                    }

                    return GestureDetector(
                      onTap: tagState.selectedTag!.isNotEmpty
                          ? () => wikiState.addWiki(tagState.selectedTag!)
                          : () {},
                      child: Text("Post Question",
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
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
                }),
              ),
              const SizedBox(height: 10),
              const Divider(
                thickness: .1,
              )
            ],
          ),
          Expanded(
            child: SafeArea(
              bottom: true,
              left: false,
              right: false,
              top: false,
              child: TextField(
                cursorColor: GGSwatch.textSecondary,
                controller: context.read<WikisViewModel>().contentController,
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
                  hintText: 'What is on your mind? Ask question',
                  hintStyle: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontSize: 18, color: Colors.grey),
                  border: InputBorder
                      .none, // Optional: Add a border around the TextField
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
