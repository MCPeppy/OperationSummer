import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'router.dart';
import 'package:lottie/lottie.dart';
import 'home_page.dart';

void main() {
  runApp(ProviderScope(child: OperationSummerApp()));
}

class OperationSummerApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(routerConfig: router,
      title: 'Operation Summer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF2f3e46),
        scaffoldBackgroundColor: Color(0xFFfef9f4),
        fontFamily: 'Rubik',
        textTheme: TextTheme(
          headlineLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2f3e46),
          ),
          headlineMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2f3e46),
          ),
          bodyLarge: TextStyle(fontSize: 16, color: Color(0xFF333333)),
        ),
      ),
    );
  }
}

