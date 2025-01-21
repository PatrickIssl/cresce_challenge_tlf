import 'package:cresce_challenge_mobile/lib/app/modules/discount/stores/product_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart' as mockito;
import 'package:mobx/mobx.dart';
import 'package:cresce_challenge_mobile/lib/shared/models/product_model.dart';
import 'package:cresce_challenge_mobile/lib/shared/services/api_service.dart';

import '../mocks/mock_api_service.mocks.dart';

void main() {
  late ProductStore productStore;
  late MockApiService mockApiService;

  setUp(() {
    mockApiService = MockApiService();
    productStore = ProductStore(mockApiService);
  });

  group('ProductStore Testes', () {
    test('deve iniciar com lista de produtos vazia', () {
      expect(productStore.products, isEmpty);
    });

    test('deve iniciar com isLoading como false', () {
      expect(productStore.isLoading, isFalse);
    });

    test('deve carregar produtos corretamente', () async {
      // Mockando resposta da API
      final mockProducts = [
        ProductModel(
          id: 1,
          title: 'Produto 1',
          description: 'Descrição do Produto 1',
          price: 10.0,
          category: 'Categoria 1',
          imageUrl: 'http://example.com/img1.png',
          rating: 4.5,
          ratingCount: 10,
        ),
        ProductModel(
          id: 2,
          title: 'Produto 2',
          description: 'Descrição do Produto 2',
          price: 20.0,
          category: 'Categoria 2',
          imageUrl: 'http://example.com/img2.png',
          rating: 3.5,
          ratingCount: 5,
        ),
      ];

      mockito.when(mockApiService.fetchProducts()).thenAnswer((_) async => mockProducts);

      await productStore.loadProducts();

      expect(productStore.isLoading, isFalse);
      expect(productStore.products.length, 2);
      expect(productStore.products.first.title, 'Produto 1');
    });

    test('deve tratar erro ao carregar produtos', () async {
      mockito.when(mockApiService.fetchProducts()).thenThrow(Exception('Erro de API'));

      await productStore.loadProducts();

      expect(productStore.isLoading, isFalse);
      expect(productStore.products.isEmpty, isTrue);
    });

    test('deve retornar produto pelo ID corretamente', () {
      final mockProducts = [
        ProductModel(
          id: 1,
          title: 'Produto 1',
          description: 'Descrição do Produto 1',
          price: 10.0,
          category: 'Categoria 1',
          imageUrl: 'http://example.com/img1.png',
          rating: 4.5,
          ratingCount: 10,
        ),
      ];

      productStore.products.addAll(mockProducts);

      final product = productStore.getProductById('1');

      expect(product, isNotNull);
      expect(product?.title, 'Produto 1');
    });

    test('deve retornar mensagem de erro se o produto não for encontrado', () {
      final product = productStore.getProductById('99');

      expect(product, isNotNull);
      expect(product?.title, 'Produto não encontrado');
    });
  });
}
