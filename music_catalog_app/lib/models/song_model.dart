class Song {
  final int id;
  final String title;
  final String artist;
  final String imageUrl;
  final String addedBy;
  final int reactionCount; // Nuevo
  final List<CommentModel> comments; // Nuevo

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.imageUrl,
    required this.addedBy,
    required this.reactionCount,
    required this.comments,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'],
      title: json['title'],
      artist: json['artist'],
      imageUrl: json['imageUrl'],
      addedBy: json['addedBy'] ?? 'Anónimo',
      reactionCount: json['reactionCount'] ?? 0,
      comments: (json['comments'] as List?)
          ?.map((item) => CommentModel.fromJson(item))
          .toList() ?? [],
    );
  }
}

// Clase de apoyo para los comentarios
class CommentModel {
  final String content;
  final String username;
  final String createdAt;

  CommentModel({
    required this.content,
    required this.username,
    required this.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      content: json['content'] ?? '',
      username: json['username'] ?? 'Anónimo',
      createdAt: json['createdAt'] ?? '',
    );
  }
}