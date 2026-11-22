import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:watch_next_f/core/api/api_client.dart';
import 'package:watch_next_f/core/api/api_exception.dart';
import 'package:watch_next_f/core/storage/secure_store.dart';

class _FakeStore implements SecureStore {
  _FakeStore(this.token);

  final String? token;

  @override
  Future<String?> readToken() async => token;
}

ApiClient _client(MockClientHandler handler, {String? token}) => ApiClient(
  MockClient(handler),
  host: 'example.com',
  store: _FakeStore(token),
);

void main() {
  // Test 5
  test('404 → NotFoundException', () {
    final api = _client((_) async => http.Response('', 404));

    expect(api.get('/shows/0'), throwsA(isA<NotFoundException>()));
  });

  // Test 6
  test('500 → ServerException with the status', () {
    final api = _client((_) async => http.Response('', 500));

    expect(
      api.get('/shows/1'),
      throwsA(isA<ServerException>().having((e) => e.status, 'status', 500)),
    );
  });

  // Test 7
  test('SocketException → NoConnectionException', () {
    final api = _client((_) => throw const SocketException('offline'));

    expect(api.get('/shows/1'), throwsA(isA<NoConnectionException>()));
  });

  test('200 decodes JSON; Bearer token and Uri.https query are sent', () async {
    late http.Request sent;
    final api = _client((request) async {
      sent = request;
      return http.Response('[{"score": 1}]', 200);
    }, token: 'tok_1');

    final body = await api.get('/search/shows', query: {'q': 'bad'});

    expect(body, [
      {'score': 1},
    ]);
    expect(sent.url.toString(), 'https://example.com/search/shows?q=bad');
    expect(sent.headers['Authorization'], 'Bearer tok_1');
  });

  test('a body that is not JSON → BadResponseException', () {
    final api = _client((_) async => http.Response('<html>', 200));

    expect(api.get('/shows/1'), throwsA(isA<BadResponseException>()));
  });

  test('create must answer 201, delete accepts 204 with no body', () async {
    final created = _client((_) async => http.Response('{}', 200));
    final deleted = _client((_) async => http.Response('', 204));

    expect(
      created.post('/watchlist', {}),
      throwsA(isA<BadResponseException>()),
    );
    expect(await deleted.delete('/watchlist/1'), isNull);
  });
}
