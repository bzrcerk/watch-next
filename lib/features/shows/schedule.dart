class Schedule {
  const Schedule({required this.time, required this.days});

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
    time: json['time'] as String,
    // Each element is cast now, so a wrong type fails inside fromJson.
    days: [for (final day in json['days'] as List) day as String],
  );

  final String time;
  final List<String> days;

  Map<String, dynamic> toJson() => {'time': time, 'days': days};

  Schedule copyWith({String? time, List<String>? days}) =>
      Schedule(time: time ?? this.time, days: days ?? this.days);
}
