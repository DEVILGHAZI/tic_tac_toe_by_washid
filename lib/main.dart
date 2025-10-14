import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'app.dart';
import 'core/theme/theme_cubit.dart';
import 'features/game/data/repositories/game_repository.dart';
import 'features/game/presentation/bloc/game_bloc.dart';
import 'core/utils/sound_effects.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Preserve the native splash screen
  FlutterNativeSplash.preserve(widgetsBinding: WidgetsFlutterBinding.ensureInitialized());
  
  // Init audio players
  await SoundEffects.init();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) {
                final cubit = ThemeCubit();
                cubit.loadTheme();
                return cubit;
              },
            ),
            BlocProvider(
              create: (context) => GameBloc(
                gameRepository: GameRepository(),
              ),
            ),
          ],
          child: const TicTacToeApp(),
        );
      },
    );
  }
}