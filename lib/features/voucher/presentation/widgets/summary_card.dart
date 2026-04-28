import 'package:flutter/material.dart';
import 'package:voucher_app/features/voucher/presentation/widgets/voucher_ui_tokens.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.youPay,
    required this.savings,
  });

  final double youPay;
  final double savings;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: voucherMint,
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
          Container(
            width: 1,
            height: 40,
            color: const Color(0xFFB7DCC6),
          ),
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
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: voucherTextMuted,
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
