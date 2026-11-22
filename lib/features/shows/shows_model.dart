import 'package:flutter/foundation.dart';

import '../../core/api/api_exception.dart';
import 'show.dart';
import 'shows_repository.dart';

// R17: owns loading / error / items. No BuildContext, Navigator or SnackBar.
class ShowsModel extends ChangeNotifier {
  ShowsModel(this._repository);

  final ShowsRepository _repository;

  String _query = '';
  List<Show> _items = const [];
  bool _loading = false;
  ApiException? _error;

  String get query => _query;
  List<Show> get items => _items;
  bool get loading => _loading;
  ApiException? get error => _error;

  Future<void> search(String text) async {
    final query = text.trim();
    _query = query;
    _error = null;
    if (query.isEmpty) {
      _items = const [];
      _loading = false;
      notifyListeners();
      return;
    }
    _loading = true;
    notifyListeners();
    try {
      final items = await _repository.search(query);
      if (query != _query) return; // a newer search started meanwhile
      _items = items;
    } on ApiException catch (e) {
      if (query != _query) return;
      _error = e;
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> retry() => search(_query);
}
