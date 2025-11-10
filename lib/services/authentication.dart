import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';

class AuthService {
  final String baseUrl = 'http://127.0.0.1:8000/api';
  final _storage = const FlutterSecureStorage();

  // Save tokens
  Future<void> _saveTokens(String access, String refresh) async {
    await _storage.write(key: 'access_token', value: access);
    await _storage.write(key: 'refresh_token', value: refresh);
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: 'access_token');
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: 'refresh_token');
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
  }

  // ---------------------------
  // REGISTER
  // ---------------------------
  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    final url = Uri.parse('$baseUrl/register/');
    final body = jsonEncode({
      "username": username,
      "email": email,
      "password": password,
      "first_name": firstName,
      "last_name": lastName,
    });

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    final responseBody = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Extract tokens and user
      final access = responseBody['access'];
      final refresh = responseBody['refresh'];
      final userJson = responseBody['user'];

      await _saveTokens(access, refresh);

      final user = User.fromJson(userJson);
      return {"user": user, "access": access, "refresh": refresh};
    } else {
      throw Exception(responseBody['detail'] ?? 'Registration failed');
    }
  }

  // ---------------------------
  // LOGIN
  // ---------------------------
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    // Adapt if your backend uses another endpoint like /api/token/
    final url = Uri.parse('$baseUrl/login/');
    final body = jsonEncode({"email": email, "password": password});

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    final responseBody = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final access = responseBody['access'];
      final refresh = responseBody['refresh'];

      // If your login also returns "user", parse it; if not, fetch it separately
      final userJson = responseBody['user'];

      await _saveTokens(access, refresh);

      final user = userJson != null ? User.fromJson(userJson) : null;

      return {"user": user, "access": access, "refresh": refresh};
    } else {
      throw Exception(responseBody['detail'] ?? 'Login failed');
    }
  }

  // ---------------------------
  // FETCH CURRENT USER (optional)
  // ---------------------------
  Future<User> getCurrentUser() async {
    final access = await getAccessToken();
    if (access == null) {
      throw Exception('No access token found');
    }

    final url = Uri.parse('$baseUrl/user/me/'); // change to your endpoint
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $access",
        "Content-Type": "application/json",
      },
    );

    final responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return User.fromJson(responseBody);
    } else {
      throw Exception(responseBody['detail'] ?? 'Failed to fetch user');
    }
  }
}
