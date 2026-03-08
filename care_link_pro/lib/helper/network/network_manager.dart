import 'dart:convert';
import 'package:http/http.dart' as http;
import '../helper.dart';

class ApiResponse {
  final bool isSuccess;
  final dynamic error;
  final dynamic data;
  final String status;

  ApiResponse({
    required this.isSuccess,
    this.error,
    this.data,
    required this.status,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      isSuccess: json['isSuccess'] ?? false,
      error: json['error'],
      data: json['data'],
      status: json['status']?.toString() ?? 'UNKNOWN',
    );
  }

  @override
  String toString() {
    return 'ApiResponse(isSuccess: $isSuccess, error: $error, status: $status, data: $data)';
  }
}

class NetworkManager {
  // Your login endpoint — token check will be skipped for this URL
  static const String _loginUrl = "http://dev-reentry.tetrus.dev/core/mobile/account/inmate/login"; // 🔹 Change this
  static const String _articleUrl = "http://dev-reentry.tetrus.dev/core/api/article/all"; // 🔹 Change this

  // Base method to ensure token validity
  static Future<bool> _checkAuthToken() async {
    final token = await SharedPreferencesHelper.getString('token');
    final refreshToken = await SharedPreferencesHelper.getString('refresh_token');
    final expireTime = await SharedPreferencesHelper.getInt('expire');

    final currentTime = DateTime.now().millisecondsSinceEpoch;

    if (token == null || token.isEmpty) {
      print('⚠️ No token found, fetching new token...');
      return await _getAuthToken(refreshToken);
    }

    if (expireTime != null && currentTime > expireTime) {
      print('⏰ Token expired, refreshing...');
      return await _getAuthToken(refreshToken);
    }

    print('✅ Token is valid.');
    return true;
  }

     static bool _isRefreshing = false;

  // Function to fetch new tokens using refreshToken (similar to Swift getAuthToken)
  static Future<bool> _getAuthToken(String? refreshToken) async {
  if (_isRefreshing) {
    print("⚠️ Token refresh already in progress...");
    return true;
  }

  _isRefreshing = true;

  if (refreshToken == null || refreshToken.isEmpty) {
    print('❌ No refresh token available');
    _isRefreshing = false;
    return false;
  }

  final url = "http://dev-reentry.tetrus.dev/core/account/refresh-login";
  final params = {"refreshToken": refreshToken};

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-current-datetime': getISO8601String(),
      },
      body: jsonEncode(params),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      print('🔁 Token refreshed successfully');

      await SharedPreferencesHelper.saveString('token', data['idToken']);
      await SharedPreferencesHelper.saveString('refresh_token', data['refreshToken']);
      await SharedPreferencesHelper.saveInt('expire', data['expire']);

      _isRefreshing = false;
      return true;
    } else {
      print('❌ Failed to refresh token: ${response.statusCode}');
      _isRefreshing = false;
      return false;
    }
  } catch (e) {
    print('❌ Token refresh failed: $e');
    _isRefreshing = false;
    return false;
  }
}

  // -------------------------------
  // Dynamic Header Builder
  // -------------------------------
static Future<Map<String, String>> _headers() async {
  final headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'X-current-datetime': getISO8601String(),
  };

  final token = await SharedPreferencesHelper.getString('token');
  if (token != null && token.isNotEmpty) {
    headers['Authorization'] = 'Bearer $token';
  }

  return headers;
}

static String getISO8601String() {
  final now = DateTime.now().toUtc();
  return now.toIso8601String();
}

  // -------------------------------
  // GET Request
  // -------------------------------
  static Future<ApiResponse> get(String url) async {
  try {
    await _checkAuthToken();

    final headers = await _headers();

    print("🌐 GET URL: $url");
    print("📡 HEADERS: $headers");

    final response = await http.get(Uri.parse(url), headers: headers);

    return _handleResponse(response);
  } catch (e) {
    return ApiResponse(
      isSuccess: false,
      error: 'Network request failed: $e',
      status: '503 SERVICE UNAVAILABLE',
      data: null,
    );
  }
}

  // -------------------------------
  // POST Request
  // -------------------------------
  static Future<ApiResponse> post(String url, Map<String, dynamic> params) async {
    try {
      if (url != _loginUrl) {
        await _checkAuthToken(); // 🔹 Only skip for login
      }

      final headers = await _headers();
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(params),
      );
      return _handleResponse(response);
    } catch (e) {
      return ApiResponse(
        isSuccess: false,
        error: 'Network request failed: $e',
        status: '503 SERVICE UNAVAILABLE',
        data: null,
      );
    }
  }

  // -------------------------------
  // Handle Response
  // -------------------------------
  static ApiResponse _handleResponse(http.Response response) {
  try {
    print("📥 Status Code: ${response.statusCode}");
    print("📦 Raw Response: ${response.body}");

    if (response.body.isEmpty) {
      return ApiResponse(
        isSuccess: false,
        error: 'Empty response from server',
        status: response.statusCode.toString(),
        data: null,
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is Map<String, dynamic>) {
      final apiResponse = ApiResponse.fromJson(decoded);

      if (!apiResponse.isSuccess) {
        print("❌ API Error: ${apiResponse.error}");
      }

      return apiResponse;
    }

    return ApiResponse(
      isSuccess: false,
      error: 'Unexpected response format',
      status: response.statusCode.toString(),
      data: decoded,
    );
  } catch (e) {
    print("❌ JSON Decode Error: $e");

    return ApiResponse(
      isSuccess: false,
      error: 'Failed to decode response: $e',
      status: response.statusCode.toString(),
      data: response.body,
    );
  }
}
  
}
