import 'package:flutter/material.dart';
import '../models/song_model.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import 'song_form_screen.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({super.key, required this.user});

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

  Future<void> _fetchSongs() async {
    try {
      final songs = await _apiService.getSongs();
      setState(() {
        _songs = songs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  // --- NUEVA FUNCIÓN PARA LIKES ---
  Future<void> _toggleLike(int songId) async {
    final success = await _apiService.toggleLike(songId, widget.user.id);
    if (success) {
      _fetchSongs(); // Refrescamos para ver el nuevo contador
    }
  }

  // --- NUEVA FUNCIÓN PARA COMENTAR ---
  void _showCommentDialog(int songId) {
    final TextEditingController commentController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Escribir comentario"),
        content: TextField(
          controller: commentController,
          decoration: const InputDecoration(hintText: "Ej: ¡Me encanta esta canción!"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
          ElevatedButton(
            onPressed: () async {
              if (commentController.text.isNotEmpty) {
                await _apiService.addComment(songId, widget.user.id, commentController.text);
                Navigator.pop(context);
                _fetchSongs();
              }
            },
            child: const Text("Publicar"),
          ),
        ],
      ),
    );
  }

  void _showForm({Song? song}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SongFormScreen(
          song: song,
          userId: widget.user.id,
          onSave: () => _fetchSongs(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Social Catalog'),
        backgroundColor: const Color(0xFF311B92),
        actions: [
          Center(child: Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Text("Hola, ${widget.user.username}"),
          ))
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _songs.length,
        itemBuilder: (context, index) {
          final song = _songs[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ExpansionTile( // Usamos ExpansionTile para ver comentarios al tocar
              leading: Image.network(song.imageUrl, width: 50, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.music_note)),
              title: Text(song.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("${song.artist} • por ${song.addedBy}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // BOTÓN DE LIKE
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => _toggleLike(song.id),
                        child: const Icon(Icons.favorite, color: Colors.red),
                      ),
                      Text("${song.reactionCount}", style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _showForm(song: song),
                  ),
                ],
              ),
              children: [
                // SECCIÓN DE COMENTARIOS
                const Divider(),
                ...song.comments.map((c) => ListTile(
                  dense: true,
                  title: Text("${c.username}: ${c.content}"),
                  subtitle: Text(c.createdAt, style: const TextStyle(fontSize: 10)),
                )),
                TextButton.icon(
                  onPressed: () => _showCommentDialog(song.id),
                  icon: const Icon(Icons.comment),
                  label: const Text("Añadir comentario"),
                )
              ],
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