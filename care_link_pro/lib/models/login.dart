/// Data Model for Articles, matching the API response structure
class LoginDetails {
  final String idToken;
  final String refreshToken; // Maps to subtitle in the UI
  final String displayName;
  final String lmsUserId;
  final String refId;
  final String tenantId;

  LoginDetails({
    required this.idToken,
    required this.refreshToken,
    required this.displayName,
    required this.lmsUserId,
    required this.refId,
    required this.tenantId,
  });

  factory LoginDetails.fromJson(Map<String, dynamic> json) {
    return LoginDetails(
      idToken: json['idToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      displayName: json['displayName'] ?? '',
      lmsUserId: json['lmsUserId'] ?? '',
      refId: json['refId'] ?? '',
      tenantId: json['tenantId'] ?? '',

    );
  }
}
