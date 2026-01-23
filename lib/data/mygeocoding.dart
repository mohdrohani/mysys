import 'package:geocoding/geocoding.dart';

Future<String> getFullAddress(double lat, double lng) async {
  List<Placemark> placemarks =
      await placemarkFromCoordinates(lat, lng);

  Placemark place = placemarks.first;

  return '''
${place.street},
${place.subLocality},
${place.locality},
${place.administrativeArea},
${place.postalCode},
${place.country}
''';
}