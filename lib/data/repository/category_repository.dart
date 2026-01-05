import 'package:moneyserver/data/service/httpservice.dart';
import 'package:moneyserver/data/usecase/response/GetCategoryResponse.dart';

class CategoryRepository {
  final  HttpService httpService;

  CategoryRepository(this.httpService);

  Future<GetCategoryResponse> getAllCategories() async {
    final response = await httpService.get('categories');
    if (response.statusCode == 200) {
      final responseData = GetCategoryResponse.fromJson(response.body);
      return responseData;
    }  
    else{
     final errorResponse = GetCategoryResponse.fromJson(response.body);
      return errorResponse; 
    }
  }
}
