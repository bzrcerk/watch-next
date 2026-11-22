class ShowImage {
  const ShowImage({required this.medium, required this.original});

  factory ShowImage.fromJson(Map<String, dynamic> json) => ShowImage(
    medium: json['medium'] as String,
    original: json['original'] as String,
  );

  final String medium;
  final String original;

  Map<String, dynamic> toJson() => {'medium': medium, 'original': original};

  ShowImage copyWith({String? medium, String? original}) => ShowImage(
    medium: medium ?? this.medium,
    original: original ?? this.original,
  );
}
