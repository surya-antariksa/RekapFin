enum AppFlavor { dev, staging, prod }

class EnvConfig {
  final AppFlavor flavor;
  final String supabaseUrl;
  final String supabaseAnonKey;

  const EnvConfig({
    required this.flavor,
    required this.supabaseUrl,
    required this.supabaseAnonKey,
  });

  static EnvConfig fromEnvironment(AppFlavor flavor) {
    const url = String.fromEnvironment('SUPABASE_URL', defaultValue: '');
    const anonKey =
        String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: '');
    return EnvConfig(
      flavor: flavor,
      supabaseUrl: url,
      supabaseAnonKey: anonKey,
    );
  }

  bool get isConfigured => supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
}
