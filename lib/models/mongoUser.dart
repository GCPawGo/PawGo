
class MongoUser {
  String userId;
  String? username;


  MongoUser(this.userId, this.username);

  factory MongoUser.fromJson(dynamic json) {
    return MongoUser(
        json['userId'] as String,
        null
    );
  }

  @override
  String toString() {
    return 'MongoUser{userId: $userId, username: $username}';
  }
}
