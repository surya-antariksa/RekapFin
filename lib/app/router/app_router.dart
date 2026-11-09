import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rekap_fin/core/version/app_config.dart';
import 'package:rekap_fin/features/analytics/presentation/analytics_screen.dart';
import 'package:rekap_fin/features/auth/presentation/forgot_password_screen.dart';
import 'package:rekap_fin/features/auth/presentation/login_screen.dart';
import 'package:rekap_fin/features/auth/presentation/onboarding_screen.dart';
import 'package:rekap_fin/features/auth/presentation/signup_screen.dart';
import 'package:rekap_fin/features/budget/presentation/budget_edit_screen.dart';
import 'package:rekap_fin/features/budget/presentation/budget_screen.dart';
import 'package:rekap_fin/features/chat/presentation/chat_screen.dart';
import 'package:rekap_fin/features/core/presentation/component_catalog_screen.dart';
import 'package:rekap_fin/features/core/presentation/main_shell_screen.dart';
import 'package:rekap_fin/features/core/presentation/update_required_screen.dart';
import 'package:rekap_fin/features/debts/presentation/debt_detail_screen.dart';
import 'package:rekap_fin/features/debts/presentation/debt_net_screen.dart';
import 'package:rekap_fin/features/debts/presentation/debt_offset_screen.dart';
import 'package:rekap_fin/features/debts/presentation/debt_payment_screen.dart';
import 'package:rekap_fin/features/debts/presentation/debts_screen.dart';
import 'package:rekap_fin/features/home/presentation/home_screen.dart';
import 'package:rekap_fin/features/investments/presentation/add_investment_screen.dart';
import 'package:rekap_fin/features/investments/presentation/investment_detail_screen.dart';
import 'package:rekap_fin/features/investments/presentation/investments_screen.dart';
import 'package:rekap_fin/features/investments/presentation/scan_investment_result_screen.dart';
import 'package:rekap_fin/features/investments/presentation/scan_investment_screen.dart';
import 'package:rekap_fin/features/profile/presentation/edit_profile_screen.dart';
import 'package:rekap_fin/features/profile/presentation/profile_screen.dart';
import 'package:rekap_fin/features/scan/presentation/scan_result_screen.dart';
import 'package:rekap_fin/features/scan/presentation/scan_screen.dart';
import 'package:rekap_fin/features/settings/presentation/settings_screen.dart';
import 'package:rekap_fin/features/transactions/presentation/transaction_detail_screen.dart';
import 'package:rekap_fin/features/transactions/presentation/transactions_screen.dart';
import 'package:rekap_fin/features/wallets/presentation/transfer_screen.dart';
import 'package:rekap_fin/features/wallets/presentation/wallets_screen.dart';

/// Logika pengalihan navigasi RekapFin sesuai F04, T-MIG-03, dan BR-41
String? appRouterRedirectLogic({
  required String location,
  required bool isAuthenticated,
  required bool isOnboarded,
  required VersionStatus versionStatus,
}) {
  final isPublicRoute = location == '/login' ||
      location == '/signup' ||
      location == '/forgot-password' ||
      location == '/catalog';

  // 1. Pengguna tanpa sesi diarahkan ke /login
  if (!isAuthenticated) {
    if (isPublicRoute) {
      return null;
    }
    return '/login';
  }

  // 2. Pengguna dengan sesi: periksa versi aplikasi (T-MIG-03)
  if (versionStatus == VersionStatus.updateRequired) {
    if (location == '/update-required') {
      return null;
    }
    return '/update-required';
  } else if (location == '/update-required') {
    return '/home';
  }

  // 3. Pengguna belum onboarding diarahkan ke /onboarding (AUT-07)
  if (!isOnboarded) {
    if (location == '/onboarding') {
      return null;
    }
    return '/onboarding';
  } else if (location == '/onboarding' ||
      location == '/login' ||
      location == '/signup') {
    return '/home';
  }

  return null;
}

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Membuat instance GoRouter yang dapat dikonfigurasi untuk pengujian maupun runtime
GoRouter createAppRouter({
  bool isAuthenticated = true,
  bool isOnboarded = true,
  VersionStatus versionStatus = VersionStatus.supported,
  String initialLocation = '/home',
  Listenable? refreshListenable,
  GlobalKey<NavigatorState>? navigatorKey,
}) {
  return GoRouter(
    navigatorKey: navigatorKey ?? _rootNavigatorKey,
    initialLocation: initialLocation,
    refreshListenable: refreshListenable,
    redirect: (context, state) {
      return appRouterRedirectLogic(
        location: state.uri.path,
        isAuthenticated: isAuthenticated,
        isOnboarded: isOnboarded,
        versionStatus: versionStatus,
      );
    },
    routes: [
      // ShellRoute: 5 tab utama (Beranda, Transaksi, Anggaran, Analitik, Profil)
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShellScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/transactions',
                builder: (context, state) => const TransactionsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/budget',
                builder: (context, state) => const BudgetScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/analytics',
                builder: (context, state) => const AnalyticsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),

      // Auth routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Standalone feature routes
      GoRoute(
        path: '/chat',
        builder: (context, state) => const ChatScreen(),
      ),
      GoRoute(
        path: '/scan',
        builder: (context, state) => const ScanScreen(),
      ),
      GoRoute(
        path: '/scan-result',
        builder: (context, state) => const ScanResultScreen(),
      ),

      // Wallets & Transactions
      GoRoute(
        path: '/wallets',
        builder: (context, state) => const WalletsScreen(),
      ),
      GoRoute(
        path: '/transfer',
        builder: (context, state) => const TransferScreen(),
      ),
      GoRoute(
        path: '/transaction-detail',
        builder: (context, state) => const TransactionDetailScreen(),
      ),

      // Budget & Analytics details
      GoRoute(
        path: '/budget-edit',
        builder: (context, state) => const BudgetEditScreen(),
      ),

      // Debts
      GoRoute(
        path: '/debts',
        builder: (context, state) => const DebtsScreen(),
      ),
      GoRoute(
        path: '/debt-detail',
        builder: (context, state) => const DebtDetailScreen(),
      ),
      GoRoute(
        path: '/debt-payment',
        builder: (context, state) => const DebtPaymentScreen(),
      ),
      GoRoute(
        path: '/debt-net',
        builder: (context, state) => const DebtNetScreen(),
      ),
      GoRoute(
        path: '/debt-offset',
        builder: (context, state) => const DebtOffsetScreen(),
      ),

      // Investments
      GoRoute(
        path: '/investments',
        builder: (context, state) => const InvestmentsScreen(),
      ),
      GoRoute(
        path: '/scan-investment',
        builder: (context, state) => const ScanInvestmentScreen(),
      ),
      GoRoute(
        path: '/scan-investment-result',
        builder: (context, state) => const ScanInvestmentResultScreen(),
      ),
      GoRoute(
        path: '/add-investment',
        builder: (context, state) => const AddInvestmentScreen(),
      ),
      GoRoute(
        path: '/investment-detail',
        builder: (context, state) => const InvestmentDetailScreen(),
      ),

      // Profile & Settings
      GoRoute(
        path: '/edit-profile',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/update-required',
        builder: (context, state) => const UpdateRequiredScreen(),
      ),
      GoRoute(
        path: '/catalog',
        builder: (context, state) => const ComponentCatalogScreen(),
      ),
    ],
  );
}

/// Instance router default untuk aplikasi
final GoRouter appRouter = createAppRouter();
