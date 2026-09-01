import 'package:flutter/material.dart';
import 'theme.dart';

class DnStatusPill extends StatelessWidget {
  final String status;
  const DnStatusPill({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final s = DnStatus.forWashStatus(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: s.background, borderRadius: BorderRadius.circular(999)),
      child: Text(s.label, style: TextStyle(color: s.color, fontWeight: FontWeight.w600, fontSize: 12)),
    );
  }
}

/// The five-car-badge monthly loyalty meter, matching the reference UI.
class DnLoyaltyMeter extends StatelessWidget {
  final int count;
  final double size;
  const DnLoyaltyMeter({super.key, required this.count, this.size = 28});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final filled = i < count;
        return Padding(
          padding: const EdgeInsets.only(right: 4),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: filled ? DnColors.blue : Colors.white,
              border: Border.all(color: filled ? DnColors.blue : const Color(0xFFD7DEE8), width: 1.5),
            ),
            child: Icon(Icons.directions_car, size: size * 0.55, color: filled ? Colors.white : const Color(0xFFB9C4D2)),
          ),
        );
      }),
    );
  }
}

class DnCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  const DnCard({super.key, required this.child, this.padding = const EdgeInsets.all(16)});

  @override
  Widget build(BuildContext context) {
    return Card(child: Padding(padding: padding, child: child));
  }
}

class DnEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String hint;
  const DnEmptyState({super.key, required this.icon, required this.title, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Icon(icon, size: 32, color: const Color(0xFFB9C4D2)),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(hint, style: const TextStyle(color: DnColors.muted, fontSize: 13), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class DnKpi extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color tint;
  final Color iconColor;
  const DnKpi({super.key, required this.icon, required this.label, required this.value, required this.tint, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return DnCard(
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(color: tint, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: DnColors.muted, fontSize: 12), overflow: TextOverflow.ellipsis),
                Text(value, style: TextStyle(color: iconColor, fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
