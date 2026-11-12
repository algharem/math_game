import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/constants/app_assets.dart';
import '../../shared/widgets/app_widgets.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  Future<void> _bootstrap() async {
    try {
      await ref.read(databaseProvider).getAllProfiles();
      await ref.read(parentLanControllerProvider).initialize();
      if (!mounted) return;
      context.go('/login');
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = 'تعذر فتح ملفات اللاعبين. تأكد من وجود مساحة تخزين كافية.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PlayfulScaffold(
      accent: AppColors.leaf,
      body: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(18),
              child: Image.asset(
                AppAssets.mascotHappy,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.emoji_nature_rounded, size: 72),
              ),
            ),
            const SizedBox(height: 22),
            Text(
              'أبطال الحساب',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: AppColors.skyDeep,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'مغامرة يومية في عالم الضرب والقسمة',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.mutedForeground,
                  ),
            ),
            const SizedBox(height: 34),
            if (_error == null)
              const CircularProgressIndicator()
            else ...[
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.coralDeep,
                    ),
              ),
              const SizedBox(height: 18),
              PressButton(
                onPressed: () {
                  setState(() => _error = null);
                  _bootstrap();
                },
                child: const Text('حاول مرة أخرى'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
