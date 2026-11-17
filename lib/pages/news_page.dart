import 'package:flutter/material.dart';
import '../models/article.dart';
import '../services/news_service.dart';
import 'article_detail_page.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final NewsService _newsService = NewsService();
  late Future<List<Article>> _newsFuture;

  String _selectedCategory = 'general';
  String _activeSearchQuery = '';

  final List<Map<String, String>> _categories = const [
    {'label': 'Umum', 'value': 'general'},
    {'label': 'Bisnis', 'value': 'business'},
    {'label': 'Hiburan', 'value': 'entertainment'},
    {'label': 'Kesehatan', 'value': 'health'},
    {'label': 'Sains', 'value': 'science'},
    {'label': 'Olahraga', 'value': 'sports'},
    {'label': 'Teknologi', 'value': 'technology'},
  ];

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _localFilterController = TextEditingController();
  String _localKeyword = '';

  @override
  void initState() {
    super.initState();
    _newsFuture = _newsService.fetchTopHeadlines(category: _selectedCategory);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _localFilterController.dispose();
    super.dispose();
  }

  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
      _activeSearchQuery = '';
      _searchController.clear();
      _newsFuture = _newsService.fetchTopHeadlines(category: category);
    });
  }

  void _searchNews() {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      _selectCategory(_selectedCategory);
      return;
    }
    setState(() {
      _activeSearchQuery = query;
      _newsFuture = _newsService.searchArticles(query: query);
    });
  }

  void _retryFetch() {
    setState(() {
      if (_activeSearchQuery.isNotEmpty) {
        _newsFuture = _newsService.searchArticles(query: _activeSearchQuery);
      } else {
        _newsFuture = _newsService.fetchTopHeadlines(category: _selectedCategory);
      }
    });
  }

  List<Article> filterByTitle(List<Article> articles, String keyword) {
    if (keyword.trim().isEmpty) return articles;

    return articles.where((article) {
      return article.title.toLowerCase().contains(
            keyword.trim().toLowerCase(),
          );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News App'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 1. Kotak Pencarian Berita (API Filter)
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _searchNews(),
              decoration: InputDecoration(
                hintText: 'Cari berita...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: _searchNews,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // 2. Pilihan Kategori Berita (API Filter)
          SizedBox(
            height: 56,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              children: _categories.map((category) {
                final selected = _selectedCategory == category['value'] &&
                    _activeSearchQuery.isEmpty;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(category['label']!),
                    selected: selected,
                    onSelected: (_) {
                      _selectCategory(category['value']!);
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          // 3. Kolom Filter Judul Berita (Filter Lokal)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 4,
            ),
            child: TextField(
              controller: _localFilterController,
              decoration: InputDecoration(
                labelText: 'Filter judul berita',
                hintText: 'Contoh: AI, technology, sports',
                prefixIcon: const Icon(Icons.filter_alt),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _localFilterController.clear();
                    setState(() {
                      _localKeyword = '';
                    });
                  },
                ),
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _localKeyword = value;
                });
              },
            ),
          ),

          // 4. Daftar Berita dengan FutureBuilder (Loading, Error, Empty, Success)
          Expanded(
            child: FutureBuilder<List<Article>>(
              future: _newsFuture,
              builder: (context, snapshot) {
                // Kondisi 1: Loading
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // Kondisi 2: Error
                if (snapshot.hasError) {
                  return Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.wifi_off,
                              size: 48,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Berita gagal dimuat. Periksa koneksi lalu coba lagi.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${snapshot.error}'.replaceAll('Exception: ', ''),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: _retryFetch,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Coba Lagi'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                // Kondisi 3: Data Kosong dari API
                final List<Article> articles = snapshot.data ?? [];
                if (articles.isEmpty) {
                  return const Center(
                    child: Text('Berita tidak ditemukan.'),
                  );
                }

                // Terapkan Filter Lokal berdasarkan judul
                final List<Article> filteredArticles =
                    filterByTitle(articles, _localKeyword);

                // Kondisi 4: Hasil Filter Lokal Kosong
                if (filteredArticles.isEmpty) {
                  return const Center(
                    child: Text('Tidak ada berita yang cocok.'),
                  );
                }

                // Kondisi 5: Menampilkan Daftar Berita
                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: filteredArticles.length,
                  itemBuilder: (context, index) {
                    final article = filteredArticles[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ArticleDetailPage(
                                article: article,
                              );
                            },
                          ),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (article.imageUrl.isNotEmpty)
                              Image.network(
                                article.imageUrl,
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const SizedBox(
                                    height: 120,
                                    child: Center(
                                      child: Icon(Icons.broken_image, size: 40),
                                    ),
                                  );
                                },
                              ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    article.sourceName,
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    article.title,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    article.description.isEmpty
                                        ? 'Deskripsi tidak tersedia.'
                                        : article.description,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

