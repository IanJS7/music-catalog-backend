class Song {
  final int id;
  final String title;
  final String artist;
  final String imageUrl;

  Song({required this.id, required this.title, required this.artist, required this.imageUrl});

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'],
      title: json['title'],
      artist: json['artist'],
      imageUrl: json['imageUrl'],
    );
  }
}