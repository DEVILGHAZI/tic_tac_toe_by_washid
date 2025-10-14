import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'core/utils/sound_effects.dart';
import 'features/home/splash_screen.dart';

class TicTacToeApp extends StatefulWidget {
  const TicTacToeApp({super.key});

  @override
  State<TicTacToeApp> createState() => _TicTacToeAppState();
}

class _TicTacToeAppState extends State<TicTacToeApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    // Remove the native splash screen after the app is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        SoundEffects.pauseAll();
        break;
      case AppLifecycleState.resumed:
        SoundEffects.resumeLoop();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp(
          title: 'Tic Tac Toe',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          home: const SplashScreen(),
        );
      },
    );
  }
}