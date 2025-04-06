import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ghana_to_germany/Presentation/theme/colors.dart';

class Button extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool? isLoading;
  final String text;
  final IconData? icon;
  final Color? color;
  final Color? textColor;
  final Color? borderColor;
  final Color? iconColor;

  const Button({
    super.key,
    required this.text,
    this.icon,
    this.onPressed,
    this.isLoading = false,
    this.color = Colors.transparent,
    this.iconColor = GGSwatch.textSecondary,
    this.borderColor = Colors.transparent,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: isLoading == true
        ? TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          backgroundColor: color ?? GGSwatch.secondarySwatch[500]!,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: borderColor!),
            borderRadius: BorderRadius.circular(8), // Rounded corners
          ),
        ),
        child: const SpinKitThreeInOut(
          color: Colors.white, // Customize the color
          size: 25.0,         // Customize the size
        ),
      )
        : TextButton.icon(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: color ?? GGSwatch.secondarySwatch[500]!,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: borderColor!),
            borderRadius: BorderRadius.circular(8), // Rounded corners
          ),
        ),
        icon: icon != null ? Icon(icon, size: 18, color: iconColor,) : const SizedBox(),
        label: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: textColor ?? Colors.white, fontWeight: FontWeight.bold),
        ),
      )
    );
  }
}
