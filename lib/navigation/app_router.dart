import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/login/login_screen.dart';
import '../screens/register/register_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/messages/messages_screen.dart';
import '../screens/conversation/conversation_screen.dart';
import '../screens/quick_reply/quick_reply_screen.dart';
import '../screens/voice_control/voice_control_screen.dart';
import '../screens/ble_settings/ble_settings_screen.dart';
import '../screens/sos/sos_screen.dart';
import '../screens/station_finder/station_finder_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/message_simulator/message_simulator_screen.dart';
import '../widgets/bottom_nav_shell.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    // ─── Auth flow ───
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),

    // ─── Main app with bottom nav ───
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => BottomNavShell(child: child),
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/messages',
          builder: (context, state) => const MessagesScreen(),
        ),
        GoRoute(
          path: '/station-finder',
          builder: (context, state) => const StationFinderScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    ),

    // ─── Standalone screens (no bottom nav) ───
    GoRoute(
      path: '/messages/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => ConversationScreen(
        conversationId: state.pathParameters['id'] ?? '',
      ),
    ),
    GoRoute(
      path: '/quick-reply',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const QuickReplyScreen(),
    ),
    GoRoute(
      path: '/voice',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const VoiceControlScreen(),
        transitionsBuilder: (context, animation, _, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),
    GoRoute(
      path: '/ble-settings',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const BleSettingsScreen(),
    ),
    GoRoute(
      path: '/sos',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SosScreen(),
    ),
    GoRoute(
      path: '/station-finder',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const StationFinderScreen(),
    ),
    GoRoute(
      path: '/simulator',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const MessageSimulatorScreen(),
    ),
  ],
);
