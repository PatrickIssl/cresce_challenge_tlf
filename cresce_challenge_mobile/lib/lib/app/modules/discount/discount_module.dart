import 'package:cresce_challenge_mobile/lib/app/modules/discount/pages/discount_create_page.dart';
import 'package:cresce_challenge_mobile/lib/app/modules/discount/stores/discount_store.dart';
import 'package:cresce_challenge_mobile/lib/app/modules/discount/stores/product_store.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'pages/discount_page.dart';
import 'pages/discount_detail_page.dart';
import '../../../shared/services/api_service.dart';

class DiscountModule extends Module {
  @override
  List<Bind> get binds => [
    Bind.lazySingleton((i) => ApiService()),
    Bind.lazySingleton((i) => ProductStore(i())),
    Bind.lazySingleton((i) => DiscountStore())
  ];

  @override
  List<ModularRoute> get routes => [
    ChildRoute('/', child: (_, __) => DiscountPage()),
    ChildRoute('/detail', child: (_, args) => DiscountDetailPage(discount: args.data)),
    ChildRoute('/create', child: (_, __) => DiscountCreatePage()),
  ];
}
