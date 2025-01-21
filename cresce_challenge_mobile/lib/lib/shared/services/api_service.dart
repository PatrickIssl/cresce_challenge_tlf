import 'package:dio/dio.dart';
import 'package:cresce_challenge_mobile/lib/shared/models/product_model.dart';

class ApiService {
  final Dio dio;

  ApiService({Dio? dio}) : dio = dio ?? Dio();

  Future<List<ProductModel>> fetchProducts() async {
    try {
      final response = await dio.get('https://fakestoreapi.com/products');

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw Exception("Erro ao carregar os descontos");
      }
    } catch (e) {
      throw Exception("Falha ao buscar os descontos: $e");
    }
  }
}
