import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:cresce_challenge_mobile/lib/app/modules/discount/stores/discount_store.dart';
import 'package:cresce_challenge_mobile/lib/app/modules/discount/stores/product_store.dart';

@GenerateMocks([ProductStore, DiscountStore])
void main() {}
