import 'package:flutter/material.dart';
import 'package:ghana_to_germany/Application/Providers/login.provider.dart';
import 'package:ghana_to_germany/Application/Providers/logout.provider.dart';
import 'package:ghana_to_germany/Application/Providers/news.provider.dart';
import 'package:ghana_to_germany/Application/Providers/posts.provider.dart';
import 'package:ghana_to_germany/Application/Providers/profile.provider.dart';
import 'package:ghana_to_germany/Application/Providers/register.provider.dart';
import 'package:ghana_to_germany/Application/Providers/search.provider.dart';
import 'package:ghana_to_germany/Application/Providers/tags.provider.dart';
import 'package:ghana_to_germany/Application/Providers/translate.provider.dart';
import 'package:ghana_to_germany/Application/Providers/wikis.provider.dart';
import 'package:provider/provider.dart';
import 'package:ghana_to_germany/Presentation/config/service_locator.dart'
    as sl;

class AppProvider extends StatelessWidget {
  final Widget child;

  const AppProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (BuildContext context) {
          return LoginViewModel(
              loginUseCase: sl.getIt(),
              googleAuth: sl.getIt(),
              socialRegisterUseCase: sl.getIt());
        }),
        ChangeNotifierProvider(create: (BuildContext context) {
          return LogoutViewModel(logoutUseCase: sl.getIt(), googleAuth: sl.getIt());
        }),
        ChangeNotifierProvider(create: (BuildContext context) {
          return RegisterViewModel(registerUseCase: sl.getIt());
        }),
        ChangeNotifierProvider(create: (BuildContext context) {
          return PostsViewModel(
              authProvider: sl.getIt(),
              getPostsUseCase: sl.getIt(),
              addPostUseCase: sl.getIt(),
              likePostUseCase: sl.getIt(),
              addCommentUseCase: sl.getIt(),
              getCommentsUseCase: sl.getIt());
        }),
        ChangeNotifierProvider(create: (BuildContext context) {
          return TagsViewModel(getTagsUseCase: sl.getIt());
        }),
        ChangeNotifierProvider(create: (BuildContext context) {
          return WikisViewModel(
              getWikisUseCase: sl.getIt(), addWikiUseCase: sl.getIt());
        }),
        ChangeNotifierProvider(create: (BuildContext context) {
          return NewsViewModel(getNewsUseCase: sl.getIt());
        }),
        ChangeNotifierProvider(create: (BuildContext context) {
          return TranslateViewModel(translateTextUseCase: sl.getIt());
        }),
        ChangeNotifierProvider(create: (BuildContext context) {
          return ProfileViewModel(
              authProvider: sl.getIt(),
              completeProfileUseCase: sl.getIt(),
              getProfileUseCase: sl.getIt());
        }),
        ChangeNotifierProvider(create: (BuildContext context) {
          return SearchViewModel(searchUseCase: sl.getIt());
        })
      ],
      child: child,
    );
  }
}
