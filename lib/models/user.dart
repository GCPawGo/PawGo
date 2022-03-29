
class User {
  String userAge;
  String userDesc;

  User(this.userAge, this.userDesc);

  factory User.fromJson(dynamic json) {
    return User(json['userAge'] as String, json['userDesc'] as String);
  }

  @override
  String toString() {
    return 'User{userAge: $userAge, userDesc: $userDesc}';
  }
}