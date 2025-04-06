import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ghana_to_germany/Presentation/theme/colors.dart';

class CommunitiesScreen extends StatelessWidget {
  final VoidCallback goBack;

  const CommunitiesScreen({super.key, required this.goBack});

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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: goBack,
                    child: const Icon(CupertinoIcons.back),
                  ),
                  Text("Communities", style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold, color: GGSwatch.textPrimary)),
                  IconButton(onPressed: (){}, icon: const Icon(CupertinoIcons.add_circled, color: Colors.transparent))
                ],
              )),
        ),
      ),
      body: Center(
        child: Icon(CupertinoIcons.bubble_left_bubble_right, size: 50, color: GGSwatch.disabled.withOpacity(.5)),
      ),
    );
  }
}
