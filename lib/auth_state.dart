import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class AuthState with ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isLoading = false;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;

  final _storage = const FlutterSecureStorage();

  Future<void> _saveAccessToken(String token) async {
    await _storage.write(key: 'accessToken', value: token);
  }

  Future<String?> _getAccessToken() async {
    String? token = await _storage.read(key: 'accessToken');
    return token;
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void register(
      String name, String email, String password, BuildContext context) async {
    final body = {
      'name': name,
      'email': email,
      'password': password,
    };

    final response = await makeHttpRequest('register', {}, body, 'post');
    final jsonResponse = jsonDecode(response.body);
    String msg = jsonResponse['message'];
    if (!context.mounted) return;

    if (response.statusCode == 201) {
      final jsonResponse = jsonDecode(response.body);

      String token = jsonResponse['token'];
      _saveAccessToken(token);

      _isLoggedIn = true;
      context.go('/');
    }
    _showSnackBar(msg, context);
  }

  void login(String email, String password, BuildContext context) async {
    final body = {
      'email': email,
      'password': password,
    };

    final response = await makeHttpRequest('login', {}, body, 'post');
    final jsonResponse = jsonDecode(response.body);
    if (!context.mounted) return;

    if (response.statusCode == 201) {
      String token = jsonResponse['token'];
      _saveAccessToken(token);
      _isLoggedIn = true;
      context.go('/');
    }

    if (!context.mounted) return;
    _showSnackBar(jsonResponse['message'], context);
  }

  void logout(BuildContext context) async {
    _setLoading(true);
    String? accessToken = await _getAccessToken();
    final headers = {
      'Authorization': 'Bearer $accessToken',
    };

    final response = await makeHttpRequest('logout', headers, {}, 'post');
    final jsonResponse = jsonDecode(response.body);
    if (!context.mounted) return;

    _isLoggedIn = false;
    context.go('/welcome');
    _showSnackBar(jsonResponse['message'], context);
  }

  Future<List> getAllEvents(BuildContext context) async {
    String? accessToken = await _getAccessToken();
    final headers = {
      'Authorization': 'Bearer $accessToken',
    };

    final response = await makeHttpRequest('event/all', headers, {}, 'get');
    final jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 201) {
      print("2");
      List<dynamic> events = jsonResponse['events'];
      return events;
    }

    if (!context.mounted) return [];
    _showSnackBar("Errore nel reperire gli eventi", context);
    return [];
  }

  Future<bool> addEvent(
    String title,
    String description,
    DateTime dateTimeStart,
    DateTime dateTimeEnd,
    BuildContext context,
  ) async {
    String? accessToken = await _getAccessToken();
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    final body = {
      'title': title,
      'description': description,
      'date_time_start': dateTimeStart.toIso8601String(),
      'date_time_end': dateTimeEnd.toIso8601String(),
    };

    final response = await makeHttpRequest('event/add', headers, body, 'post');

    if (!context.mounted) return true;
    final jsonResponse = jsonDecode(response.body);
    String msg = jsonResponse['message'];
    _showSnackBar(msg, context);
    return true;
  }

  Future<bool> editEvent(
    String title,
    String description,
    DateTime dateTimeStart,
    DateTime dateTimeEnd,
    BuildContext context,
    int id,
  ) async {
    String? accessToken = await _getAccessToken();
    final headers = {
      'Authorization': 'Bearer $accessToken',
    };

    final body = {
      'title': title,
      'description': description,
      'date_time_start': dateTimeStart.toIso8601String(),
      'date_time_end': dateTimeEnd.toIso8601String(),
    };

    final response = await makeHttpRequest(
      'event/update/$id',
      headers,
      body,
      'put',
    );

    if (!context.mounted) return true;
    final jsonResponse = jsonDecode(response.body);
    String msg = jsonResponse['message'];
    _showSnackBar(msg, context);
    return true;
  }

  Future<bool> removeEvent(
    BuildContext context,
    int id,
  ) async {
    String? accessToken = await _getAccessToken();
    final headers = {
      'Authorization': 'Bearer $accessToken',
    };

    final response = await makeHttpRequest(
      'event/delete/$id',
      headers,
      {},
      'delete',
    );

    if (!context.mounted) return true;
    final jsonResponse = jsonDecode(response.body);
    String msg = jsonResponse['message'];
    _showSnackBar(msg, context);
    return true;
  }

  Future<Response> makeHttpRequest(
    String route,
    Map<String, String> iHeaders,
    Map<String, String> iBody,
    String method,
  ) async {
    Response response;
    final url = Uri.parse('http://51.20.8.36/api/$route');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    headers.addAll(iHeaders);
    final body = jsonEncode(iBody);

    _setLoading(true);
    switch (method) {
      case 'post':
        response = await http.post(url, headers: headers, body: body);
        break;
      case 'get':
        response = await http.get(url, headers: headers);
        break;
      case 'put':
        response = await http.put(url, headers: headers, body: body);
        break;
      case 'delete':
        response = await http.delete(url, headers: headers, body: body);
        break;
      default:
        response = http.Response('{"message": "Parametro method errato"}', 400);
    }
    _setLoading(false);

    return response;
  }

  Future<void> checkToken(BuildContext context) async {
    String? accessToken = await _getAccessToken();
    final headers = {
      'Authorization': 'Bearer $accessToken',
    };

    final response = await makeHttpRequest(
      'check-token',
      headers,
      {},
      'post',
    );

    if (response.statusCode == 201) {
      _isLoggedIn = true;
    }
  }
}

void _showSnackBar(String msg, BuildContext context) {
  var snackBar = SnackBar(
    content: Text(msg),
    backgroundColor: const Color.fromRGBO(168, 126, 255, 1),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(50),
    ),
    behavior: SnackBarBehavior.floating,
    duration: const Duration(seconds: 2),
    showCloseIcon: true,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
