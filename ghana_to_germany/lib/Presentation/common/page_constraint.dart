import 'package:flutter/material.dart';

class PageConstraint extends StatelessWidget {
  final Widget child;
  const PageConstraint({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 550),
        child: child,
      ),
    );
  }
}
