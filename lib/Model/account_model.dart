import 'package:hive/hive.dart';

part 'account_model.g.dart';

@HiveType(typeId: 1)
class AccountModel {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? username;

  @HiveField(2)
  String? password;

  AccountModel({required this.username, required this.password});
}
