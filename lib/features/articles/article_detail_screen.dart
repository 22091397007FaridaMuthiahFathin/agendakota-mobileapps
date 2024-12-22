import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../models/article.dart';

class ArticleDetailScreen extends StatelessWidget {
  final String title;
  final String description;
  /*
  final List<dynamic> blocks;

   */

  const ArticleDetailScreen({
    Key? key,
    required this.title,
    required this.description,
    /*
    required this.blocks

     */
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      /*
      body: ListView.builder(
        itemCount: blocks.length,
        itemBuilder: (context, index) {
          return renderBlock(blocks[index]);
        },
      ),

       */


      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Markdown(
          data: description,
          styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
        ),
      ),

    );
  }

  Widget renderBlock(dynamic block) {
    switch (block['__component']) {
      case 'shared.rich-text':
        return Text(block['content'] ?? '');
      case 'shared.media':
        return Image.network(block['image']['url']);
      case 'shared.quote':
        return Text(
          block['quote'] ?? '',
          style: TextStyle(fontStyle: FontStyle.italic),
        );
      default:
        return SizedBox.shrink();
    }
  }

}
