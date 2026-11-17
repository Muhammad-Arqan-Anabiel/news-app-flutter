import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/pages/article_detail_page.dart';

void main() {
  group('Article Model Tests', () {
    test('Article.fromJson should parse valid json correctly', () {
      final json = {
        'title': 'Flutter 3.47 Released',
        'description': 'Exciting new features in Flutter',
        'urlToImage': 'https://example.com/image.png',
        'source': {'name': 'Flutter News'},
        'publishedAt': '2026-11-08T10:00:00Z',
        'url': 'https://flutter.dev',
      };

      final article = Article.fromJson(json);

      expect(article.title, 'Flutter 3.47 Released');
      expect(article.description, 'Exciting new features in Flutter');
      expect(article.imageUrl, 'https://example.com/image.png');
      expect(article.sourceName, 'Flutter News');
      expect(article.publishedAt, '2026-11-08T10:00:00Z');
      expect(article.url, 'https://flutter.dev');
    });

    test('Article.fromJson should handle null fields with fallback defaults', () {
      final json = <String, dynamic>{
        'title': null,
        'description': null,
        'urlToImage': null,
        'source': null,
        'publishedAt': null,
        'url': null,
      };

      final article = Article.fromJson(json);

      expect(article.title, 'Judul tidak tersedia');
      expect(article.description, '');
      expect(article.imageUrl, '');
      expect(article.sourceName, 'Sumber tidak diketahui');
      expect(article.publishedAt, '');
      expect(article.url, '');
    });
  });

  group('ArticleDetailPage Widget Tests', () {
    testWidgets('ArticleDetailPage displays article details properly',
        (WidgetTester tester) async {
      final testArticle = Article(
        title: 'Berita Uji Coba',
        description: 'Deskripsi lengkap berita uji coba.',
        imageUrl: '',
        sourceName: 'Kompas',
        publishedAt: '2026-11-08',
        url: 'https://example.com/test',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: ArticleDetailPage(article: testArticle),
        ),
      );

      expect(find.text('Detail Berita'), findsOneWidget);
      expect(find.text('Berita Uji Coba'), findsOneWidget);
      expect(find.text('Kompas'), findsOneWidget);
      expect(find.text('Tanggal publikasi: 2026-11-08'), findsOneWidget);
      expect(find.text('Deskripsi lengkap berita uji coba.'), findsOneWidget);
      expect(find.text('Baca Artikel Asli'), findsOneWidget);
    });
  });
}
