import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:rekap_fin/features/auth/presentation/forgot_password_screen.dart';
import 'package:rekap_fin/features/auth/presentation/login_screen.dart';
import 'package:rekap_fin/features/auth/presentation/onboarding_screen.dart';
import 'package:rekap_fin/features/auth/presentation/signup_screen.dart';
import 'package:rekap_fin/features/analytics/presentation/analytics_screen.dart';
import 'package:rekap_fin/features/budget/presentation/budget_edit_screen.dart';
import 'package:rekap_fin/features/budget/presentation/budget_screen.dart';
import 'package:rekap_fin/features/chat/presentation/chat_screen.dart';
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

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    // Shell routes for bottom navigation tabs
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

    // AI & Scan routes
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

    // Wallets & Transfers
    GoRoute(
      path: '/wallets',
      builder: (context, state) => const WalletsScreen(),
    ),
    GoRoute(
      path: '/transfer',
      builder: (context, state) => const TransferScreen(),
    ),

    // Transactions detail
    GoRoute(
      path: '/transaction-detail',
      builder: (context, state) => const TransactionDetailScreen(),
    ),

    // Budget edit
    GoRoute(
      path: '/budget-edit',
      builder: (context, state) => const BudgetEditScreen(),
    ),

    // Debts routes
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

    // Investments routes
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
  ],
);
