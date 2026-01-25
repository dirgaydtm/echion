import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;

  const CustomSearchBar({
    super.key,
    required this.controller,
    this.hintText = 'Search...',
    required this.onChanged,
  });

  @override
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasText = controller.text.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 12, right: 16),
      child: TextField(
        controller: controller,
        cursorColor: colorScheme.onPrimary,
        style: TextStyle(color: colorScheme.onPrimary),
        decoration: InputDecoration(
          isDense: true,
          hintText: hintText,
          hintStyle: TextStyle(color: colorScheme.onPrimary),
          prefixIcon: Icon(Icons.search, color: colorScheme.onPrimary),
          suffixIcon: hasText
              ? IconButton(
                  icon: Icon(Icons.clear, color: colorScheme.onPrimary),
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                )
              : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: colorScheme.primary,
        ),
        onChanged: onChanged,
      ),
    );
  }
}
