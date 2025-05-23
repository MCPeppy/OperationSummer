import 'package:go_router/go_router.dart';
import 'home_page.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/chores/chore_board_screen.dart';
import 'features/calendar/calendar_screen.dart';
import 'features/learning/learning_hub_screen.dart';

final router = GoRouter(routes: [
  GoRoute(path: '/', builder: (_, __) => const HomePage()),
  GoRoute(path: '/dashboard', builder: (_, __) => const DashboardScreen()),
  GoRoute(path: '/chores', builder: (_, __) => const ChoreBoardScreen()),
  GoRoute(path: '/calendar', builder: (_, __) => const CalendarScreen()),
  GoRoute(path: '/learning', builder: (_, __) => const LearningHubScreen()),
]);
