import 'package:flutter/material.dart';

class VoucherHero extends StatelessWidget {
  const VoucherHero({
    super.key,
    required this.title,
  });

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
