import '../../shared/models/cosmetics.dart';
import '../../shared/models/enums.dart';

class AppAssets {
  AppAssets._();

  static const mascotIdle = 'assets/images/mascot/lion-idle.png';
  static const mascotHappy = 'assets/images/mascot/lion-happy.png';
  static const mascotEncouraging = 'assets/images/mascot/lion-encouraging.png';
  static const mascotCelebrating = 'assets/images/mascot/lion-celebrating.png';

  static const star = 'assets/images/objects/star.png';
  static const gem = 'assets/images/objects/gem.png';
  static const chest = 'assets/images/objects/treasure-chest.png';

  static const islands = [
    'assets/images/islands/island-palm.png',
    'assets/images/islands/island-desert.png',
    'assets/images/islands/island-volcano.png',
    'assets/images/islands/island-snow.png',
  ];

  static const profileAvatars = [
    mascotIdle,
    mascotHappy,
    mascotCelebrating,
    mascotEncouraging,
  ];

  static const badgeFirstStar = 'assets/images/badges/badge-first-star.png';
  static const badgeStreak = 'assets/images/badges/badge-streak.png';
  static const badgeTableMaster = 'assets/images/badges/badge-table-master.png';
  static const badgeDivisionHero =
      'assets/images/badges/badge-division-hero.png';

  static const mascotByMood = {
    MascotMood.idle: mascotIdle,
    MascotMood.happy: mascotHappy,
    MascotMood.encouraging: mascotEncouraging,
    MascotMood.celebrating: mascotCelebrating,
  };

  static String mascot(MascotMood mood) => mascotByMood[mood] ?? mascotIdle;

  static String islandFor(int table) =>
      islands[(table - 1).clamp(0, islands.length - 1)];

  static String? backgroundAsset(String? id) {
    final item = CosmeticCatalog.byId(id);
    if (item == null || item.type != CosmeticType.background) return null;
    return item.assetPath;
  }

  static String? skinAsset(String? id) {
    final item = CosmeticCatalog.byId(id);
    if (item == null || item.type != CosmeticType.skin) return null;
    return item.assetPath;
  }
}
