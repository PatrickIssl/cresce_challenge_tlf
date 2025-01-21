import 'package:mobx/mobx.dart';
import 'package:cresce_challenge_mobile/lib/shared/models/product_model.dart';
import 'package:cresce_challenge_mobile/lib/shared/services/api_service.dart';

part 'product_store.g.dart';

class ProductStore = _ProductStoreBase with _$ProductStore;

abstract class _ProductStoreBase with Store {
  final ApiService apiService;

  _ProductStoreBase(this.apiService){
    loadProducts();
  }


  @observable
  ObservableList<ProductModel> products = ObservableList<ProductModel>();

  @observable
  bool isLoading = false;

  @action
  Future<void> loadProducts() async {
    isLoading = true;
    try {
      final fetchedProducts = await apiService.fetchProducts();
      products.clear();
      products.addAll(fetchedProducts);
    } catch (e) {
      print("Erro ao carregar produtos: $e");
    } finally {
      isLoading = false;
    }
  }

  @action
  ProductModel? getProductById(String productId) {
    return products.firstWhere(
          (p) => p.id.toString() == productId,
      orElse: () => ProductModel(
        id: 0,
        title: 'Produto não encontrado',
        description: 'Descrição não disponível',
        price: 0.0,
        category: '',
        imageUrl: '',
        rating: 0.0,
        ratingCount: 0,
      ),
    );
  }
}
