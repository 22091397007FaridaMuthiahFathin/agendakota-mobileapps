// models/category.dart
class Category {
  final int id;
  final String name;
  final String slug;
  final String description;

  Category({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
  });

  // Fungsi untuk memetakan data dari JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      description: json['description'] ?? '',
    );
  }
}
