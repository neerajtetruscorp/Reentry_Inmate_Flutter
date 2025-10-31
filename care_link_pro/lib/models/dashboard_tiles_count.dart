/// Data Model for Articles, matching the API response structure
class DashboardTilesCount {
  final int upcomingEventsCount;
  final int programsCount;
  final String goalPercentage; // Maps to subtitle in the UI

  DashboardTilesCount({
    required this.upcomingEventsCount,
    required this.programsCount,
    required this.goalPercentage,

  });

  factory DashboardTilesCount.fromJson(Map<String, dynamic> json) {
    return DashboardTilesCount(
      upcomingEventsCount: json['upcomingEventsCount'] ?? 0,
      programsCount: json['programsCount'] ?? 0,
      goalPercentage: json['goalPercentage'] ?? '',
    );
  }
}
