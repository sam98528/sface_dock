import 'package:flutter/material.dart';

class QuantityStepper extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;

  const QuantityStepper({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 1,
    this.max = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 감소 버튼
          const SizedBox(width: 8),
          _buildButton(
            icon: Icons.remove,
            onPressed: value > min
                ? () {
                    onChanged(value - 1);
                  }
                : null,
          ),

          // 수량 표시
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(
                  value.toString(),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),

          // 증가 버튼
          _buildButton(
            icon: Icons.add,
            onPressed: value < max
                ? () {
                    onChanged(value + 1);
                  }
                : null,
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: onPressed != null
                ? Colors.black
                : Colors.black.withValues(alpha: 0.1),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: onPressed != null ? Colors.black87 : Colors.black45,
          size: 24,
        ),
      ),
    );
  }
}
