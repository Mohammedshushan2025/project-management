import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';

class SearchButtonWidget extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isEnabled;

  const SearchButtonWidget({
    super.key,
    required this.onPressed,
    this.isEnabled = true,
  });

  @override
  State<SearchButtonWidget> createState() => _SearchButtonWidgetState();
}

class _SearchButtonWidgetState extends State<SearchButtonWidget>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTapDown: widget.isEnabled
          ? (_) => setState(() => _isPressed = true)
          : null,
      onTapUp: widget.isEnabled
          ? (_) {
              setState(() => _isPressed = false);
              Future.delayed(
                const Duration(milliseconds: 100),
                widget.onPressed,
              );
            }
          : null,
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..scale(_isPressed ? 0.97 : 1.0),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            gradient: widget.isEnabled
                ? const LinearGradient(
                    colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : LinearGradient(
                    colors: [Colors.grey[400]!, Colors.grey[500]!],
                  ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: widget.isEnabled && !_isPressed
                ? [
                    BoxShadow(
                      color: const Color(0xFF4F46E5).withOpacity(0.3),
                      spreadRadius: 0,
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.search, color: Colors.white, size: 22),
              const SizedBox(width: 8),
              Text(
                l10n.search,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
