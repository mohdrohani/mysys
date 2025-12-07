import 'package:flutter/material.dart';
import 'package:mysys/pages/second.dart';

class ButtonSection extends StatelessWidget {
  const ButtonSection({super.key});

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).primaryColor;
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ButtonWithText(color: color, icon: Icons.call, label: 'CALL'),
          ButtonWithText(color: color, icon: Icons.near_me, label: 'ROUTE'),
          ButtonWithText(color: color, icon: Icons.share, label: 'SHARE'),
        ],
      ),
    );
  }
}

class ButtonWithText extends StatelessWidget {
  const ButtonWithText({
    super.key,
    required this.color,
    required this.icon,
    required this.label,
    this.onPressed,
  });

  final Color color;
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (label == 'ROUTE') {
          Navigator.push(
            context,
            MaterialPageRoute<void>(builder: (context) => const Second()),
          );
        }
        onPressed?.call();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
