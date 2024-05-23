import 'dart:math';
import 'package:flutter_test/flutter_test.dart';

class Perhitungan {
  static double luasLingkaran({required double jarijari}) {
    double luas = pi * pow(jarijari, 2);
    return luas.ceilToDouble();
  }

  static double kelilingLingkaran(double jarijari) {
    double keliling = 2 * pi * jarijari;
    return keliling.ceilToDouble();
  }
}

void main() {
  test(
    'Luas Lingkaran Benar',
    () {
      double luasActual = Perhitungan.luasLingkaran(
        jarijari: 20,
      );
      double luasExpected = 1257.0;
      expect(luasActual, luasExpected);
    },
  );

  test(
    "Keliling Lingkaran",
    () {
      double kelilingActual = Perhitungan.kelilingLingkaran(20);
      double kelilingExpected = 126.0;
      expect(kelilingActual, kelilingExpected);
    },
  );
}
