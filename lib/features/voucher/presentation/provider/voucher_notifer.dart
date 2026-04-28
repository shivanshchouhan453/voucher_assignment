import 'package:flutter_riverpod/legacy.dart';
import 'package:voucher_app/features/voucher/data/repository/voucher_repository.dart';
import 'package:voucher_app/features/voucher/data/repository/voucher_repositroy_impl.dart';
import 'package:voucher_app/features/voucher/presentation/provider/voucher_state.dart';

final voucherProvider = StateNotifierProvider<VoucherNotifier, VoucherState>((
  ref,
) {
  final repo = VoucherRepositoryImpl();
  return VoucherNotifier(repo);
});

class VoucherNotifier extends StateNotifier<VoucherState> {
  final VoucherRepository repository;

  VoucherNotifier(this.repository) : super(VoucherState()) {
    loadVoucher();
  }

  Future<void> loadVoucher() async {
    final data = await repository.fetchVoucher();
    state = state.copyWith(voucher: data);
  }

  void updateAmount(int value) {
    final voucher = state.voucher!;
    if (value < voucher.minAmount || value > voucher.maxAmount) return;
    state = state.copyWith(amount: value);
  }

  void changeMethod(String method) {
    state = state.copyWith(selectedMethod: method);
  }

  void incrementQty() {
    state = state.copyWith(quantity: state.quantity + 1);
  }

  void decrementQty() {
    if (state.quantity > 1) {
      state = state.copyWith(quantity: state.quantity - 1);
    }
  }

  double get discount {
    final discountPercent = state.voucher!.discounts
        .firstWhere((e) => e.method == state.selectedMethod)
        .percent;

    return state.amount * discountPercent / 100;
  }

  double get youPay => (state.amount - discount) * state.quantity;

  double get savings => discount * state.quantity;

  bool get isPayEnabled => !(state.voucher?.disablePurchase ?? true);
}
