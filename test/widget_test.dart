import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:islamquiz/data/aqeedah_questions.dart';
import 'package:islamquiz/main.dart';
import 'package:islamquiz/services/language_service.dart';
import 'package:islamquiz/widgets/reference_box.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    LanguageService.current.value = AppLanguage.english;
  });

  testWidgets('language toggle updates the visible home screen',
      (tester) async {
    await LanguageService.init();
    await tester.pumpWidget(const IslamQuizApp());
    await tester.pumpAndSettle();

    expect(find.text(LanguageService.appName), findsOneWidget);
    expect(find.text('Learn correct aqeedah step by step.'), findsOneWidget);
    expect(find.text('ধাপে ধাপে সঠিক আকীদাহ শিখুন।'), findsNothing);

    await tester.tap(find.text('বাংলা'));
    await tester.pumpAndSettle();

    expect(find.text(LanguageService.appName), findsOneWidget);
    expect(find.text('ধাপে ধাপে সঠিক আকীদাহ শিখুন।'), findsOneWidget);
    expect(find.text('Learn correct aqeedah step by step.'), findsNothing);

    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();

    expect(find.text(LanguageService.appName), findsOneWidget);
    expect(find.text('Learn correct aqeedah step by step.'), findsOneWidget);
    expect(find.text('ধাপে ধাপে সঠিক আকীদাহ শিখুন।'), findsNothing);
  });

  testWidgets('reference quotes are translated in Bangla mode', (tester) async {
    LanguageService.current.value = AppLanguage.bangla;

    await tester.pumpWidget(
      AppLanguageScope(
        child: MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: ReferenceBox(
                question: aqeedahQuestions.first,
                answeredCorrectly: true,
              ),
            ),
          ),
        ),
      ),
    );

    expect(
      find.textContaining('পরম দয়াময় আল্লাহ আরশের উপর উঠেছেন'),
      findsOneWidget,
    );
    expect(find.textContaining('হিলালী ও খান'), findsWidgets);
    expect(find.textContaining('সহীহ মুসলিম'), findsOneWidget);
    expect(find.textContaining('The Most Merciful'), findsNothing);
    expect(find.textContaining('in the heaven'), findsNothing);
    expect(find.textContaining('Saheeh International'), findsNothing);
    expect(find.textContaining('Sahih Muslim'), findsNothing);
  });
}
