import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voucher_app/features/voucher/data/models/voucher_model.dart';
import 'package:voucher_app/features/voucher/presentation/provider/voucher_notifer.dart';

const _accent = Color(0xFF6D3DF5);
const _accentLight = Color(0xFFF0EBFF);
const _mint = Color(0xFFE8FAF1);
const _border = Color(0xFFE7E1F4);
const _textMuted = Color(0xFF857E96);
const _pageBg = Color(0xFFF7F4FC);

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
      backgroundColor: _pageBg,
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [_accent, Color(0xFF8A56FF)],
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
              _HeaderChip(accent: _accent),
              const SizedBox(height: 20),
              _VoucherHero(title: voucher.title),
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
              Text(
                'Pick your bill amount, choose a payment method, and see your savings instantly.',
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: _textMuted,
                ),
              ),
              const SizedBox(height: 18),
              _AmountCard(
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
              _SummaryCard(youPay: notifier.youPay, savings: notifier.savings),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _PaymentMethodCard(
                      label: 'UPI',
                      badge: '${_discountFor(voucher, 'UPI')}% OFF',
                      selected: state.selectedMethod == 'UPI',
                      icon: Icons.account_balance_wallet_outlined,
                      onTap: () => notifier.changeMethod('UPI'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _PaymentMethodCard(
                      label: 'Card',
                      badge: '${_discountFor(voucher, 'CARD')}% OFF',
                      selected: state.selectedMethod == 'CARD',
                      icon: Icons.credit_card_rounded,
                      onTap: () => notifier.changeMethod('CARD'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _QuantityCard(
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
                          color: _accentLight,
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: _accent,
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
                            color: _textMuted,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: const [
                  Expanded(child: _InfoButton(label: 'About Brand')),
                  SizedBox(width: 12),
                  Expanded(child: _InfoButton(label: 'Terms & Conditions')),
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

class _HeaderChip extends StatelessWidget {
  const _HeaderChip({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: const Color(0xFFD9D1EA)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.share_outlined,
                  size: 18,
                  color: Color(0xFF444050),
                ),
                const SizedBox(width: 6),
                const Text(
                  'REFER & EARN ',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF444050),
                  ),
                ),
                Text(
                  '₹500',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: accent,
                  ),
                ),
              ],
            ),
          ),
        ),
        const Spacer(),
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFD9D1EA)),
          ),
          child: const Icon(Icons.close_rounded, color: Color(0xFF5D586C)),
        ),
      ],
    );
  }
}

class _VoucherHero extends StatelessWidget {
  const _VoucherHero({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFE1D8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: AspectRatio(
        aspectRatio: 1.85,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFFF4D5D), Color(0xFFE11D2C)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              CustomPaint(painter: _VoucherPatternPainter()),
              Center(
                child: Text(
                  title.split(' ').first.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                    color: Color(0xFFFFE867),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AmountCard extends StatelessWidget {
  const _AmountCard({
    required this.fieldKey,
    required this.controller,
    required this.minAmount,
    required this.maxAmount,
    required this.validator,
    required this.onChanged,
  });

  final GlobalKey<FormFieldState<String>> fieldKey;
  final TextEditingController controller;
  final int minAmount;
  final int maxAmount;
  final String? Function(String?) validator;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFBFD4FF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enter your desired / bill amount',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: _accent,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  key: fieldKey,
                  controller: controller,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF272133),
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    prefixText: '₹ ',
                    prefixStyle: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF272133),
                    ),
                    contentPadding: EdgeInsets.zero,
                    errorStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFD92D20),
                    ),
                  ),
                  validator: validator,
                  onChanged: onChanged,
                ),
              ),
              Text(
                'Min: ₹$minAmount     Max: ₹${_formatMax(maxAmount)}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _textMuted,
                ),
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatMax(int value) {
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(value % 1000 == 0 ? 0 : 1)}K';
    }
    return value.toString();
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.youPay, required this.savings});

  final double youPay;
  final double savings;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: _mint,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFCFECDD)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _SummaryValue(
              label: 'YOU PAY',
              value: '₹${youPay.toStringAsFixed(2)}',
            ),
          ),
          Container(width: 1, height: 40, color: const Color(0xFFB7DCC6)),
          Expanded(
            child: _SummaryValue(
              label: 'SAVINGS',
              value: '₹${savings.toStringAsFixed(2)}',
              alignEnd: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryValue extends StatelessWidget {
  const _SummaryValue({
    required this.label,
    required this.value,
    this.alignEnd = false,
  });

  final String label;
  final String value;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: _textMuted,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Color(0xFF149A63),
          ),
        ),
      ],
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  const _PaymentMethodCard({
    required this.label,
    required this.badge,
    required this.selected,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final String badge;
  final bool selected;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? _accentLight : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? _accent : _border,
            width: selected ? 1.6 : 1,
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: selected
                      ? _accent
                      : const Color(0xFF6A627C),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2A233B),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              badge,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: selected
                    ? _accent
                    : const Color(0xFF4F46E5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuantityCard extends StatelessWidget {
  const _QuantityCard({
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        children: [
          const Text(
            'QUANTITY',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: _textMuted,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _QtyButton(icon: Icons.remove, onTap: onDecrement),
              Text(
                quantity.toString().padLeft(2, '0'),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2A233B),
                ),
              ),
              _QtyButton(icon: Icons.add, onTap: onIncrement),
            ],
          ),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  const _QtyButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: _accentLight,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 16, color: _accent),
      ),
    );
  }
}

class _InfoButton extends StatelessWidget {
  const _InfoButton({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF111111),
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
    );
  }
}

class _VoucherPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = const Color(0x33FFE867);

    const spacing = 34.0;
    for (double x = -spacing; x < size.width + spacing; x += spacing) {
      final path = Path()
        ..moveTo(x, 0)
        ..lineTo(x + spacing / 2, size.height / 2)
        ..lineTo(x + spacing, 0);
      canvas.drawPath(path, stroke);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
