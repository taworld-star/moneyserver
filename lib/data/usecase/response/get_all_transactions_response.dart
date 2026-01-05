
import 'dart:convert';
import 'package:moneyserver/data/model/transaction.dart';

class GetAllTransactionsResponse {
  String status;
  String message;
  List<Transaction> data;

  GetAllTransactionsResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GetAllTransactionsResponse.fromMap(Map<String, dynamic> json) =>
      GetAllTransactionsResponse(
        status: json["status"],
        message: json["message"],
        data: List<Transaction>.from(
          json["data"].map((x) => Transaction.fromMap(x)),
        ),
      );

  factory GetAllTransactionsResponse.fromJson(String str) =>
      GetAllTransactionsResponse.fromMap(json.decode(str));

  Map<String, dynamic> toMap() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toMap())),
  };

  String toJson() => json.encode(toMap());
}
