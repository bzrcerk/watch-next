class Country {
  const Country({required this.name, required this.code});

  factory Country.fromJson(Map<String, dynamic> json) =>
      Country(name: json['name'] as String, code: json['code'] as String);

  final String name;
  final String code;

  Map<String, dynamic> toJson() => {'name': name, 'code': code};

  Country copyWith({String? name, String? code}) =>
      Country(name: name ?? this.name, code: code ?? this.code);
}
