// lib/auth/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static const String baseUrl = /*'http://192.168.1.80:1337/api'*/ 'http://192.168.14.170:1337/api' ;
  static const String tokenKey = 'jwtToken';
  static const String roleKey = 'role';

  // Instance untuk penyimpanan secure
  static final _storage = FlutterSecureStorage();

  // Fungsi untuk mendapatkan JWT dari secure storage
  static Future<String?> getJwtToken() async {
    return await _storage.read(key: tokenKey);
  }

  // Fungsi untuk menyimpan JWT token di FlutterSecureStorage
  static Future<void> saveJwtToken(String token) async {
    await _storage.write(key: tokenKey, value: token);
  }

  // Fungsi untuk menghapus JWT token
  static Future<void> deleteJwtToken() async {
    await _storage.delete(key: tokenKey);
  }

  // fungsi untuk mendapatkan role dari FlutterSecureStorage
  static Future<String?> getRole() async {
    return await _storage.read(key: 'role');
  }

  // Fungsi untuk menyimpan role user di secure storage
  static Future<void> saveRole(String role) async {
    await _storage.write(key: roleKey, value: role);
  }

  // Fungsi login
  static Future<void> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/local'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'identifier': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Ambil token dari respons
      final token = data['jwt'];
      if (token == null) {
        throw Exception('Login response invalid: Missing JWT token');
      }

      // Simpan token di storage
      await saveJwtToken(token);

      // Ambil data user
      final user = data['user'];
      if (user == null) {
        throw Exception('Login response invalid: Missing user data');
      }

      // Ambil role pengguna
      final role = await fetchUserRole(); // Perbaiki nama fungsi
      await saveRole(role);

      print('Login berhasil untuk user: ${user['username']} (ID: ${user['id']})');
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception('Login failed: ${errorData['error']?['message']}');
    }
  }

  // Fungsi untuk mendapatkan role user dari API jika authenticated
  static Future<String> fetchUserRole() async {
    final jwt = await getJwtToken();
    if (jwt == null) return 'guest'; // Default role jika tidak ada token

    final response = await http.get(
      Uri.parse('$baseUrl/users/me'),
      headers: {'Authorization': 'Bearer $jwt'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Tambahkan log untuk memeriksa data
      print('Data dari API: $data');

      // Pastikan data['role'] tidak null sebelum mengakses 'name'
      if (data['role'] != null && data['role']['name'] != null) {
        return data['role']['name'];
      } else {
        return 'guest'; // Kembalikan 'guest' jika role tidak ada
      }
    } else {
      // Tambahkan log untuk memeriksa kesalahan
      print('Gagal mendapatkan data pengguna: ${response.body}');
      throw Exception('Failed to fetch user role');
    }
  }

  // Fungsi logout
  static Future<void> logout() async {
    // Hapus token dan role di FlutterSecureStorage
    await _storage.delete(key: 'jwtToken');
    await _storage.delete(key: 'role');
  }

  /* // Fungsi untuk mendapatkan role user dari API jika authenticated
  static Future<String?> fetchUserRole() async {
    final jwt = await getJwtToken();
    if (jwt == null) return null;

    final response = await http.get(
      Uri.parse('$baseUrl/users/me'),
      headers: {'Authorization': 'Bearer $jwt'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['role']['name'];
    } else {
      return null;
    }
  }*/

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
  }

}
