import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../helper/network/network_manager.dart';
import '../models/article.dart';
import 'my_profile.dart';

// Constants
const Color kPrimaryBlue = Color(0xFF1976D2);
const Color kArticleListColor = Color(0xFFE8EAF6);
const String kArticlesApiUrl = "http://dev-reentry.tetrus.dev/core/api/article/all";
const String kBaseImageUrl = "http://dev-reentry.tetrus.dev/";

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool _isLoading = true;
  List<Article> _articles = [];
  String? _fetchError;

  int _selectedIndex = 0; // ✅ Track current tab index

  // Mock counts (replace with real API calls)
  int _programCount = 11;
  int _appointmentCount = 5;
  int _goalsCount = 0;
  int _infoCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchArticles();
  }

  Future<void> _fetchArticles() async {
    setState(() {
      _isLoading = true;
      _fetchError = null;
    });

    try {
      final result = await NetworkManager.get(kArticlesApiUrl);
      if (mounted) {
        if (result.isSuccess && result.data is List) {
          _articles = (result.data as List)
              .map((json) => Article.fromJson(json))
              .toList();
        } else {
          _fetchError = result.error?.toString() ?? 'Failed to load articles.';
        }
      }
    } catch (e) {
      if (mounted) _fetchError = 'Network error: $e';
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _onTileTapped(String title) {
    debugPrint('Tapped on: $title');
  }

  void _onArticleTapped(String title) {
    debugPrint('Tapped on article: $title');
  }

  Widget _buildTile({
    required String title,
    required IconData icon,
    required Color color,
    required int count,
  }) {
    return InkWell(
      onTap: () => _onTileTapped(title),
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: Colors.white, size: 30),
                Text(
                  count.toString().padLeft(2, '0'),
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Poppins',
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainTiles() {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16.0,
      mainAxisSpacing: 16.0,
      childAspectRatio: 1.1,
      padding: EdgeInsets.zero,
      children: <Widget>[
        _buildTile(
          title: 'Programs',
          icon: Icons.assignment,
          color: Color(0xFFFC5F2D),
          count: _programCount,

        ),
        _buildTile(
          title: 'Appointments',
          icon: Icons.calendar_today,
          color: Color(0xFF06BD76),
          count: _appointmentCount,
        ),
        _buildTile(
          title: 'My Goals',
          icon: Icons.flag,
          color: Color(0xFF2AC3FF),
          count: _goalsCount,
        ),
        _buildTile(
          title: 'My Info',
          icon: Icons.credit_card,
          color: Color(0xFF7A54FF),
          count: _infoCount,
        ),
      ],
    );
  }

  Widget _buildArticlesListContent() {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    if (_fetchError != null) {
      return Center(
        child: Column(
          children: [
            Text(
              'Error: $_fetchError',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.red.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            TextButton(onPressed: _fetchArticles, child: const Text('Try Again')),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _articles.length,
      itemBuilder: (context, index) {
        return _buildArticleTile(_articles[index]);
      },
    );
  }

  Widget? _buildArticlesList() {
    if (_isLoading) return _buildArticlesListContent();

    if (!_isLoading && _fetchError == null && _articles.isEmpty) {
      return const Center(
        child: Text(
          'No articles found.',
          style: TextStyle(fontFamily: 'Poppins'),
        ),
      );
    }

    if (_fetchError != null) return _buildArticlesListContent();

    if (_articles.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Articles',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          _buildArticlesListContent(),
        ],
      );
    }
    return null;
  }

  Widget _buildArticleTile(Article article) {
    final logoUrl = '$kBaseImageUrl${article.logoImgBase64}';

    return InkWell(
      onTap: () => _onArticleTapped(article.title),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.blueGrey.shade800,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  logoUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                  const Center(child: Icon(Icons.description, color: Colors.white)),
                  loadingBuilder: (context, child, progress) =>
                  progress == null ? child : const Center(child: CircularProgressIndicator()),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    article.body,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Icon(Icons.link, color: kPrimaryBlue, size: 28),
            const SizedBox(width: 4),
            Icon(Icons.favorite, color: Colors.red.shade700, size: 20),
            const SizedBox(width: 4),
            const Text(
              'CareLink',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ]),
          const Icon(Icons.notifications_none, size: 28),
        ],
      ),
    );
  }

  Widget _buildGreeting() {
    return const Padding(
      padding: EdgeInsets.only(top: 24.0),
      child: Text(
        'Hello Jonathan!',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 20,
          color: Colors.black87,
        ),
      ),
    );
  }

  // ✅ Bottom navigation bar with tab switching (not push navigation)
  Widget _buildBottomNavBar() {
    final items = [
      {'icon': Icons.home, 'label': 'Home'},
      {'icon': Icons.qr_code, 'label': 'QR Code'},
      {'icon': Icons.person_outline, 'label': 'Profile'},
      {'icon': Icons.more_horiz, 'label': 'More'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1.0)),
      ),
      height: 50 + MediaQuery.of(context).padding.bottom,
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final isActive = _selectedIndex == index;
          final color = isActive ? kPrimaryBlue : Colors.grey.shade600;

          return InkWell(
            onTap: () => setState(() => _selectedIndex = index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(items[index]['icon'] as IconData, color: color, size: 26),
                const SizedBox(height: 4),
                Text(
                  items[index]['label'] as String,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: color,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildHomeContent() {
    final screenWidth = MediaQuery.of(context).size.width;
    const horizontalPadding = 24.0 * 2;
    const crossAxisSpacing = 16.0;
    final availableWidth = screenWidth - horizontalPadding;
    final tileWidth = (availableWidth - crossAxisSpacing) / 2;
    final requiredTileHeight = (tileWidth * 2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildAppBar(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildGreeting(),
                const SizedBox(height: 24),
                SizedBox(height: requiredTileHeight, child: _buildMainTiles()),
                const SizedBox(height: 32),
                if (_buildArticlesList() != null) _buildArticlesList()!,
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildHomeContent(),
      const Center(child: Text("QR Code Screen")),
      const MyProfileScreen(),
      const Center(child: Text("More Screen")),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: pages[_selectedIndex]),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }
}
