import 'package:moneyserver/data/model/transaction.dart';
import 'package:moneyserver/data/service/httpservice.dart';

class TransactionRepository {
  final HttpService httpService;

  TransactionRepository(this.httpService);
  
  Future<GetTransactionResponse> getTransaction() async {
    final response = await  httpService.get('transactions');
     if (response.statusCode == 200) {
      final responseData = GetTransactionResponse.fromJson(response.body);
      return responseData;
    }  
    else{
     final errorResponse = GetTransactionResponse.fromJson(response.body);
      return errorResponse; 
    }
  }
}