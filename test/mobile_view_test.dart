import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:islamquiz/data/aqeedah_questions.dart';
import 'package:islamquiz/main.dart';
import 'package:islamquiz/screens/category_screen.dart';
import 'package:islamquiz/screens/core_beliefs_screen.dart';
import 'package:islamquiz/screens/quiz_screen.dart';
import 'package:islamquiz/services/language_service.dart';

Future<void> pumpMobile(WidgetTester tester, Widget child) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(AppLanguageScope(child: MaterialApp(home: child)));
  await tester.pumpAndSettle();
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    LanguageService.current.value = AppLanguage.bangla;
  });

  testWidgets('mobile home Bangla has no layout exception', (tester) async {
    await LanguageService.init();
    LanguageService.current.value = AppLanguage.bangla;
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const IslamQuizApp());
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('mobile category Bangla has no layout exception', (tester) async {
    await pumpMobile(tester, const CategoryScreen());
    expect(tester.takeException(), isNull);
  });

  testWidgets('mobile quiz Bangla has no layout exception', (tester) async {
    await pumpMobile(tester, QuizScreen(customQuestions: aqeedahQuestions.take(1).toList(), titleOverride: 'Full Quiz'));
    expect(tester.takeException(), isNull);
  });

  testWidgets('mobile core beliefs Bangla has no layout exception', (tester) async {
    await pumpMobile(tester, const CoreBeliefsScreen());
    expect(tester.takeException(), isNull);
  });
}
