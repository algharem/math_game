import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme.dart';
import '../../core/constants/app_assets.dart';
import '../../core/utils/arabic_numbers.dart';

class PlayfulScaffold extends StatelessWidget {
  const PlayfulScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.accent = AppColors.sun,
    this.backgroundImage,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final Color accent;
  final String? backgroundImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      body: Stack(
        children: [
          Positioned.fill(
            child: _PlayfulBackground(
              accent: accent,
              backgroundImage: backgroundImage,
            ),
          ),
          SafeArea(
            top: appBar == null,
            bottom: bottomNavigationBar == null,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 820),
                child: body,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayfulBackground extends StatelessWidget {
  const _PlayfulBackground({required this.accent, this.backgroundImage});

  final Color accent;
  final String? backgroundImage;

  @override
  Widget build(BuildContext context) {
    final highContrast =
        Theme.of(context).colorScheme.onSurface == const Color(0xFF07182D);
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: highContrast
              ? const [Colors.white, Colors.white]
              : const [
                  Color(0xFFF2FAFF),
                  AppColors.background,
                  Color(0xFFFFFBF0),
                ],
        ),
      ),
      child: Stack(
        children: [
          if (!highContrast && backgroundImage != null)
            Positioned.fill(
              child: Opacity(
                opacity: 0.2,
                child: Image.asset(
                  backgroundImage!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox.shrink(),
                ),
              ),
            ),
          if (!highContrast) ...[
            Positioned(
              top: -80,
              left: -70,
              child: _Blob(size: 210, color: accent.withValues(alpha: 0.18)),
            ),
            Positioned(
              top: 150,
              right: -90,
              child: _Blob(
                size: 180,
                color: AppColors.sky.withValues(alpha: 0.10),
              ),
            ),
            Positioned(
              bottom: -80,
              left: 40,
              child: _Blob(
                size: 230,
                color: AppColors.leaf.withValues(alpha: 0.10),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.color = Colors.white,
    this.borderColor,
    this.radius = 28,
    this.onTap,
    this.semanticLabel,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;
  final Color? borderColor;
  final double radius;
  final VoidCallback? onTap;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: borderColor ?? Theme.of(context).colorScheme.outline,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.045),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(padding: padding, child: child),
    );
    if (onTap == null) return card;
    return Semantics(
      button: true,
      label: semanticLabel,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(radius),
          onTap: () {
            HapticFeedback.selectionClick();
            onTap!();
          },
          child: card,
        ),
      ),
    );
  }
}

class PressButton extends StatefulWidget {
  const PressButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.color = AppColors.sky,
    this.foregroundColor = Colors.white,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
    this.radius = 20,
    this.minHeight = 54,
    this.expanded = false,
    this.semanticLabel,
    this.border,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final Color color;
  final Color foregroundColor;
  final EdgeInsetsGeometry padding;
  final double radius;
  final double minHeight;
  final bool expanded;
  final String? semanticLabel;
  final BorderSide? border;

  @override
  State<PressButton> createState() => _PressButtonState();
}

class _PressButtonState extends State<PressButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    final button = Semantics(
      button: true,
      enabled: enabled,
      label: widget.semanticLabel,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1,
        duration: const Duration(milliseconds: 110),
        child: Material(
          color: enabled
              ? widget.color
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(widget.radius),
          child: InkWell(
            borderRadius: BorderRadius.circular(widget.radius),
            onTap: enabled
                ? () {
                    HapticFeedback.selectionClick();
                    widget.onPressed!();
                  }
                : null,
            onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
            onTapUp: enabled ? (_) => setState(() => _pressed = false) : null,
            onTapCancel:
                enabled ? () => setState(() => _pressed = false) : null,
            child: Container(
              constraints: BoxConstraints(minHeight: widget.minHeight),
              padding: widget.padding,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.radius),
                border: widget.border == null
                    ? null
                    : Border.fromBorderSide(widget.border!),
                boxShadow: enabled
                    ? [
                        BoxShadow(
                          color: widget.color.withValues(alpha: 0.25),
                          blurRadius: 16,
                          offset: const Offset(0, 7),
                        ),
                      ]
                    : null,
              ),
              child: DefaultTextStyle(
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: enabled
                          ? widget.foregroundColor
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                child: IconTheme(
                  data: IconThemeData(
                    color: enabled
                        ? widget.foregroundColor
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  child: Center(child: widget.child),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    // A PressButton's Container has no width constraint, so its intrinsic
    // width is infinite. When used as a ListTile.trailing (or any other
    // context that relies on intrinsic sizing), that infinite width makes
    // the parent fail to lay out and the screen can render black. Wrap in
    // IntrinsicWidth so the button sizes to its child instead.
    final sized = IntrinsicWidth(child: button);
    return widget.expanded
        ? SizedBox(width: double.infinity, child: sized)
        : sized;
  }
}

class MascotBubble extends StatelessWidget {
  const MascotBubble({
    super.key,
    required this.message,
    this.asset = AppAssets.mascotIdle,
    this.mascotSize = 96,
    this.onSpeak,
  });

  final String message;
  final String asset;
  final double mascotSize;
  final VoidCallback? onSpeak;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Hero(
          tag: 'mascot',
          child: Image.asset(
            asset,
            width: mascotSize,
            height: mascotSize,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Container(
              width: mascotSize,
              height: mascotSize,
              decoration: const BoxDecoration(
                color: AppColors.sunSoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.emoji_nature_rounded, size: 42),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: AppCard(
            padding: const EdgeInsets.fromLTRB(18, 16, 12, 16),
            radius: 24,
            borderColor: AppColors.skySoft,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    message,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
                if (onSpeak != null)
                  IconButton(
                    tooltip: 'اسمع التعليمات',
                    onPressed: onSpeak,
                    icon: const Icon(Icons.volume_up_rounded),
                    color: AppColors.skyDeep,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class StatChip extends StatelessWidget {
  const StatChip({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.color = AppColors.sun,
    this.foreground = AppColors.ink,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: foreground.withValues(alpha: 0.08)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 19, color: foreground),
          const SizedBox(width: 6),
          Text(
            value,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: foreground,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: foreground.withValues(alpha: 0.8),
                ),
          ),
        ],
      ),
    );
  }
}

class OperatorBadge extends StatelessWidget {
  const OperatorBadge({
    super.key,
    required this.symbol,
    this.color = AppColors.sky,
    this.size = 52,
  });

  final String symbol;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(size * 0.32),
      ),
      child: Text(
        symbol,
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
      ),
    );
  }
}

class SectionTile extends StatelessWidget {
  const SectionTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.symbol,
    required this.color,
    required this.onTap,
    this.trailing,
  });

  final String title;
  final String subtitle;
  final String symbol;
  final Color color;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      semanticLabel: title,
      padding: const EdgeInsets.all(16),
      borderColor: color.withValues(alpha: 0.22),
      child: Row(
        children: [
          OperatorBadge(symbol: symbol, color: color),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.mutedForeground,
                      ),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing!,
          const SizedBox(width: 4),
          Icon(Icons.chevron_left_rounded, color: color),
        ],
      ),
    );
  }
}

class StarsRow extends StatelessWidget {
  const StarsRow({
    super.key,
    required this.earned,
    this.total = 5,
    this.size = 28,
  });

  final int earned;
  final int total;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(total, (index) {
        final active = index < earned;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Opacity(
            opacity: active ? 1 : 0.22,
            child: Image.asset(
              AppAssets.star,
              width: size,
              height: size,
              errorBuilder: (context, error, stackTrace) => Icon(
                active ? Icons.star_rounded : Icons.star_outline_rounded,
                color: AppColors.sunDeep,
                size: size,
              ),
            ),
          ),
        );
      }),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.auto_awesome_rounded,
    this.action,
  });

  final String title;
  final String message;
  final IconData icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: const BoxDecoration(
                color: AppColors.sunSoft,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 42, color: AppColors.sunDeep),
            ),
            const SizedBox(height: 18),
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.mutedForeground,
                  ),
            ),
            if (action != null) ...[const SizedBox(height: 18), action!],
          ],
        ),
      ),
    );
  }
}

class LoadingView extends StatelessWidget {
  const LoadingView({super.key, this.message = 'نجهّز لك النشاط...'});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(message, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}

class ErrorRetryView extends StatelessWidget {
  const ErrorRetryView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              size: 54,
              color: AppColors.coral,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            PressButton(
              onPressed: onRetry,
              color: AppColors.sky,
              child: const Text('حاول مرة أخرى'),
            ),
          ],
        ),
      ),
    );
  }
}

class NumericKeypad extends StatelessWidget {
  const NumericKeypad({
    super.key,
    required this.onDigit,
    required this.onBackspace,
    this.onClear,
    this.enabled = true,
  });

  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;
  final VoidCallback? onClear;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final keys = [
      '١',
      '٢',
      '٣',
      '٤',
      '٥',
      '٦',
      '٧',
      '٨',
      '٩',
    ];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var row = 0; row < 3; row++)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  for (var column = 0; column < 3; column++)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: _KeypadButton(
                          label: keys[row * 3 + column],
                          onTap: enabled
                              ? () => onDigit(
                                    ArabicNumbers.toWesternDigits(
                                      keys[row * 3 + column],
                                    ),
                                  )
                              : null,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: _KeypadButton(
                    label: 'مسح',
                    onTap: enabled ? onClear : null,
                    color: AppColors.coralSoft,
                    foreground: AppColors.coralDeep,
                    small: true,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: _KeypadButton(
                    label: '٠',
                    onTap: enabled ? () => onDigit('0') : null,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: _KeypadButton(
                    label: '⌫',
                    onTap: enabled ? onBackspace : null,
                    color: AppColors.skySoft,
                    foreground: AppColors.skyDeep,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _KeypadButton extends StatelessWidget {
  const _KeypadButton({
    required this.label,
    required this.onTap,
    this.color = Colors.white,
    this.foreground = AppColors.ink,
    this.small = false,
  });

  final String label;
  final VoidCallback? onTap;
  final Color color;
  final Color foreground;
  final bool small;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          height: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Theme.of(context).colorScheme.outline),
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: foreground,
                  fontWeight: FontWeight.w800,
                  fontSize: small ? 16 : null,
                ),
          ),
        ),
      ),
    );
  }
}

class ProgressPill extends StatelessWidget {
  const ProgressPill({
    super.key,
    required this.value,
    this.color = AppColors.leaf,
    this.height = 12,
  });

  final double value;
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height),
      child: LinearProgressIndicator(
        value: value.clamp(0, 1).toDouble(),
        minHeight: height,
        backgroundColor: color.withValues(alpha: 0.15),
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}

void showAppSnack(
  BuildContext context,
  String message, {
  bool isError = false,
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.coralDeep : AppColors.ink,
      ),
    );
}

Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = 'تأكيد',
  String cancelLabel = 'إلغاء',
  bool destructive = false,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelLabel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: TextButton.styleFrom(
            foregroundColor:
                destructive ? AppColors.coralDeep : AppColors.skyDeep,
          ),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return result ?? false;
}
