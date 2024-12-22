import 'package:flutter/material.dart';
import '../../services/article_service.dart';

class AdminArticleList extends StatelessWidget {
  final ArticleService _articleService = ArticleService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin - Articles')),
      body: FutureBuilder(
        future: _articleService.fetchArticles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final articles = snapshot.data as List;
            return ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                return ListTile(
                  title: Text(article['title']),
                  subtitle: Text('By: ${article['author']}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      // Tambahkan fungsi hapus
                    },
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
