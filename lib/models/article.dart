import 'package:flutter/material.dart';
import 'package:qrcodescanner/models/author.dart';
import 'package:qrcodescanner/models/category.dart';

class Article {
  final int id;
  final String? documentId;
  final String? slug;
  final String title;
  final String content;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  /*
  final List<dynamic> blocks;
   */
  /*
  final String? author;
  final String? category;
   */

  Article({
    required this.id,
    this.documentId,
    this.slug,
    required this.title,
    required this.content,
    this.createdAt,
    this.updatedAt, Author? author, Category? category,
    /*
    required this.blocks
     */
    /*
    this.author,
    this.category,
     */
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] ?? 0,
      documentId: json['documentId'] ?? '',
      slug: json['slug'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      /*
      blocks: json['blocks'] ?? [],
       */
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'documentId': documentId,
      'title': title,
      'slug': slug,
      'content': content,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      /*
      'blocks': blocks
       */
    };
  }
}