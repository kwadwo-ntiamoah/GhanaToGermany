import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ghana_to_germany/Application/Providers/posts.provider.dart';
import 'package:ghana_to_germany/Application/Providers/shared/form_status.dart';
import 'package:ghana_to_germany/Application/Providers/translate.provider.dart';
import 'package:ghana_to_germany/Domain/Post/post.dart';
import 'package:ghana_to_germany/Infrastructure/Services/Utilities.dart';
import 'package:ghana_to_germany/Presentation/config/router.dart';
import 'package:ghana_to_germany/Presentation/theme/colors.dart';
import 'package:go_router/go_router.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class GGCard extends StatelessWidget {
  final Post post;
  final bool showActions;

  const GGCard({super.key, this.showActions = true, required this.post});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.postDetails, extra: post),
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: AppColors.primary),
                    child: Center(
                      child: Text(
                        Utilities.getFirstLetter(post.owner),
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(
                                color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(post.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(fontWeight: FontWeight.bold)),
                                const SizedBox(width: 5),
                                Text(
                                  "@${post.owner.split("@").first}",
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: GGSwatch.textSecondary
                                              .withOpacity(.5),
                                          fontSize: 14),
                                ),
                              ],
                            ),
                            Text(
                                timeago.format(DateTime.parse(post.dateCreated),
                                    locale: 'en_short'),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                        color: GGSwatch.textSecondary
                                            .withOpacity(.5),
                                        fontSize: 14.5))
                          ],
                        ),
                        Text(post.content,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontSize: 14.5)),
                        const SizedBox(height: 10),
                        post.thumbnail != null
                            ? Container(
                                width: double.infinity,
                                height: 160,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: AppColors.secondary),
                              )
                            : const SizedBox.shrink(),
                        SizedBox(height: post.thumbnail != null ? 10 : 0),
                        showActions
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Consumer<PostsViewModel>(
                                      builder: (context, state, _) {
                                    return CardIcon(
                                        onPressed: () => state.likePost(post.id),
                                        icon: post.isLiked
                                            ? FontAwesomeIcons.solidHeart
                                            : FontAwesomeIcons.heart,
                                        color: GGSwatch.textSecondary
                                            .withOpacity(.5),
                                        value: post.likeCount.toString());
                                  }),
                                  CardIcon(
                                      onPressed: () => context.push(AppRoutes.postDetails, extra: post),
                                      icon: FontAwesomeIcons.comment,
                                      color:
                                          GGSwatch.textSecondary.withOpacity(.5),
                                      value: post.commentCount.toString()),
                                  CardIcon(
                                      onPressed: () {},
                                      icon: FontAwesomeIcons.bookmark,
                                      color:
                                          GGSwatch.textSecondary.withOpacity(.5),
                                      value: post.bookmarkCount.toString()),
                                  CardIcon(
                                      color:
                                          GGSwatch.textSecondary.withOpacity(.5),
                                      onPressed: () {
                                        // check if user profile is completed
                                        context
                                            .read<TranslateViewModel>()
                                            .translate(post.id);

                                        showPopover(
                                            context: context,
                                            bodyBuilder: (context) => context
                                                        .watch<
                                                            TranslateViewModel>()
                                                        .status ==
                                                    FormStatus.SUCCESSFUL
                                                ? TranslateView(post: post)
                                                : context
                                                            .watch<
                                                                TranslateViewModel>()
                                                            .status ==
                                                        FormStatus.FAILED
                                                    ? Text(
                                                        "Error getting translation",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyLarge!
                                                            .copyWith(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic),
                                                      )
                                                    : const SizedBox(
                                                        height: 100,
                                                        width: double.infinity,
                                                        child: Center(
                                                            child:
                                                                CircularProgressIndicator()),
                                                      ),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .93,
                                            arrowDxOffset: 145,
                                            direction: PopoverDirection.top);
                                      },
                                      icon: FontAwesomeIcons.language,
                                      value: "")
                                ],
                              )
                            : SizedBox.shrink()
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CardIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value;
  final VoidCallback onPressed;

  const CardIcon(
      {super.key,
      required this.icon,
      required this.value,
      required this.onPressed,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        splashFactory: NoSplash.splashFactory,
        enableFeedback: true,
      ),
      onPressed: onPressed,
      icon: FaIcon(
        icon,
        color: color,
        size: 15,
      ),
      label: Text(value,
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: GGSwatch.textSecondary.withOpacity(.8))),
    );
  }
}

class TranslateView extends StatelessWidget {
  final Post post;

  const TranslateView({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: IntrinsicHeight(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Translation",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic)),
            const SizedBox(height: 5),
            Text(context.watch<TranslateViewModel>().translatedText!,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontSize: 14.5, fontStyle: FontStyle.italic)),
          ],
        ),
      ),
    );
  }
}
