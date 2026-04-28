import 'package:voucher_app/features/voucher/data/models/voucher_model.dart';

class VoucherState {
  final VoucherModel? voucher;
  final int amount;
  final int quantity;
  final String selectedMethod;

  VoucherState({
    this.voucher,
    this.amount = 100,
    this.quantity = 1,
    this.selectedMethod = 'UPI',
  });

  VoucherState copyWith({
    VoucherModel? voucher,
    int? amount,
    int? quantity,
    String? selectedMethod,
  }) {
    return VoucherState(
      voucher: voucher ?? this.voucher,
      amount: amount ?? this.amount,
      quantity: quantity ?? this.quantity,
      selectedMethod: selectedMethod ?? this.selectedMethod,
    );
  }
}
