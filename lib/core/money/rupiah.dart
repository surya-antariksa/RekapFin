import 'package:intl/intl.dart';

/// Kelas representasi nominal mata uang Rupiah sesuai aturan bisnis:
/// - BR-01: Disimpan sebagai integer murni (tanpa sen, tanpa float/double)
/// - BR-02: Format tampilan "Rp 1.250.000", satu karakter minus U+2212 (OI-16)
/// - Batas maksimum Rp 100 miliar per transaksi (WAL-02, CLAUDE.md)
class Rupiah implements Comparable<Rupiah> {
  final int amount;

  /// Batas transaksi maksimum Rp 100 miliar (100.000.000.000)
  static const int maxTransactionAmount = 100000000000;

  /// Karakter minus resmi U+2212 (OI-16)
  static const String minusSign = '\u2212';

  const Rupiah(this.amount);

  static const Rupiah zero = Rupiah(0);

  bool get isNegative => amount < 0;
  bool get isPositive => amount > 0;
  bool get isZero => amount == 0;

  Rupiah operator +(Rupiah other) => Rupiah(amount + other.amount);
  Rupiah operator -(Rupiah other) => Rupiah(amount - other.amount);
  Rupiah operator -() => Rupiah(-amount);

  @override
  int compareTo(Rupiah other) => amount.compareTo(other.amount);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Rupiah &&
          runtimeType == other.runtimeType &&
          amount == other.amount;

  @override
  int get hashCode => amount.hashCode;

  /// Format rupiah standar: "Rp 1.250.000", "Rp 0", atau "−Rp 45.000" (U+2212)
  /// Jika [includePositiveSign] bernilai true dan nominal positif: "+Rp 1.250.000"
  String format({bool includePositiveSign = false}) {
    final absAmount = amount.abs();
    final buffer = StringBuffer();

    // Format titik ribuan id_ID
    final formattedDigits =
        NumberFormat('#,###', 'id_ID').format(absAmount).replaceAll(',', '.');

    if (amount < 0) {
      buffer.write(minusSign);
    } else if (includePositiveSign && amount > 0) {
      buffer.write('+');
    }

    buffer.write('Rp $formattedDigits');
    return buffer.toString();
  }

  /// Format ringkas untuk kartu ringkas sesuai BR-02:
  /// Contoh: "Rp 24,8 jt", "Rp 1,5 M", "Rp 500 rb"
  String formatCompact() {
    final abs = amount.abs();
    final sign = amount < 0 ? minusSign : '';

    String formatUnit(double val, String unit) {
      // Pembulatan 1 desimal setengah ke atas
      final rounded = ((val * 10).round() / 10);
      final str = rounded.toStringAsFixed(1).replaceAll('.', ',');
      final trimmed =
          str.endsWith(',0') ? str.substring(0, str.length - 2) : str;
      return '$sign' 'Rp $trimmed $unit';
    }

    if (abs >= 1000000000000) {
      return formatUnit(abs / 1000000000000.0, 'T');
    } else if (abs >= 1000000000) {
      return formatUnit(abs / 1000000000.0, 'M');
    } else if (abs >= 1000000) {
      return formatUnit(abs / 1000000.0, 'jt');
    } else if (abs >= 1000) {
      return formatUnit(abs / 1000.0, 'rb');
    }
    return format();
  }

  /// Fungsi pembantu statis untuk memformat nominal integer langsung
  static String formatAmount(int amount, {bool includePositiveSign = false}) {
    return Rupiah(amount).format(includePositiveSign: includePositiveSign);
  }

  /// Fungsi pembantu statis untuk format ringkas nominal integer langsung
  static String formatAmountCompact(int amount) {
    return Rupiah(amount).formatCompact();
  }

  @override
  String toString() => format();
}
