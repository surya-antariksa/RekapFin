/// Kelas dasar representasi kegagalan (Failure) RekapFin
abstract class Failure {
  final String message;
  final String? code;

  const Failure(this.message, {this.code});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          code == other.code;

  @override
  int get hashCode => Object.hash(runtimeType, message, code);

  @override
  String toString() => '$runtimeType(message: $message, code: $code)';
}

/// Kegagalan jaringan / offline seragam sesuai docs/07 bagian 12 & T-OFF-01/02
class NetworkFailure extends Failure {
  static const String defaultMessage =
      'Tidak ada koneksi. Periksa jaringan lalu coba lagi.';

  final bool isTimeout;

  const NetworkFailure({
    String message = defaultMessage,
    this.isTimeout = false,
    String? code,
  }) : super(message, code: code);
}

/// Kegagalan batas waktu permintaan (tenggat 15 detik sesuai T-OFF-06)
class TimeoutFailure extends NetworkFailure {
  static const String timeoutMessage =
      'Batas waktu permintaan terlampaui (15 detik). Periksa jaringan lalu coba lagi.';

  const TimeoutFailure({
    super.message = timeoutMessage,
    super.code = 'timeout',
  }) : super(isTimeout: true);
}

/// Kegagalan dari server/RPC basis data
class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.code});

  /// True jika server mendeteksi penggunaan ulang client_request_id secara tidak sah (T-IDM-02)
  bool get isRequestIdReuse => code == 'request_id_reuse';

  /// True jika kuota harian fallback vision habis (OI-48)
  bool get isFallbackQuotaExhausted => code == 'fallback_quota_exhausted';

  /// True jika kuota harian scan habis
  bool get isScanQuotaExhausted => code == 'scan_quota_exhausted';

  /// True jika kuota harian chat habis
  bool get isChatQuotaExhausted => code == 'chat_quota_exhausted';

  /// True jika belum ada persetujuan pemrosesan AI (BR-47, OI-54)
  bool get isAiConsentRequired => code == 'ai_consent_required';

  /// True jika fungsi membutuhkan autentikasi
  bool get isAuthenticationRequired => code == 'authentication_required';
}

/// Kegagalan autentikasi (login salah, sesi habis)
class AuthFailure extends Failure {
  const AuthFailure(super.message, {super.code});
}

/// Kegagalan validasi masukan lokal
class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {super.code});
}

/// Kegagalan versi aplikasi di bawah batas minimum (T-MIG-03)
class VersionBlockedFailure extends Failure {
  final String minAppVersion;
  final String currentVersion;
  final String updateUrl;

  const VersionBlockedFailure({
    required this.minAppVersion,
    required this.currentVersion,
    required this.updateUrl,
    String message =
        'Versi aplikasi ini sudah tidak didukung. Harap perbarui ke versi terbaru.',
  }) : super(message, code: 'version_blocked');
}
