import '../utils/mobile_library.dart';

class FavouriteUser extends ChangeNotifier {
  String userId;
  String favouriteUserId;
  String favouriteUserDogId;

  FavouriteUser(this.userId, this.favouriteUserId, this.favouriteUserDogId);

  factory FavouriteUser.fromJson(dynamic json) {
    return FavouriteUser(
        json['userId'] as String,
        json['favouriteUserId'] as String,
        json['favouriteUserDogId'] as String
    );
  }

  @override
  String toString() {
    return 'FavouriteUser{userId: $userId, favouriteUserId: $favouriteUserId, favouriteUserDogId: $favouriteUserDogId}';
  }
}