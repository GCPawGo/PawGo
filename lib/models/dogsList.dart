import 'package:pawgo/models/dog.dart';

import '../utils/mobile_library.dart';

class DogsList extends ChangeNotifier {
  List<Dog> dogsList;

  DogsList(this.dogsList);

  static DogsList? instance;

  static initInstance(List<Dog> dogsList) {
    instance = DogsList(dogsList);
  }

  void updateDogsList(List<Dog> un) {
    instance!.dogsList = un;
    notifyListeners();
  }
}