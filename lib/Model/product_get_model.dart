

import 'dart:convert';

List<ProductGetModels> productGetModelsFromJson(String str) =>
    List<ProductGetModels>.from(json.decode(str).map((x) => ProductGetModels.fromJson(x)));

String userModelsToJson(List<ProductGetModels> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductGetModels {
  String id;
  String name;
  double price;
  String imageUrl;
  String productType;
  String description;

  ProductGetModels({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.productType,
    required this.description,
  });

  factory ProductGetModels.fromJson(Map<String, dynamic> json) => ProductGetModels(
    id: json["id"],
    name: json["name"],
    price: json["price"],
    imageUrl: json["thumbnail"],
    productType: json["condition"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "price": price,
    "thumbnail": imageUrl,
    "condition": productType,
    "description": description,
  };
}