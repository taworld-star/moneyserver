import 'package:moneyserver/data/service/httpservice.dart';
import 'package:moneyserver/data/usecase/request/add_transaction_request.dart';
import 'package:moneyserver/data/usecase/response/get_transactions_response.dart';
import 'package:moneyserver/data/usecase/response/get_all_transactions_response.dart';
import 'package:moneyserver/data/usecase/response/get_income_response.dart';

class TransactionRepository {
  final HttpService apiService;
  TransactionRepository(this.apiService);
  Future<GetAllTransactionsResponse> getTransaction() async {
    final response = await apiService.get('transactions');
    try {
      if (response.statusCode == 200) {
        final responseData = GetAllTransactionsResponse.fromJson(response.body);
        return responseData;
      } else {
        final errorResponse = GetAllTransactionsResponse.fromJson(response.body);
        return errorResponse;
      }
    } catch (e) {
      throw Exception('Error parsing transactions: $e');
    }
  }

  Future<GetTransactionsResponse> createTransaction({
    AddTransactionRequest? request,
  }) async {
    try {
      // Jika ada image, gunakan postWithFile
      // if (request!.image != null) {

      final response = await apiService.postWithFile(
        'transactions',
        request!.toMap(),
        request.image,
        'image',
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = GetTransactionsResponse.fromJson(response.body);
        return responseData;
      } else {
        final errorResponse = GetTransactionsResponse.fromJson(response.body);
        return errorResponse;
      }
    } catch (e) {
      throw Exception('Error creating transaction: $e');
    }
  }

  Future<GetIncomeResponse> getIncome() async {
    final response = await apiService.get('transactions/income');
    try {
      if (response.statusCode == 200) {
        final responseData = GetIncomeResponse.fromJson(response.body);
        return responseData;
      } else {
        final errorResponse = GetIncomeResponse.fromJson(response.body);
        return errorResponse;
      }
    } catch (e) {
      throw Exception('Error parsing income: $e');
    }
  }
}
