// models/author.dart
class Author {
  final int id;
  final String name;
  final String avatarUrl;
  final String email;

  Author({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.email,
  });

  // Fungsi untuk memetakan data dari JSON
  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'],
      name: json['name'],
      avatarUrl: json['avatar']?['url'] ?? '', // Sesuaikan dengan respons API Strapi untuk avatar
      email: json['email'],
    );
  }
}
