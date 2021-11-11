import 'package:hive/hive.dart';
part 'LiverOffline.g.dart';

@HiveType(typeId: 0)
class Person extends HiveObject {
  @HiveField(0)
  String? counter;

  @HiveField(1)
  String? fullName;

  @HiveField(2)
  String? id;

  @HiveField(3)
  String? uchetId;

  @HiveField(4)
  var pokazanie;
  Person({this.counter, this.fullName, this.id, this.uchetId, this.pokazanie});
}

@HiveType(typeId: 1)
class LiverId extends HiveObject {
  @HiveField(0)
  var allId;
  LiverId({this.allId});
}
