import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ghana_to_germany/Application/Providers/profile.provider.dart';
import 'package:ghana_to_germany/Application/Providers/shared/form_status.dart';
import 'package:ghana_to_germany/Presentation/common/button.dart';
import 'package:ghana_to_germany/Presentation/common/input.dart';
import 'package:ghana_to_germany/Presentation/common/page_constraint.dart';
import 'package:ghana_to_germany/Presentation/common/validators.dart';
import 'package:ghana_to_germany/Presentation/config/router.dart';
import 'package:ghana_to_germany/Presentation/theme/colors.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ProfileSetupScreen extends StatelessWidget {
  const ProfileSetupScreen({super.key, required this.goBack});

  final VoidCallback goBack;

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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: goBack,
                      child: const Icon(CupertinoIcons.back),
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: goBack,
                      child: Text("Profile",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: GGSwatch.textPrimary)),
                    ),
                  ],
                )),
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: PageConstraint(
              child: ListView(
                children: [
                  Text("Complete Profile Setup",
                      style: Theme.of(context).textTheme.displayLarge),
                  SizedBox(height: 5),
                  Text(
                      "Provide the details below. This will help us tailor the platform to better serve you",
                      style: Theme.of(context).textTheme.bodyLarge),
                  SizedBox(height: MediaQuery.of(context).size.height * .03),
                  const _CompleteProfileForm(),
                ],
              ),
            )));
  }
}

class _CompleteProfileForm extends StatefulWidget {
  const _CompleteProfileForm({super.key});

  @override
  State<_CompleteProfileForm> createState() => _CompleteProfileFormState();
}

class _CompleteProfileFormState extends State<_CompleteProfileForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(builder: (context, state, _) {

      if (state.status == FormStatus.SUCCESSFUL || state.isProfilePending == false) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.go(AppRoutes.landing);
        });
      }

      return Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(height: 18),
            FloatingLabelInput(
              label: "First Name",
              hintText: "Enter your first name",
              controller: state.firstNameController,
            ),
            SizedBox(height: 18),
            FloatingLabelInput(
              label: "Last Name",
              hintText: "Enter your last name",
              controller: state.lastNameController,
            ),
            SizedBox(height: 18),
            FloatingLabelSelectInput(
              label: "Country",
              hintText: "Enter your country",
              controller: state.countryController,
              items: [
                "Ghana", "Germany"
              ],
            ),
            SizedBox(height: 18),
            FloatingLabelInput(
              label: "Phone Number",
              hintText: "Enter your phone number",
              controller: state.phoneNumberController,
              inputType: TextInputType.phone,
              inputAction: TextInputAction.done,
              validator: Validator.validateRequired
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .03),
            Button(
                text: "Complete Profile",
                color: AppColors.secondary,
                isLoading: state.status == FormStatus.LOADING,
                onPressed: () {
                  if (state.status == FormStatus.LOADING) {
                    return;
                  }

                  if (_formKey.currentState?.validate() ?? false) {
                    state.completeProfileSetup();
                  }
                })
          ],
        ),
      );
    });
  }
}
