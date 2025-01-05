// geolocation_calculator.dart
import 'dart:math';
import 'package:geolocator/geolocator.dart';

class GeolocationCalculator {
  // Haversine formülü ile iki nokta arasındaki mesafeyi hesaplamak
  double haversine(double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371; // Dünya'nın yarıçapı (km)
    final double phi1 = _degreesToRadians(lat1);
    final double phi2 = _degreesToRadians(lat2);
    final double deltaPhi = _degreesToRadians(lat2 - lat1);
    final double deltaLambda = _degreesToRadians(lon2 - lon1);

    final double a = sin(deltaPhi / 2) * sin(deltaPhi / 2) +
        cos(phi1) * cos(phi2) * sin(deltaLambda / 2) * sin(deltaLambda / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c; // km cinsinden mesafe
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  // Geolocation listesindeki tüm mesafeleri hesaplayan ve toplam süreyi veren fonksiyon
  Future<double> toplamGeziSuresi(List<Position> konumlar, double hiz) async {
    double toplamMesafe = 0;

    // Geolocation çiftlerinin üzerinden geçme (tüm ardışık konumlar arasındaki mesafeyi hesapla)
    for (int i = 0; i < konumlar.length - 1; i++) {
      final lat1 = konumlar[i].latitude;
      final lon1 = konumlar[i].longitude;
      final lat2 = konumlar[i + 1].latitude;
      final lon2 = konumlar[i + 1].longitude;

      final mesafe = haversine(lat1, lon1, lat2, lon2);
      toplamMesafe += mesafe;
    }

    // Toplam mesafeyi verilen hızla (km/saat) bölerek süreyi hesapla (saat cinsinden)
    return toplamMesafe / hiz; // Saat cinsinden
  }
}
