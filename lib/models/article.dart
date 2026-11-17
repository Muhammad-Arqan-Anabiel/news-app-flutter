class Article {
  final String title;
  final String description;
  final String imageUrl;
  final String sourceName;
  final String publishedAt;
  final String url;

  Article({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.sourceName,
    required this.publishedAt,
    required this.url,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    final source = json['source'] as Map<String, dynamic>?;

    return Article(
      title: json['title'] as String? ?? 'Judul tidak tersedia',
      description: json['description'] as String? ?? '',
      imageUrl: json['urlToImage'] as String? ?? '',
      sourceName: source?['name'] as String? ?? 'Sumber tidak diketahui',
      publishedAt: json['publishedAt'] as String? ?? '',
      url: json['url'] as String? ?? '',
    );
  }
}

