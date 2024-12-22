import 'package:flutter/material.dart';
import '../../models/article.dart';
import 'article_detail_screen.dart';

class ArticleItem extends StatelessWidget {
  final Article article;

  const ArticleItem({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(article.title ?? "No Title"),
      subtitle: Text(
        article.content.length > 50
            ? article.content.substring(0, 50) + "..."
            : article.content,
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleDetailScreen(
              title: article.title ?? "No Title",
              description: article.content,
              /*
              blocks: article.blocks,
               */
            ),
          ),
        );
      },
    );
  }
}