import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ghana_to_germany/Application/Providers/login.provider.dart';
import 'package:ghana_to_germany/Application/Providers/shared/form_status.dart';
import 'package:ghana_to_germany/Presentation/assets/assets.dart';
import 'package:ghana_to_germany/Presentation/common/button.dart';
import 'package:ghana_to_germany/Presentation/common/page_error_listener.dart';
import 'package:ghana_to_germany/Presentation/common/input.dart';
import 'package:ghana_to_germany/Presentation/common/page_constraint.dart';
import 'package:ghana_to_germany/Presentation/common/validators.dart';
import 'package:ghana_to_germany/Presentation/config/router.dart';
import 'package:ghana_to_germany/Presentation/theme/colors.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../config/service_locator.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: PageConstraint(
            child: SafeArea(
              child: Consumer<LoginViewModel>(builder: (context, state, _) {
                return PageErrorListener<LoginViewModel>(
                  onWillPop: state.resetState,
                  child: ListView(
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * .02),
                      const Logo(),
                      SizedBox(height: MediaQuery.of(context).size.height * .1),
                      LoginForm(),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * .02),
                      const AuthDivider(),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * .02),
                      const ExternalAuthButtons(),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * .15),
                      GestureDetector(
                        onTap: () => context.go(AppRoutes.signUp),
                        child: Text("You don't have an account? Sign Up",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge),
                      ),
                    ],
                  ),
                );
              }),
            ),
          )),
    );
  }
}

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(Assets.imagesLogo, height: 40, width: 40),
        Text("Ghana Germany",
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginViewModel>(builder: (context, state, _) {
      if (state.status == FormStatus.SUCCESSFUL ||
          state.googleStatus == FormStatus.SUCCESSFUL) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.go(AppRoutes.landing);

          // delay resetting state for a second
          // this prevents navigation from cancelling
          Future.delayed(const Duration(seconds: 1), () {
            state.resetState();
          });
        });
      }

      return Column(
        children: [
          Text("Sign In", style: Theme.of(context).textTheme.displayLarge),
          Text("Login to continue",
              style: Theme.of(context).textTheme.bodyLarge),
          SizedBox(height: MediaQuery.of(context).size.height * .025),
          Form(
            key: _formKey,
            child: Column(
              children: [
                FloatingLabelInput(
                  label: "Email",
                  hintText: "Enter Email",
                  controller: state.usernameController,
                  validator: Validator.combineValidators(
                      [Validator.validateRequired, Validator.validateEmail]),
                ),
                const SizedBox(height: 18),
                FloatingLabelInput(
                  label: "Password",
                  hintText: "Enter Password",
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
                GestureDetector(
                  child: Text(
                    "Forgot Password",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: GGSwatch.textPrimary),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * .03),
                Button(
                  text: "Sign In",
                  color: AppColors.secondary,
                  isLoading: state.status == FormStatus.LOADING,
                  onPressed: () =>
                      _formKey.currentState!.validate() ? state.login() : () {},
                ),
              ],
            ),
          )
        ],
      );
    });
  }
}

class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: Divider(
            color: GGSwatch.disabled,
            thickness: 1,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'OR',
            style: TextStyle(color: GGSwatch.disabled),
          ),
        ),
        Expanded(
          child: Divider(
            color: GGSwatch.disabled,
            thickness: 1,
          ),
        ),
      ],
    );
  }
}

class ExternalAuthButtons extends StatelessWidget {
  const ExternalAuthButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginViewModel>(builder: (context, state, _) {
      return Column(
        children: [
          Button(
              text: "Sign In with Google",
              borderColor: GGSwatch.textSecondary,
              color: GGSwatch.textSecondary,
              textColor: Colors.white,
              icon: FontAwesomeIcons.google,
              iconColor: Colors.white,
              isLoading: state.googleStatus == FormStatus.LOADING,
              onPressed: state.loginWithGoogle)
        ],
      );
    });
  }
}
