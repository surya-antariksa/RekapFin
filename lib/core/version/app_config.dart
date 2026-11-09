/// Model konfigurasi aplikasi dari server (tabel app_config via get_app_config_v1)
class AppConfig {
  final String minAppVersion;
  final String recommendedVersion;
  final String updateUrl;

  const AppConfig({
    required this.minAppVersion,
    required this.recommendedVersion,
    required this.updateUrl,
  });

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      minAppVersion: json['min_app_version'] as String? ?? '1.0.0',
      recommendedVersion: json['recommended_version'] as String? ?? '1.0.0',
      updateUrl: json['update_url'] as String? ?? 'https://drive.google.com',
    );
  }
}

enum VersionStatus {
  supported,
  updateRecommended,
  updateRequired,
}

/// Pemeriksa kompatibilitas versi aplikasi RekapFin sesuai T-MIG-03 & BR-41
class AppVersionChecker {
  static const String currentAppVersion = '1.0.0';

  /// Membandingkan dua string versi semantik (mis. "1.0.0" vs "1.1.0")
  /// Mengembalikan true jika [current] < [target]
  static bool isVersionBelow(String current, String target) {
    final currentParts =
        current.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    final targetParts =
        target.split('.').map((e) => int.tryParse(e) ?? 0).toList();

    final maxLen = currentParts.length > targetParts.length
        ? currentParts.length
        : targetParts.length;

    for (int i = 0; i < maxLen; i++) {
      final c = i < currentParts.length ? currentParts[i] : 0;
      final t = i < targetParts.length ? targetParts[i] : 0;

      if (c < t) return true;
      if (c > t) return false;
    }

    return false;
  }

  /// Menentukan status versi aplikasi berdasarkan AppConfig dari server
  static VersionStatus evaluate({
    required String currentVersion,
    required AppConfig config,
  }) {
    if (isVersionBelow(currentVersion, config.minAppVersion)) {
      return VersionStatus.updateRequired;
    }
    if (isVersionBelow(currentVersion, config.recommendedVersion)) {
      return VersionStatus.updateRecommended;
    }
    return VersionStatus.supported;
  }
}

