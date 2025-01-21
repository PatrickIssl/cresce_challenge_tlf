import 'package:cresce_challenge_mobile/lib/app/modules/discount/discount_module.dart';
import 'package:cresce_challenge_mobile/lib/app/modules/splash/splash_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends Module {
  @override
  List<ModularRoute> get routes => [
    ChildRoute(Modular.initialRoute, child: (_, __) => SplashPage()),
    ModuleRoute('/discounts', module: DiscountModule()),
  ];
}