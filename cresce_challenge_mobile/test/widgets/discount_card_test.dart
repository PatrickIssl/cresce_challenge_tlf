
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:cresce_challenge_mobile/lib/app/modules/discount/widgets/discount_card.dart';
import 'package:cresce_challenge_mobile/lib/app/modules/discount/stores/product_store.dart';
import 'package:cresce_challenge_mobile/lib/app/modules/discount/stores/discount_store.dart';
import 'package:cresce_challenge_mobile/lib/shared/models/product_model.dart';
import 'package:cresce_challenge_mobile/lib/shared/models/discount_model.dart';

import '../mocks/mock_stores.mocks.dart';

void main() {
  late MockProductStore mockProductStore;
  late MockDiscountStore mockDiscountStore;

  final testDiscount = DiscountModel(
    id: "1",
    productId: "1",
    type: 'percentual',
    dateActivation: DateTime(2023, 1, 1),
    dateInactivation: DateTime(2023, 12, 31),
    newPrice: 80.0,
    oldPrice: 100.0,
    discountPercentage: 20,
    status: true,
    image: 'https://via.placeholder.com/150', // mock image URL
  );

  final testProduct = ProductModel(
    id: 1,
    title: 'Product Test',
    description: 'Test Description',
    price: 100.0,
    category: 'Test Category',
    imageUrl: 'https://via.placeholder.com/150',
    rating: 4.0,
    ratingCount: 10,
  );

  setUpAll(() {
    mockProductStore = MockProductStore();
    mockDiscountStore = MockDiscountStore();

    when(mockProductStore.getProductById("1"))
        .thenReturn(testProduct);

    when(mockDiscountStore.updateDiscountStatus(any, any))
        .thenAnswer((_) async => true);

    Modular.init(_MockModule(
      productStore: mockProductStore,
      discountStore: mockDiscountStore,
    ));

    Modular.navigatorDelegate = MockNavigator();
  });

  testWidgets('deve exibir as informações do produto e do desconto corretamente',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: DiscountCard(discount: testDiscount),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Product Test'), findsOneWidget);

        expect(find.text('Desconto: percentual'), findsOneWidget);

        expect(find.text('01/01/2023'), findsOneWidget);

        expect(find.text('31/12/2023'), findsOneWidget);

        final switchFinder = find.byType(Switch);
        expect(switchFinder, findsOneWidget);

        final Switch switchWidget = tester.widget(switchFinder);
        expect(switchWidget.value, isTrue);
      });

  testWidgets('deve chamar updateDiscountStatus ao alterar o switch',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: DiscountCard(discount: testDiscount),
          ),
        );
        await tester.pumpAndSettle();

        final switchFinder = find.byType(Switch);

        await tester.tap(switchFinder);
        await tester.pumpAndSettle();

        verify(mockDiscountStore.updateDiscountStatus("1", false)).called(1);
      });


}

class _MockModule extends Module {
  final ProductStore productStore;
  final DiscountStore discountStore;

  _MockModule({required this.productStore, required this.discountStore});

  @override
  List<Bind<Object>> get binds => [
    Bind.instance<ProductStore>(productStore),
    Bind.instance<DiscountStore>(discountStore),
  ];
}

class MockNavigator extends Mock implements IModularNavigator {}
