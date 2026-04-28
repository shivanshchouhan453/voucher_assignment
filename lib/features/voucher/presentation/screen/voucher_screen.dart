import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voucher_app/features/voucher/data/models/voucher_model.dart';
import 'package:voucher_app/features/voucher/presentation/provider/voucher_notifer.dart';
import 'package:voucher_app/features/voucher/presentation/widgets/amount_card.dart';
import 'package:voucher_app/features/voucher/presentation/widgets/header_chip.dart';
import 'package:voucher_app/features/voucher/presentation/widgets/info_button.dart';
import 'package:voucher_app/features/voucher/presentation/widgets/payment_method_card.dart';
import 'package:voucher_app/features/voucher/presentation/widgets/quantity_card.dart';
import 'package:voucher_app/features/voucher/presentation/widgets/summary_card.dart';
import 'package:voucher_app/features/voucher/presentation/widgets/voucher_hero.dart';
import 'package:voucher_app/features/voucher/presentation/widgets/voucher_ui_tokens.dart';

class VoucherScreen extends ConsumerStatefulWidget {
  const VoucherScreen({super.key});

  @override
  ConsumerState<VoucherScreen> createState() => _VoucherScreenState();
}

class _VoucherScreenState extends ConsumerState<VoucherScreen> {
  late final TextEditingController _amountController;
  final _amountFieldKey = GlobalKey<FormFieldState<String>>();

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(voucherProvider);
    final notifier = ref.read(voucherProvider.notifier);

    if (state.voucher == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final voucher = state.voucher!;
    if (_amountController.text.isEmpty) {
      _amountController.text = state.amount.toString();
    }

    final amountError = _validateAmount(
      _amountController.text,
      voucher.minAmount,
      voucher.maxAmount,
    );
    final canPay = notifier.isPayEnabled && amountError == null;

    return Scaffold(
      backgroundColor: voucherPageBackground,
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [voucherAccent, Color(0xFF8A56FF)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Color(0x336D3DF5),
                blurRadius: 18,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: canPay ? () {} : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              disabledBackgroundColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              canPay
                  ? 'Pay ₹${notifier.youPay.toStringAsFixed(2)}  ✨'
                  : notifier.isPayEnabled
                      ? 'Enter a valid amount'
                      : 'Voucher unavailable',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeaderChip(accent: voucherAccent),
              const SizedBox(height: 20),
              VoucherHero(title: voucher.title),
              const SizedBox(height: 20),
              Text(
                voucher.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1F1831),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Pick your bill amount, choose a payment method, and see your savings instantly.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: voucherTextMuted,
                ),
              ),
              const SizedBox(height: 18),
              AmountCard(
                fieldKey: _amountFieldKey,
                controller: _amountController,
                minAmount: voucher.minAmount,
                maxAmount: voucher.maxAmount,
                validator: (value) =>
                    _validateAmount(value, voucher.minAmount, voucher.maxAmount),
                onChanged: (value) {
                  setState(() {});
                  final parsed = int.tryParse(value);
                  if (_validateAmount(
                        value,
                        voucher.minAmount,
                        voucher.maxAmount,
                      ) ==
                      null) {
                    notifier.updateAmount(parsed ?? 0);
                  }
                },
              ),
              const SizedBox(height: 14),
              SummaryCard(youPay: notifier.youPay, savings: notifier.savings),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: PaymentMethodCard(
                      label: 'UPI',
                      badge: '${_discountFor(voucher, 'UPI')}% OFF',
                      selected: state.selectedMethod == 'UPI',
                      icon: Icons.account_balance_wallet_outlined,
                      onTap: () => notifier.changeMethod('UPI'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: PaymentMethodCard(
                      label: 'Card',
                      badge: '${_discountFor(voucher, 'CARD')}% OFF',
                      selected: state.selectedMethod == 'CARD',
                      icon: Icons.credit_card_rounded,
                      onTap: () => notifier.changeMethod('CARD'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: QuantityCard(
                      quantity: state.quantity,
                      onIncrement: notifier.incrementQty,
                      onDecrement: notifier.decrementQty,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              const Text(
                'HOW TO REDEEM',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.4,
                  color: Color(0xFF2A233B),
                ),
              ),
              const SizedBox(height: 12),
              ...List.generate(
                voucher.redeemSteps.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 26,
                        height: 26,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: voucherAccentLight,
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: voucherAccent,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          voucher.redeemSteps[index],
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: voucherTextMuted,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Row(
                children: [
                  Expanded(child: InfoButton(label: 'About Brand')),
                  SizedBox(width: 12),
                  Expanded(child: InfoButton(label: 'Terms & Conditions')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _discountFor(VoucherModel voucher, String method) {
    return voucher.discounts
        .firstWhere(
          (entry) => entry.method.toUpperCase() == method,
          orElse: () => DiscountModel(method: method, percent: 0),
        )
        .percent;
  }

  String? _validateAmount(String? value, int minAmount, int maxAmount) {
    final amount = int.tryParse((value ?? '').trim());
    if (amount == null) {
      return 'Enter a valid bill amount';
    }
    if (amount < minAmount) {
      return 'Bill amount should be at least ₹$minAmount';
    }
    if (amount > maxAmount) {
      return 'Bill amount should not exceed ₹$maxAmount';
    }
    return null;
  }
}
