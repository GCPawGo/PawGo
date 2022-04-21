import 'package:pawgo/models/dog.dart';

import '../utils/mobile_library.dart';

class SearchResult extends ChangeNotifier {
  String userId;
  String userName;
  String userMail;
  String userAge;
  String userDesc;
  String userImage;
  Dog dog;

  SearchResult(this.userId, this.userName, this.userMail, this.userAge, this.userDesc, this.userImage, this.dog);

  @override
  String toString() {
    return 'SearchResult{userId: $userId, userName: $userName, userMail: $userMail, userAge: $userAge, userDesc: $userDesc, userImage: $userImage, dog: $dog}';
  }
}