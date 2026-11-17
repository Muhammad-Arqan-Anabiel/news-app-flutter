import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/article.dart';

class NewsService {
  final http.Client _client;

  NewsService({http.Client? client}) : _client = client ?? http.Client();

  /// Mengambil berita utama berdasarkan kategori (Pertemuan 1, 2, 4)
  Future<List<Article>> fetchTopHeadlines({
    String category = 'general',
  }) async {
    final uri = Uri.https(
      'newsapi.org',
      '/v2/top-headlines',
      {
        'country': 'us',
        'category': category,
        'pageSize': '20',
      },
    );
    return _getArticles(uri);
  }

  /// Mencari berita berdasarkan kata kunci melalui NewsAPI (Pertemuan 2, 4)
  Future<List<Article>> searchArticles({
    required String query,
  }) async {
    final uri = Uri.https(
      'newsapi.org',
      '/v2/everything',
      {
        'q': query,
        'pageSize': '20',
        'sortBy': 'publishedAt',
      },
    );
    return _getArticles(uri);
  }

  /// Fungsi bersama untuk request HTTP dan parsing JSON (Pertemuan 2, 4, 5)
  Future<List<Article>> _getArticles(Uri uri) async {
    final String apiKey = dotenv.env['NEWS_API_KEY'] ?? '';

    if (apiKey.isEmpty || apiKey == 'your_news_api_key_here' || apiKey == 'ISI_API_KEY_MILIKMU_DI_SINI') {
      throw Exception(
        'NEWS_API_KEY belum diatur. Masukkan API key valid pada file .env.',
      );
    }

    try {
      final response = await _client.get(
        uri,
        headers: {
          'X-Api-Key': apiKey,
        },
      );

      if (response.statusCode != 200) {
        if (response.statusCode == 401) {
          throw Exception(
            'Autentikasi gagal (401). Periksa API key NewsAPI pada file .env.',
          );
        } else if (response.statusCode == 429) {
          throw Exception(
            'Batas permintaan API terlampaui (429). Coba lagi beberapa saat lagi.',
          );
        } else {
          throw Exception(
            'Permintaan berita gagal. Kode HTTP: ${response.statusCode}',
          );
        }
      }

      final Map<String, dynamic> jsonData =
          jsonDecode(response.body) as Map<String, dynamic>;

      if (jsonData['status'] != 'ok') {
        throw Exception(
          jsonData['message'] as String? ?? 'NewsAPI mengembalikan kesalahan.',
        );
      }

      final List<dynamic> results =
          jsonData['articles'] as List<dynamic>? ?? [];

      return results
          .map((item) => Article.fromJson(item as Map<String, dynamic>))
          .toList();
    } on SocketException {
      throw Exception(
        'Tidak ada koneksi internet. Periksa jaringan Anda lalu coba lagi.',
      );
    } on http.ClientException {
      throw Exception(
        'Gagal menghubungi server berita. Periksa koneksi internet Anda.',
      );
    }
  }
}

