import 'package:hive/hive.dart';


@HiveType(typeId: 0)
class IMCModel {
  @HiveField(0)
  String name;

  @HiveField(1)
  double height;

  @HiveField(2)
  double weight;

  IMCModel(this.name, this.height, this.weight);

  double calculateIMC() {
    return weight / (height * height);
  }
}
