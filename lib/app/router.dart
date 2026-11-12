import 'package:go_router/go_router.dart';

import '../core/network/lan_connection.dart';
import '../core/network/parent_lan_client.dart';
import '../features/achievements/achievements_screen.dart';
import '../features/daily/daily_screen.dart';
import '../features/home/home_screen.dart';
import '../features/levels/levels_screen.dart';
import '../features/login/login_screen.dart';
import '../features/parent/parent_screen.dart';
import '../features/practice/arithmetic_screen.dart';
import '../features/practice/division_screen.dart';
import '../features/practice/mixed_screen.dart';
import '../features/practice/multiplication_screen.dart';
import '../features/quiz/quiz_screen.dart';
import '../features/quiz/topic_exam_setup_screen.dart';
import '../features/remote_parent/remote_parent_connect_screen.dart';
import '../features/remote_parent/remote_parent_dashboard_screen.dart';
import '../features/remote_parent/remote_parent_login_screen.dart';
import '../features/results/results_screen.dart';
import '../features/retry/retry_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/settings/biometric_settings_screen.dart';
import '../features/splash/splash_screen.dart';
import '../features/stats/stats_screen.dart';
import '../features/store/store_screen.dart';
import '../shared/models/enums.dart';
import '../shared/models/exam_models.dart';
import '../shared/models/quiz_launch_data.dart';
import 'app.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  errorBuilder: (context, state) => const MissingRouteDataScreen(),
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/parent-remote/connect',
      builder: (context, state) => const RemoteParentConnectScreen(),
    ),
    GoRoute(
      path: '/parent-remote/login',
      builder: (context, state) {
        final extra = state.extra;
        if (extra is! LanConnectionInfo) {
          return const MissingRouteDataScreen();
        }
        return RemoteParentLoginScreen(connection: extra);
      },
    ),
    GoRoute(
      path: '/parent-remote/dashboard',
      builder: (context, state) {
        final extra = state.extra;
        if (extra is! RemoteParentSession) {
          return const MissingRouteDataScreen();
        }
        return RemoteParentDashboardScreen(session: extra);
      },
    ),
    GoRoute(
      path: '/profiles',
      redirect: (context, state) => '/login',
    ),
    GoRoute(
      path: '/profiles/new',
      redirect: (context, state) => '/login',
    ),
    GoRoute(
      path: '/levels',
      builder: (context, state) => const LevelsScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/multiplication',
      builder: (context, state) => const MultiplicationScreen(),
    ),
    GoRoute(
      path: '/division',
      builder: (context, state) => const DivisionScreen(),
    ),
    GoRoute(
      path: '/addition',
      builder: (context, state) => const ArithmeticScreen(
        section: MathSection.addition,
      ),
    ),
    GoRoute(
      path: '/subtraction',
      builder: (context, state) => const ArithmeticScreen(
        section: MathSection.subtraction,
      ),
    ),
    GoRoute(
      path: '/mixed',
      builder: (context, state) => const MixedScreen(),
    ),
    GoRoute(
      path: '/daily',
      builder: (context, state) => const DailyScreen(),
    ),
    GoRoute(
      path: '/topic-exam',
      builder: (context, state) => const TopicExamSetupScreen(),
    ),
    GoRoute(
      path: '/quiz',
      builder: (context, state) {
        final data = state.extra;
        if (data is! QuizLaunchData) return const MissingRouteDataScreen();
        return QuizScreen(launchData: data);
      },
    ),
    GoRoute(
      path: '/results',
      builder: (context, state) {
        final data = state.extra;
        if (data is! ResultArgs) return const MissingRouteDataScreen();
        return ResultsScreen(args: data);
      },
    ),
    GoRoute(
      path: '/retry',
      builder: (context, state) {
        final data = state.extra;
        if (data is! RetryArgs) return const MissingRouteDataScreen();
        return RetryScreen(args: data);
      },
    ),
    GoRoute(
      path: '/stats',
      builder: (context, state) => const StatsScreen(),
    ),
    GoRoute(
      path: '/achievements',
      builder: (context, state) => const AchievementsScreen(),
    ),
    GoRoute(
      path: '/store',
      builder: (context, state) => const StoreScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/settings/biometric',
      builder: (context, state) {
        final userId = state.uri.queryParameters['userId'];
        if (userId == null || userId.isEmpty) {
          return const MissingRouteDataScreen();
        }
        return BiometricSettingsScreen(userId: userId);
      },
    ),
    GoRoute(
      path: '/parent',
      builder: (context, state) => const ParentScreen(),
    ),
  ],
);
