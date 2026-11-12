import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/constants/app_assets.dart';
import '../../core/services/audio_service.dart';
import '../../core/utils/validators.dart';
import '../../shared/widgets/app_widgets.dart';

class AddProfileScreen extends ConsumerStatefulWidget {
  const AddProfileScreen({super.key});

  @override
  ConsumerState<AddProfileScreen> createState() => _AddProfileScreenState();
}

class _AddProfileScreenState extends ConsumerState<AddProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  int _avatarIndex = 0;
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _saving) return;
    setState(() => _saving = true);
    try {
      final profile = await ref.read(profilesProvider.notifier).createProfile(
            name: _nameController.text,
            avatarIndex: _avatarIndex,
          );
      ref.read(activeProfileProvider.notifier).setProfile(profile);
      await ref.read(settingsProvider.notifier).selectProfile(profile.id);
      ref.read(audioServiceProvider).play(SoundEffect.celebration);
      if (mounted) context.go('/home');
    } catch (error) {
      if (mounted) {
        setState(() => _saving = false);
        showAppSnack(
          context,
          'تعذر إنشاء الملف. حاول مرة أخرى.',
          isError: true,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PlayfulScaffold(
      appBar: AppBar(
        title: const Text('بطل جديد'),
        leading: IconButton(
          tooltip: 'رجوع',
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_forward_rounded),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MascotBubble(
                asset: AppAssets.mascotEncouraging,
                message:
                    'اكتب اسم البطل واختر شكله. سنحتفظ بتقدمه في هذا الجهاز.',
              ),
              const SizedBox(height: 20),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'اسم البطل',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _nameController,
                      autofocus: true,
                      textInputAction: TextInputAction.done,
                      textCapitalization: TextCapitalization.words,
                      maxLength: 24,
                      validator: Validators.profileName,
                      onFieldSubmitted: (_) => _save(),
                      decoration: const InputDecoration(
                        hintText: 'مثال: سارة',
                        prefixIcon: Icon(Icons.person_rounded),
                        counterText: '',
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'اختر الشخصية',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        AppAssets.profileAvatars.length,
                        (index) {
                          final selected = index == _avatarIndex;
                          return GestureDetector(
                            onTap: () {
                              setState(() => _avatarIndex = index);
                              ref
                                  .read(audioServiceProvider)
                                  .play(SoundEffect.tap);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 160),
                              width: 68,
                              height: 68,
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color:
                                    selected ? AppColors.skySoft : Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: selected
                                      ? AppColors.sky
                                      : AppColors.border,
                                  width: selected ? 3 : 1,
                                ),
                              ),
                              child: Image.asset(
                                AppAssets.profileAvatars[index],
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(
                                  Icons.emoji_nature_rounded,
                                  size: 30,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              PressButton(
                onPressed: _saving ? null : _save,
                expanded: true,
                minHeight: 58,
                child: _saving
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.rocket_launch_rounded),
                          SizedBox(width: 8),
                          Text('ابدأ المغامرة'),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
