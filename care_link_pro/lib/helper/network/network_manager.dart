import 'dart:convert';
import 'package:http/http.dart' as http;

// 1. API Response Model
// CRITICAL FIX: The 'error' field is now 'dynamic' to correctly handle both
// simple strings (network failures) and complex error Maps (server responses).
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

  // Factory constructor to create an ApiResponse from the server's JSON map
  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      isSuccess: json['isSuccess'] ?? false,
      // This correctly handles the 'error' field, regardless of whether it's null, a string, or a map.
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

// 2. Network Manager Class
class NetworkManager {
  // Standard headers, crucial for JSON requests
  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Static method to handle GET requests
  static Future<ApiResponse> get(String url) async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: _headers,
      );
      return _handleResponse(response);
    } catch (e) {
      // Handles network errors (no internet, DNS lookup failed, etc.)
      return ApiResponse(
        isSuccess: false,
        error: 'Network request failed: $e',
        status: '503 SERVICE UNAVAILABLE',
        data: null,
      );
    }
  }

  // Static method to handle POST requests
  static Future<ApiResponse> post(
      String url, Map<String, dynamic> params) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: _headers,
        // Convert the map of parameters into a JSON string for the body
        body: jsonEncode(params),
      );
      return _handleResponse(response);
    } catch (e) {
      // Handles network errors (no internet, DNS lookup failed, etc.)
      return ApiResponse(
        isSuccess: false,
        error: 'Network request failed: $e',
        status: '503 SERVICE UNAVAILABLE',
        data: null,
      );
    }
  }

  // 3. Private Response Handler
  static ApiResponse _handleResponse(http.Response response) {
    dynamic decodedBody;
    try {
      // Attempt to decode the response body
      decodedBody = jsonDecode(response.body);
    } catch (e) {
      // Failed to decode JSON (e.g., HTML response, empty body, or invalid JSON)
      // This is considered a failure as it doesn't match the expected API structure.
      return ApiResponse(
        isSuccess: false,
        error: 'Response body is not valid JSON. Status Code: ${response.statusCode}',
        status: response.statusCode.toString(),
        data: response.body, // The raw body is useful for debugging
      );
    }

    // Ensure the decoded body is a Map before trying to parse it as ApiResponse
    if (decodedBody is Map<String, dynamic>) {
      // Use the standard parser. Since ApiResponse.fromJson is designed to handle
      // the server's standard structure (isSuccess, error, data), we use it
      // regardless of the HTTP status code.
      return ApiResponse.fromJson(decodedBody);

    } else {
      // Handles cases where the response body is valid JSON but not a top-level Map
      return ApiResponse(
        isSuccess: false,
        error: 'Server response is valid JSON but not a top-level object.',
        status: response.statusCode.toString(),
        data: decodedBody,
      );
    }
  }
}
