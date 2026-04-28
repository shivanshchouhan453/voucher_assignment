import 'dart:convert';

import 'package:voucher_app/features/voucher/data/models/voucher_model.dart';
import 'package:voucher_app/features/voucher/data/repository/voucher_repository.dart';

class VoucherRepositoryImpl implements VoucherRepository {
  @override
  Future<VoucherModel> fetchVoucher() async {
    await Future.delayed(const Duration(milliseconds: 300));

    final jsonString = '''
    {
      "id": "zepto-100",
      "title": "Zepto Instant Voucher",
      "minAmount": 50,
      "maxAmount": 10000,
      "disablePurchase": false,
      "discounts": [
        { "method": "UPI", "percent": 4 },
        { "method": "CARD", "percent": 4 }
      ],
      "redeemSteps": [
        "Login to Zepto Platform",
        "Click on My profile / Settings",
        "Go to Zepto Cash & Gift Card",
        "Click on Add Card option"
      ]
    }
    ''';

    return VoucherModel.fromJson(json.decode(jsonString));
  }
}
