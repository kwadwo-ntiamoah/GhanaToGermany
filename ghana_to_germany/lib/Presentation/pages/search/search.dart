import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ghana_to_germany/Application/Providers/search.provider.dart';
import 'package:ghana_to_germany/Presentation/common/card.dart';
import 'package:ghana_to_germany/Presentation/common/input.dart';
import 'package:provider/provider.dart';

import '../../theme/colors.dart';

class SearchScreen extends StatelessWidget {
  final VoidCallback goBack;

  const SearchScreen({super.key, required this.goBack});

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchViewModel>(builder: (context, state, _) {
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
                    children: [
                      GestureDetector(
                        onTap: goBack,
                        child: const Icon(CupertinoIcons.back),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: SearchInput(
                          onChanged: (query) => state.search(query),
                        ),
                      )
                    ],
                  )),
            ),
          ),
          body: Padding(
              padding: const EdgeInsets.all(16),
              child: state.results.isEmpty
                  ? Center(
                      child: Icon(CupertinoIcons.doc_text_search,
                          size: 50, color: GGSwatch.disabled.withOpacity(.5)))
                  : ListView.builder(
                      itemCount: state.results.length, // Adjust item count for separators
                      itemBuilder: (context, index) {
                        return GGCard(post: state.results[index], showActions: false,);
                      },
                    )));
    });
  }
}
