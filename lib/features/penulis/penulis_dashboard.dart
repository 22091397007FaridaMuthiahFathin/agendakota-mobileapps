// lib/screens/penulis_dashboard.dart
import 'package:flutter/material.dart';
import '../../models/article.dart';
import '../../services/api_service.dart';
import '../articles/add_edit_article.dart';

class AuthorDashboard extends StatefulWidget {
  @override
  _AuthorDashboardState createState() => _AuthorDashboardState();
}

class _AuthorDashboardState extends State<AuthorDashboard> {
  late Future<List<Article>> _articles;

  @override
  void initState() {
    super.initState();
    _articles = ApiService().fetchArticlesByAuthor(); // Fetch articles by author
  }

  // Fungsi untuk menambahkan artikel baru
  void _addArticle() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditArticleScreen(),
      ),
    );
    if (result == true) {
      setState(() {
        _articles = ApiService().fetchArticlesByAuthor();
      });
    }
  }

  void _editArticle(Article article) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditArticleScreen(article: article),
      ),
    );
    if (result == true) {
      setState(() {
        _articles = ApiService().fetchArticlesByAuthor();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Author Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addArticle, // Tambah artikel baru
          ),
        ],
      ),
      body: FutureBuilder<List<Article>>(
        future: _articles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No articles found.'));
          } else {
            final articles = snapshot.data!;
            return ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                return ListTile(
                  title: Text(article.title),
                  subtitle: Text(article.content),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => _editArticle(article),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
