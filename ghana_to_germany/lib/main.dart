import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghana_to_germany/Presentation/config/app_provider.dart';
import 'package:ghana_to_germany/Presentation/config/service_locator.dart' as sl;
import 'package:ghana_to_germany/Presentation/theme/theme.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  final sharedPreferences = await SharedPreferences.getInstance();

  sl.initServiceLocator(sharedPreferences);
  await sl.getIt.allReady();

  runApp(const AppProvider(child: App()));
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, Widget? child) {
        return MaterialApp.router(
          title: 'Ghana to Germany',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.theme(context),
          routerConfig: sl.getIt<GoRouter>(),
        );
      },
    );
  }
}