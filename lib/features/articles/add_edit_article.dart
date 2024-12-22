import 'package:flutter/material.dart';
import '../../models/article.dart';
import '../../services/api_service.dart';

class EditArticleScreen extends StatefulWidget {
  final Article? article;

  EditArticleScreen({this.article}); // Null jika tambah artikel

  @override
  _EditArticleScreenState createState() => _EditArticleScreenState();
}

class _EditArticleScreenState extends State<EditArticleScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.article?.title ?? '',
    );
    _contentController = TextEditingController(
      text: widget.article?.content ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveArticle() {
    Navigator.pop(context, 'edited');
  }

  /*
  Future<void> _saveArticle() async {
    if (_formKey.currentState!.validate()) {
      final article = Article(
        id: widget.article?.id ?? 0, // 0 untuk artikel baru
        title: _titleController.text,
        content: _contentController.text,
      );

      try {
        if (widget.article == null) {
          await ApiService().addArticle(article); // Tambah artikel
        } else {
          await ApiService().updateArticle(article); // Update artikel
        }
        Navigator.pop(context, true); // Kembali dan refresh
      } catch (e) {
        print('Failed to save article: $e');
      }
    }
  }
   */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Article'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveArticle,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Content'),
              maxLines: 10,
            ),
            /*
            TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _contentController,
                decoration: InputDecoration(labelText: 'Content'),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter content';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveArticle,
                child: Text('Save'),
              ),
            ],
          ),
          */
          ],
        ),
      ),
    );
  }
}
