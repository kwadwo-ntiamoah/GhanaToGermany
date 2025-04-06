import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ghana_to_germany/Application/Providers/tags.provider.dart';
import 'package:ghana_to_germany/Presentation/theme/colors.dart';
import 'package:provider/provider.dart';

class TagChip extends StatelessWidget {
  final String value;

  const TagChip({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Consumer<TagsViewModel>(builder: (BuildContext context, state, _) {
      return GestureDetector(
        onTap: () => state.setTag(value),
        child: Chip(
          label: Text(value),
          onDeleted: () => state.setTag(value),
          deleteIcon: value == state.selectedTag
              ? const Icon(
                  CupertinoIcons.circle_filled,
                  size: 15,
                )
              : const Icon(
                  CupertinoIcons.circle,
                  size: 15,
                ),
          deleteIconColor: value == state.selectedTag
              ? Colors.blueAccent
              : GGSwatch.disabled,
          backgroundColor: Colors.transparent,
          labelStyle: const TextStyle(
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
          ),
          shape: RoundedRectangleBorder(
            side: BorderSide(
                width: .5,
                color: state.selectedTag == value
                    ? Colors.blueAccent
                    : Colors.grey),
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      );
    });
  }
}
