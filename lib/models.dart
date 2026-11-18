class WaynPost {
  final String id;
  final String userId;
  final String title;
  final String description;
  final String? imageUrl;
  final DateTime createdAt;

  WaynPost({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.createdAt,
  });

  factory WaynPost.fromJson(Map<String, dynamic> json) {
    return WaynPost(
      id: json['id'].toString(),
      userId: json['user_id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image_url'],
      createdAt: DateTime.tryParse(
            json['created_at']?.toString() ?? '',
          ) ??
          DateTime.now(),
    );
  }
}

class WaynReport {
  final String id;
  final String userId;
  final String type;
  final String description;
  final String? imageUrl;
  final DateTime createdAt;

  WaynReport({
    required this.id,
    required this.userId,
    required this.type,
    required this.description,
    this.imageUrl,
    required this.createdAt,
  });

  factory WaynReport.fromJson(Map<String, dynamic> json) {
    return WaynReport(
      id: json['id'].toString(),
      userId: json['user_id']?.toString() ?? '',
      type: json['type'] ?? 'other',
      description: json['description'] ?? '',
      imageUrl: json['image_url'],
      createdAt: DateTime.tryParse(
            json['created_at']?.toString() ?? '',
          ) ??
          DateTime.now(),
    );
  }
}

class WaynPlace {
  final String id;
  final String name;
  final String category;
  final String description;
  final String? imageUrl;
  final double? latitude;
  final double? longitude;

  WaynPlace({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    this.imageUrl,
    this.latitude,
    this.longitude,
  });

  factory WaynPlace.fromJson(Map<String, dynamic> json) {
    return WaynPlace(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      category: json['category'] ?? 'other',
      description: json['description'] ?? '',
      imageUrl: json['image_url'],
      latitude: double.tryParse(json['latitude']?.toString() ?? ''),
      longitude: double.tryParse(json['longitude']?.toString() ?? ''),
    );
  }
}
