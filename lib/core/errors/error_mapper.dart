import 'dart:async';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:rekap_fin/core/errors/failures.dart';

/// Pemeta kesalahan teknis menjadi Failure domain yang seragam
class ErrorMapper {
  static Failure map(Object error) {
    if (error is Failure) {
      return error;
    }

    if (error is TimeoutException) {
      return const TimeoutFailure();
    }

    if (error is SocketException) {
      return const NetworkFailure();
    }

    if (error is PostgrestException) {
      final msg = error.message.toLowerCase();

      if (msg.contains('request_id_reuse')) {
        return const ServerFailure(
          'ID permintaan sudah digunakan untuk operasi lain.',
          code: 'request_id_reuse',
        );
      }
      if (msg.contains('fallback_quota_exhausted')) {
        return const ServerFailure(
          'Batas kuota harian fallback pemindaian nota telah habis.',
          code: 'fallback_quota_exhausted',
        );
      }
      if (msg.contains('scan_quota_exhausted')) {
        return const ServerFailure(
          'Batas kuota harian scan nota telah habis.',
          code: 'scan_quota_exhausted',
        );
      }
      if (msg.contains('chat_quota_exhausted')) {
        return const ServerFailure(
          'Batas kuota harian percakapan AI telah habis.',
          code: 'chat_quota_exhausted',
        );
      }
      if (msg.contains('ai_consent_required')) {
        return const ServerFailure(
          'Persetujuan pemrosesan AI diperlukan sebelum melanjutkan.',
          code: 'ai_consent_required',
        );
      }
      if (msg.contains('authentication_required')) {
        return const ServerFailure(
          'Sesi login diperlukan untuk melakukan tindakan ini.',
          code: 'authentication_required',
        );
      }

      // Bila terdeteksi pesan koneksi atau jaringan
      if (msg.contains('failed to connect') ||
          msg.contains('network') ||
          msg.contains('connection refused') ||
          msg.contains('socket')) {
        return const NetworkFailure();
      }

      return ServerFailure(error.message, code: error.code);
    }

    if (error is AuthException) {
      return AuthFailure(error.message, code: error.statusCode);
    }

    final str = error.toString().toLowerCase();
    if (str.contains('socket') ||
        str.contains('network') ||
        str.contains('connection') ||
        str.contains('clientexception')) {
      return const NetworkFailure();
    }

    return ServerFailure(error.toString());
  }
}
