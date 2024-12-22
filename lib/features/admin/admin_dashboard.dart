// lib/screens/admin_dashboard.dart
import 'package:flutter/material.dart';
import '../../models/article.dart';
import '../../services/api_service.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  late Future<List<Article>> _articles;

  @override
  void initState() {
    super.initState();
    _articles = ApiService().fetchArticles(); // Fetch all articles
  }

  // Fungsi untuk mempublish artikel
  Future<void> _publishArticle(Article article) async {
    try {
      await ApiService().publishArticle(article.id); // Publish API
      setState(() {
        _articles = ApiService().fetchArticles(); // Refresh articles
      });
    } catch (e) {
      print('Failed to publish article: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Dashboard')),
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
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          // Arahkan ke layar edit artikel
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          // Tambahkan fungsi hapus artikel
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.publish),
                        onPressed: () => _publishArticle(article), // Publish artikel
                      ),
                    ],
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
