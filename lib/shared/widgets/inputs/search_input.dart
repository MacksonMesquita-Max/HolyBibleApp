import 'package:flutter/material.dart';

class SearchInput extends StatelessWidget {
  const SearchInput({
    required this.controller,
    required this.onSubmitted,
    this.hintText = 'Pesquisar',
    this.labelText,
    this.autofocus = false,
    this.enabled = true,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;
  final String hintText;
  final String? labelText;
  final bool autofocus;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: enabled,
      autofocus: autofocus,
      textInputAction: TextInputAction.search,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: const Icon(Icons.search_rounded),
      ),
    );
  }
}
