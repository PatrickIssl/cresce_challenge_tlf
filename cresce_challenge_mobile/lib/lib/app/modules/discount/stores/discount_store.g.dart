// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discount_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$DiscountStore on _DiscountStoreBase, Store {
  late final _$discountsAtom =
      Atom(name: '_DiscountStoreBase.discounts', context: context);

  @override
  ObservableList<DiscountModel> get discounts {
    _$discountsAtom.reportRead();
    return super.discounts;
  }

  @override
  set discounts(ObservableList<DiscountModel> value) {
    _$discountsAtom.reportWrite(value, super.discounts, () {
      super.discounts = value;
    });
  }

  late final _$loadDiscountsAsyncAction =
      AsyncAction('_DiscountStoreBase.loadDiscounts', context: context);

  @override
  Future<void> loadDiscounts() {
    return _$loadDiscountsAsyncAction.run(() => super.loadDiscounts());
  }

  late final _$_saveDiscountsAsyncAction =
      AsyncAction('_DiscountStoreBase._saveDiscounts', context: context);

  @override
  Future<void> _saveDiscounts() {
    return _$_saveDiscountsAsyncAction.run(() => super._saveDiscounts());
  }

  late final _$_DiscountStoreBaseActionController =
      ActionController(name: '_DiscountStoreBase', context: context);

  @override
  void addDiscount(DiscountModel discount) {
    final _$actionInfo = _$_DiscountStoreBaseActionController.startAction(
        name: '_DiscountStoreBase.addDiscount');
    try {
      return super.addDiscount(discount);
    } finally {
      _$_DiscountStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateDiscount(DiscountModel updatedDiscount) {
    final _$actionInfo = _$_DiscountStoreBaseActionController.startAction(
        name: '_DiscountStoreBase.updateDiscount');
    try {
      return super.updateDiscount(updatedDiscount);
    } finally {
      _$_DiscountStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateDiscountStatus(String discountId, bool newStatus) {
    final _$actionInfo = _$_DiscountStoreBaseActionController.startAction(
        name: '_DiscountStoreBase.updateDiscountStatus');
    try {
      return super.updateDiscountStatus(discountId, newStatus);
    } finally {
      _$_DiscountStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
discounts: ${discounts}
    ''';
  }
}
