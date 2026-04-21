import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/song_model.dart';

class SongFormScreen extends StatefulWidget {
  final Song? song; // Para editar
  final int userId;
  final VoidCallback? onSave; // Para refrescar la lista

  const SongFormScreen({super.key, this.song, required this.userId, this.onSave});

  @override
  State<SongFormScreen> createState() => _SongFormScreenState();
}

class _SongFormScreenState extends State<SongFormScreen> {
  final _titleController = TextEditingController();
  final _artistController = TextEditingController();
  final _imageController = TextEditingController();
  final _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    // Si estamos editando, cargamos los datos existentes
    if (widget.song != null) {
      _titleController.text = widget.song!.title;
      _artistController.text = widget.song!.artist;
      _imageController.text = widget.song!.imageUrl;
    }
  }

  void _saveSong() async {
    if (_titleController.text.isEmpty || _artistController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Completa los campos")));
      return;
    }

    bool success;
    if (widget.song == null) {
      // Crear nueva
      success = await _apiService.createSong(
        _titleController.text,
        _artistController.text,
        _imageController.text.isEmpty ? "https://cdn-icons-png.flaticon.com/512/3844/3844724.png" : _imageController.text,
        widget.userId,
      );
    } else {
      // Aquí iría tu lógica de editar (updateSong) si la tienes en el service
      success = true;
    }

    if (success && mounted) {
      if (widget.onSave != null) widget.onSave!();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container( // Usamos Container para que se vea bien en el BottomSheet
      padding: const EdgeInsets.all(25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.song == null ? "Nueva Canción" : "Editar Canción",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          TextField(controller: _titleController, decoration: const InputDecoration(labelText: "Título")),
          TextField(controller: _artistController, decoration: const InputDecoration(labelText: "Artista")),
          TextField(controller: _imageController, decoration: const InputDecoration(labelText: "URL Imagen")),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: _saveSong, child: const Text("GUARDAR")),
        ],
      ),
    );
  }
}