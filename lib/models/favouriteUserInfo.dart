import '../utils/mobile_library.dart';

class FavouriteUserInfo extends ChangeNotifier {
  String userId;
  String userName;
  String userMail;
  String userImage;
  String dogImage;

  FavouriteUserInfo(this.userId, this.userName, this.userMail, this.userImage, this.dogImage);

  factory FavouriteUserInfo.fromJson(dynamic json) {
    return FavouriteUserInfo(
        json['userId'] as String,
        json['userName'] as String,
        json['userMail'] as String,
        json['userImage'] as String,
        json['dogImage'] as String
    );
  }

  @override
  String toString() {
    return 'FavouriteUserInfo{userId: $userId, userName: $userName, userMail: $userMail, userImage: $userImage, dogImage: $dogImage}';
  }
}