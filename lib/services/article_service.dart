import 'dart:convert';
import 'package:http/http.dart' as http;

class ArticleService {
  static const String baseUrl = /*'http://192.168.1.80:1337/api'*/ 'http://192.168.14.170:1337/api' ;

  Future<List<dynamic>> fetchArticles() async {
    final response = await http.get(Uri.parse('$baseUrl/articles'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch articles');
    }
  }

  Future<void> createArticle(String title, String content) async {
    final response = await http.post(
      Uri.parse('$baseUrl/articles'),
      body: {'title': title, 'content': content},
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create article');
    }
  }
}
