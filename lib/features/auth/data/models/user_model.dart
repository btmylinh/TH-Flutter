import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    required super.email,
    super.displayName,
  });

  factory UserModel.fromFirebase(dynamic user) {
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
    );
  }

  Map<String, dynamic> toJson() {
    return {'uid': uid, 'email': email, 'displayName': displayName};
  }
}
