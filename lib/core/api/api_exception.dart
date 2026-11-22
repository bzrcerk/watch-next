// R6: sealed, so a `switch` over ApiException without `default` must name
// every subclass — adding one breaks every screen until it is handled.
// All subclasses live in this file because Dart requires it for `sealed`.
sealed class ApiException implements Exception {
  const ApiException();
}

/// SocketException or TimeoutException (kRequestTimeout).
final class NoConnectionException extends ApiException {
  const NoConnectionException();
}

/// 401.
final class UnauthorizedException extends ApiException {
  const UnauthorizedException();
}

/// 404.
final class NotFoundException extends ApiException {
  const NotFoundException();
}

/// Any other 4xx (429 too, for now).
final class ClientException extends ApiException {
  const ClientException(this.status);
  final int status;
}

/// 5xx.
final class ServerException extends ApiException {
  const ServerException(this.status);
  final int status;
}

/// Body is not the JSON we expected: FormatException or a failed cast (R15).
final class BadResponseException extends ApiException {
  const BadResponseException(this.detail);
  final String detail;

  @override
  String toString() => 'BadResponseException: $detail';
}
