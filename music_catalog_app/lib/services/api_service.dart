import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/song_model.dart';
import '../models/user_model.dart';

class ApiService {
  final String baseUrl = "https://music-catalog-backend-drry.onrender.com/api";

  Future<User?> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  Future<bool> register(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );
    return response.statusCode == 201 || response.statusCode == 200;
  }

  Future<List<Song>> getSongs() async {
    final response = await http.get(Uri.parse('$baseUrl/songs'));
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((item) => Song.fromJson(item)).toList();
    }
    return [];
  }

  Future<bool> createSong(String title, String artist, String url, int userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/songs'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': title,
        'artist': artist,
        'imageUrl': url,
        'user': {'id': userId}
      }),
    );
    return response.statusCode == 201 || response.statusCode == 200;
  }

  Future<void> deleteSong(int id) async {
    await http.delete(Uri.parse('$baseUrl/songs/$id'));
  }
}