import 'package:flutter/material.dart';

/// A minimal, reusable primary button for the app.
///
/// Features:
/// - Required `label` text.
/// - Optional `leading` icon/widget.
/// - `onPressed` callback (null disables the button).
/// - `loading` flag to show a small progress indicator and disable taps.
/// - Accepts an optional `style` to customize the underlying button style.
class PrimaryButton extends StatelessWidget {
	final String label;
	final VoidCallback? onPressed;
	final Widget? leading;
	final bool loading;
	final ButtonStyle? style;
	final EdgeInsetsGeometry padding;

	const PrimaryButton({
		super.key,
		required this.label,
		this.onPressed,
		this.leading,
		this.loading = false,
		this.style,
		this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
	});

	bool get _isEnabled => onPressed != null && !loading;

	@override
	Widget build(BuildContext context) {
		final colorScheme = Theme.of(context).colorScheme;

		final defaultStyle = ElevatedButton.styleFrom(
			backgroundColor: colorScheme.primary,
			foregroundColor: colorScheme.onPrimary,
			padding: padding,
			shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
			elevation: 2,
		);

		final mergedStyle = style == null ? defaultStyle : defaultStyle.merge(style);

		final child = loading
				? Row(
						mainAxisSize: MainAxisSize.min,
						children: [
							SizedBox(
								width: 16,
								height: 16,
								child: CircularProgressIndicator(
									strokeWidth: 2.0,
									valueColor: AlwaysStoppedAnimation<Color>(colorScheme.onPrimary),
								),
							),
							const SizedBox(width: 12),
							Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
						],
					)
				: Row(
						mainAxisSize: MainAxisSize.min,
						children: [
							if (leading != null) ...[
								leading!,
								const SizedBox(width: 10),
							],
							Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
						],
					);

		return ElevatedButton(
			onPressed: _isEnabled ? onPressed : null,
			style: mergedStyle,
			child: child,
		);
	}
}

