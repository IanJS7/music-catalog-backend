import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/song_model.dart';

class SongFormScreen extends StatefulWidget {
  final Song? song;
  final int userId;
  final VoidCallback? onSave;

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
    if (widget.song != null) {
      _titleController.text = widget.song!.title;
      _artistController.text = widget.song!.artist;
      _imageController.text = widget.song!.imageUrl;
    }
  }

  void _saveSong() async {
    if (_titleController.text.isEmpty || _artistController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Completa los campos"))
      );
      return;
    }

    bool success;
    String finalUrl = _imageController.text.trim().isEmpty
        ? "https://cdn-icons-png.flaticon.com/512/3844/3844724.png"
        : _imageController.text;

    if (widget.song == null) {
      // CREAR NUEVA CANCIÓN
      success = await _apiService.createSong(
        _titleController.text,
        _artistController.text,
        finalUrl,
        widget.userId, // Usa el ID del usuario que inició sesión
      );
    } else {
      // EDITAR CANCIÓN EXISTENTE (Ya no es success = true fijo)
      success = await _apiService.updateSong(
        widget.song!.id,
        _titleController.text,
        _artistController.text,
        finalUrl,
        widget.userId, // Mantiene el dueño o lo cambia al que edita
      );
    }

    if (success && mounted) {
      if (widget.onSave != null) widget.onSave!();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("¡Cambios guardados correctamente!"))
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error al guardar. Revisa tu conexión."))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 25, // Para que el teclado no tape el botón
        top: 25,
        left: 25,
        right: 25,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
              widget.song == null ? "Nueva Canción" : "Editar Canción",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
          ),
          TextField(controller: _titleController, decoration: const InputDecoration(labelText: "Título")),
          TextField(controller: _artistController, decoration: const InputDecoration(labelText: "Artista")),
          TextField(controller: _imageController, decoration: const InputDecoration(labelText: "URL Imagen")),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: _saveSong,
                child: const Text("GUARDAR CAMBIOS")
            ),
          ),
        ],
      ),
    );
  }
}