import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';

class AuthService {
  // 🔹 Signup API
  Future<Map<String, dynamic>> signup(String username, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$API_BASE_URL/signup'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username, "email": email, "password": password}),
      );

      print("🔹 Signup Response: ${response.statusCode} - ${response.body}");

      return jsonDecode(response.body);
    } catch (e) {
      print("❌ Signup Error: $e");
      return {'status': 'error', 'message': 'Failed to signup'};
    }
  }

  // 🔹 Login API
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$API_BASE_URL/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username, "password": password}),
      );

      print("🔹 Login Response: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.containsKey('token')) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', data['token']); // Store JWT token
        }
        return data;
      } else {
        return {'status': 'error', 'message': 'Invalid credentials'};
      }
    } catch (e) {
      print("❌ Login Error: $e");
      return {'status': 'error', 'message': 'Failed to login'};
    }
  }

  // 🔹 Logout API
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    print("✅ Logged out successfully!");
  }

  // 🔹 Lock Folder API
  Future<Map<String, dynamic>> lockFolder(String folderPath, String encryptionKey) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.post(
        Uri.parse('$API_BASE_URL/lock-folder'),  // ✅ Fixed endpoint
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'folder_path': folderPath, 'encryption_key': encryptionKey}),
      );

      print("🔹 Lock Folder Response: ${response.statusCode} - ${response.body}");

      return jsonDecode(response.body);
    } catch (e) {
      print("❌ Lock Folder Error: $e");
      return {'status': 'error', 'message': 'Failed to lock folder'};
    }
  }
  Future<Map<String, dynamic>> lockFolderen(String folderPath, String encryptionKey) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.post(
        Uri.parse('$API_BASE_URL/lock-folderen'),  // ✅ Fixed endpoint
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'folder_path': folderPath, 'encryption_key': encryptionKey}),
      );

      print("🔹 Lock Folder Response: ${response.statusCode} - ${response.body}");

      return jsonDecode(response.body);
    } catch (e) {
      print("❌ Lock Folder Error: $e");
      return {'status': 'error', 'message': 'Failed to lock folder'};
    }
  }
  // 🔹 Unlock Folder API
  Future<Map<String, dynamic>> unlockFolder(int folderId, String encryptionKey) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.post(
        Uri.parse('$API_BASE_URL/unlock-folder'),  // ✅ Fixed endpoint
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'folder_id': folderId, 'encryption_key': encryptionKey}),
      );

      print("🔹 Unlock Folder Response: ${response.statusCode} - ${response.body}");

      return jsonDecode(response.body);
    } catch (e) {
      print("❌ Unlock Folder Error: $e");
      return {'status': 'error', 'message': 'Failed to unlock folder'};
    }
  }

  // 🔹 Get Locked Folders API
  Future<List<dynamic>> getLockedFolders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.get(
        Uri.parse('$API_BASE_URL/locked-folders'),  // ✅ Fixed endpoint
        headers: {'Authorization': 'Bearer $token'},
      );

      print("🔹 Get Locked Folders Response: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['folders'];
      } else {
        return [];
      }
    } catch (e) {
      print("❌ Get Locked Folders Error: $e");
      return [];
    }
  }

  // 🔹 Get Lock/Unlock History API
  Future<List<dynamic>> getLockHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.get(
        Uri.parse('$API_BASE_URL/lock-history'),  // ✅ Fixed endpoint
        headers: {'Authorization': 'Bearer $token'},
      );

      print("🔹 Get Lock History Response: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['history'];
      } else {
        return [];
      }
    } catch (e) {
      print("❌ Get Lock History Error: $e");
      return [];
    }
  }

  
}
