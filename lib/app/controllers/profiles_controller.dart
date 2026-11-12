import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../providers.dart';

class ProfilesController extends AsyncNotifier<List<Profile>> {
  @override
  Future<List<Profile>> build() {
    return ref.watch(databaseProvider).getAllProfiles();
  }

  Future<Profile> createProfile({
    required String name,
    required int avatarIndex,
  }) async {
    final database = ref.read(databaseProvider);
    final profile = await database.insertProfile(
      name: name,
      avatarIndex: avatarIndex,
    );
    final current = state.valueOrNull ?? await database.getAllProfiles();
    state = AsyncData([...current, profile]);
    return profile;
  }

  Future<void> deleteProfile(String profileId) async {
    final database = ref.read(databaseProvider);
    await database.deleteProfile(profileId);
    final current = state.valueOrNull ?? const <Profile>[];
    state = AsyncData(
      current.where((profile) => profile.id != profileId).toList(),
    );
    if (ref.read(activeProfileProvider)?.id == profileId) {
      ref.read(activeProfileProvider.notifier).clear();
      await ref.read(settingsProvider.notifier).selectProfile(null);
    }
  }

  Future<void> refreshProfiles() async {
    state = AsyncData(await ref.read(databaseProvider).getAllProfiles());
  }
}

class ActiveProfileController extends Notifier<Profile?> {
  @override
  Profile? build() => null;

  void setProfile(Profile? profile) {
    state = profile;
  }

  void clear() {
    state = null;
  }

  Future<void> refreshActiveProfile() async {
    final current = state;
    if (current == null) return;
    final updated = await ref.read(databaseProvider).getProfile(current.id);
    if (updated != null) state = updated;
  }
}
