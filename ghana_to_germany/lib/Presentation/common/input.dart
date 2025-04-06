import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ghana_to_germany/Presentation/theme/colors.dart';

abstract class Input extends StatelessWidget {
  const Input({super.key});
}

class SearchInput extends Input {
  final Function(String)? onChanged;

  const SearchInput({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: double.infinity,
      child: TextFormField(
        onChanged: onChanged,
        cursorColor: GGSwatch.textSecondary,
        decoration: InputDecoration(
            prefixIcon: const Icon(CupertinoIcons.search, size: 18),
            filled: true,
            fillColor: GGSwatch.disabled.withOpacity(.1),
            hintText: "Search",
            hintStyle: Theme.of(context).textTheme.bodyLarge,
            contentPadding:
                const EdgeInsets.symmetric(vertical: .0, horizontal: 16),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: GGSwatch.disabled, width: .8),
              borderRadius: BorderRadius.circular(100.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: GGSwatch.disabled, width: .8),
              borderRadius: BorderRadius.circular(100.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: GGSwatch.disabled, width: .8),
              borderRadius: BorderRadius.circular(100.0),
            )),
      ),
    );
  }
}

// create a floating label select field similar to FloatingLabelInput below
class FloatingLabelSelectInput extends Input {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final List<String> items;

  const FloatingLabelSelectInput(
      {super.key,
      required this.label,
      required this.hintText,
      required this.controller,
      required this.items,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      decoration: InputDecoration(
          isDense: true,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: label,
          labelStyle: Theme.of(context).textTheme.bodySmall,
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.bodyLarge,
          errorStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.red),
          contentPadding:
          const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: GGSwatch.disabled, width: .8),
            borderRadius: BorderRadius.circular(8.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: GGSwatch.disabled, width: .8),
            borderRadius: BorderRadius.circular(8.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: .8),
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
            const BorderSide(color: GGSwatch.textSecondary, width: 1),
            borderRadius: BorderRadius.circular(8.0),
          )),
      items: items
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(item, style: Theme.of(context).textTheme.bodyLarge,),
              ))
          .toList(),
      onChanged: (value) {
        controller.text = value ?? '';
      },
      validator: validator,
    );
  }
}

class FloatingLabelInput extends Input {
  final String label;
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final TextInputType? inputType;
  final TextInputAction? inputAction;
  final Widget? suffixIcon;

  const FloatingLabelInput(
      {super.key,
      required this.label,
      required this.hintText,
      required this.controller,
      this.obscureText = false,
      this.inputType = TextInputType.text,
      this.inputAction = TextInputAction.next,
      this.validator,
      this.suffixIcon});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(letterSpacing: obscureText ? -2 : 0),
      controller: controller,
      obscureText: obscureText,
      cursorColor: GGSwatch.textSecondary,
      enableInteractiveSelection: true,
      keyboardType: inputType,
      textInputAction: inputAction,
      decoration: InputDecoration(
          suffixIcon: suffixIcon,
          isDense: true,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: label,
          labelStyle: Theme.of(context).textTheme.bodySmall,
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.bodyLarge,
          errorStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.red),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: GGSwatch.disabled, width: .8),
            borderRadius: BorderRadius.circular(8.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: GGSwatch.disabled, width: .8),
            borderRadius: BorderRadius.circular(8.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: .8),
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: GGSwatch.textSecondary, width: 1),
            borderRadius: BorderRadius.circular(8.0),
          )),
      validator: validator,
    );
  }
}
