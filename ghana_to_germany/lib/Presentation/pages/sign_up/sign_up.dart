import 'package:flutter/material.dart';
import 'package:ghana_to_germany/Application/Abstractions/Services/INavigationService.dart';
import 'package:ghana_to_germany/Presentation/common/validators.dart';
import 'package:ghana_to_germany/Presentation/config/service_locator.dart'
    as sl;
import 'package:go_router/go_router.dart';
import 'package:ghana_to_germany/Application/Providers/register.provider.dart';
import 'package:ghana_to_germany/Application/Providers/shared/form_status.dart';
import 'package:ghana_to_germany/Presentation/common/button.dart';
import 'package:ghana_to_germany/Presentation/common/input.dart';
import 'package:ghana_to_germany/Presentation/common/page_constraint.dart';
import 'package:ghana_to_germany/Presentation/common/page_error_listener.dart';
import 'package:ghana_to_germany/Presentation/config/router.dart';
import 'package:ghana_to_germany/Presentation/theme/colors.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as developer;

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

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
              elevation: 0,
              title: Text("Register",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: GGSwatch.textPrimary)),
            ),
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: PageConstraint(
              child: ListView(
                children: [
                  Text("Create an Account",
                      style: Theme.of(context).textTheme.displayLarge),
                  Text("Provide details to join the community",
                      style: Theme.of(context).textTheme.bodyLarge),
                  SizedBox(height: MediaQuery.of(context).size.height * .05),
                  _SignUpForm(),
                  SizedBox(height: MediaQuery.of(context).size.height * .1),
                  GestureDetector(
                    onTap: () => context.go(AppRoutes.login),
                    child: Text(
                      "Already have an account? Login",
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: GGSwatch.textPrimary),
                    ),
                  )
                ],
              ),
            )));
  }
}

class _SignUpForm extends StatefulWidget {
  const _SignUpForm();

  @override
  State<_SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<_SignUpForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<RegisterViewModel>(builder: (context, state, _) {
      if (state.status == FormStatus.SUCCESSFUL) {
        context.go(AppRoutes.landing);
      }

      return PageErrorListener<RegisterViewModel>(
          onWillPop: state.resetState,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                FloatingLabelInput(
                  label: "Email",
                  hintText: "Enter Email",
                  controller: state.emailController,
                  validator: Validator.combineValidators(
                      [Validator.validateEmail, Validator.validateRequired]),
                ),
                const SizedBox(height: 18),
                FloatingLabelInput(
                  label: "Password",
                  hintText: "Create Password",
                  inputAction: TextInputAction.done,
                  controller: state.passwordController,
                  obscureText: state.obscureText,
                  suffixIcon: IconButton(
                      onPressed: state.togglePassword,
                      icon: state.obscureText
                          ? Icon(Icons.visibility_off)
                          : Icon(Icons.visibility)),
                  validator: Validator.combineValidators(
                      [Validator.validateRequired, Validator.validatePassword]),
                ),
                const SizedBox(height: 18),
                Button(
                  text: "Join Community",
                  color: AppColors.secondary,
                  isLoading: state.status == FormStatus.LOADING,
                  onPressed: () => _formKey.currentState!.validate()
                      ? state.register()
                      : () {},
                )
              ],
            ),
          ));
    });
  }
}
