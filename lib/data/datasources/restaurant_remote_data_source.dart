import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/restaurant_model.dart';

abstract class RestaurantRemoteDataSource {
  Stream<List<RestaurantModel>> getRestaurants();
  Future<RestaurantModel> getRestaurantById(String id);
  Stream<RestaurantModel> watchRestaurant(String id);
  Future<void> createRestaurant({
    required String name,
    required String description,
    required String address,
    required String category,
    required String imageUrl,
  });
  Future<void> deleteRestaurant(String id);
}

class RestaurantRemoteDataSourceImpl implements RestaurantRemoteDataSource {
  final FirebaseFirestore firestore;

  RestaurantRemoteDataSourceImpl({required this.firestore});

  @override
  Stream<List<RestaurantModel>> getRestaurants() {
    return firestore
        .collection('restaurants')
        .orderBy('averageRating', descending: true)
        .snapshots()
        .map((snapshot) {
          final docs = snapshot.docs;
          print(
            '📥 [RestaurantRemoteDataSource] getRestaurants snapshot: ${docs.length} documents',
          );
          for (final doc in docs) {
            print('  🔹 docId=${doc.id}, data=${doc.data()}');
          }
          return docs
              .map((doc) => RestaurantModel.fromJson(doc.data(), doc.id))
              .toList();
        });
  }

  @override
  Future<RestaurantModel> getRestaurantById(String id) async {
    try {
      final doc = await firestore.collection('restaurants').doc(id).get();
      if (!doc.exists) {
        throw Exception('Restaurant not found');
      }
      return RestaurantModel.fromJson(doc.data()!, doc.id);
    } catch (e) {
      throw Exception('Get restaurant failed: ${e.toString()}');
    }
  }

  @override
  Stream<RestaurantModel> watchRestaurant(String id) {
    return firestore.collection('restaurants').doc(id).snapshots().map((doc) {
      if (!doc.exists) {
        throw Exception('Restaurant not found');
      }
      return RestaurantModel.fromJson(doc.data()!, doc.id);
    });
  }

  @override
  Future<void> createRestaurant({
    required String name,
    required String description,
    required String address,
    required String category,
    required String imageUrl,
  }) async {
    try {
      print('📝 CreateRestaurant - imageUrl nhận được: $imageUrl');

      final restaurant = RestaurantModel(
        id: '', // Firestore will generate
        name: name,
        description: description,
        address: address,
        category: category,
        imageUrl: imageUrl,
        averageRating: 0,
        reviewCount: 0,
        createdAt: DateTime.now(),
      );

      final jsonData = restaurant.toJson();
      print('📤 Data sẽ lưu vào Firestore: $jsonData');

      final docRef = await firestore.collection('restaurants').add(jsonData);
      print('✅ Đã lưu restaurant vào Firestore với ID: ${docRef.id}');
    } catch (e) {
      print('❌ Lỗi khi tạo restaurant: ${e.toString()}');
      throw Exception('Create restaurant failed: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteRestaurant(String id) async {
    try {
      print('🗑️ Đang xóa restaurant với ID: $id');
      await firestore.collection('restaurants').doc(id).delete();
      print('✅ Đã xóa restaurant thành công');
    } catch (e) {
      print('❌ Lỗi khi xóa restaurant: ${e.toString()}');
      throw Exception('Delete restaurant failed: ${e.toString()}');
    }
  }
}
