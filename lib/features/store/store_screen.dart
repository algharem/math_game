import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/constants/app_assets.dart';
import '../../core/database/app_database.dart';
import '../../core/services/audio_service.dart';
import '../../core/utils/arabic_numbers.dart';
import '../../shared/models/cosmetics.dart';
import '../../shared/widgets/app_widgets.dart';

class StoreScreen extends ConsumerStatefulWidget {
  const StoreScreen({super.key});

  @override
  ConsumerState<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends ConsumerState<StoreScreen> {
  CosmeticType _type = CosmeticType.skin;
  String? _busyItemId;

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(activeProfileProvider);
    final statsAsync = ref.watch(profileStatsProvider);
    final unlockedAsync = ref.watch(unlockedCosmeticsProvider);
    final unlocked = unlockedAsync.valueOrNull ?? const <UnlockedCosmetic>[];
    final ownedIds = unlocked.map((item) => item.itemId).toSet();
    final gems = statsAsync.valueOrNull?.gems ?? profile?.gems ?? 0;
    final items = CosmeticCatalog.byType(_type);

    return PlayfulScaffold(
      accent: AppColors.purple,
      appBar: AppBar(
        title: const Text('متجر المكافآت'),
        leading: IconButton(
          tooltip: 'رجوع',
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_forward_rounded),
        ),
      ),
      body: profile == null
          ? const EmptyState(
              title: 'لا يوجد بطل',
              message: 'اختر ملف بطل أولًا.',
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
              children: [
                MascotBubble(
                  asset: AppAssets.mascotCelebrating,
                  message:
                      'اجمع الجواهر من التمارين واشترِ مظهرًا جديدًا لبطلك!',
                  onSpeak: () => ref.read(ttsServiceProvider).speak(
                        'اجمع الجواهر من التمارين واشترِ مظهرًا جديدًا لبطلك!',
                      ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: StatChip(
                        icon: Icons.diamond_rounded,
                        label: 'جوهرة',
                        value: ArabicNumbers.formatInt(gems),
                        color: AppColors.skySoft,
                        foreground: AppColors.skyDeep,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'المقتنيات: ${ArabicNumbers.formatInt(ownedIds.length)}',
                        textAlign: TextAlign.end,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.mutedForeground,
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    for (final type in CosmeticType.values)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: ChoiceChip(
                            label: SizedBox(
                              width: double.infinity,
                              child: Text(
                                type.label,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            selected: _type == type,
                            onSelected: (_) => setState(() => _type = type),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 14),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.64,
                  ),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final owned = ownedIds.contains(item.id);
                    final equipped = _type == CosmeticType.skin
                        ? profile.equippedSkinId == item.id
                        : profile.equippedBackgroundId == item.id;
                    return _StoreItemCard(
                      item: item,
                      owned: owned,
                      equipped: equipped,
                      busy: _busyItemId == item.id,
                      gems: gems,
                      onBuy: () => _buy(item),
                      onEquip: () => _equip(item),
                      onUnequip: () => _unequip(item.type),
                    );
                  },
                ),
              ],
            ),
    );
  }

  Future<void> _buy(CosmeticItem item) async {
    final profile = ref.read(activeProfileProvider);
    if (profile == null) return;
    final confirmed = await showConfirmDialog(
      context,
      title: 'شراء ${item.name}؟',
      message: 'سيتم خصم ${ArabicNumbers.formatInt(item.price)} جوهرة.',
      confirmLabel: 'شراء',
    );
    if (!confirmed || !mounted) return;
    setState(() => _busyItemId = item.id);
    try {
      final result = await ref
          .read(databaseProvider)
          .purchaseCosmetic(profile.id, item.id);
      if (!mounted) return;
      switch (result) {
        case PurchaseResult.purchased:
          ref.read(audioServiceProvider).play(SoundEffect.celebration);
          _refreshAfterChange();
          showAppSnack(context, 'تم شراء ${item.name}!');
        case PurchaseResult.alreadyOwned:
          showAppSnack(context, 'تملك هذه المقتنية بالفعل.');
        case PurchaseResult.insufficientGems:
          showAppSnack(
            context,
            'تحتاج إلى ${ArabicNumbers.formatInt(item.price)} جوهرة.',
            isError: true,
          );
        case PurchaseResult.notFound:
          showAppSnack(context, 'هذه المقتنية غير متاحة.', isError: true);
        case PurchaseResult.notOwned:
          showAppSnack(context, 'هذه المقتنية غير مملوكة.', isError: true);
      }
    } catch (error) {
      if (mounted) {
        showAppSnack(context, 'تعذر إتمام الشراء.', isError: true);
      }
    } finally {
      if (mounted) setState(() => _busyItemId = null);
    }
  }

  Future<void> _equip(CosmeticItem item) async {
    final profile = ref.read(activeProfileProvider);
    if (profile == null) return;
    setState(() => _busyItemId = item.id);
    try {
      final result =
          await ref.read(databaseProvider).equipCosmetic(profile.id, item.id);
      if (!mounted) return;
      if (result == PurchaseResult.purchased) {
        ref.read(audioServiceProvider).play(SoundEffect.star);
        _refreshAfterChange();
        showAppSnack(context, 'تم تجهيز ${item.name}.');
      } else {
        showAppSnack(context, 'تعذر تجهيز المقتنية.', isError: true);
      }
    } catch (error) {
      if (mounted) {
        showAppSnack(context, 'تعذر تجهيز المقتنية.', isError: true);
      }
    } finally {
      if (mounted) setState(() => _busyItemId = null);
    }
  }

  Future<void> _unequip(CosmeticType type) async {
    final profile = ref.read(activeProfileProvider);
    if (profile == null) return;
    setState(() => _busyItemId = 'unequip-${type.name}');
    try {
      await ref.read(databaseProvider).unequipCosmetic(profile.id, type);
      if (!mounted) return;
      _refreshAfterChange();
      showAppSnack(context, 'تمت إزالة المظهر.');
    } catch (error) {
      if (mounted) {
        showAppSnack(context, 'تعذرت إزالة المظهر.', isError: true);
      }
    } finally {
      if (mounted) setState(() => _busyItemId = null);
    }
  }

  void _refreshAfterChange() {
    ref.invalidate(unlockedCosmeticsProvider);
    ref.invalidate(profilesProvider);
    ref.invalidate(profileStatsProvider);
    ref.read(activeProfileProvider.notifier).refreshActiveProfile();
  }
}

class _StoreItemCard extends StatelessWidget {
  const _StoreItemCard({
    required this.item,
    required this.owned,
    required this.equipped,
    required this.busy,
    required this.gems,
    required this.onBuy,
    required this.onEquip,
    required this.onUnequip,
  });

  final CosmeticItem item;
  final bool owned;
  final bool equipped;
  final bool busy;
  final int gems;
  final VoidCallback onBuy;
  final VoidCallback onEquip;
  final VoidCallback onUnequip;

  @override
  Widget build(BuildContext context) {
    final isSkin = item.type == CosmeticType.skin;
    return AppCard(
      padding: const EdgeInsets.all(9),
      borderColor:
          equipped ? AppColors.leaf.withValues(alpha: 0.5) : AppColors.border,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Container(
                color: AppColors.skySoft,
                child: Image.asset(
                  item.assetPath,
                  fit: isSkin ? BoxFit.contain : BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child: Icon(Icons.image_not_supported_rounded),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              if (equipped)
                const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.leafDeep,
                  size: 18,
                ),
            ],
          ),
          const SizedBox(height: 3),
          if (owned)
            Text(
              equipped ? 'مُجهّز حاليًا' : 'مملوك',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: equipped
                        ? AppColors.leafDeep
                        : AppColors.mutedForeground,
                  ),
            )
          else
            Row(
              children: [
                const Icon(
                  Icons.diamond_rounded,
                  color: AppColors.skyDeep,
                  size: 15,
                ),
                const SizedBox(width: 3),
                Text(
                  ArabicNumbers.formatInt(item.price),
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.skyDeep,
                      ),
                ),
              ],
            ),
          const SizedBox(height: 8),
          if (busy)
            const Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              ),
            )
          else if (!owned)
            PressButton(
              onPressed: gems >= item.price ? onBuy : null,
              color: AppColors.purple,
              minHeight: 40,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              radius: 14,
              expanded: true,
              child: const Text('شراء', style: TextStyle(fontSize: 13)),
            )
          else if (equipped)
            PressButton(
              onPressed: onUnequip,
              color: AppColors.coralSoft,
              foregroundColor: AppColors.coralDeep,
              minHeight: 40,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              radius: 14,
              expanded: true,
              child: const Text('إزالة', style: TextStyle(fontSize: 13)),
            )
          else
            PressButton(
              onPressed: onEquip,
              color: AppColors.leafDeep,
              minHeight: 40,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              radius: 14,
              expanded: true,
              child: const Text('استخدام', style: TextStyle(fontSize: 13)),
            ),
        ],
      ),
    );
  }
}
