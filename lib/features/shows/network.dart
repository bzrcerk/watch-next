import 'country.dart';

class Network {
  const Network({required this.id, required this.name, this.country});

  factory Network.fromJson(Map<String, dynamic> json) {
    final country = json['country'] as Map<String, dynamic>?;
    return Network(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      // Nested twice: Show → Network → Country, each with its own fromJson.
      country: country == null ? null : Country.fromJson(country),
    );
  }

  final int id;
  final String name;
  final Country? country;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'country': country?.toJson(),
  };

  Network copyWith({int? id, String? name, Country? country}) => Network(
    id: id ?? this.id,
    name: name ?? this.name,
    country: country ?? this.country,
  );
}
