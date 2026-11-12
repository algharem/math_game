enum CosmeticType {
  skin,
  background,
}

class CosmeticItem {
  const CosmeticItem({
    required this.id,
    required this.type,
    required this.name,
    required this.price,
    required this.assetPath,
  });

  final String id;
  final CosmeticType type;
  final String name;
  final int price;
  final String assetPath;
}

class CosmeticCatalog {
  CosmeticCatalog._();

  static const List<CosmeticItem> items = [
    CosmeticItem(
      id: 'skin-explorer',
      type: CosmeticType.skin,
      name: 'المستكشف',
      price: 80,
      assetPath: 'assets/images/store/skin-explorer.png',
    ),
    CosmeticItem(
      id: 'skin-astronaut',
      type: CosmeticType.skin,
      name: 'رائد الفضاء',
      price: 150,
      assetPath: 'assets/images/store/skin-astronaut.png',
    ),
    CosmeticItem(
      id: 'skin-superhero',
      type: CosmeticType.skin,
      name: 'البطل الخارق',
      price: 200,
      assetPath: 'assets/images/store/skin-superhero.png',
    ),
    CosmeticItem(
      id: 'bg-jungle',
      type: CosmeticType.background,
      name: 'الغابة المشمسة',
      price: 60,
      assetPath: 'assets/images/store/bg-jungle.jpg',
    ),
    CosmeticItem(
      id: 'bg-underwater',
      type: CosmeticType.background,
      name: 'أعماق البحر',
      price: 90,
      assetPath: 'assets/images/store/bg-underwater.jpg',
    ),
    CosmeticItem(
      id: 'bg-space',
      type: CosmeticType.background,
      name: 'الفضاء الواسع',
      price: 140,
      assetPath: 'assets/images/store/bg-space.jpg',
    ),
  ];

  static CosmeticItem? byId(String? id) {
    if (id == null) return null;
    for (final item in items) {
      if (item.id == id) return item;
    }
    return null;
  }

  static List<CosmeticItem> byType(CosmeticType type) =>
      items.where((item) => item.type == type).toList(growable: false);
}

extension CosmeticTypeX on CosmeticType {
  String get label {
    switch (this) {
      case CosmeticType.skin:
        return 'الشخصيات';
      case CosmeticType.background:
        return 'الخلفيات';
    }
  }
}
