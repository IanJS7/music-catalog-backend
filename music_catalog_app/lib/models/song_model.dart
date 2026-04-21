class Song {
  final int id;
  final String title;
  final String artist;
  final String imageUrl;
  final String addedBy; // <--- Añade esta línea

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.imageUrl,
    required this.addedBy, // <--- Y esta
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'],
      title: json['title'],
      artist: json['artist'],
      imageUrl: json['imageUrl'],
      addedBy: json['addedBy'] ?? 'Anónimo', // <--- Lee el campo de la imagen de Postman
    );
  }
}