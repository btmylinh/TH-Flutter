import '../../domain/entities/restaurant.dart';

class RestaurantModel extends Restaurant {
  const RestaurantModel({
    required super.id,
    required super.name,
    required super.description,
    required super.address,
    required super.imageUrl,
    required super.averageRating,
    required super.reviewCount,
    required super.categories,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      // Chấp nhận cả 'description' hoặc bỏ trống nếu không có
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      // Cho phép fallback các tên field phổ biến: 'rating' -> averageRating
      averageRating: (() {
        final v = json.containsKey('averageRating')
            ? json['averageRating']
            : json['rating'];
        if (v is int) return v.toDouble();
        if (v is double) return v;
        if (v is String) return double.tryParse(v) ?? 0.0;
        return 0.0;
      })(),
      // 'totalReviews' -> reviewCount
      reviewCount: (json['reviewCount'] ?? json['totalReviews'] ?? 0) as int,
      // 'categories' hoặc nếu có 'cuisine' thì chuyển thành danh sách 1 phần tử
      categories: (() {
        final cats = json['categories'];
        if (cats is List) return List<String>.from(cats);
        final cuisine = json['cuisine'];
        if (cuisine is String && cuisine.isNotEmpty) return [cuisine];
        return <String>[];
      })(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'address': address,
      'imageUrl': imageUrl,
      'averageRating': averageRating,
      'reviewCount': reviewCount,
      'categories': categories,
    };
  }
}
