import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AuthState with ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isLoading = false; // Aggiungi lo stato di caricamento
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading; // Getter per lo stato di caricamento

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
    _setLoading(true);
    final url = Uri.parse('http://51.20.8.36/api/register');
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };

    final body = {
      'name': name,
      'email': email,
      'password': password,
    };

    final jsonBody = jsonEncode(body);

    final response = await http.post(url, headers: headers, body: jsonBody);
    final jsonResponse = jsonDecode(response.body);
    String msg = jsonResponse['message'];
    _setLoading(false);
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
    _setLoading(true);
    final url = Uri.parse('http://51.20.8.36/api/login');
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };

    final body = {
      'email': email,
      'password': password,
    };

    final jsonBody = jsonEncode(body);

    final response = await http.post(url, headers: headers, body: jsonBody);
    final jsonResponse = jsonDecode(response.body);
    String msg = jsonResponse['message'];
    _setLoading(false);
    if (!context.mounted) return;

    if (response.statusCode == 201) {
      String token = jsonResponse['token'];
      _saveAccessToken(token);
      _isLoggedIn = true;
      context.go('/');
    }

    _showSnackBar(msg, context);
  }

  void logout(BuildContext context) async {
    _setLoading(true);
    String? accessToken = await _getAccessToken();
    final url = Uri.parse('http://51.20.8.36/api/logout');
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    final response = await http.post(url, headers: headers);
    final jsonResponse = jsonDecode(response.body);
    String msg = jsonResponse['message'];
    _setLoading(false);
    if (!context.mounted) return;

    if (response.statusCode == 201) {
      _isLoggedIn = false;
      context.go('/register');
    } else {
      _isLoggedIn = false;
      context.go('/login');
    }
    _showSnackBar(msg, context);
  }

  Future<List> getAllEvents(BuildContext context) async {
    String? accessToken = await _getAccessToken();
    final url = Uri.parse('http://51.20.8.36/api/event/all');
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    final response = await http.get(url, headers: headers);
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

  void addEvent(String title, String description, DateTime dateTimeStart,
      DateTime dateTimeEnd, BuildContext context) async {
    String? accessToken = await _getAccessToken();
    final url = Uri.parse('http://51.20.8.36/api/event/add');
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

    print(body);

    final jsonBody = jsonEncode(body);

    _setLoading(true);
    final response = await http.post(url, headers: headers, body: jsonBody);
    _setLoading(false);
    if (!context.mounted) return;
    final jsonResponse = jsonDecode(response.body);
    String msg = jsonResponse['message'];
    _showSnackBar(msg, context);
  }

  void editEvent(String title, String description, DateTime dateTimeStart,
      DateTime dateTimeEnd, BuildContext context, int id) async {
    String? accessToken = await _getAccessToken();
    final url = Uri.parse('http://51.20.8.36/api/event/update/$id');
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

    final jsonBody = jsonEncode(body);

    _setLoading(true);
    final response = await http.put(url, headers: headers, body: jsonBody);
    _setLoading(false);
    if (!context.mounted) return;
    final jsonResponse = jsonDecode(response.body);
    String msg = jsonResponse['message'];
    _showSnackBar(msg, context);
  }
}

void _showSnackBar(String msg, BuildContext context) {
  var snackBar = SnackBar(content: Text(msg));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
