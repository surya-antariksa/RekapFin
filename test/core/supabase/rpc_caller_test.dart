import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:rekap_fin/core/errors/failures.dart';
import 'package:rekap_fin/core/money/rupiah.dart';
import 'package:rekap_fin/core/supabase/client_request_id.dart';
import 'package:rekap_fin/core/supabase/rpc_caller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  group('Inti Data & RPC (F03)', () {
    test('T-MON-01: Format 1250000, -35000, 0', () {
      expect(const Rupiah(1250000).format(), equals('Rp 1.250.000'));
      expect(const Rupiah(0).format(), equals('Rp 0'));
      // Format negatif menghasilkan karakter minus U+2212 resmi
      expect(const Rupiah(-35000).format(), equals('\u2212Rp 35.000'));
    });

    test('ClientRequestId: menghasilkan UUID v4 valid dan unik', () {
      final id1 = ClientRequestId.generate();
      final id2 = ClientRequestId.generate();

      expect(id1, isNot(equals(id2)));
      expect(ClientRequestId.isValid(id1), isTrue);
      expect(ClientRequestId.isValid(id2), isTrue);
    });

    test(
        'T-IDM-08: Retry klien setelah respons hilang memakai client_request_id yang sama',
        () async {
      final capturedRequestIds = <String>[];
      int attempt = 0;

      final caller = RpcCaller.withInvoker((name, params) async {
        attempt++;
        final reqId = params['p_client_request_id'] as String;
        capturedRequestIds.add(reqId);

        if (attempt == 1) {
          // Simulasi respons hilang / timeout
          throw const SocketException('Connection lost');
        }

        return {'status': 'success', 'transaction_id': 'trx_123'};
      });

      final fixedRequestId = ClientRequestId.generate();

      // Panggilan pertama (gagal jaringan)
      final firstResult = await caller.callSafe(
        'create_transaction_v1',
        params: {'p_title': 'Makan'},
        clientRequestId: fixedRequestId,
        isWriteOperation: true,
      );

      expect(firstResult.failure, isA<NetworkFailure>());
      expect(firstResult.data, isNull);

      // Panggilan retry (memakai clientRequestId yang sama persis sesuai T-IDM-08)
      final retryResult = await caller.callSafe(
        'create_transaction_v1',
        params: {'p_title': 'Makan'},
        clientRequestId: fixedRequestId,
        isWriteOperation: true,
      );

      expect(retryResult.failure, isNull);
      expect(retryResult.data,
          equals({'status': 'success', 'transaction_id': 'trx_123'}));

      // Verifikasi ID yang dikirim pada kedua percobaan adalah sama persis
      expect(capturedRequestIds.length, equals(2));
      expect(capturedRequestIds[0], equals(fixedRequestId));
      expect(capturedRequestIds[1], equals(fixedRequestId));
    });

    test(
        'T-OFF-01: Tanpa koneksi internet mengembalikan pesan seragam NetworkFailure',
        () async {
      final caller = RpcCaller.withInvoker((name, params) async {
        throw const SocketException('Network is unreachable');
      });

      final res = await caller.callSafe('get_monthly_summary_v1');
      expect(res.failure, isA<NetworkFailure>());
      expect(
        res.failure!.message,
        equals(NetworkFailure.defaultMessage),
      );
      expect(
        res.failure!.message,
        equals('Tidak ada koneksi. Periksa jaringan lalu coba lagi.'),
      );
    });

    test(
        'T-OFF-02: Jaringan putus saat simpan -> pesan seragam & retry dengan ID sama tanpa duplikat',
        () async {
      final intentId = ClientRequestId.generate();
      int callCount = 0;

      final caller = RpcCaller.withInvoker((name, params) async {
        callCount++;
        if (callCount == 1) {
          throw const SocketException('Broken pipe');
        }
        return {'id': 'created_row_1'};
      });

      // Percobaan 1 gagal
      final res1 = await caller.callSafe(
        'create_transaction_v1',
        params: {'p_amount': 50000},
        clientRequestId: intentId,
        isWriteOperation: true,
      );
      expect(res1.failure, isA<NetworkFailure>());
      expect(res1.failure!.message, contains('Tidak ada koneksi'));

      // Percobaan 2 ("Coba lagi" dari pengguna)
      final res2 = await caller.callSafe(
        'create_transaction_v1',
        params: {'p_amount': 50000},
        clientRequestId: intentId,
        isWriteOperation: true,
      );
      expect(res2.failure, isNull);
      expect(res2.data, equals({'id': 'created_row_1'}));
    });

    test(
        'T-OFF-06: Tenggat waktu 15 detik dibatalkan dan dilaporkan sebagai TimeoutFailure',
        () async {
      final caller = RpcCaller.withInvoker((name, params) async {
        // Simulasi fungsi yang memakan waktu lebih lama dari batas timeout
        await Future.delayed(const Duration(milliseconds: 100));
        return {'status': 'done'};
      });

      // Set timeout sangat kecil untuk simulasi batas 15 detik
      final res = await caller.callSafe(
        'slow_function_v1',
        timeout: const Duration(milliseconds: 20),
      );

      expect(res.failure, isA<TimeoutFailure>());
      expect(res.failure, isA<NetworkFailure>());
      expect(
        res.failure!.message,
        contains('Batas waktu permintaan terlampaui'),
      );
    });

    test('T-OFF-07: Tidak ada antrean tulis lokal (online-only)', () async {
      // Pada arsitektur RekapFin, RpcCaller tidak memiliki antrean penyimpanan offline
      // Permintaan yang gagal langsung mengembalikan Failure ke pemanggil tanpa menyimpan
      // antrean lokal di database/storage lokal.
      final caller = RpcCaller.withInvoker((name, params) async {
        throw const SocketException('No route to host');
      });

      final res = await caller.callSafe('create_transaction_v1',
          isWriteOperation: true);
      expect(res.failure, isA<NetworkFailure>());
      // Tidak ada state antrean tersembunyi
      expect(res.data, isNull);
    });

    test(
        'Pemetaan kesalahan server: request_id_reuse, kuota AI, dan autentikasi',
        () async {
      final testCases = <String, String>{
        'request_id_reuse': 'request_id_reuse',
        'fallback_quota_exhausted': 'fallback_quota_exhausted',
        'scan_quota_exhausted': 'scan_quota_exhausted',
        'chat_quota_exhausted': 'chat_quota_exhausted',
        'ai_consent_required': 'ai_consent_required',
        'authentication_required': 'authentication_required',
      };

      for (final entry in testCases.entries) {
        final caller = RpcCaller.withInvoker((name, params) async {
          throw PostgrestException(message: entry.key);
        });

        final res = await caller.callSafe('some_rpc_v1');
        expect(res.failure, isA<ServerFailure>());
        final serverFailure = res.failure as ServerFailure;
        expect(serverFailure.code, equals(entry.value));
      }
    });
  });
}
