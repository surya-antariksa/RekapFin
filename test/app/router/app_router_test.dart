import 'package:flutter_test/flutter_test.dart';
import 'package:rekap_fin/app/router/app_router.dart';
import 'package:rekap_fin/core/version/app_config.dart';

void main() {
  group('Router & Redirect Logic (F04 & T-MIG-03)', () {
    test(
        'Pengguna tanpa sesi diarahkan ke /login saat mengakses rute terproteksi',
        () {
      final protectedRoutes = [
        '/home',
        '/transactions',
        '/budget',
        '/analytics',
        '/profile',
        '/wallets'
      ];

      for (final route in protectedRoutes) {
        final redirect = appRouterRedirectLogic(
          location: route,
          isAuthenticated: false,
          isOnboarded: false,
          versionStatus: VersionStatus.supported,
        );
        expect(redirect, equals('/login'),
            reason: 'Rute $route harus dialihkan ke /login');
      }
    });

    test(
        'Pengguna tanpa sesi dapat mengakses rute publik (/login, /signup, /forgot-password, /catalog)',
        () {
      final publicRoutes = [
        '/login',
        '/signup',
        '/forgot-password',
        '/catalog'
      ];

      for (final route in publicRoutes) {
        final redirect = appRouterRedirectLogic(
          location: route,
          isAuthenticated: false,
          isOnboarded: false,
          versionStatus: VersionStatus.supported,
        );
        expect(redirect, isNull,
            reason: 'Rute publik $route tidak boleh dialihkan');
      }
    });

    test(
        'T-MIG-03: Pengguna dengan sesi & versi kadaluarsa diarahkan ke /update-required',
        () {
      final redirect = appRouterRedirectLogic(
        location: '/home',
        isAuthenticated: true,
        isOnboarded: true,
        versionStatus: VersionStatus.updateRequired,
      );

      expect(redirect, equals('/update-required'));
    });

    test(
        'Pengguna di /update-required diizinkan tetap di /update-required jika versi kadaluarsa',
        () {
      final redirect = appRouterRedirectLogic(
        location: '/update-required',
        isAuthenticated: true,
        isOnboarded: true,
        versionStatus: VersionStatus.updateRequired,
      );

      expect(redirect, isNull);
    });

    test(
        'Pengguna di /update-required dialihkan ke /home jika versi sudah didukung',
        () {
      final redirect = appRouterRedirectLogic(
        location: '/update-required',
        isAuthenticated: true,
        isOnboarded: true,
        versionStatus: VersionStatus.supported,
      );

      expect(redirect, equals('/home'));
    });

    test('Pengguna belum onboarding diarahkan ke /onboarding', () {
      final redirect = appRouterRedirectLogic(
        location: '/home',
        isAuthenticated: true,
        isOnboarded: false,
        versionStatus: VersionStatus.supported,
      );

      expect(redirect, equals('/onboarding'));
    });

    test(
        'Pengguna sudah onboarding dan login dialihkan dari /onboarding atau /login ke /home',
        () {
      expect(
        appRouterRedirectLogic(
          location: '/onboarding',
          isAuthenticated: true,
          isOnboarded: true,
          versionStatus: VersionStatus.supported,
        ),
        equals('/home'),
      );

      expect(
        appRouterRedirectLogic(
          location: '/login',
          isAuthenticated: true,
          isOnboarded: true,
          versionStatus: VersionStatus.supported,
        ),
        equals('/home'),
      );
    });
  });
}
