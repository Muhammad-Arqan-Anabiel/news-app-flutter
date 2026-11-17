import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/models/article.dart';

void main() {
  group('Filter Logic Tests', () {
    final articles = [
      Article(
        title: 'Google Announces Gemini 2.0 and AI Updates',
        description: 'New model released with better reasoning.',
        imageUrl: '',
        sourceName: 'TechCrunch',
        publishedAt: '2026-11-01',
        url: 'https://example.com/1',
      ),
      Article(
        title: 'Arsenal Wins Premier League Match with Dramatic Goal',
        description: 'Spectacular match over the weekend.',
        imageUrl: '',
        sourceName: 'BBC Sport',
        publishedAt: '2026-11-02',
        url: 'https://example.com/2',
      ),
      Article(
        title: 'New Technology in Healthcare Saves Lives',
        description: 'Advances in biotech instruments.',
        imageUrl: '',
        sourceName: 'Reuters',
        publishedAt: '2026-11-03',
        url: 'https://example.com/3',
      ),
    ];

    List<Article> filterByTitle(List<Article> list, String keyword) {
      if (keyword.trim().isEmpty) return list;
      return list
          .where((item) =>
              item.title.toLowerCase().contains(keyword.trim().toLowerCase()))
          .toList();
    }

    test('Empty keyword returns all articles', () {
      final filtered = filterByTitle(articles, '   ');
      expect(filtered.length, 3);
    });

    test('Case-insensitive keyword filtering works', () {
      final filtered = filterByTitle(articles, 'gemini');
      expect(filtered.length, 1);
      expect(filtered.first.sourceName, 'TechCrunch');

      final filteredTech = filterByTitle(articles, 'technology');
      expect(filteredTech.length, 1);
      expect(filteredTech.first.title, contains('Healthcare'));
    });

    test('Keyword with no match returns empty list', () {
      final filtered = filterByTitle(articles, 'Astronomy Mars Discovery');
      expect(filtered.isEmpty, true);
    });
  });
}

