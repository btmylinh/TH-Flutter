import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/restaurant_model.dart';

abstract class RestaurantRemoteDataSource {
  Future<List<RestaurantModel>> getRestaurants();
  Future<RestaurantModel> getRestaurantDetail(String id);
  Future<String> addRestaurant(Map<String, dynamic> data);
}

class RestaurantRemoteDataSourceImpl implements RestaurantRemoteDataSource {
  final FirebaseFirestore firestore;

  RestaurantRemoteDataSourceImpl({required this.firestore});

  @override
  Future<String> addRestaurant(Map<String, dynamic> data) async {
    try {
      final docRef = await firestore.collection('restaurants').add(data);
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add restaurant: ${e.toString()}');
    }
  }

  @override
  Future<List<RestaurantModel>> getRestaurants() async {
    try {
      final snapshot = await firestore.collection('restaurants').get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return RestaurantModel.fromJson(data);
      }).toList();
    } catch (e) {
      throw Exception('Failed to get restaurants: ${e.toString()}');
    }
  }

  @override
  Future<RestaurantModel> getRestaurantDetail(String id) async {
    try {
      final doc = await firestore.collection('restaurants').doc(id).get();
      if (!doc.exists) {
        throw Exception('Restaurant not found');
      }
      final data = doc.data()!;
      data['id'] = doc.id;
      return RestaurantModel.fromJson(data);
    } catch (e) {
      throw Exception('Failed to get restaurant detail: ${e.toString()}');
    }
  }
}
