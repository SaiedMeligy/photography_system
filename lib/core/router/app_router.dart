import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../feature/home/presentation/screens/home_screen.dart';
import '../../feature/portfolio/presentation/screens/portfolio_screen.dart';
import '../../feature/packages/presentation/screens/packages_screen.dart';
import '../../feature/booking/presentation/screens/booking_screen.dart';
import '../../feature/testimonials/presentation/screens/testimonials_screen.dart';
import '../../feature/shell/presentation/widgets/app_shell.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/portfolio',
            name: 'portfolio',
            builder: (context, state) => const PortfolioScreen(),
          ),
          GoRoute(
            path: '/packages',
            name: 'packages',
            builder: (context, state) => const PackagesScreen(),
          ),
          GoRoute(
            path: '/booking',
            name: 'booking',
            builder: (context, state) => const BookingScreen(),
          ),
          GoRoute(
            path: '/testimonials',
            name: 'testimonials',
            builder: (context, state) => const TestimonialsScreen(),
          ),
        ],
      ),
    ],
  );
}
