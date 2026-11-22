import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../storage/secure_store.dart';
import 'api_exception.dart';

// The only place the timeout is set (pool task 3).
const kRequestTimeout = Duration(seconds: 10);

class ApiClient {
  // Callers still write `host:` and `store:` (private named parameters).
  ApiClient(this._client, {required this._host, required this._store});

  final http.Client _client;
  final String _host;
  final SecureStore _store;

  Future<Object?> get(String path, {Map<String, String>? query}) =>
      _send('GET', path, query: query, ok: const {200});

  Future<Object?> post(String path, Map<String, Object?> body) =>
      _send('POST', path, body: body, ok: const {201});

  Future<Object?> put(String path, Map<String, Object?> body) =>
      _send('PUT', path, body: body, ok: const {200});

  Future<Object?> delete(String path) =>
      _send('DELETE', path, ok: const {200, 204});

  Future<Object?> _send(
    String method,
    String path, {
    required Set<int> ok,
    Map<String, String>? query,
    Map<String, Object?>? body,
  }) async {
    final request = http.Request(method, Uri.https(_host, path, query));
    // R9: the token is added here and nowhere else.
    final token = await _store.readToken();
    if (token != null) request.headers['Authorization'] = 'Bearer $token';
    if (body != null) {
      request.headers['Content-Type'] = 'application/json';
      request.body = jsonEncode(body);
    }

    final watch = Stopwatch()..start();
    final http.Response response;
    try {
      response = await _client
          .send(request)
          .then(http.Response.fromStream)
          .timeout(kRequestTimeout);
    } on SocketException {
      throw const NoConnectionException();
    } on TimeoutException {
      throw const NoConnectionException();
    }
    // R11: debug only, never the token or the headers.
    if (kDebugMode) {
      log(
        '$method $path ${response.statusCode} ${watch.elapsedMilliseconds} ms',
        name: 'api',
      );
    }

    _check(response, method, path, ok);
    return _decode(response, path);
  }

  // Status is checked before the body is decoded.
  void _check(http.Response response, String method, String path, Set<int> ok) {
    final status = response.statusCode;
    if (ok.contains(status)) return;
    if (status == 401) throw const UnauthorizedException();
    if (status == 404) throw const NotFoundException();
    if (status >= 400 && status < 500) throw ClientException(status);
    if (status >= 500) throw ServerException(status);
    // A 2xx/3xx we did not expect, e.g. 200 where create must give 201 (R8).
    throw BadResponseException('$method $path: expected $ok, got $status');
  }

  Object? _decode(http.Response response, String path) {
    if (response.body.isEmpty) return null; // 204 on delete
    try {
      return jsonDecode(response.body);
    } on FormatException {
      throw BadResponseException('$path: body is not JSON');
    }
  }
}
