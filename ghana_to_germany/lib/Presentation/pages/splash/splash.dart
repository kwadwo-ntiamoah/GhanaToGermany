import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:ghana_to_germany/Application/Abstractions/Services/IAuthProvider.dart';
import 'package:ghana_to_germany/Application/Abstractions/Services/INavigationService.dart';
import 'package:ghana_to_germany/Presentation/config/router.dart';
import 'package:ghana_to_germany/Presentation/config/service_locator.dart'
    as sl;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/splash.mp4')
      ..initialize().then((_) {
        setState(() {
          // Start playing as soon as the video is loaded
          _controller.play();
        });
      });

    // Listen for video completion
    _controller.addListener(() {
      if (_controller.value.position >= _controller.value.duration) {
        onDoneLoading();
      }
    });
  }

  void onDoneLoading() {
    var authProvider = sl.getIt<IAuthProvider>();
    var isLoggedIn = authProvider.getAuthState();
    var navigator = sl.getIt<INavigationService>();

    if (isLoggedIn == true) {
      navigator.replace(AppRoutes.landing);
    } else {
      navigator.replace(AppRoutes.login);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
