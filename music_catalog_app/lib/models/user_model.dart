class User {
  final int id;         // <--- Verifica que se llame id
  final String username; // <--- Verifica que se llame username

  User({
    required this.id,
    required this.username
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
    );
  }
}