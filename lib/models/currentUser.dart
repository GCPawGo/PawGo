
class CurrentUser {
  String userAge;
  String userDesc;

  CurrentUser(this.userAge, this.userDesc);

  factory CurrentUser.fromJson(dynamic json) {
    return CurrentUser(json['userAge'] as String, json['userDesc'] as String);
  }

  String getUserAge() {
    return userAge;
  }

  String getUserDesc() {
    return userDesc;
  }

  @override
  String toString() {
    return 'CurrentUser{userAge: $userAge, userDesc: $userDesc}';
  }
}