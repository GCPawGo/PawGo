import '../utils/mobile_library.dart';

class CurrentUser extends ChangeNotifier {
  String userAge;
  String userDesc;

  CurrentUser(this.userAge, this.userDesc);

  static CurrentUser? instance;

  static initInstance(String userAge, String userDesc) {
    instance = CurrentUser(userAge, userDesc);
  }

  factory CurrentUser.fromJson(dynamic json) {
    return CurrentUser(json['userAge'] as String, json['userDesc'] as String);
  }

  String getUserAge() {
    return userAge;
  }

  String getUserDesc() {
    return userDesc;
  }

  void updateUserAge(String un) {
    instance!.userAge = un;
    notifyListeners();
  }

  void updateUserDesc(String un) {
    instance!.userDesc = un;
    notifyListeners();
  }

  @override
  String toString() {
    return 'CurrentUser{userAge: $userAge, userDesc: $userDesc}';
  }
}