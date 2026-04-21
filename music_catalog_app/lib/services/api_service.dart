import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/config.dart';
import '../models/user_model.dart';
import '../models/song_model.dart';

class ApiService {
  final String authUrl = "${Config.baseUrl}/auth";
  final String songUrl = "${Config.baseUrl}/songs";

  // LOGIN
  Future<User?> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$authUrl/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username, "password": password}),
    );
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  // OBTENER CANCIONES
  Future<List<Song>> getSongs() async {
    final response = await http.get(Uri.parse(songUrl));
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((data) => Song.fromJson(data)).toList();
    } else {
      throw Exception('Error al cargar canciones');
    }
  }

  // ELIMINAR CANCIÓN (DELETE)
  Future<bool> deleteSong(int id) async {
    final response = await http.delete(Uri.parse('$songUrl/$id'));
    return response.statusCode == 204;
  }

  Future<bool> createSong(String title, String artist, String imageUrl, int userId) async {
    final response = await http.post(
      Uri.parse(songUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "title": title,
        "artist": artist,
        "imageUrl": imageUrl,
        "userId": userId,
      }),
    );
    return response.statusCode == 201;
  }
}