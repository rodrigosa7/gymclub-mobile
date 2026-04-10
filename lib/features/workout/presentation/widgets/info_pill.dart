import 'package:flutter/material.dart';

class InfoPill extends StatelessWidget {
  const InfoPill({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF4E6D7),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label),
    );
  }
}
