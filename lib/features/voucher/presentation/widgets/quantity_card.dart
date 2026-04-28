import 'package:flutter/material.dart';
import 'package:voucher_app/features/voucher/presentation/widgets/voucher_ui_tokens.dart';

class QuantityCard extends StatelessWidget {
  const QuantityCard({
    super.key,
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
        border: Border.all(color: voucherBorder),
      ),
      child: Column(
        children: [
          const Text(
            'QUANTITY',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: voucherTextMuted,
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
  const _QtyButton({
    required this.icon,
    required this.onTap,
  });

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
          color: voucherAccentLight,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 16, color: voucherAccent),
      ),
    );
  }
}
