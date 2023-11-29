import 'package:hive/hive.dart';

part 'cosmetic_model.g.dart';

@HiveType(typeId: 0)
class CosmeticModel {
  @HiveField(0)
  final int? id;
  @HiveField(1)
  final String? brand;
  @HiveField(2)
  final String? name;
  @HiveField(3)
  final String? price;
  @HiveField(4)
  final String? priceSign;
  @HiveField(5)
  final String? imageLink;
  @HiveField(6)
  final String? productLink;
  @HiveField(7)
  final String? websiteLink;
  @HiveField(8)
  final String? description;

  CosmeticModel({
    this.id,
    this.brand,
    this.name,
    this.price,
    this.priceSign,
    this.imageLink,
    this.productLink,
    this.websiteLink,
    this.description,
  });
}
