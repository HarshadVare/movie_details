class CachedResponse {
  final String data;
  final DateTime expiresAt;

  CachedResponse({required this.data, required this.expiresAt});

  factory CachedResponse.fromJson(Map<String, dynamic> json) {
    return CachedResponse(
      data: json["data"],
      expiresAt: DateTime.parse(
        json["expires_at"],
      ),
    );
  }

  static Map<String, dynamic> toJson(CachedResponse data) {
    return {"data": data.data, "expires_at": data.expiresAt.toString()};
  }
}
