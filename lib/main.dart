import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'services/app_route_observer.dart';
import 'services/language_service.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LanguageService.init();
  runApp(const IslamQuizApp());
}

class IslamQuizApp extends StatelessWidget {
  const IslamQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLanguageScope(
      child: MaterialApp(
        title: LanguageService.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        navigatorObservers: [appRouteObserver],
        home: const HomeScreen(),
      ),
    );
  }
}
