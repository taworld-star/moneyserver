
import 'package:meta/meta.dart';
import 'dart:convert';

Category categoryFromMap(String str) => Category.fromMap(json.decode(str));

String categoryToMap(Category data) => json.encode(data.toMap());

class Category {
    String status;
    String message;
    Data data;

    Category({
        required this.status,
        required this.message,
        required this.data,
    });

    factory Category.fromMap(Map<String, dynamic> json) => Category(
        status: json["status"],
        message: json["message"],
        data: Data.fromMap(json["data"]),
    );

    Map<String, dynamic> toMap() => {
        "status": status,
        "message": message,
        "data": data.toMap(),
    };
}

class Data {
    int id;
    String name;
    String type;

    Data({
        required this.id,
        required this.name,
        required this.type,
    });

    factory Data.fromMap(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        type: json["type"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "type": type,
    };
}
