import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:watch_next_f/features/shows/show.dart';

// Shape of GET /shows/169 on TVMaze (trimmed). Replace with your Postman copy.
const _breakingBad = '''
{
  "id": 169,
  "url": "https://www.tvmaze.com/shows/169/breaking-bad",
  "name": "Breaking Bad",
  "type": "Scripted",
  "genres": ["Drama", "Crime", "Thriller"],
  "status": "Ended",
  "premiered": "2008-01-20",
  "ended": "2013-09-29",
  "officialSite": "http://www.amc.com/shows/breaking-bad",
  "schedule": {"time": "22:00", "days": ["Sunday"]},
  "rating": {"average": 9},
  "network": {
    "id": 20,
    "name": "AMC",
    "country": {"name": "United States", "code": "US", "timezone": "America/New_York"}
  },
  "webChannel": null,
  "image": {
    "medium": "https://static.tvmaze.com/uploads/images/medium_portrait/501/1253519.jpg",
    "original": "https://static.tvmaze.com/uploads/images/original_untouched/501/1253519.jpg"
  },
  "summary": "<p><b>Breaking Bad</b> follows a chemistry teacher.</p>"
}
''';

Map<String, dynamic> _json() =>
    jsonDecode(_breakingBad) as Map<String, dynamic>;

void main() {
  // Test 1
  test('fromJson parses real TVMaze JSON, network → country included', () {
    final show = Show.fromJson(_json());

    expect(show.id, 169);
    expect(show.rating, 9.0); // int 9 in JSON, read as num → double
    expect(show.network?.country?.name, 'United States');
    expect(show.schedule.days, ['Sunday']);
    expect(show.premiered, DateTime(2008, 1, 20));
    expect(show.yearsLabel, '2008–2013');
    expect(show.isRunning, isFalse);
    expect(show.plainSummary, 'Breaking Bad follows a chemistry teacher.');
  });

  // Test 2
  test('fromJson with a wrong type throws TypeError', () {
    final json = _json()..['id'] = '169';

    expect(() => Show.fromJson(json), throwsA(isA<TypeError>()));
  });

  test('toJson → fromJson round-trips', () {
    final show = Show.fromJson(_json());
    final again = Show.fromJson(show.toJson());

    expect(again.toJson(), show.toJson());
  });

  test('nullable parts may be null; running show has an open yearsLabel', () {
    final json = _json()
      ..['network'] = null
      ..['image'] = null
      ..['ended'] = null
      ..['rating'] = {'average': null};
    final show = Show.fromJson(json);

    expect(show.network, isNull);
    expect(show.rating, isNull);
    expect(show.isRunning, isTrue);
    expect(show.yearsLabel, '2008–');
  });
}
