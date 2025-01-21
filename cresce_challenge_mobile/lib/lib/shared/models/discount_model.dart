class DiscountModel {
  final String id;
  final String productId;
  final String type;
  final double oldPrice;
  final double newPrice;
  final double discountPercentage;
  final int? take;
  final int? pay;
  final DateTime dateActivation;
  final DateTime dateInactivation;
  final String? image;
  late final bool status;

  DiscountModel({
    required this.id,
    required this.productId,
    required this.type,
    required this.oldPrice,
    required this.newPrice,
    required this.discountPercentage,
    this.take,
    this.pay,
    required this.dateActivation,
    required this.dateInactivation,
    this.image,
    required this.status,
  });

  factory DiscountModel.fromJson(Map<String, dynamic> json) {
    return DiscountModel(
      id: json['id'],
      productId: json['fakeProductId'],
      type: json['type'],
      oldPrice: double.tryParse(json['old_price'] ?? '0') ?? 0.0,
      newPrice: double.tryParse(json['new_price'] ?? '0') ?? 0.0,
      discountPercentage: double.tryParse(json['discount_percentage'] ?? '0') ?? 0.0,
      take: json['take'] != null ? int.tryParse(json['take']) : null,
      pay: json['pay'] != null ? int.tryParse(json['pay']) : null,
      dateActivation: DateTime.parse(json['date_activation']),
      dateInactivation: DateTime.parse(json['date_inactivation']),
      image: json['image'],
      status: json['status'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fakeProductId': productId,
      'type': type,
      'old_price': oldPrice.toString(),
      'new_price': newPrice.toString(),
      'discount_percentage': discountPercentage.toString(),
      'take': take?.toString(),
      'pay': pay?.toString(),
      'date_activation': dateActivation.toIso8601String(),
      'date_inactivation': dateInactivation.toIso8601String(),
      'image': image,
      'status': status,
    };
  }

  DiscountModel copyWith({
    String? id,
    String? productId,
    String? type,
    double? oldPrice,
    double? newPrice,
    double? discountPercentage,
    int? take,
    int? pay,
    DateTime? dateActivation,
    DateTime? dateInactivation,
    String? image,
    bool? status,
  }) {
    return DiscountModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      type: type ?? this.type,
      oldPrice: oldPrice ?? this.oldPrice,
      newPrice: newPrice ?? this.newPrice,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      take: take ?? this.take,
      pay: pay ?? this.pay,
      dateActivation: dateActivation ?? this.dateActivation,
      dateInactivation: dateInactivation ?? this.dateInactivation,
      image: image ?? this.image,
      status: status ?? this.status,
    );
  }

  String get discountLabel {
    if (type == "PERCENTUAL") {
      return "${discountPercentage.toInt()}% Desconto";
    } else if (type == "LEVE_PAGUE" && take != null && pay != null) {
      return "Leve $take Pague $pay";
    } else {
      return "Economize R\$ ${(oldPrice-newPrice).toStringAsFixed(2)}";
    }
  }
}
