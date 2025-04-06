import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ghana_to_germany/Application/Abstractions/Services/INavigationService.dart';
import 'package:ghana_to_germany/Application/Providers/logout.provider.dart';
import 'package:ghana_to_germany/Application/Providers/profile.provider.dart';
import 'package:ghana_to_germany/Application/Providers/shared/form_status.dart';
import 'package:ghana_to_germany/Presentation/common/complete_profile.dart';
import 'package:ghana_to_germany/Presentation/config/router.dart';
import 'package:ghana_to_germany/Presentation/theme/colors.dart';
import 'package:ghana_to_germany/Presentation/config/service_locator.dart'
    as sl;
import 'package:ghana_to_germany/generated/assets.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback goBack;

  const ProfileScreen({super.key, required this.goBack});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if(mounted) {
        context.read<ProfileViewModel>().getProfileCompletionStatus();
      }
    });
  }

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
                      onTap: widget.goBack,
                      child: const Icon(CupertinoIcons.back),
                    ),
                    Text("Profile",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: GGSwatch.textPrimary)),
                    const Icon(Icons.sign_language, color: Colors.transparent)
                  ],
                )),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Consumer<ProfileViewModel>(builder: (context, state, _) {
            return Column(
              children: [
                state.profile == null
                    ? CompleteProfileCTA()
                    : _ProfileBody(),
                Divider(
                  height: MediaQuery.of(context).size.height * .06,
                  thickness: 0.3,
                ),
                const _ProfileLinks()
              ],
            );
          }),
        ));
  }
}

class _ProfileBody extends StatelessWidget {
  const _ProfileBody();

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(builder: (context, state, _) {
      return ListTile(
        onTap: () {},
        title: Text(state.profile?.fullName != null ? state.profile!.fullName : "...",
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.bold, color: GGSwatch.textPrimary)),
        leading: SvgPicture.asset(Assets.svgProfileImg),
        subtitle: Text(
          state.profile?.email != null ? state.profile!.email : "...",
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 14),
        ),
      );
    });
  }
}

class _ProfileLinks extends StatelessWidget {
  const _ProfileLinks();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          onTap: () {},
          title: const Text("Likes"),
          subtitle: const Text("View your liked Posts, Wikis & News"),
          trailing: const Icon(Icons.chevron_right),
        ),
        ListTile(
          onTap: () {},
          title: const Text("Bookmarks"),
          subtitle: const Text("View your bookmarked Posts, Wikis & News"),
          trailing: const Icon(Icons.chevron_right),
        ),
        ListTile(
          onTap: () {},
          title: const Text("Change Password"),
          subtitle: const Text("Update your password"),
          trailing: const Icon(Icons.chevron_right),
        ),
        ListTile(
          onTap: () {},
          title: const Text("Delete Account"),
          subtitle: const Text("This action is irreversible"),
          trailing: const Icon(Icons.chevron_right),
        ),
        Consumer<LogoutViewModel>(builder: (context, state, _) {
          if (state.status == FormStatus.SUCCESSFUL) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              state.resetState();
              sl.getIt<INavigationService>().go(AppRoutes.login);
            });
          }

          return ListTile(onTap: state.logout, title: const Text("Logout"));
        })
      ],
    );
  }
}
