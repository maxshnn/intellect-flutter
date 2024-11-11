// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intellect/bloc/theme/theme_cubit.dart';
import 'package:intellect/constants.dart';
import 'package:intellect/screen/chat_screen.dart';
import 'package:intellect/screen/dashboard_screen.dart';
import 'package:intellect/screen/init_screen.dart';
import 'package:intellect/screen/welcome_screen.dart';
// import 'bloc/app/app_bloc.dart';
import 'bloc/chat/chat_bloc.dart';
import 'generated/codegen_loader.g.dart';
import 'models/chat.dart' as model;

void main() async {
  FlutterNativeSplash.removeAfter(initialization);
  await Hive.initFlutter();
  Hive.registerAdapter(model.MarkAdapter());
  Hive.registerAdapter(model.RoleAdapter());
  Hive.registerAdapter(model.MessageAdapter());
  Hive.registerAdapter(model.MessageTypeAdapter());
  Hive.registerAdapter(model.ChatAdapter());
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
/*   SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.white, statusBarBrightness: Brightness.light, )); */

  runApp(
    EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('ru')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en', 'US'),
        assetLoader: const CodegenLoader(),
        child: const MyApp()),
  );
}

Future initialization(BuildContext? context) async {
  await Future.delayed(const Duration(seconds: 2));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ChatBloc()
            ..add(ChatNowEvent(chatNow: 0))
            ..add(ChatInitEvent(id: 0, name: '')),
          lazy: false,
        ),
        BlocProvider(
          create: (context) => ThemeCubit()..initTheme(),
          lazy: false,
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: state.theme == AppTheme.dark
                ? Brightness.light
                : Brightness.dark,
            statusBarBrightness: state.theme == AppTheme.dark
                ? Brightness.light
                : Brightness.dark,
          ));
          return MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            scrollBehavior: const ScrollBehavior(),
            initialRoute: '/init',
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case '/init':
                  return CupertinoPageRoute(builder: (context) => const Init());
                case '/':
                  return CupertinoPageRoute(
                      builder: (context) => const Dashboard());
                case '/welcome':
                  return CupertinoPageRoute(
                      builder: (context) => const Welcome());
                case '/chat':
                  return CupertinoPageRoute(builder: (context) => const Chat());
                /*           '/welcome': (context) => const Welcome(),
                        '/chat': (context) => const Chat(), */
              }
              return null;
            },
            themeMode: state.theme == AppTheme.light
                ? ThemeMode.light
                : ThemeMode.dark,
            darkTheme: MyThemes.darkThemes,
            theme: MyThemes.lightTheme,
/*               theme: state.theme == AppTheme.light
                  ? MyThemes.lightTheme
                  : MyThemes.darkThemes */
          );
        },
      ),
    );
  }
}
