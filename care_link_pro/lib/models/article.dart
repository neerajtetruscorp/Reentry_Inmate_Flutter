/// Data Model for Articles, matching the API response structure
class Article {
  final int id;
  final String title;
  final String body; // Maps to subtitle in the UI
  final String url;
  final String imgBase64;
  final String logoImgBase64;

  Article({
    required this.id,
    required this.title,
    required this.body,
    required this.url,
    required this.imgBase64,
    required this.logoImgBase64,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
      url: json['url'] as String,
      imgBase64: json['imgBase64'] as String,
      logoImgBase64: json['logoImgBase64'] as String,
    );
  }
}
