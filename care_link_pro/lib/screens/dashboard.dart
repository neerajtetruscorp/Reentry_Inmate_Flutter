import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../helper/network/network_manager.dart';
import '../models/article.dart';
import 'my_profile.dart';

// ---------------------------
// Constants
// ---------------------------

/// Primary blue theme color used throughout the app.
const Color kPrimaryBlue = Color(0xFF1976D2);

/// Background color used for article section.
const Color kArticleListColor = Color(0xFFE8EAF6);

/// API endpoint URL to fetch all articles.
const String kArticlesApiUrl = "http://dev-reentry.tetrus.dev/core/api/article/all";

/// Base URL for image resources.
const String kBaseImageUrl = "http://dev-reentry.tetrus.dev/";

/// Dashboard screen — the main landing screen after login.
///
/// Displays quick stats (Programs, Appointments, Goals, My Info),
/// a personalized greeting, articles fetched from backend API,
/// and a bottom navigation bar for switching between tabs.
class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool _isLoading = true;
  List<Article> _articles = [];
  String? _fetchError;

  int _selectedIndex = 0; // Track the current bottom navigation index.

  // Mock counts — these values should be replaced with API-based data.
  int _programCount = 11;
  int _appointmentCount = 5;
  int _goalsCount = 0;
  int _infoCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchArticles();
  }

  // ---------------------------------------------------------------------------
  // DATA FETCHING & API HANDLING
  // ---------------------------------------------------------------------------

  /// Fetches the list of articles from the remote API endpoint.
  ///
  /// - Sets loading state before making the request.
  /// - Calls the custom `NetworkManager.get()` utility to handle HTTP GET requests.
  /// - On success, parses the list of articles into `Article` model objects.
  /// - On failure, stores an error message for display in the UI.
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

  // ---------------------------------------------------------------------------
  // EVENT HANDLERS
  // ---------------------------------------------------------------------------

  /// Handles tap actions when a dashboard tile (Programs, Appointments, etc.) is tapped.
  ///
  /// Currently logs the title tapped — can be extended for navigation or action triggers.
  void _onTileTapped(String title) {
    debugPrint('Tapped on: $title');
  }

  /// Handles tap actions when an article is selected.
  ///
  /// Currently logs the article title — can be replaced by navigation to a detail screen.
  void _onArticleTapped(String title) {
    debugPrint('Tapped on article: $title');
  }

  // ---------------------------------------------------------------------------
  // UI BUILDERS — DASHBOARD CARDS
  // ---------------------------------------------------------------------------

  /// Builds a single dashboard tile widget (e.g., Programs, Appointments).
  ///
  /// Displays:
  /// - Icon on the left
  /// - Count value on the top-right
  /// - Title at the bottom
  ///
  /// Uses a gradient color background and elevation shadow for visual emphasis.
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
            // Top Row: Icon + Count
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
            // Bottom Text: Tile title
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

  /// Builds the grid layout containing all four main dashboard tiles.
  ///
  /// Uses a `GridView.count` with two columns and fixed aspect ratio.
  ///
  /// Scrolling is disabled (`NeverScrollableScrollPhysics`) because
  /// this grid appears inside a parent scroll view.
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
          color: const Color(0xFFFC5F2D),
          count: _programCount,
        ),
        _buildTile(
          title: 'Appointments',
          icon: Icons.calendar_today,
          color: const Color(0xFF06BD76),
          count: _appointmentCount,
        ),
        _buildTile(
          title: 'My Goals',
          icon: Icons.flag,
          color: const Color(0xFF2AC3FF),
          count: _goalsCount,
        ),
        _buildTile(
          title: 'My Info',
          icon: Icons.credit_card,
          color: const Color(0xFF7A54FF),
          count: _infoCount,
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // UI BUILDERS — ARTICLES SECTION
  // ---------------------------------------------------------------------------

  /// Builds the main articles content area.
  ///
  /// Handles three states:
  /// - **Loading:** Shows a progress indicator.
  /// - **Error:** Displays an error message and retry button.
  /// - **Success:** Displays a non-scrollable list of articles.
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

  /// Determines whether to display the article list, error message, or fallback message.
  ///
  /// Wraps [_buildArticlesListContent] with appropriate header and layout styling.
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

  /// Builds a single article tile widget.
  ///
  /// Each tile contains:
  /// - Article thumbnail image (fetched from server)
  /// - Title and a short preview of the article body
  ///
  /// Tapping the tile triggers [_onArticleTapped].
  Widget _buildArticleTile(Article article) {
    final logoUrl = '$kBaseImageUrl${article.logoImgBase64}';

    return InkWell(
      onTap: () => _onArticleTapped(article.title),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left: Article image
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
            // Right: Text content
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

  // ---------------------------------------------------------------------------
  // UI BUILDERS — STATIC COMPONENTS
  // ---------------------------------------------------------------------------

  /// Builds the fixed top navigation bar displaying the app name "CareLink"
  /// and a notification icon.
  ///
  /// The app bar remains visible and fixed while the user scrolls content below.
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

  /// Displays a simple greeting message to the user.
  ///
  /// In production, the name (e.g., "Jonathan") can be dynamic
  /// based on the logged-in user’s profile information.
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

  // ---------------------------------------------------------------------------
  // UI BUILDERS — BOTTOM NAVIGATION
  // ---------------------------------------------------------------------------

  /// Builds the persistent bottom navigation bar with four tabs:
  /// Home, QR Code, Profile, and More.
  ///
  /// Highlights the currently active tab and updates `_selectedIndex`
  /// on tap to switch between pages within the same scaffold.
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

  // ---------------------------------------------------------------------------
  // UI BUILDERS — MAIN CONTENT
  // ---------------------------------------------------------------------------

  /// Builds the main home screen layout.
  ///
  /// Contains:
  /// - Fixed top navigation bar (`_buildAppBar`)
  /// - Scrollable body with greeting, tiles, and articles
  ///
  /// Uses `Expanded` + `SingleChildScrollView` to allow
  /// only the content area to scroll while keeping the top bar fixed.
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
        _buildAppBar(), // Fixed top bar
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

  // ---------------------------------------------------------------------------
  // MAIN BUILD METHOD
  // ---------------------------------------------------------------------------

  /// Builds the root structure of the `Dashboard` screen.
  ///
  /// The layout includes:
  /// - SafeArea with one of four pages (based on `_selectedIndex`)
  /// - Persistent bottom navigation bar for page switching
  ///
  /// Page 0 → Home
  /// Page 1 → QR Code
  /// Page 2 → Profile
  /// Page 3 → More
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
