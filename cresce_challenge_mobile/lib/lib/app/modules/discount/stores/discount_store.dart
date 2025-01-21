import 'package:mobx/mobx.dart';
import 'package:cresce_challenge_mobile/lib/shared/models/discount_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

part 'discount_store.g.dart';

class DiscountStore = _DiscountStoreBase with _$DiscountStore;

abstract class _DiscountStoreBase with Store {
  @observable
  ObservableList<DiscountModel> discounts = ObservableList<DiscountModel>();

  _DiscountStoreBase() {
    loadDiscounts();
  }

  @action
  Future<void> loadDiscounts() async {
    final prefs = await SharedPreferences.getInstance();
    final discountsJson = prefs.getString('discounts');

    if (discountsJson != null) {
      List<dynamic> decodedList = jsonDecode(discountsJson);
      discounts = ObservableList.of(decodedList.map((json) => DiscountModel.fromJson(json)).toList());
    }
  }

  @action
  Future<void> _saveDiscounts() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedList = jsonEncode(discounts.map((discount) => discount.toJson()).toList());
    await prefs.setString('discounts', encodedList);
  }

  @action
  void addDiscount(DiscountModel discount) {
    discounts.add(discount);
    _saveDiscounts();
  }

  @action
  void updateDiscount(DiscountModel updatedDiscount) {
    final index = discounts.indexWhere((d) => d.id == updatedDiscount.id);
    if (index != -1) {
      discounts[index] = updatedDiscount;
      _saveDiscounts();
    }
  }

  @action
  void updateDiscountStatus(String discountId, bool newStatus) {
    final index = discounts.indexWhere((d) => d.id == discountId);
    if (index != -1) {
      discounts[index] = DiscountModel(
        id: discounts[index].id,
        productId: discounts[index].productId,
        type: discounts[index].type,
        oldPrice: discounts[index].oldPrice,
        newPrice: discounts[index].newPrice,
        discountPercentage: discounts[index].discountPercentage,
        take: discounts[index].take,
        pay: discounts[index].pay,
        dateActivation: discounts[index].dateActivation,
        dateInactivation: discounts[index].dateInactivation,
        image: discounts[index].image,
        status: newStatus,
      );
      _saveDiscounts();
    }
  }
}
