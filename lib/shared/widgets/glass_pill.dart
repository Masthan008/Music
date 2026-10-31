import 'package:flutter/material.dart';
import 'package:sound_center/shared/widgets/glass.dart';

class GlassPillItem {
  final String id;
  final String label;
  final IconData icon;

  const GlassPillItem({
    required this.id,
    required this.label,
    required this.icon,
  });
}

class GlassPillBar extends StatelessWidget {
  const GlassPillBar({
    super.key,
    required this.items,
    required this.selectedId,
    required this.onSelected,
    this.height = 42.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
  });

  final List<GlassPillItem> items;
  final String selectedId;
  final ValueChanged<String> onSelected;
  final double height;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        padding: padding,
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final item = items[index];
          final isSelected = item.id == selectedId;
          return GlassPillChip(
            item: item,
            isSelected: isSelected,
            onTap: () => onSelected(item.id),
          );
        },
      ),
    );
  }
}

class GlassPillChip extends StatefulWidget {
  const GlassPillChip({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final GlassPillItem item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<GlassPillChip> createState() => _GlassPillChipState();
}

class _GlassPillChipState extends State<GlassPillChip> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    final textColor = widget.isSelected
        ? (theme.brightness == Brightness.dark ? Colors.white : primaryColor)
        : theme.colorScheme.onSurface.withValues(alpha: 0.85);

    final iconColor = widget.isSelected
        ? (theme.brightness == Brightness.dark ? Colors.white : primaryColor)
        : theme.colorScheme.onSurfaceVariant;

    final pillColor = widget.isSelected
        ? primaryColor.withValues(alpha: 0.28)
        : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.12);

    return AnimatedScale(
      scale: _isPressed ? 0.94 : 1.0,
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeOutCubic,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOutCubic,
          child: Glass(
            borderRadius: 24,
            blur: widget.isSelected ? 16 : 8,
            opacity: widget.isSelected ? 0.35 : 0.15,
            color: pillColor,
            useBorder: true,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 6,
                children: [
                  Icon(
                    widget.item.icon,
                    size: 16,
                    color: iconColor,
                  ),
                  Text(
                    widget.item.label,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: widget.isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: textColor,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
