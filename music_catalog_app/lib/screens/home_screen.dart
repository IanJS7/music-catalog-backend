import 'package:flutter/material.dart';
import '../models/song_model.dart'; // Nombre exacto de tu archivo
import '../services/api_service.dart';
import 'song_form_screen.dart'; // Nombre exacto de tu archivo en la misma carpeta

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  List<Song> _songs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSongs();
  }

  // Función para obtener las canciones
  Future<void> _fetchSongs() async {
    try {
      final songs = await _apiService.getSongs();
      setState(() {
        _songs = songs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      debugPrint("Error: $e");
    }
  }

  void _showForm({Song? song}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SongFormScreen(
          song: song,
          userId: 1, // ID temporal para el examen, luego puedes pasarlo desde el Login
          onSave: () => _fetchSongs(),
        ),
      ),
    );
  }

  Future<void> _deleteSong(int id) async {
    try {
      await _apiService.deleteSong(id);
      _fetchSongs();
    } catch (e) {
      debugPrint("Error al eliminar: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Música'),
        backgroundColor: const Color(0xFF311B92), // Color a juego con tu Login
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _songs.length,
        itemBuilder: (context, index) {
          final song = _songs[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              leading: song.imageUrl.isNotEmpty
                  ? Image.network(song.imageUrl, width: 50, fit: BoxFit.cover)
                  : const Icon(Icons.music_note),
              title: Text(song.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(song.artist),
                  const SizedBox(height: 4),
                  Text(
                    "Agregada por: ${song.addedBy}", // El campo de Postman
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _showForm(song: song),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteSong(song.id!),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purpleAccent,
        onPressed: () => _showForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}