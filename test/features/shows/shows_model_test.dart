import 'package:flutter_test/flutter_test.dart';
import 'package:watch_next_f/core/api/api_exception.dart';
import 'package:watch_next_f/features/shows/fake_shows_repository.dart';
import 'package:watch_next_f/features/shows/shows_model.dart';

void main() {
  // Test 3
  test('search with the fake fills items', () async {
    final model = ShowsModel(FakeShowsRepository());

    await model.search('breaking');

    expect(model.items.map((s) => s.name), ['Breaking Bad']);
    expect(model.loading, isFalse);
    expect(model.error, isNull);
  });

  // Test 4
  test('search with a failing fake sets NoConnectionException', () async {
    final model = ShowsModel(FakeShowsRepository(fail: true));

    await model.search('breaking');

    expect(model.error, isA<NoConnectionException>());
    expect(model.loading, isFalse);
  });

  test('an empty query clears items without calling the repository', () async {
    final model = ShowsModel(FakeShowsRepository(fail: true));

    await model.search('   ');

    expect(model.items, isEmpty);
    expect(model.error, isNull);
  });
}
