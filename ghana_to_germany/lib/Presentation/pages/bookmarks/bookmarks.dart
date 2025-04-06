import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ghana_to_germany/Presentation/theme/colors.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Bookmarks",
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(fontWeight: FontWeight.bold),
                )
              ],
            ),
          )
        ],
      ),
      Align(
        alignment: Alignment.center,
        child: Icon(CupertinoIcons.bookmark
            , size: 50, color: GGSwatch.disabled.withOpacity(.5)),
      )
    ]);
  }
}
