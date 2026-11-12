import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/constants/app_assets.dart';
import '../../core/database/app_database.dart';
import '../../core/services/audio_service.dart';
import '../../core/utils/arabic_numbers.dart';
import '../../shared/widgets/app_widgets.dart';

class ProfilesScreen extends ConsumerWidget {
  const ProfilesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profiles = ref.watch(profilesProvider);
    return PlayfulScaffold(
      appBar: AppBar(
        title: const Text('أبطال الحساب'),
        actions: [
          IconButton(
            tooltip: 'الإعدادات',
            onPressed: () => context.push('/settings'),
            icon: const Icon(Icons.settings_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: profiles.when(
        loading: () => const LoadingView(message: 'نفتح عالم الأبطال...'),
        error: (error, stackTrace) => ErrorRetryView(
          message: 'تعذر تحميل ملفات الأبطال.',
          onRetry: () => ref.invalidate(profilesProvider),
        ),
        data: (items) => CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    MascotBubble(
                      asset: AppAssets.mascotHappy,
                      message: items.isEmpty
                          ? 'مرحبًا! أنا ليث. لنصنع معًا أول بطل حساب!'
                          : 'من سيلعب اليوم؟ اختر بطلك المفضل.',
                      onSpeak: () => ref.read(ttsServiceProvider).speak(
                            items.isEmpty
                                ? 'مرحبًا! لنصنع معًا أول بطل حساب!'
                                : 'من سيلعب اليوم؟ اختر بطلك المفضل.',
                          ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Text(
                          items.isEmpty ? 'ابدأ الرحلة' : 'ملفات الأبطال',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const Spacer(),
                        if (items.isNotEmpty)
                          Text(
                            '${ArabicNumbers.formatInt(items.length)} أبطال',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.mutedForeground,
                                    ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
              sliver: SliverLayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.crossAxisExtent;
                  final columns = width > 680 ? 3 : (width > 430 ? 2 : 2);
                  return SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 0.88,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index >= items.length) {
                          return _AddProfileCard(
                            onTap: () => context.push('/profiles/new'),
                          );
                        }
                        return _ProfileCard(
                          profile: items[index],
                          onSelect: () => _selectProfile(
                            context,
                            ref,
                            items[index],
                          ),
                          onDelete: () => _deleteProfile(
                            context,
                            ref,
                            items[index],
                          ),
                        );
                      },
                      childCount: items.length + 1,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectProfile(
    BuildContext context,
    WidgetRef ref,
    Profile profile,
  ) async {
    ref.read(activeProfileProvider.notifier).setProfile(profile);
    await ref.read(settingsProvider.notifier).selectProfile(profile.id);
    ref.read(audioServiceProvider).play(SoundEffect.tap);
    if (context.mounted) context.go('/home');
  }

  Future<void> _deleteProfile(
    BuildContext context,
    WidgetRef ref,
    Profile profile,
  ) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'حذف ملف ${profile.name}؟',
      message:
          'ستُحذف كل النجوم والجواهر وسجل التمارين لهذا البطل. لا يمكن التراجع.',
      confirmLabel: 'حذف الملف',
      destructive: true,
    );
    if (!confirmed || !context.mounted) return;
    try {
      await ref.read(profilesProvider.notifier).deleteProfile(profile.id);
      if (context.mounted) {
        showAppSnack(context, 'تم حذف ملف ${profile.name}.');
      }
    } catch (error) {
      if (context.mounted) {
        showAppSnack(
          context,
          'تعذر حذف الملف. حاول مرة أخرى.',
          isError: true,
        );
      }
    }
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({
    required this.profile,
    required this.onSelect,
    required this.onDelete,
  });

  final Profile profile;
  final VoidCallback onSelect;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final avatar = AppAssets
        .profileAvatars[profile.avatarIndex % AppAssets.profileAvatars.length];
    return Stack(
      children: [
        Positioned.fill(
          child: AppCard(
            onTap: onSelect,
            semanticLabel: 'اللعب باسم ${profile.name}',
            padding: const EdgeInsets.fromLTRB(14, 18, 14, 14),
            borderColor: AppColors.skySoft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: const BoxDecoration(
                    color: AppColors.sunSoft,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Image.asset(
                    avatar,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.emoji_nature_rounded, size: 42),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  profile.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: AppColors.sunDeep,
                      size: 18,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      ArabicNumbers.formatInt(profile.stars),
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(width: 10),
                    const Icon(
                      Icons.diamond_rounded,
                      color: AppColors.sky,
                      size: 17,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      ArabicNumbers.formatInt(profile.gems),
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 4,
          left: 4,
          child: IconButton(
            tooltip: 'حذف الملف',
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline_rounded, size: 20),
            color: AppColors.mutedForeground,
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ),
      ],
    );
  }
}

class _AddProfileCard extends StatelessWidget {
  const _AddProfileCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      semanticLabel: 'إضافة بطل جديد',
      padding: const EdgeInsets.all(14),
      color: AppColors.skySoft,
      borderColor: AppColors.sky.withValues(alpha: 0.35),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 66,
            height: 66,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_add_alt_1_rounded,
              size: 32,
              color: AppColors.skyDeep,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'بطل جديد',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.skyDeep,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'أضف لاعبًا إلى الرحلة',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.mutedForeground,
                ),
          ),
        ],
      ),
    );
  }
}
