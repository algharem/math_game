import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:math_heroes/app/providers.dart';
import 'package:math_heroes/core/database/app_database.dart';
import 'package:math_heroes/core/services/dev_account_seeder.dart';
import 'package:math_heroes/core/services/settings_service.dart';
import 'package:math_heroes/features/login/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late AppDatabase db;
  late SettingsService settings;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    SharedPreferences.setMockInitialValues({});
    settings = SettingsService(await SharedPreferences.getInstance());
    await DevAccountSeeder.seed(db);
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets(
      'login screen shows dev badges and username login opens the right grade',
      (tester) async {
    tester.view.physicalSize = const Size(1200, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        settingsServiceProvider.overrideWithValue(settings),
      ],
    );
    addTearDown(container.dispose);

    final router = GoRouter(
      initialLocation: '/login',
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const Scaffold(body: Text('HOME_ROUTE')),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    // All nine seeded students appear with the development badge.
    expect(find.text('حساب تجريبي'), findsNWidgets(9));
    expect(find.text('Student 1'), findsOneWidget);
    expect(find.text('Student 9'), findsOneWidget);

    // The shared password is never printed on the screen.
    expect(find.text(DevAccountSeeder.defaultPassword), findsNothing);

    await tester.tap(find.text('الدخول باسم المستخدم'));
    await tester.pumpAndSettle();
    expect(find.text('اسم المستخدم'), findsOneWidget);

    // Wrong password keeps the dialog open with an error.
    await tester.enterText(find.byType(TextFormField).first, 'student4');
    await tester.enterText(find.byType(TextFormField).last, '000000');
    await tester.tap(find.text('دخول'));
    await tester.pumpAndSettle();
    expect(find.text('اسم المستخدم'), findsOneWidget);
    expect(container.read(authProvider), isNull);
    expect(find.text('HOME_ROUTE'), findsNothing);

    // Correct credentials close the dialog, set the session, and route home.
    await tester.enterText(find.byType(TextFormField).last, '111111');
    await tester.tap(find.text('دخول'));
    await tester.pumpAndSettle();

    expect(find.text('HOME_ROUTE'), findsOneWidget);
    expect(container.read(authProvider)?.account.schoolGrade, 4);
    expect(container.read(activeProfileProvider)?.schoolGrade, 4);
    expect(container.read(activeProfileProvider)?.name, 'Student 4');
    expect(container.read(settingsProvider).selectedProfileId, isNotNull);
  });
}
