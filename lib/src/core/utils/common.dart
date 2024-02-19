import 'dart:math';

/// Calculates the distance between two coordinates using the Haversine formula.
/// @param lat1,lon1 The latitude and longitude of the first coordinate.
/// @param lat2,lon2 The latitude and longitude of the second coordinate.
/// @return The distance between the two coordinates in kilometers.
double calculateDistanceBetweenTwoLatAndLong({required double? lat1, required double? lon1, required double? lat2, required double? lon2}) {
  if (lat1 == null || lon1 == null || lat2 == null || lon2 == null) return 10.0;

  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 - c((lat2 - lat1) * p) / 2 + c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a));
}

String formatAddress({
  String? name,
  String? administrativeArea,
  String? subAdministrativeArea,
  String? country,
  String? postalCode,
}) {
  // List to store non-null address components
  List<String> addressComponents = [];

  // Add non-null address components to the list
  if (name != null) addressComponents.add(name);
  if (administrativeArea != null) addressComponents.add(administrativeArea);
  if (subAdministrativeArea != null) addressComponents.add(subAdministrativeArea);
  if (country != null) addressComponents.add(country);
  if (postalCode != null) addressComponents.add(postalCode);

  // Join the address components using ', '
  String formattedAddress = addressComponents.join(', ');

  return formattedAddress;
}

String getCurrentLocation(placemark) {
  String name = placemark!.first.name ?? "";
  String administrativeArea = placemark!.first.administrativeArea ?? "";
  String subAdministrativeArea = placemark!.first.subAdministrativeArea ?? "";
  String country = placemark!.first.country ?? "";
  String postalCode = placemark!.first.postalCode ?? "";
  for (var element in placemark!) {
    if (!name.contains(element.name ?? "")) {
      name += ", ${element.name}";
    }
    if (!administrativeArea.contains(element.administrativeArea ?? "")) {
      administrativeArea += ", ${element.administrativeArea}";
    }
    if (!subAdministrativeArea.contains(element.subAdministrativeArea ?? "")) {
      subAdministrativeArea += ", ${element.subAdministrativeArea}";
    }
    if (!country.contains(element.country ?? "")) {
      country += ", ${element.country}";
    }
    if (!postalCode.contains(element.postalCode ?? "")) {
      postalCode += ", ${element.postalCode}";
    }
    return formatAddress(
      name: name,
      administrativeArea: administrativeArea,
      subAdministrativeArea: subAdministrativeArea,
      country: country,
      postalCode: postalCode,
    );
  }
  return formatAddress(
    name: name,
    administrativeArea: administrativeArea,
    subAdministrativeArea: subAdministrativeArea,
    country: country,
    postalCode: postalCode,
  );
}
