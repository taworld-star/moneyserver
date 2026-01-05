import 'dart:convert';

class GetTransactionResponse {
    final String status;
    final String message;
    final List<Data> data;

    GetTransactionResponse({
        required this.status,
        required this.message,
        required this.data,
    });

    GetTransactionResponse copyWith({
        String? status,
        String? message,
        List<Data>? data,
    }) => 
        GetTransactionResponse(
            status: status ?? this.status,
            message: message ?? this.message,
            data: data ?? this.data,
        );

    factory GetTransactionResponse.fromJson(String str) => GetTransactionResponse.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GetTransactionResponse.fromMap(Map<String, dynamic> json) => GetTransactionResponse(
        status: json["status"],
        message: json["message"],
        data: List<Data>.from(json["data"].map((x) => Data.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
    };
}

class Data {
    final int id;
    final String categoryName;
    final String categoryType;
    final int amount;
    final DateTime transactionDate;
    final dynamic note;
    final dynamic image;
    final DateTime createdAt;
    final DateTime updatedAt;

    Data({
        required this.id,
        required this.categoryName,
        required this.categoryType,
        required this.amount,
        required this.transactionDate,
        required this.note,
        required this.image,
        required this.createdAt,
        required this.updatedAt,
    });

    Data copyWith({
        int? id,
        String? categoryName,
        String? categoryType,
        int? amount,
        DateTime? transactionDate,
        dynamic note,
        dynamic image,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        Data(
            id: id ?? this.id,
            categoryName: categoryName ?? this.categoryName,
            categoryType: categoryType ?? this.categoryType,
            amount: amount ?? this.amount,
            transactionDate: transactionDate ?? this.transactionDate,
            note: note ?? this.note,
            image: image ?? this.image,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Data.fromMap(Map<String, dynamic> json) => Data(
        id: json["id"],
        categoryName: json["category_name"],
        categoryType: json["category_type"],
        amount: json["amount"],
        transactionDate: DateTime.parse(json["transaction_date"]),
        note: json["note"],
        image: json["image"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "category_name": categoryName,
        "category_type": categoryType,
        "amount": amount,
        "transaction_date": "${transactionDate.year.toString().padLeft(4, '0')}-${transactionDate.month.toString().padLeft(2, '0')}-${transactionDate.day.toString().padLeft(2, '0')}",
        "note": note,
        "image": image,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}

class Transaction {
  int id;
  String categoryName;
  String categoryType;
  int amount;
  DateTime transactionDate;
  String? note;
  String? image;
  DateTime createdAt;
  DateTime updatedAt;

  Transaction({
    required this.id,
    required this.categoryName,
    required this.categoryType,
    required this.amount,
    required this.transactionDate,
    required this.note,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Transaction.fromJson(String str) =>
      Transaction.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Transaction.fromMap(Map<String, dynamic> json) => Transaction(
        id: json["id"],
        categoryName: json["category_name"],
        categoryType: json["category_type"],
        amount: json["amount"],
        transactionDate: DateTime.parse(json["transaction_date"]),
        note: json["note"],
        image: json["image"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "category_name": categoryName,
        "category_type": categoryType,
        "amount": amount,
        "transaction_date":
            "${transactionDate.year.toString().padLeft(4, '0')}-${transactionDate.month.toString().padLeft(2, '0')}-${transactionDate.day.toString().padLeft(2, '0')}",
        "note": note,
        "image": image,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
