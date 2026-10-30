import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sound_center/shared/theme/themes.dart';

class Glass extends StatelessWidget {
  const Glass({
    super.key,
    this.borderRadius = 0.0,
    required this.color,
    required this.child,
    this.blur,
    this.opacity,
    this.elevation = 0.0,
    this.useBorder = true,
    this.onlyTopBorderRadius = false,
    this.quality,
  });

  final double borderRadius;
  final Color color;
  final double? blur;
  final double? opacity;
  final double elevation;
  final Widget child;
  final bool useBorder;
  final bool onlyTopBorderRadius;
  final GlassQuality? quality;

  @override
  Widget build(BuildContext context) {
    final finalOpacity = opacity ?? ThemeManager.current.opacity;
    final finalBlur = blur ?? ThemeManager.current.blur;

    final borderSide = useBorder
        ? BorderSide(
            color: ThemeManager.current.iconColor.withValues(alpha: 0.2),
            width: 0.8,
          )
        : BorderSide.none;

    final LiquidShape shape = onlyTopBorderRadius
        ? LiquidVerticalRoundedRectangle(
            topRadius: borderRadius,
            bottomRadius: 0,
            side: borderSide,
          )
        : borderRadius > 0
            ? LiquidRoundedSuperellipse(
                borderRadius: borderRadius,
                side: borderSide,
              )
            : LiquidRoundedRectangle(
                borderRadius: 0,
                side: borderSide,
              );

    final settings = LiquidGlassSettings(
      glassColor: color.withValues(alpha: finalOpacity),
      blur: finalBlur > 0 ? finalBlur : 0.01,
      thickness: 25,
      fresnelStrength: useBorder ? 1.0 : 0.2,
      chromaticAberration: 0.015,
      specularSharpness: GlassSpecularSharpness.medium,
    );

    Widget container = GlassContainer(
      useOwnLayer: true,
      quality: quality ?? GlassQuality.standard,
      shape: shape,
      settings: settings,
      color: color.withValues(alpha: finalOpacity),
      clipBehavior: Clip.antiAlias,
      allowElevation: elevation > 0,
      child: child,
    );

    if (elevation > 0) {
      container = DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: onlyTopBorderRadius
              ? BorderRadius.vertical(top: Radius.circular(borderRadius))
              : BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 5),
              blurRadius: elevation * 1.5,
              spreadRadius: elevation * 0.5,
              color: Colors.black.withValues(alpha: 0.35),
            ),
          ],
        ),
        child: container,
      );
    }

    return container;
  }
}
