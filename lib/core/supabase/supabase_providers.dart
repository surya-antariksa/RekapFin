import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:rekap_fin/core/supabase/rpc_caller.dart';
import 'package:rekap_fin/core/version/app_config.dart';

/// Provider klien Supabase utama
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Provider pembungkus RPC berversi dengan batas waktu dan idempotensi
final rpcCallerProvider = Provider<RpcCaller>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return RpcCaller(client);
});

/// Provider sesi Supabase saat ini
final currentSessionProvider = Provider<Session?>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return client.auth.currentSession;
});

/// Provider status apakah pengguna telah masuk (authenticated)
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(currentSessionProvider) != null;
});

/// Provider stream perubahan status autentikasi
final authStateChangesProvider = StreamProvider<AuthState>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return client.auth.onAuthStateChange;
});

/// Provider pengecekan versi aplikasi (hanya dipanggil setelah sesi tersedia sesuai T-MIG-03)
final appConfigProvider = FutureProvider<AppConfig?>((ref) async {
  final isAuthenticated = ref.watch(isAuthenticatedProvider);
  if (!isAuthenticated) {
    return null;
  }

  final rpcCaller = ref.watch(rpcCallerProvider);
  final res = await rpcCaller.callSafe(
    'get_app_config_v1',
    params: {'p_platform': 'android'},
  );

  if (res.data != null && res.data is Map<String, dynamic>) {
    return AppConfig.fromJson(res.data as Map<String, dynamic>);
  }

  return null;
});
