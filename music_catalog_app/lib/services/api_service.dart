import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/song_model.dart';
import '../models/user_model.dart';

class ApiService {
  final String baseUrl = "https://music-catalog-backend-drry.onrender.com/api";

  // --- MÉTODOS DE AUTENTICACIÓN ---
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

  // --- MÉTODOS DE CANCIONES ---
  Future<List<Song>> getSongs() async {
    final response = await http.get(Uri.parse('$baseUrl/songs?t=${DateTime.now().millisecondsSinceEpoch}'));
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((item) => Song.fromJson(item)).toList();
    }
    return [];
  }

  Future<bool> createSong(String title, String artist, String url, int userId) async {
    try {
      String finalUrl = url.trim().isEmpty ? "default" : url;
      final response = await http.post(
        Uri.parse('$baseUrl/songs'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': title,
          'artist': artist,
          'imageUrl': finalUrl,
          'userId': userId
        }),
      );
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateSong(int id, String title, String artist, String url, int userId) async {
    try {
      String finalUrl = url.trim().isEmpty ? "default" : url;
      final response = await http.put(
        Uri.parse('$baseUrl/songs/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': title,
          'artist': artist,
          'imageUrl': finalUrl,
          'userId': userId
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteSong(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/songs/$id'));
    return response.statusCode == 200 || response.statusCode == 204;
  }

  // --- NUEVOS MÉTODOS DE INTERACCIÓN ---

  // Para dar o quitar Like (usa el QueryParam ?userId= que definimos en Java)
  Future<bool> toggleLike(int songId, int userId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/songs/$songId/like?userId=$userId'),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Para enviar un comentario
  Future<bool> addComment(int songId, int userId, String content) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/songs/$songId/comment'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'content': content
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}