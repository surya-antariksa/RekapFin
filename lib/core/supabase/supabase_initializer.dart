import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:rekap_fin/core/config/env_config.dart';

class SupabaseInitializer {
  static Future<void> init(EnvConfig config) async {
    if (config.isConfigured) {
      await Supabase.initialize(
        url: config.supabaseUrl,
        // ignore: deprecated_member_use
        anonKey: config.supabaseAnonKey,
      );
    } else {
      if (kDebugMode) {
        // Log notification that SUPABASE_URL and SUPABASE_ANON_KEY are not provided yet.
        // During Sprint 0 placeholder phase, app will run in offline/unconnected mode.
      }
    }
  }
}
