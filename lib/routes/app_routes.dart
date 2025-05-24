import 'package:go_router/go_router.dart';
import '../views/game.dart';
import '../views/principal.dart';

final GoRouter appRoutes = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'principal',
      builder: (context, state) => const Principal(),
    ),
    GoRoute(
      path: '/game',
      name: 'game',
      builder: (context, state) => const Game(),
    )
  ],
);
