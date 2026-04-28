class VoucherModel {
  final String id;
  final String title;
  final int minAmount;
  final int maxAmount;
  final bool disablePurchase;
  final List<DiscountModel> discounts;
  final List<String> redeemSteps;

  VoucherModel({
    required this.id,
    required this.title,
    required this.minAmount,
    required this.maxAmount,
    required this.disablePurchase,
    required this.discounts,
    required this.redeemSteps,
  });

  factory VoucherModel.fromJson(Map<String, dynamic> json) {
    return VoucherModel(
      id: json['id'],
      title: json['title'],
      minAmount: json['minAmount'],
      maxAmount: json['maxAmount'],
      disablePurchase: json['disablePurchase'],
      discounts: (json['discounts'] as List)
          .map((e) => DiscountModel.fromJson(e))
          .toList(),
      redeemSteps: List<String>.from(json['redeemSteps']),
    );
  }
}

class DiscountModel {
  final String method;
  final int percent;

  DiscountModel({required this.method, required this.percent});

  factory DiscountModel.fromJson(Map<String, dynamic> json) {
    return DiscountModel(method: json['method'], percent: json['percent']);
  }
}
