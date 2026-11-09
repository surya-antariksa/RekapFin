import 'package:flutter_test/flutter_test.dart';
import 'package:rekap_fin/core/version/app_config.dart';

void main() {
  group('AppConfig & Version Check (T-MIG-03 & BR-41)', () {
    test('isVersionBelow membandingkan versi semantik dengan benar', () {
      expect(AppVersionChecker.isVersionBelow('1.0.0', '1.0.1'), isTrue);
      expect(AppVersionChecker.isVersionBelow('1.0.0', '1.1.0'), isTrue);
      expect(AppVersionChecker.isVersionBelow('1.0.0', '2.0.0'), isTrue);

      expect(AppVersionChecker.isVersionBelow('1.0.1', '1.0.0'), isFalse);
      expect(AppVersionChecker.isVersionBelow('1.1.0', '1.0.0'), isFalse);
      expect(AppVersionChecker.isVersionBelow('1.0.0', '1.0.0'), isFalse);
      expect(AppVersionChecker.isVersionBelow('2.0.0', '1.9.9'), isFalse);
    });

    test(
        'T-MIG-03: Versi di bawah min_app_version menghasilkan VersionStatus.updateRequired',
        () {
      const config = AppConfig(
        minAppVersion: '2.0.0',
        recommendedVersion: '2.1.0',
        updateUrl: 'https://drive.google.com/rekapfin',
      );

      final status = AppVersionChecker.evaluate(
        currentVersion: '1.0.0',
        config: config,
      );

      expect(status, equals(VersionStatus.updateRequired));
    });

    test(
        'Versi di atas min_app_version tetapi di bawah recommended menghasilkan updateRecommended',
        () {
      const config = AppConfig(
        minAppVersion: '1.0.0',
        recommendedVersion: '1.2.0',
        updateUrl: 'https://drive.google.com/rekapfin',
      );

      final status = AppVersionChecker.evaluate(
        currentVersion: '1.1.0',
        config: config,
      );

      expect(status, equals(VersionStatus.updateRecommended));
    });

    test(
        'Versi memenuhi atau melampaui recommended menghasilkan VersionStatus.supported',
        () {
      const config = AppConfig(
        minAppVersion: '1.0.0',
        recommendedVersion: '1.0.0',
        updateUrl: 'https://drive.google.com/rekapfin',
      );

      final status = AppVersionChecker.evaluate(
        currentVersion: '1.0.0',
        config: config,
      );

      expect(status, equals(VersionStatus.supported));
    });

    test('Parsing AppConfig dari respons JSON get_app_config_v1', () {
      final json = {
        'min_app_version': '1.0.0',
        'recommended_version': '1.1.0',
        'update_url': 'https://drive.google.com/apk',
      };

      final config = AppConfig.fromJson(json);
      expect(config.minAppVersion, equals('1.0.0'));
      expect(config.recommendedVersion, equals('1.1.0'));
      expect(config.updateUrl, equals('https://drive.google.com/apk'));
    });
  });
}
