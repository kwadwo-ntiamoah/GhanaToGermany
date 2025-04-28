import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:ghana_to_germany/Application/Abstractions/Repositories/IAuthRepository.dart';
import 'package:ghana_to_germany/Application/Abstractions/Repositories/IPostRepository.dart';
import 'package:ghana_to_germany/Application/Abstractions/Repositories/ITranslateRepository.dart';
import 'package:ghana_to_germany/Application/Providers/news.provider.dart';
import 'package:ghana_to_germany/Application/Providers/posts.provider.dart';
import 'package:ghana_to_germany/Application/Providers/tags.provider.dart';
import 'package:ghana_to_germany/Application/Providers/wikis.provider.dart';
import 'package:ghana_to_germany/Application/UseCases/addComment.usecase.dart';
import 'package:ghana_to_germany/Application/UseCases/addPost.usecase.dart';
import 'package:ghana_to_germany/Application/UseCases/addWiki.usecase.dart';
import 'package:ghana_to_germany/Application/UseCases/completeProfile.usecase.dart';
import 'package:ghana_to_germany/Application/UseCases/getComments.usecase.dart';
import 'package:ghana_to_germany/Application/UseCases/getNews.usecase.dart';
import 'package:ghana_to_germany/Application/UseCases/getPosts.usecase.dart';
import 'package:ghana_to_germany/Application/UseCases/getProfile.usecase.dart';
import 'package:ghana_to_germany/Application/UseCases/getTags.usecase.dart';
import 'package:ghana_to_germany/Application/UseCases/getWikis.usecase.dart';
import 'package:ghana_to_germany/Application/UseCases/likePost.usecase.dart';
import 'package:ghana_to_germany/Application/UseCases/login.usecase.dart';
import 'package:ghana_to_germany/Application/UseCases/logout.usecase.dart';
import 'package:ghana_to_germany/Application/UseCases/register.usecase.dart';
import 'package:ghana_to_germany/Application/UseCases/search.usecase.dart';
import 'package:ghana_to_germany/Application/UseCases/socialRegister.usecase.dart';
import 'package:ghana_to_germany/Application/UseCases/translateText.usecase.dart';
import 'package:ghana_to_germany/Infrastructure/Repositories/AuthRepository.dart';
import 'package:ghana_to_germany/Infrastructure/Repositories/PostRepository.dart';
import 'package:ghana_to_germany/Infrastructure/Repositories/TranslateRepository.dart';
import 'package:ghana_to_germany/Infrastructure/Services/GoogleAuth.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ghana_to_germany/Application/Abstractions/Services/IAuthProvider.dart';
import 'package:ghana_to_germany/Application/Abstractions/Services/IHttpClient.dart';
import 'package:ghana_to_germany/Application/Abstractions/Services/INavigationService.dart';
import 'package:ghana_to_germany/Application/Abstractions/Services/IPostWsService.dart';
import 'package:ghana_to_germany/Infrastructure/Services/AuthProvider.dart';
import 'package:ghana_to_germany/Infrastructure/Services/DioHttpClient.dart';
import 'package:ghana_to_germany/Infrastructure/Services/Navigation.dart';
import 'package:ghana_to_germany/Infrastructure/Services/PostWsService.dart';
import 'package:ghana_to_germany/Presentation/config/router.dart';

GetIt getIt = GetIt.instance;

void initServiceLocator(SharedPreferences sharedPreferences) {
  getIt
    // ============ EXTERNAL PLUGINS ==============
    ..registerSingleton<SharedPreferences>(sharedPreferences)
    ..registerSingleton<GoRouter>(router)
    ..registerSingleton<Dio>(Dio())
    ..registerSingleton<IAuthProvider>(AuthProvider(prefs: getIt()))
    ..registerSingleton<IHttpClient>(
        DioHttpClient(dio: getIt(), authProvider: getIt()))
    ..registerSingleton<INavigationService>(NavigationService(router: getIt()))
    ..registerSingleton<GoogleAuth>(GoogleAuth())

    // ============ REPOSITORIES ==============
    ..registerSingleton<IAuthRepository>(AuthRepository(httpClient: getIt()))
    ..registerSingleton<IPostRepository>(PostRepository(httpClient: getIt()))
    ..registerSingleton<ITranslateRepository>(
        TranslateRepository(httpClient: getIt()))
    // ============ USE CASES ==============
    ..registerFactory<LoginUseCase>(() =>
        LoginUseCase(authRepository: getIt(), authProvider: getIt()))
    ..registerSingleton<LogoutUseCase>(
        LogoutUseCase(authRepository: getIt(), authProvider: getIt()))
    ..registerFactory<RegisterUseCase>(() =>
        RegisterUseCase(authRepository: getIt(), authProvider: getIt()))
    ..registerFactory<SocialRegisterUseCase>(() =>
        SocialRegisterUseCase(authRepository: getIt(), authProvider: getIt()))
    ..registerSingleton<GetPostsUseCase>(
        GetPostsUseCase(postRepository: getIt()))
    ..registerFactory<AddPostUseCase>(() => AddPostUseCase(postRepository: getIt()))
    ..registerSingleton<LikePostUseCase>(
        LikePostUseCase(postRepository: getIt()))
    ..registerSingleton<GetTagsUseCase>(GetTagsUseCase(postRepository: getIt()))
    ..registerSingleton<GetWikisUseCase>(
        GetWikisUseCase(postRepository: getIt()))
    ..registerFactory<AddWikiUseCase>(() => AddWikiUseCase(postRepository: getIt()))
    ..registerSingleton<GetNewsUseCase>(GetNewsUseCase(postRepository: getIt()))
    ..registerSingleton<TranslateTextUseCase>(
        TranslateTextUseCase(translateRepository: getIt()))
    ..registerSingleton<SearchUseCase>(SearchUseCase(postRepository: getIt()))
    ..registerSingleton<AddCommentUseCase>(
        AddCommentUseCase(postRepository: getIt()))
    ..registerSingleton<GetCommentsUseCase>(
        GetCommentsUseCase(postRepository: getIt()))
    ..registerFactory<CompleteProfileUseCase>(() =>
        CompleteProfileUseCase(authRepository: getIt()))
    ..registerSingleton<GetProfileUseCase>(
        GetProfileUseCase(authRepository: getIt()))
    // ============ VIEW MODELS ==============
    ..registerSingleton<PostsViewModel>(PostsViewModel(
        authProvider: getIt(),
        getPostsUseCase: getIt(),
        addPostUseCase: getIt(),
        likePostUseCase: getIt(),
        getCommentsUseCase: getIt(),
        addCommentUseCase: getIt()))
    ..registerSingleton<TagsViewModel>(TagsViewModel(getTagsUseCase: getIt()))
    ..registerSingleton<WikisViewModel>(
        WikisViewModel(getWikisUseCase: getIt(), addWikiUseCase: getIt()))
    ..registerSingleton<NewsViewModel>(NewsViewModel(getNewsUseCase: getIt()))
    ..registerSingleton<IPostWsService>(PostWsService(postsViewModel: getIt()));
}
