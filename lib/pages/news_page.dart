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
  bool _isPreviewMode = false;

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
    _newsFuture = _loadNews();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _localFilterController.dispose();
    super.dispose();
  }

  Future<List<Article>> _loadNews() {
    if (_isPreviewMode) {
      return Future.value(
        _getPreviewArticles(
          category: _selectedCategory,
          query: _activeSearchQuery,
        ),
      );
    }
    if (_activeSearchQuery.isNotEmpty) {
      return _newsService.searchArticles(query: _activeSearchQuery);
    }
    return _newsService.fetchTopHeadlines(category: _selectedCategory);
  }

  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
      _activeSearchQuery = '';
      _searchController.clear();
      _newsFuture = _loadNews();
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
      _newsFuture = _loadNews();
    });
  }

  void _retryFetch() {
    setState(() {
      _newsFuture = _loadNews();
    });
  }

  void _enablePreviewMode() {
    setState(() {
      _isPreviewMode = true;
      _newsFuture = _loadNews();
    });
  }

  void _disablePreviewMode() {
    setState(() {
      _isPreviewMode = false;
      _newsFuture = _loadNews();
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

  List<Article> _getPreviewArticles({
    required String category,
    String query = '',
  }) {
    final allSamples = <String, List<Article>>{
      'general': [
        Article(
          title: 'Global Summit Discusses Clean Energy Transition and Digital Infrastructure',
          description:
              'Leaders and researchers met this week to outline long-term investments in renewable grids and cross-border digital networks.',
          imageUrl: '',
          sourceName: 'Reuters',
          publishedAt: '2026-11-18T08:00:00Z',
          url: 'https://www.reuters.com',
        ),
        Article(
          title: 'Public Transit Modernization Accelerates Across Major Cities',
          description:
              'Electric bus fleets and unified mobile ticketing systems are expanding across metropolitan transit corridors.',
          imageUrl: '',
          sourceName: 'Associated Press',
          publishedAt: '2026-11-18T06:30:00Z',
          url: 'https://apnews.com',
        ),
      ],
      'technology': [
        Article(
          title: 'Flutter Framework Expands Multi-Platform Web Performance',
          description:
              'New compiler optimizations improve startup speed and rendering smoothness across desktop and mobile browsers.',
          imageUrl: '',
          sourceName: 'TechCrunch',
          publishedAt: '2026-11-18T07:45:00Z',
          url: 'https://flutter.dev',
        ),
        Article(
          title: 'Open-Source AI Tooling Focuses on Local Developer Privacy',
          description:
              'Developers are adopting lightweight local inference pipelines and strict secret isolation practices.',
          imageUrl: '',
          sourceName: 'The Verge',
          publishedAt: '2026-11-17T21:15:00Z',
          url: 'https://www.theverge.com',
        ),
      ],
      'business': [
        Article(
          title: 'Small Software Studios Drive Regional Export Growth',
          description:
              'Independent mobile app teams report stronger recurring revenue from cross-border SaaS and utility products.',
          imageUrl: '',
          sourceName: 'Bloomberg',
          publishedAt: '2026-11-18T05:10:00Z',
          url: 'https://www.bloomberg.com',
        ),
      ],
      'sports': [
        Article(
          title: 'Champions League Night Delivers Late Dramatic Equalizer',
          description:
              'A stoppage-time strike secured a crucial point in a high-tempo European fixture.',
          imageUrl: '',
          sourceName: 'BBC Sport',
          publishedAt: '2026-11-18T04:00:00Z',
          url: 'https://www.bbc.com/sport',
        ),
      ],
      'science': [
        Article(
          title: 'Deep Ocean Sensors Capture New Thermal Vent Ecosystems',
          description:
              'Marine biologists cataloged previously unseen mineral structures along the Pacific ridge.',
          imageUrl: '',
          sourceName: 'Nature News',
          publishedAt: '2026-11-17T18:20:00Z',
          url: 'https://www.nature.com',
        ),
      ],
      'health': [
        Article(
          title: 'Consistent Sleep Routines Linked to Stronger Metabolic Health',
          description:
              'A multi-year observational study highlights the value of regular sleep timing alongside daily movement.',
          imageUrl: '',
          sourceName: 'Medical News Today',
          publishedAt: '2026-11-17T15:00:00Z',
          url: 'https://www.medicalnewstoday.com',
        ),
      ],
      'entertainment': [
        Article(
          title: 'Independent Animation Showcase Opens With Record Attendance',
          description:
              'Short-form creators from Southeast Asia premiered original hand-crafted visual stories.',
          imageUrl: '',
          sourceName: 'Variety',
          publishedAt: '2026-11-17T12:40:00Z',
          url: 'https://variety.com',
        ),
      ],
    };

    if (query.isNotEmpty) {
      final combined = allSamples.values.expand((list) => list).toList();
      return combined
          .where((a) =>
              a.title.toLowerCase().contains(query.toLowerCase()) ||
              a.description.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    return allSamples[category] ?? allSamples['general']!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News App'),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            children: [
              if (_isPreviewMode)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 18,
                        color: Colors.blue.shade800,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Mode Pratinjau UI aktif (API Key tidak dipublikasikan di web statis).',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue.shade900,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: _disablePreviewMode,
                        child: const Text('Coba API'),
                      ),
                    ],
                  ),
                ),

              // 1. Kotak Pencarian Berita (API Filter)
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  controller: _searchController,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (_) => _searchNews(),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
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
                    filled: true,
                    fillColor: Colors.white,
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
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
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
                      final errorMsg = '${snapshot.error}'
                          .replaceAll('Exception: ', '');
                      final isMissingConfig =
                          errorMsg.contains('NEWS_API_KEY belum diatur');

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
                                  errorMsg,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Wrap(
                                  spacing: 12,
                                  runSpacing: 8,
                                  alignment: WrapAlignment.center,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: _retryFetch,
                                      icon: const Icon(Icons.refresh),
                                      label: const Text('Coba Lagi'),
                                    ),
                                    if (isMissingConfig)
                                      OutlinedButton.icon(
                                        onPressed: _enablePreviewMode,
                                        icon: const Icon(Icons.visibility),
                                        label: const Text(
                                          'Pratinjau UI (Mode Demo)',
                                        ),
                                      ),
                                  ],
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
                                          child: Icon(
                                            Icons.broken_image,
                                            size: 40,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                Padding(
                                  padding: const EdgeInsets.all(14),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
        ),
      ),
    );
  }
}
