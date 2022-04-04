import '../utils/mobile_library.dart';

class Dog extends ChangeNotifier {
  String _id;
  String userId;
  String dogName;
  String dogAge;
  String dogBreed;
  String dogHobby;
  String dogPersonality;

  Dog(this._id, this.userId, this.dogName, this.dogAge, this.dogBreed, this.dogHobby, this.dogPersonality);

  factory Dog.fromJson(dynamic json) {
    return Dog(
        json['_id'] as String,
        json['userId'] as String,
        json['dogName'] as String,
        json['dogAge'] as String,
        json['dogBreed'] as String,
        json['dogHobby'] as String,
        json['dogPersonality'] as String
    );
  }


  String get id => _id;

  @override
  String toString() {
    return 'Dog{_id: $_id, userId: $userId, dogName: $dogName, dogAge: $dogAge, dogBreed: $dogBreed, dogHobby: $dogHobby, dogPersonality: $dogPersonality}';
  }
}