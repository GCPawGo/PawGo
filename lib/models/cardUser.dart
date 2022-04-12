import 'package:pawgo/models/dog.dart';

import '../utils/mobile_library.dart';

class CardUser extends ChangeNotifier {
  String userId;
  String userName;
  String userAge;
  String userImage;
  String userDesc;
  Dog dog;

  CardUser(this.userId, this.userName, this.userAge, this.userImage, this.userDesc, this.dog);

  @override
  String toString() {
    return 'CardUser{userId: $userId, userName: $userName, userAge: $userAge, userImage: $userImage, userDesc: $userDesc, dog: $dog}';
  }
}
