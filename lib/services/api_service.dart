import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';
import '../models/author.dart';
import '../models/category.dart';
import '../auth/auth_service.dart';

class ApiService {
  final String baseUrl = /*'http://192.168.1.80:1337/api'*/ 'http://192.168.14.170:1337/api' ;

  Future<List<Article>> fetchArticles() async {
    final token = await AuthService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/articles'),
      headers: {
        'Content-Type': 'application/json',
        /*
        'Authorization': 'Bearer $token',
         */
      },
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)/*['data']*/;
      return data.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load articles');
    }
  }

  Future<void> addArticle(Article article) async {
    final token = await AuthService.getToken();
    final url = Uri.parse('$baseUrl/articles');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        "data": {
          "title": article.title,
          "slug": article.slug,
          "content": article.content,
        }
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to add article: ${response.body}');
    }
  }

  // api_service.dart (di dalam fungsi login)
  Future<void> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/local'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'identifier': username,
        'password': password,
      }),
    );

    print('Login status: ${response.statusCode}');
    print('Login response: ${response.body}');

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final token = responseData['jwt'];
      await AuthService.saveToken(token);
      print('Token saved: $token');
    } else {
      throw Exception('Failed to login');
    }
  }


  /// Fetch categories
  Future<List<Category>> fetchCategories() async {
    final token = await AuthService.getToken();
    final response = await http.get(Uri.parse('$baseUrl/categories'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

// Fetch authors
  Future<List<Author>> fetchAuthors() async {
    final token = await AuthService.getToken();
    final response = await http.get(Uri.parse('$baseUrl/authors'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((json) => Author.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load authors');
    }
  }

  // Fetch articles by specific author
  Future<List<Article>> fetchArticlesByAuthor() async {
    final token = await AuthService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/articles?filters[author][id]=current_user_id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load articles by author');
    }
  }

  // Publish an article
  Future<void> publishArticle(int articleId) async {
    final token = await AuthService.getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/articles/$articleId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "data": {
          "publishedAt": DateTime.now().toIso8601String(),
        }
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to publish article: ${response.body}');
    }
  }

  // api_service.dart
  Future<bool> checkUserRole() async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/users/me'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final userData = jsonDecode(response.body);
      final roles = userData['role']['name'];
      print('User role: $roles');
      return roles == 'admin'; // Kembalikan true jika role adalah admin
    } else {
      throw Exception('Failed to fetch user role');
    }
  }

  Future<void> updateArticle(Article article) async {
    final token = await AuthService.getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/articles/${article.id}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "data": {
          "title": article.title,
          "content": article.content,
        }
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to update article: ${response.body}');
    }
  }

}
