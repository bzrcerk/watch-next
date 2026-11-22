import '../../core/api/api_exception.dart';
import 'network.dart';
import 'country.dart';
import 'schedule.dart';
import 'show.dart';
import 'shows_repository.dart';

// Deterministic: always the same three shows. `fail: true` throws
// NoConnectionException, so the error state can be shown offline.
class FakeShowsRepository implements ShowsRepository {
  FakeShowsRepository({this.fail = false, this.delay = Duration.zero});

  final bool fail;
  final Duration delay;

  static final _shows = [
    Show(
      id: 169,
      name: 'Breaking Bad',
      genres: const ['Drama', 'Crime', 'Thriller'],
      status: 'Ended',
      premiered: DateTime(2008, 1, 20),
      ended: DateTime(2013, 9, 29),
      rating: 9.2,
      network: const Network(
        id: 20,
        name: 'AMC',
        country: Country(name: 'United States', code: 'US'),
      ),
      schedule: const Schedule(time: '22:00', days: ['Sunday']),
      url: 'https://www.tvmaze.com/shows/169/breaking-bad',
      summary: '<p>A chemistry teacher turns to making meth.</p>',
    ),
    Show(
      id: 82,
      name: 'Game of Thrones',
      genres: const ['Drama', 'Adventure', 'Fantasy'],
      status: 'Ended',
      premiered: DateTime(2011, 4, 17),
      ended: DateTime(2019, 5, 19),
      rating: 8.9,
      network: const Network(
        id: 8,
        name: 'HBO',
        country: Country(name: 'United States', code: 'US'),
      ),
      schedule: const Schedule(time: '21:00', days: ['Sunday']),
      url: 'https://www.tvmaze.com/shows/82/game-of-thrones',
      summary: '<p>Noble families fight for the <b>Iron Throne</b>.</p>',
    ),
    Show(
      id: 44458,
      name: 'Severance',
      genres: const ['Drama', 'Mystery', 'Science-Fiction'],
      status: 'Running',
      premiered: DateTime(2022, 2, 18),
      schedule: const Schedule(time: '', days: ['Friday']),
      url: 'https://www.tvmaze.com/shows/44458/severance',
    ),
  ];

  @override
  Future<List<Show>> search(String query) async {
    await Future<void>.delayed(delay);
    if (fail) throw const NoConnectionException();
    final q = query.toLowerCase();
    return [
      for (final show in _shows)
        if (show.name.toLowerCase().contains(q)) show,
    ];
  }

  @override
  Future<Show> getById(int id) async {
    await Future<void>.delayed(delay);
    if (fail) throw const NoConnectionException();
    for (final show in _shows) {
      if (show.id == id) return show;
    }
    throw const NotFoundException();
  }
}
