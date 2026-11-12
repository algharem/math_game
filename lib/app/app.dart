import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../shared/widgets/app_widgets.dart';
import 'providers.dart';
import 'router.dart';
import 'theme.dart';

class MathHeroesApp extends ConsumerWidget {
  const MathHeroesApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    return MaterialApp.router(
      title: 'أبطال الحساب',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.build(
        highContrast: settings.highContrast,
        largeText: settings.largeText,
      ),
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: appRouter,
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}

class MissingRouteDataScreen extends StatelessWidget {
  const MissingRouteDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlayfulScaffold(
      body: EmptyState(
        title: 'هذه الصفحة غير متاحة',
        message: 'ابدأ نشاطًا جديدًا من الصفحة الرئيسية.',
        icon: Icons.explore_off_rounded,
        action: PressButton(
          onPressed: () => Navigator.of(context).maybePop(),
          child: const Text('العودة'),
        ),
      ),
    );
  }
}
