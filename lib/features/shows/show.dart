import 'network.dart';
import 'schedule.dart';
import 'show_image.dart';

class Show {
  const Show({
    required this.id,
    required this.name,
    required this.genres,
    required this.schedule,
    required this.url,
    this.status,
    this.premiered,
    this.ended,
    this.rating,
    this.image,
    this.network,
    this.officialSite,
    this.summary,
  });

  // Casts that fail throw TypeError; the repository turns that into
  // BadResponseException('shows.<field>: …') (R15). No `!` here (R14).
  factory Show.fromJson(Map<String, dynamic> json) {
    final premiered = json['premiered'] as String?;
    final ended = json['ended'] as String?;
    final rating = json['rating'] as Map<String, dynamic>?;
    final image = json['image'] as Map<String, dynamic>?;
    final network = json['network'] as Map<String, dynamic>?;
    return Show(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      genres: [for (final genre in json['genres'] as List) genre as String],
      status: json['status'] as String?,
      premiered: premiered == null ? null : DateTime.parse(premiered),
      ended: ended == null ? null : DateTime.parse(ended),
      rating: (rating?['average'] as num?)?.toDouble(),
      image: image == null ? null : ShowImage.fromJson(image),
      network: network == null ? null : Network.fromJson(network),
      schedule: Schedule.fromJson(json['schedule'] as Map<String, dynamic>),
      officialSite: json['officialSite'] as String?,
      url: json['url'] as String,
      summary: json['summary'] as String?,
    );
  }

  final int id;
  final String name;
  final List<String> genres;
  final String? status;
  final DateTime? premiered;
  final DateTime? ended;
  final double? rating;
  final ShowImage? image;
  final Network? network;
  final Schedule schedule;
  final String? officialSite;
  final String url;
  final String? summary; // HTML from TVMaze; show plainSummary instead.

  // R16: derived values live on the model, never in build().
  String get plainSummary =>
      (summary ?? '').replaceAll(RegExp(r'<[^>]*>'), '').trim();

  bool get isRunning => ended == null;

  String get yearsLabel {
    final start = premiered;
    if (start == null) return '';
    return '${start.year}–${ended?.year ?? ''}';
  }

  // Same shape as TVMaze, so the cache can store toJson and read fromJson.
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'genres': genres,
    'status': status,
    'premiered': premiered?.toIso8601String().split('T').first,
    'ended': ended?.toIso8601String().split('T').first,
    'rating': {'average': rating},
    'image': image?.toJson(),
    'network': network?.toJson(),
    'schedule': schedule.toJson(),
    'officialSite': officialSite,
    'url': url,
    'summary': summary,
  };

  Show copyWith({
    int? id,
    String? name,
    List<String>? genres,
    String? status,
    DateTime? premiered,
    DateTime? ended,
    double? rating,
    ShowImage? image,
    Network? network,
    Schedule? schedule,
    String? officialSite,
    String? url,
    String? summary,
  }) => Show(
    id: id ?? this.id,
    name: name ?? this.name,
    genres: genres ?? this.genres,
    status: status ?? this.status,
    premiered: premiered ?? this.premiered,
    ended: ended ?? this.ended,
    rating: rating ?? this.rating,
    image: image ?? this.image,
    network: network ?? this.network,
    schedule: schedule ?? this.schedule,
    officialSite: officialSite ?? this.officialSite,
    url: url ?? this.url,
    summary: summary ?? this.summary,
  );
}
