import 'package:flutter/material.dart';

/// A convenient customizable button that accepts a direct `Color` and
/// several optional parameters for quick use across the app.
class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? textColor;
  final Widget? leading;
  final bool loading;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double elevation;
  final TextStyle? textStyle;
  final bool expand;

  const CustomButton({
    super.key,
    required this.label,
    this.onPressed,
    this.color,
    this.textColor,
    this.leading,
    this.loading = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
    this.borderRadius = 8.0,
    this.elevation = 2.0,
    this.textStyle,
    this.expand = false,
  });

  bool get _enabled => onPressed != null && !loading;

  Color _resolveBackground(ColorScheme scheme) {
    return color ?? scheme.primary;
  }

  Color _resolveForeground(ColorScheme scheme) {
    if (textColor != null) return textColor!;
    final bg = _resolveBackground(scheme);
    // choose white or black depending on background luminance
    return bg.computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = _resolveBackground(scheme);
    final fg = _resolveForeground(scheme);

    final style =
        ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          padding: padding,
          elevation: elevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ).merge(
          ButtonStyle(
            overlayColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.pressed))
                return bg.withOpacity(0.85);
              return null;
            }),
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled))
                return Colors.grey.shade400;
              if (states.contains(WidgetState.pressed))
                return bg.withOpacity(0.95);
              return bg;
            }),
          ),
        );

    final content = loading
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: AlwaysStoppedAnimation<Color>(fg),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style:
                    textStyle ??
                    TextStyle(color: fg, fontWeight: FontWeight.w600),
              ),
            ],
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leading != null) ...[leading!, const SizedBox(width: 10)],
              Text(
                label,
                style:
                    textStyle ??
                    TextStyle(color: fg, fontWeight: FontWeight.w600),
              ),
            ],
          );

    final button = ElevatedButton(
      onPressed: _enabled ? onPressed : null,
      style: style,
      child: content,
    );

    if (expand) return SizedBox(width: double.infinity, child: button);
    return button;
  }
}
