import 'package:flutter/material.dart';

class HeaderChip extends StatelessWidget {
  const HeaderChip({
    super.key,
    required this.accent,
  });

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
