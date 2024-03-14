import 'package:currency_exchange/firebase_options.dart';
import 'package:currency_exchange/utils/app_theme.dart';
import 'package:currency_exchange/utils/routing/app_router.dart';
import 'package:currency_exchange/utils/routing/app_routes.dart';
import 'package:currency_exchange/view_models/theme_cubit/theme_cubit.dart';
import 'package:currency_exchange/view_models/update_cubit/update_data_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // Status bar color
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final themeCubit = ThemeCubit();
            return themeCubit;
          },
        ),
        BlocProvider(
          create: (context) {
            final cubit = UpdateDataCubit();
            cubit.getApiUpadte();
            return cubit;
          },
        ),
      ],
      child: Builder(
        builder: (context) {
          return BlocBuilder<ThemeCubit, ThemeState>(
            bloc: BlocProvider.of<ThemeCubit>(context),
            buildWhen: (previous, current) =>
                current is ThemeDark ||
                current is ThemeLight ||
                current is ThemeInitial,
            builder: (context, state) {
              return ScreenUtilInit(
                  designSize: const Size(500, 751),
                  minTextAdapt: true,
                  splitScreenMode: true,
                  // Use builder only if you need to use library outside ScreenUtilInit context
                  builder: (_, child) {
                    return MaterialApp(
                      debugShowCheckedModeBanner: false,
                      theme: AppTheme.lightTheme,
                      darkTheme: AppTheme.darkTheme,
                      themeMode: state is ThemeInitial
                          ? ThemeMode.system
                          : state is ThemeLight
                              ? ThemeMode.light
                              : ThemeMode.dark,
                      initialRoute: AppRoutes.mainPage,
                      onGenerateRoute: AppRouter.onGenerateRoute,
                    );
                  });
            },
          );
        },
      ),
    );
  }
}
