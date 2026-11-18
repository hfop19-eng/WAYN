
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
      title: json['title']?.toString() ?? '',
      description: (json['content'] ?? json['description'] ?? '').toString(),
      imageUrl: json['image_url']?.toString(),
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
  final String category;
  final String title;
  final String description;
  final String? area;
  final String? imageUrl;
  final String status;
  final DateTime createdAt;

  WaynReport({
    required this.id,
    required this.userId,
    required this.category,
    required this.title,
    required this.description,
    this.area,
    this.imageUrl,
    required this.status,
    required this.createdAt,
  });

  factory WaynReport.fromJson(Map<String, dynamic> json) {
    return WaynReport(
      id: json['id'].toString(),
      userId: json['user_id']?.toString() ?? '',
      category: json['category']?.toString() ?? 'other',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      area: json['area']?.toString(),
      imageUrl: json['image_url']?.toString(),
      status: json['status']?.toString() ?? 'pending',
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
      name: json['name']?.toString() ?? '',
      category: json['category']?.toString() ?? 'other',
      description: json['description']?.toString() ?? '',
      imageUrl: json['image_url']?.toString(),
      latitude: double.tryParse(json['latitude']?.toString() ?? ''),
      longitude: double.tryParse(json['longitude']?.toString() ?? ''),
    );
  }
}
