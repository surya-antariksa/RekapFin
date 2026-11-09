import 'package:flutter_test/flutter_test.dart';
import 'package:rekap_fin/core/money/rupiah.dart';

void main() {
  group('Rupiah (BR-01 & BR-02)', () {
    test('BR-01: Disimpan sebagai integer murni', () {
      const r1 = Rupiah(1250000);
      expect(r1.amount, isA<int>());
      expect(r1.amount, equals(1250000));

      const r2 = Rupiah(500000);
      expect((r1 + r2).amount, equals(1750000));
      expect((r1 - r2).amount, equals(750000));
      expect((-r1).amount, equals(-1250000));
    });

    test('Batas transaksi maksimum Rp 100 miliar', () {
      expect(Rupiah.maxTransactionAmount, equals(100000000000));
      const r = Rupiah(Rupiah.maxTransactionAmount);
      expect(r.amount, equals(100000000000));
    });

    test(
        'BR-02: Format rupiah standar dengan titik ribuan dan spasi setelah Rp',
        () {
      expect(const Rupiah(1250000).format(), equals('Rp 1.250.000'));
      expect(const Rupiah(0).format(), equals('Rp 0'));
      expect(const Rupiah(500).format(), equals('Rp 500'));
      expect(const Rupiah(24750000).format(), equals('Rp 24.750.000'));
      expect(Rupiah.formatAmount(18500000), equals('Rp 18.500.000'));
    });

    test('BR-02 & OI-16: Format negatif memakai satu karakter minus U+2212',
        () {
      final formattedNegative = const Rupiah(-45000).format();
      expect(formattedNegative, equals('\u2212Rp 45.000'));
      // Verifikasi karakter minus adalah U+2212 ('−'), bukan tanda hubung ASCII '-'
      expect(formattedNegative.startsWith('\u2212'), isTrue);
      expect(formattedNegative.startsWith('-'), isFalse);
    });

    test('Format dengan tanda positif eksplisit (+Rp n) untuk pemasukan', () {
      expect(
        const Rupiah(8500000).format(includePositiveSign: true),
        equals('+Rp 8.500.000'),
      );
      // Nol tidak diberi tanda plus
      expect(
        const Rupiah(0).format(includePositiveSign: true),
        equals('Rp 0'),
      );
      // Negatif tetap memakai U+2212
      expect(
        const Rupiah(-50000).format(includePositiveSign: true),
        equals('\u2212Rp 50.000'),
      );
    });

    test('BR-02: Format ringkas untuk kartu ringkas', () {
      expect(const Rupiah(24800000).formatCompact(), equals('Rp 24,8 jt'));
      expect(const Rupiah(1500000000).formatCompact(), equals('Rp 1,5 M'));
      expect(const Rupiah(500000).formatCompact(), equals('Rp 500 rb'));
      expect(const Rupiah(-1500000).formatCompact(), equals('\u2212Rp 1,5 jt'));
      expect(const Rupiah(1000000).formatCompact(), equals('Rp 1 jt'));
    });

    test('Perbandingan dan kesetaraan nilai Rupiah', () {
      const a = Rupiah(10000);
      const b = Rupiah(10000);
      const c = Rupiah(20000);

      expect(a, equals(b));
      expect(a == b, isTrue);
      expect(a.hashCode, equals(b.hashCode));
      expect(a.compareTo(c), isNegative);
      expect(c.compareTo(a), isPositive);
    });
  });
}
