import 'show.dart';

// R7: screens and ShowsModel only know this interface; main.dart picks
// HttpShowsRepository or FakeShowsRepository.
abstract interface class ShowsRepository {
  Future<List<Show>> search(String query);

  Future<Show> getById(int id);
}
