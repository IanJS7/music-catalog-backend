import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SongFormScreen extends StatefulWidget {
  final int userId;
  const SongFormScreen({super.key, required this.userId});

  @override
  State<SongFormScreen> createState() => _SongFormScreenState();
}

class _SongFormScreenState extends State<SongFormScreen> {
  final _titleController = TextEditingController();
  final _artistController = TextEditingController();
  final _imageController = TextEditingController();
  final _apiService = ApiService();

  void _saveSong() async {
    if (_titleController.text.isEmpty || _artistController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Completa los campos obligatorios")));
      return;
    }

    String urlFinal = _imageController.text.isEmpty
        ? "https://cdn-icons-png.flaticon.com/512/3844/3844724.png"
        : _imageController.text;

    bool success = await _apiService.createSong(
      _titleController.text,
      _artistController.text,
      urlFinal,
      widget.userId,
    );

    if (success && mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nueva Canción")),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            TextField(controller: _titleController, decoration: const InputDecoration(labelText: "Título de la canción")),
            const SizedBox(height: 15),
            TextField(controller: _artistController, decoration: const InputDecoration(labelText: "Artista / Banda")),
            const SizedBox(height: 15),
            TextField(controller: _imageController, decoration: const InputDecoration(labelText: "URL de la portada (Opcional)")),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveSong,
                child: const Text("GUARDAR EN CATÁLOGO"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}