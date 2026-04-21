import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/song_model.dart';
import 'song_form_screen.dart';

class HomeScreen extends StatefulWidget {
  final int userId;
  final String username;
  const HomeScreen({super.key, required this.userId, required this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Song>> _songsFuture;

  @override
  void initState() {
    super.initState();
    _refreshSongs();
  }

  void _refreshSongs() {
    setState(() {
      _songsFuture = _apiService.getSongs();
    });
  }

  void _deleteSong(int id) async {
    bool deleted = await _apiService.deleteSong(id);
    if (deleted) _refreshSongs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hola, ${widget.username}"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _refreshSongs),
        ],
      ),
      body: FutureBuilder<List<Song>>(
        future: _songsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No hay canciones registradas"));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final song = snapshot.data![index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: song.imageUrl.isNotEmpty
                        ? Image.network(song.imageUrl, width: 50, height: 50, fit: BoxFit.cover, errorBuilder: (c,e,s) => const Icon(Icons.album))
                        : const Icon(Icons.album, size: 50),
                  ),
                  title: Text(song.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(song.artist, style: TextStyle(color: Colors.grey[400])),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () => _deleteSong(song.id),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purpleAccent,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SongFormScreen(userId: widget.userId)),
          );
          _refreshSongs();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}