import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ghana_to_germany/Application/Providers/shared/errorNotifier.mixin.dart';
import 'package:ghana_to_germany/Presentation/theme/colors.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as developer;

class PageErrorListener<T extends ErrorNotifierMixin> extends StatelessWidget {
  final Widget child;
  final VoidCallback? onWillPop;

  const PageErrorListener({super.key, required this.child, this.onWillPop});

  @override
  Widget build(BuildContext context) {
    return Consumer<T>(
      builder: (context, model, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (model.error != null) {
            _handleError(context, model, onWillPop);
          }
        });

        return child!;
      },
      child: child,
    );
  }

  void _handleError(BuildContext context, T model, VoidCallback? onWillPop) {
    // some ui to update error
    developer.log(model.error!);
    HapticFeedback.heavyImpact();

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.amber),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              model.error!,
              style: Theme.of(context)
                .textTheme
                .bodyLarge?.copyWith(color: Colors.white)
            ),
          ),
        ],
      ),
      backgroundColor: GGSwatch.textSecondary,
      duration: const Duration(seconds: 5),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height - 100,
        right: 20,
        left: 20,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ));

    model.clearError();
    onWillPop?.call();
  }
}
