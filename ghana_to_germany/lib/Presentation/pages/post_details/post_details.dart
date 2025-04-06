import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ghana_to_germany/Application/Providers/posts.provider.dart';
import 'package:ghana_to_germany/Application/Providers/shared/form_status.dart';
import 'package:ghana_to_germany/Application/Providers/translate.provider.dart';
import 'package:ghana_to_germany/Domain/Comment/comment.dart';
import 'package:ghana_to_germany/Domain/Post/post.dart';
import 'package:ghana_to_germany/Infrastructure/Services/Utilities.dart';
import 'package:ghana_to_germany/Presentation/common/card.dart';
import 'package:ghana_to_germany/Presentation/theme/colors.dart';
import 'package:go_router/go_router.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostDetailsScreen extends StatefulWidget {
  final Post post;

  const PostDetailsScreen({super.key, required this.post});

  @override
  State<PostDetailsScreen> createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  @override
  didChangeDependencies() {
    super.didChangeDependencies();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<PostsViewModel>().getComments(widget.post.id);
    });
  }

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
              automaticallyImplyLeading: false,
              elevation: 0,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: context.pop,
                    child: const Icon(CupertinoIcons.back),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: context.pop,
                    child: Text("Posts",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: GGSwatch.textPrimary)),
                  ),
                ],
              )),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(children: [
          _MainDetailView(post: widget.post),
          Container(
            alignment: Alignment.centerLeft,
            width: double.infinity,
            padding: EdgeInsets.only(left: 5),
            height: 40,
            decoration: BoxDecoration(
                color: GGSwatch.disabled.withOpacity(.1),
                border: Border.symmetric(
                    horizontal:
                        BorderSide(color: GGSwatch.disabled, width: .5))),
            child: Text("Comments",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold, color: GGSwatch.textPrimary)),
          ),
          Expanded(child: _CommentsView()),
          _AddComment(post: widget.post)
        ]),
      ),
    );
  }
}

class _MainDetailView extends StatelessWidget {
  final Post post;

  const _MainDetailView({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Consumer<PostsViewModel>(
                              builder: (context, state, _) {
                            return CardIcon(
                                onPressed: () => state.likePost(post.id),
                                icon: post.isLiked
                                    ? FontAwesomeIcons.solidHeart
                                    : FontAwesomeIcons.heart,
                                color: GGSwatch.textSecondary.withOpacity(.5),
                                value: post.likeCount.toString());
                          }),
                          CardIcon(
                              onPressed: () {},
                              icon: FontAwesomeIcons.comment,
                              color: GGSwatch.textSecondary.withOpacity(.5),
                              value: post.commentCount.toString()),
                          CardIcon(
                              onPressed: () {},
                              icon: FontAwesomeIcons.bookmark,
                              color: GGSwatch.textSecondary.withOpacity(.5),
                              value: post.bookmarkCount.toString()),
                          CardIcon(
                              color: GGSwatch.textSecondary.withOpacity(.5),
                              onPressed: () {
                                // check if user profile is completed
                                context
                                    .read<TranslateViewModel>()
                                    .translate(post.id);

                                showPopover(
                                    context: context,
                                    bodyBuilder: (context) => context
                                                .watch<TranslateViewModel>()
                                                .status ==
                                            FormStatus.SUCCESSFUL
                                        ? TranslateView(post: post)
                                        : context
                                                    .watch<TranslateViewModel>()
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
                                                            FontWeight.bold,
                                                        fontStyle:
                                                            FontStyle.italic),
                                              )
                                            : const SizedBox(
                                                height: 100,
                                                width: double.infinity,
                                                child: Center(
                                                    child:
                                                        CircularProgressIndicator()),
                                              ),
                                    width:
                                        MediaQuery.of(context).size.width * .93,
                                    arrowDxOffset: 145,
                                    direction: PopoverDirection.top);
                              },
                              icon: FontAwesomeIcons.language,
                              value: "")
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _CommentsView extends StatelessWidget {
  const _CommentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PostsViewModel>(builder: (context, state, _) {
      if (state.status == FormStatus.LOADING) {
        return Center(
          child: SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(color: AppColors.secondary)),
        );
      }

      return SizedBox(
        width: double.infinity,
        child: state.comments.isEmpty
            ? Center(
                child: Icon(CupertinoIcons.bubble_left_bubble_right,
                    size: 50, color: GGSwatch.disabled.withOpacity(.5)),
              )
            : Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 15),
                child: ListView.builder(
                  itemCount:
                      state.comments.length, // Adjust item count for separators
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        _CommentCard(comment: state.comments[index]),
                        index.isOdd
                            ? const SizedBox.shrink()
                            : const Divider(thickness: .2)
                      ],
                    );
                  },
                )),
      );
    });
  }
}

class _AddComment extends StatelessWidget {
  final Post post;
  const _AddComment({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Consumer<PostsViewModel>(builder: (context, state, _) {
      return SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: state.commentController,
                cursorColor: GGSwatch.textSecondary,
                maxLines: 1, // Allows the TextField to expand vertically
                expands: false, // Expands to take up all available space
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
                  border: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: GGSwatch.disabled, width: .8),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: GGSwatch.disabled, width: .8),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: GGSwatch.textSecondary, width: 1.5),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  hintText: 'Add Comment',
                  hintStyle: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontSize: 18, color: Colors.grey),
                ),
              ),
            ),
            SizedBox(width: 8),
            SizedBox(
                height: 50,
                width: 50,
                child: TextButton(
                    onPressed: () => state.addComment(post.id),
                    style: TextButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                    child: state.addCommentStatus == FormStatus.LOADING
                        ? SizedBox(
                            height: 15,
                            width: 15,
                            child: CircularProgressIndicator(
                                color: Colors.white),
                          )
                        : Icon(
                            CupertinoIcons.paperplane_fill,
                            color: Colors.white,
                          ))),
          ],
        ),
      );
    });
  }
}

class _CommentCard extends StatelessWidget {
  final Comment comment;

  const _CommentCard({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: GGSwatch.disabled),
                child: Center(
                  child: Text(
                    Utilities.getFirstLetter(comment.owner),
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
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
                            Text(
                              "@${comment.owner.split("@").first}",
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
                            timeago.format(DateTime.parse(comment.dateCreated),
                                locale: 'en_short'),
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    color:
                                        GGSwatch.textSecondary.withOpacity(.5),
                                    fontSize: 14.5))
                      ],
                    ),
                    Text(comment.content,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontSize: 14.5)),
                    const SizedBox(height: 10)
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
