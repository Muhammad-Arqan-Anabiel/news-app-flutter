import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/article.dart';

class NewsService {
  static const String _compileTimeProxyUrl =
      String.fromEnvironment('API_PROXY_URL');

  final http.Client _client;

  NewsService({http.Client? client}) : _client = client ?? http.Client();

  String get _proxyUrl {
    if (_compileTimeProxyUrl.isNotEmpty) return _compileTimeProxyUrl.trim();
    if (dotenv.isInitialized) {
      return (dotenv.env['API_PROXY_URL'] ?? '').trim();
    }
    return '';
  }

  /// Mengambil berita utama berdasarkan kategori (Pertemuan 1, 2, 4)
  Future<List<Article>> fetchTopHeadlines({
    String category = 'general',
  }) async {
    final params = {
      'country': 'us',
      'category': category,
      'pageSize': '20',
    };

    if (_proxyUrl.isNotEmpty) {
      final baseUri = Uri.parse(_proxyUrl);
      final uri = baseUri.replace(
        queryParameters: {
          ...baseUri.queryParameters,
          'endpoint': 'top-headlines',
          ...params,
        },
      );
      return _getArticles(uri, useProxy: true);
    }

    final uri = Uri.https('newsapi.org', '/v2/top-headlines', params);
    return _getArticles(uri);
  }

  /// Mencari berita berdasarkan kata kunci melalui NewsAPI (Pertemuan 2, 4)
  Future<List<Article>> searchArticles({
    required String query,
  }) async {
    final params = {
      'q': query,
      'pageSize': '20',
      'sortBy': 'publishedAt',
    };

    if (_proxyUrl.isNotEmpty) {
      final baseUri = Uri.parse(_proxyUrl);
      final uri = baseUri.replace(
        queryParameters: {
          ...baseUri.queryParameters,
          'endpoint': 'everything',
          ...params,
        },
      );
      return _getArticles(uri, useProxy: true);
    }

    final uri = Uri.https('newsapi.org', '/v2/everything', params);
    return _getArticles(uri);
  }

  /// Fungsi bersama untuk request HTTP dan parsing JSON (Pertemuan 2, 4, 5)
  Future<List<Article>> _getArticles(Uri uri, {bool useProxy = false}) async {
    final headers = <String, String>{};

    if (!useProxy) {
      final String apiKey = dotenv.isInitialized
          ? (dotenv.env['NEWS_API_KEY'] ?? '')
          : '';

      if (apiKey.isEmpty ||
          apiKey == 'your_news_api_key_here' ||
          apiKey == 'ISI_API_KEY_MILIKMU_DI_SINI') {
        throw Exception(
          'NEWS_API_KEY belum diatur. Masukkan API key valid pada file .env atau hubungkan API_PROXY_URL backend.',
        );
      }
      headers['X-Api-Key'] = apiKey;
    }

    try {
      final response = await _client.get(uri, headers: headers);

      if (response.statusCode != 200) {
        if (response.statusCode == 401) {
          throw Exception(
            'Autentikasi gagal (401). Periksa API key NewsAPI pada file .env atau backend.',
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
