import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';

import 'package:cresce_challenge_mobile/lib/shared/models/product_model.dart';
import 'package:cresce_challenge_mobile/lib/shared/services/api_service.dart';

import '../mocks/mock_dio.mocks.dart';

void main() {
  late ApiService apiService;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    apiService = ApiService(dio: mockDio);
  });

  group('ApiService tests', () {
    test('deve retornar uma resposta 200 ao realizar consulta', () async {
      when(mockDio.get(any)).thenAnswer(
            (_) async => Response(
          data: [
            {
              "id": 1,
              "title": "Teste Dio",
              "price": 10.00,
              "description": "teste",
              "category": "teste",
              "image": "https://1.bp.blogspot.com/-sFhEBRhVscI/TpkAUfkrH3I/AAAAAAAAAEc/Pq4OHod0MJI/s1600/teste1.png",
              "rating": {"rate": 0.0, "count": 1}
            }
          ],
          statusCode: 200,
          requestOptions: RequestOptions(path: 'https://fakestoreapi.com/products'),
        ),
      );

      final products = await apiService.fetchProducts();

      expect(products, isA<List<ProductModel>>());
      expect(products.length, 1);
      expect(products.first.title, "Teste Dio");

      verify(mockDio.get('https://fakestoreapi.com/products')).called(1);
    });

    test('deve retornar erro ao retornar exceção', () async {

      when(mockDio.get(any)).thenThrow(DioError(
        requestOptions: RequestOptions(path: 'https://fakestoreapi.com/products'),
        type: DioErrorType.badResponse,
        error: 'Something went wrong!',
      ));

      expect(() async => await apiService.fetchProducts(), throwsA(isA<Exception>()));

      verify(mockDio.get('https://fakestoreapi.com/products')).called(1);
    });
  });
}
