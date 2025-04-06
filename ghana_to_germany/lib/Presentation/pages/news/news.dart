import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ghana_to_germany/Application/Providers/news.provider.dart';
import 'package:ghana_to_germany/Application/Providers/shared/form_status.dart';
import 'package:ghana_to_germany/Presentation/common/card.dart';
import 'package:ghana_to_germany/Presentation/theme/colors.dart';
import 'package:provider/provider.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NewsViewModel>(builder: (context, state, _) {
      if (state.status == FormStatus.LOADING) {
        return const Center(child: CircularProgressIndicator());
      }

      if (state.news.isEmpty) {
        return Center(
          child: Icon(CupertinoIcons.folder_open,
              color: GGSwatch.disabled.withOpacity(.2), size: 80),
        );
      }

      return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView.builder(
            itemCount: state.news.length, // Adjust item count for separators
            itemBuilder: (context, index) {
              return Column(
                children: [
                  GGCard(post: state.news[index]),
                  index.isOdd ? const SizedBox.shrink() : const Divider(thickness: .2)
                ],
              );
            },
          ));
    });
  }
}
