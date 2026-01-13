import 'dart:convert';

class GetIncomeResponse {
    final String status;
    final String message;
    final Data data;

    GetIncomeResponse({
        required this.status,
        required this.message,
        required this.data,
    });

    GetIncomeResponse copyWith({
        String? status,
        String? message,
        Data? data,
    }) => 
        GetIncomeResponse(
            status: status ?? this.status,
            message: message ?? this.message,
            data: data ?? this.data,
        );

    factory GetIncomeResponse.fromJson(String str) => GetIncomeResponse.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GetIncomeResponse.fromMap(Map<String, dynamic> json) => GetIncomeResponse(
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
    final String totalIncome;

    Data({
        required this.totalIncome,
    });

    Data copyWith({
        String? totalIncome,
    }) => 
        Data(
            totalIncome: totalIncome ?? this.totalIncome,
        );

    factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Data.fromMap(Map<String, dynamic> json) => Data(
        totalIncome: json["total_income"],
    );

    Map<String, dynamic> toMap() => {
        "total_income": totalIncome,
    };
}
