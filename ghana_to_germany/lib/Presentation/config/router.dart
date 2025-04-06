import "dart:io";

import "package:flutter/cupertino.dart";
import "package:ghana_to_germany/Application/Abstractions/Services/IAuthProvider.dart";
import "package:ghana_to_germany/Domain/Post/post.dart";
import "package:ghana_to_germany/Presentation/config/service_locator.dart"
    as sl;
import "package:ghana_to_germany/Presentation/pages/add_post/add_post.dart";
import "package:ghana_to_germany/Presentation/pages/add_wiki/add_wiki.dart";
import "package:ghana_to_germany/Presentation/pages/landing/landing.dart";
import "package:ghana_to_germany/Presentation/pages/login/login.dart";
import "package:ghana_to_germany/Presentation/pages/post_details/post_details.dart";
import "package:ghana_to_germany/Presentation/pages/profile_setup/profile_setup.dart";
import "package:ghana_to_germany/Presentation/pages/sign_up/sign_up.dart";
import "package:ghana_to_germany/Presentation/pages/splash/splash.dart";
import "package:go_router/go_router.dart";

class AppRoutes {
  AppRoutes._();

  static const String index = "/";
  static const String login = "/login";
  static const String signUp = "/signUp";
  static const String landing = "/landing";
  static const String addWiki = "/addWiki";
  static const String addPost = "/addPost";
  static const String postDetails = "/postDetails";
  static const String completeProfile = "/completeProfile";
}

final GoRouter router = GoRouter(routes: <RouteBase>[
  GoRoute(
      path: AppRoutes.index,
      builder: (context, state) {
        return const SplashScreen();
      }),
  GoRoute(
      path: AppRoutes.login,
      builder: (context, state) {
        return const LoginScreen();
      }),
  GoRoute(
      path: AppRoutes.signUp,
      pageBuilder: (context, state) {
        return _buildPlatformPageTransition(const SignUpScreen());
      }),
  GoRoute(
      path: AppRoutes.landing,
      pageBuilder: (context, state) {
        return _buildPlatformPageTransition(const LandingScreen());
      },
      redirect: (BuildContext context, GoRouterState state) async {
        var authState = sl.getIt<IAuthProvider>();
        bool isAuthenticated = authState.getAuthState() ?? false;

        if (!isAuthenticated) {
          return AppRoutes.login;
        }

        return AppRoutes.landing;
      }),
  GoRoute(
      path: AppRoutes.addWiki,
      pageBuilder: (context, state) {
        return _buildPlatformPageTransition(
          const AddWikiScreen(),
        );
      }),
  GoRoute(
      path: AppRoutes.addPost,
      pageBuilder: (context, state) {
        return _buildPlatformPageTransition(
          const AddPostScreen(),
        );
      }),
  GoRoute(path: AppRoutes.postDetails,
  pageBuilder: (context, state) {
    var post = state.extra as Post;

    return _buildPlatformPageTransition(
        PostDetailsScreen(post: post)
    );
  }),
  GoRoute(
      path: AppRoutes.completeProfile,
      pageBuilder: (context, state) {
        return _buildPlatformPageTransition(
            ProfileSetupScreen(goBack: context.pop));
      })
]);

// page transition animation
CustomTransitionPage _buildPlatformPageTransition(Widget page) {
  return CustomTransitionPage(
    child: page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      if (Platform.isIOS) {
        // Cupertino (iOS) style transition: Slide from right to left
        return CupertinoPageTransition(
          linearTransition: false,
          primaryRouteAnimation: animation,
          secondaryRouteAnimation: secondaryAnimation,
          child: child,
        );
      } else {
        // Material (Android) style transition: Fade transition
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      }
    },
  );
}
