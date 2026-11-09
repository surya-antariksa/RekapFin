import 'dart:math';

/// Penghasil dan validator client_request_id (UUID v4) sesuai BR-40 & arsitektur RekapFin
class ClientRequestId {
  static final Random _secureRandom = Random.secure();

  /// Menghasilkan UUID v4 acak kriptografis
  static String generate() {
    final bytes = List<int>.generate(16, (_) => _secureRandom.nextInt(256));

    // Versi 4 (bits 4-7 dari octet 6 diatur ke 0100)
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    // Varian RFC 4122 (bits 6-7 dari octet 8 diatur ke 10)
    bytes[8] = (bytes[8] & 0x3f) | 0x80;

    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();

    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
  }

  /// Memeriksa validitas format UUID v4
  static bool isValid(String uuid) {
    final regex = RegExp(
      r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
      caseSensitive: false,
    );
    return regex.hasMatch(uuid);
  }
}
