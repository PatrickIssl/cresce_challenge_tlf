import 'package:flutter_test/flutter_test.dart';
import 'package:cresce_challenge_mobile/lib/app/modules/discount/stores/discount_store.dart';
import 'package:cresce_challenge_mobile/lib/shared/models/discount_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  late DiscountStore discountStore;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    discountStore = DiscountStore();
    await discountStore.loadDiscounts();
  });

  test('deve carregar os descontos corretamente', () async {
    expect(discountStore.discounts, isNotNull);
    expect(discountStore.discounts.length, greaterThanOrEqualTo(0));
  });

  test('deve adicionar um novo desconto', () async {
    final discount = DiscountModel(
      id: '1',
      productId: '123',
      type: 'PERCENTUAL',
      oldPrice: 50.0,
      newPrice: 40.0,
      discountPercentage: 20.0,
      dateActivation: DateTime.now(),
      dateInactivation: DateTime.now().add(Duration(days: 10)),
      status: true,
    );

    discountStore.addDiscount(discount);
    await Future.delayed(Duration(milliseconds: 100));

    expect(discountStore.discounts.contains(discount), isTrue);

    final prefs = await SharedPreferences.getInstance();
    final savedDiscounts = prefs.getString('discounts');
    final decodedList = jsonDecode(savedDiscounts!);
    expect(decodedList.length, greaterThanOrEqualTo(1));
  });

  test('deve atualizar um desconto existente', () async {
    final updatedDiscount = DiscountModel(
      id: '1',
      productId: '123',
      type: 'PERCENTUAL',
      oldPrice: 60.0,
      newPrice: 35.0,
      discountPercentage: 25.0,
      dateActivation: DateTime.now(),
      dateInactivation: DateTime.now().add(Duration(days: 10)),
      status: true,
    );

    discountStore.updateDiscount(updatedDiscount);
    await Future.delayed(Duration(milliseconds: 100));

    final discount = discountStore.discounts.firstWhere((d) => d.id == '1');
    expect(discount.oldPrice, equals(60.0));
    expect(discount.newPrice, equals(35.0));

    final prefs = await SharedPreferences.getInstance();
    final savedDiscounts = prefs.getString('discounts');
    final decodedList = jsonDecode(savedDiscounts!);
    expect(decodedList.length, greaterThanOrEqualTo(1));
  });

  test('deve atualizar apenas o status de um desconto', () async {
    discountStore.updateDiscountStatus('1', false);
    await Future.delayed(Duration(milliseconds: 100));

    final discount = discountStore.discounts.firstWhere((d) => d.id == '1');
    expect(discount.status, isFalse);

    final prefs = await SharedPreferences.getInstance();
    final savedDiscounts = prefs.getString('discounts');
    final decodedList = jsonDecode(savedDiscounts!);
    final updatedDiscount = DiscountModel.fromJson(decodedList.firstWhere((d) => d['id'] == '1'));
    expect(updatedDiscount.status, isFalse);
  });
}
