import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ghana_to_germany/Application/Abstractions/Services/INavigationService.dart';
import 'package:ghana_to_germany/Presentation/config/router.dart';
import 'package:ghana_to_germany/Presentation/theme/colors.dart';
import 'package:ghana_to_germany/Presentation/config/service_locator.dart'
    as sl;

import 'package:ghana_to_germany/generated/assets.dart';

class CompleteProfileCTA extends StatelessWidget {
  const CompleteProfileCTA({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: () =>
            sl.getIt<INavigationService>().push(AppRoutes.completeProfile),
        trailing: Icon(Icons.chevron_right_rounded),
        title: Text("Complete Profile",
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.bold, color: GGSwatch.textPrimary)),
        leading: SvgPicture.asset(Assets.svgProfileImg),
        subtitle: Text("Finish setting up your profile",
            style:
                Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 14)));
  }
}
