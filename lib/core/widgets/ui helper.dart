import 'package:flutter/material.dart';

InputDecoration myFieldDecoration({
  IconData? prefixIcon,
  required String hint,
  required String label,
  bool isPassword = false,
  bool isPasswordVisible = false,
  VoidCallback? onPasswordVisibilityTap
}){
  return InputDecoration(
    prefixIcon: prefixIcon != null? Icon(prefixIcon) : null,
    hintText: hint,
    labelText: label,
    suffixIcon: isPassword ? IconButton(onPressed: onPasswordVisibilityTap, icon: Icon(isPasswordVisible ? Icons.visibility : Icons.visibility_off)) : null,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(21),
    ),
  );
}


InputDecoration myFieldDecoration2({
  required String hint,
  required String label,
  VoidCallback? onPrefixTap,
  VoidCallback? onSuffixTap,
}) {
  return InputDecoration(
    hintText: hint,
    labelText: label,

    // Prefix Button
    prefixIcon: IconButton(
      icon: const Icon(Icons.search),
      onPressed: onPrefixTap,
    ),

    // Suffix Button
    suffixIcon: IconButton(
      icon: const Icon(Icons.tune),
      onPressed: onSuffixTap,
    ),

    filled: true,
    fillColor: Colors.grey.shade100,

    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(21),
      borderSide: BorderSide.none,
    ),
  );
}
