import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'http://10.0.2.2:8000/api/';

  // ======================
  // LOGIN
  // ======================
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${baseUrl}login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email_user': email,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    // Simpan token jika login berhasil
    if (response.statusCode == 200 && data['token'] != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
    }

    return data;
  }

  // ======================
  // REGISTER
  // ======================
  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('${baseUrl}register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nama_user': name,
        'email_user': email,
        'password': password,
        'password_confirmation': password,
      }),
    );

    return jsonDecode(response.body);
  }

  // ======================
  // GET PROFILE
  // ======================
  Future<Map<String, dynamic>> getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('${baseUrl}account/me'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    return jsonDecode(response.body);
  }
}
