import 'package:flutter/material.dart';
import 'package:voucher_app/features/voucher/presentation/widgets/voucher_ui_tokens.dart';

class AmountCard extends StatelessWidget {
  const AmountCard({
    super.key,
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
          const Text(
            'Enter your desired / bill amount',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: voucherAccent,
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
                  color: voucherTextMuted,
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
