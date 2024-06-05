import 'package:http/http.dart' as http;

class ServerError implements Exception {
  final http.Response response;

  ServerError(this.response);
}

class UnAthries implements Exception {
  String text;
  UnAthries(this.text);
  @override
  String toString() {
    return text;
  }
}
