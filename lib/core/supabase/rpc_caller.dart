import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:rekap_fin/core/errors/error_mapper.dart';
import 'package:rekap_fin/core/errors/failures.dart';
import 'package:rekap_fin/core/supabase/client_request_id.dart';

typedef RpcInvoker = Future<dynamic> Function(
  String functionName,
  Map<String, dynamic> params,
);

/// Pembungkus RPC Supabase berversi sesuai arsitektur RekapFin (docs/07 bagian 3 & 12)
/// Aturan:
/// - Menyertakan client_request_id untuk RPC tulis tabel kelas A (BR-40)
/// - Menggunakan ulang client_request_id yang sama saat retry (T-IDM-08, T-OFF-02)
/// - Menegakkan tenggat waktu 15 detik (T-OFF-06)
/// - Memetakan kegagalan jaringan seragam ke NetworkFailure (T-OFF-01/02)
/// - Tanpa antrean tulis offline lokal (T-OFF-07)
class RpcCaller {
  final SupabaseClient? _client;
  final RpcInvoker? _invoker;

  /// Tenggat waktu standar 15 detik sesuai keputusan arsitektur (T-OFF-06)
  static const Duration defaultTimeout = Duration(seconds: 15);

  const RpcCaller(SupabaseClient client)
      : _client = client,
        _invoker = null;

  /// Konstruktor pengujian dengan invoker khusus
  const RpcCaller.withInvoker(RpcInvoker invoker)
      : _client = null,
        _invoker = invoker;

  /// Memanggil RPC Supabase secara aman dengan batas waktu dan idempotensi
  ///
  /// [functionName]: Nama fungsi RPC berversi (mis. 'get_app_config_v1', 'create_transaction_v1')
  /// [params]: Parameter yang dikirimkan ke RPC
  /// [clientRequestId]: UUID v4 unik per niat tindakan pengguna. Bila null pada operasi tulis,
  /// akan otomatis dibuatkan UUID baru. Saat retry, pemanggil wajib mengirimkan nilai yang sama.
  /// [isWriteOperation]: Jika true, parameter `p_client_request_id` akan dipastikan ada
  /// [timeout]: Batas waktu eksekusi (bawaan 15 detik)
  Future<dynamic> call(
    String functionName, {
    Map<String, dynamic>? params,
    String? clientRequestId,
    bool isWriteOperation = false,
    Duration timeout = defaultTimeout,
  }) async {
    final effectiveParams = Map<String, dynamic>.from(params ?? {});

    if (isWriteOperation) {
      final reqId = clientRequestId ?? ClientRequestId.generate();
      effectiveParams['p_client_request_id'] = reqId;
    }

    try {
      if (_invoker != null) {
        return await _invoker(functionName, effectiveParams).timeout(timeout);
      }

      final response = await _client!
          .rpc(functionName, params: effectiveParams)
          .timeout(timeout);

      return response;
    } on TimeoutException catch (e) {
      throw ErrorMapper.map(e);
    } catch (e) {
      throw ErrorMapper.map(e);
    }
  }

  /// Eksekusi RPC yang mengembalikan Result pattern (Success atau Failure)
  Future<({Failure? failure, dynamic data})> callSafe(
    String functionName, {
    Map<String, dynamic>? params,
    String? clientRequestId,
    bool isWriteOperation = false,
    Duration timeout = defaultTimeout,
  }) async {
    try {
      final res = await call(
        functionName,
        params: params,
        clientRequestId: clientRequestId,
        isWriteOperation: isWriteOperation,
        timeout: timeout,
      );
      return (failure: null, data: res);
    } on Failure catch (f) {
      return (failure: f, data: null);
    } catch (e) {
      return (failure: ErrorMapper.map(e), data: null);
    }
  }
}
