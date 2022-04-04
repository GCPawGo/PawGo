import '../utils/mobile_library.dart';

class Dog extends ChangeNotifier {
  String userId;
  String dogName;
  String dogAge;
  String dogBreed;
  String dogHobby;
  String dogPersonality;

  Dog(this.userId, this.dogName, this.dogAge, this.dogBreed, this.dogHobby, this.dogPersonality);

  factory Dog.fromJson(dynamic json) {
    return Dog(
        json['userId'] as String,
        json['dogName'] as String,
        json['dogAge'] as String,
        json['dogBreed'] as String,
        json['dogHobby'] as String,
        json['dogPersonality'] as String
    );
  }

  @override
  String toString() {
    return 'Dog{userId: $userId, dogName: $dogName, dogAge: $dogAge, dogBreed: $dogBreed, dogHobby: $dogHobby, dogPersonality: $dogPersonality}';
  }
}