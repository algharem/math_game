// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProfilesTable extends Profiles with TableInfo<$ProfilesTable, Profile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 24),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _avatarIndexMeta =
      const VerificationMeta('avatarIndex');
  @override
  late final GeneratedColumn<int> avatarIndex = GeneratedColumn<int>(
      'avatar_index', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _starsMeta = const VerificationMeta('stars');
  @override
  late final GeneratedColumn<int> stars = GeneratedColumn<int>(
      'stars', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _gemsMeta = const VerificationMeta('gems');
  @override
  late final GeneratedColumn<int> gems = GeneratedColumn<int>(
      'gems', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _pointsMeta = const VerificationMeta('points');
  @override
  late final GeneratedColumn<int> points = GeneratedColumn<int>(
      'points', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _equippedSkinIdMeta =
      const VerificationMeta('equippedSkinId');
  @override
  late final GeneratedColumn<String> equippedSkinId = GeneratedColumn<String>(
      'equipped_skin_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _equippedBackgroundIdMeta =
      const VerificationMeta('equippedBackgroundId');
  @override
  late final GeneratedColumn<String> equippedBackgroundId =
      GeneratedColumn<String>('equipped_background_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _schoolGradeMeta =
      const VerificationMeta('schoolGrade');
  @override
  late final GeneratedColumn<int> schoolGrade = GeneratedColumn<int>(
      'school_grade', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _currentLevelMeta =
      const VerificationMeta('currentLevel');
  @override
  late final GeneratedColumn<int> currentLevel = GeneratedColumn<int>(
      'current_level', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _totalCompletedLevelsMeta =
      const VerificationMeta('totalCompletedLevels');
  @override
  late final GeneratedColumn<int> totalCompletedLevels = GeneratedColumn<int>(
      'total_completed_levels', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        avatarIndex,
        stars,
        gems,
        points,
        equippedSkinId,
        equippedBackgroundId,
        schoolGrade,
        currentLevel,
        totalCompletedLevels,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profiles';
  @override
  VerificationContext validateIntegrity(Insertable<Profile> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('avatar_index')) {
      context.handle(
          _avatarIndexMeta,
          avatarIndex.isAcceptableOrUnknown(
              data['avatar_index']!, _avatarIndexMeta));
    }
    if (data.containsKey('stars')) {
      context.handle(
          _starsMeta, stars.isAcceptableOrUnknown(data['stars']!, _starsMeta));
    }
    if (data.containsKey('gems')) {
      context.handle(
          _gemsMeta, gems.isAcceptableOrUnknown(data['gems']!, _gemsMeta));
    }
    if (data.containsKey('points')) {
      context.handle(_pointsMeta,
          points.isAcceptableOrUnknown(data['points']!, _pointsMeta));
    }
    if (data.containsKey('equipped_skin_id')) {
      context.handle(
          _equippedSkinIdMeta,
          equippedSkinId.isAcceptableOrUnknown(
              data['equipped_skin_id']!, _equippedSkinIdMeta));
    }
    if (data.containsKey('equipped_background_id')) {
      context.handle(
          _equippedBackgroundIdMeta,
          equippedBackgroundId.isAcceptableOrUnknown(
              data['equipped_background_id']!, _equippedBackgroundIdMeta));
    }
    if (data.containsKey('school_grade')) {
      context.handle(
          _schoolGradeMeta,
          schoolGrade.isAcceptableOrUnknown(
              data['school_grade']!, _schoolGradeMeta));
    }
    if (data.containsKey('current_level')) {
      context.handle(
          _currentLevelMeta,
          currentLevel.isAcceptableOrUnknown(
              data['current_level']!, _currentLevelMeta));
    }
    if (data.containsKey('total_completed_levels')) {
      context.handle(
          _totalCompletedLevelsMeta,
          totalCompletedLevels.isAcceptableOrUnknown(
              data['total_completed_levels']!, _totalCompletedLevelsMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Profile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Profile(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      avatarIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}avatar_index'])!,
      stars: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}stars'])!,
      gems: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}gems'])!,
      points: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}points'])!,
      equippedSkinId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}equipped_skin_id']),
      equippedBackgroundId: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}equipped_background_id']),
      schoolGrade: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}school_grade'])!,
      currentLevel: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}current_level'])!,
      totalCompletedLevels: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}total_completed_levels'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ProfilesTable createAlias(String alias) {
    return $ProfilesTable(attachedDatabase, alias);
  }
}

class Profile extends DataClass implements Insertable<Profile> {
  final String id;
  final String name;
  final int avatarIndex;
  final int stars;
  final int gems;
  final int points;
  final String? equippedSkinId;
  final String? equippedBackgroundId;
  final int schoolGrade;
  final int currentLevel;
  final int totalCompletedLevels;
  final DateTime createdAt;
  const Profile(
      {required this.id,
      required this.name,
      required this.avatarIndex,
      required this.stars,
      required this.gems,
      required this.points,
      this.equippedSkinId,
      this.equippedBackgroundId,
      required this.schoolGrade,
      required this.currentLevel,
      required this.totalCompletedLevels,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['avatar_index'] = Variable<int>(avatarIndex);
    map['stars'] = Variable<int>(stars);
    map['gems'] = Variable<int>(gems);
    map['points'] = Variable<int>(points);
    if (!nullToAbsent || equippedSkinId != null) {
      map['equipped_skin_id'] = Variable<String>(equippedSkinId);
    }
    if (!nullToAbsent || equippedBackgroundId != null) {
      map['equipped_background_id'] = Variable<String>(equippedBackgroundId);
    }
    map['school_grade'] = Variable<int>(schoolGrade);
    map['current_level'] = Variable<int>(currentLevel);
    map['total_completed_levels'] = Variable<int>(totalCompletedLevels);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ProfilesCompanion toCompanion(bool nullToAbsent) {
    return ProfilesCompanion(
      id: Value(id),
      name: Value(name),
      avatarIndex: Value(avatarIndex),
      stars: Value(stars),
      gems: Value(gems),
      points: Value(points),
      equippedSkinId: equippedSkinId == null && nullToAbsent
          ? const Value.absent()
          : Value(equippedSkinId),
      equippedBackgroundId: equippedBackgroundId == null && nullToAbsent
          ? const Value.absent()
          : Value(equippedBackgroundId),
      schoolGrade: Value(schoolGrade),
      currentLevel: Value(currentLevel),
      totalCompletedLevels: Value(totalCompletedLevels),
      createdAt: Value(createdAt),
    );
  }

  factory Profile.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Profile(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      avatarIndex: serializer.fromJson<int>(json['avatarIndex']),
      stars: serializer.fromJson<int>(json['stars']),
      gems: serializer.fromJson<int>(json['gems']),
      points: serializer.fromJson<int>(json['points']),
      equippedSkinId: serializer.fromJson<String?>(json['equippedSkinId']),
      equippedBackgroundId:
          serializer.fromJson<String?>(json['equippedBackgroundId']),
      schoolGrade: serializer.fromJson<int>(json['schoolGrade']),
      currentLevel: serializer.fromJson<int>(json['currentLevel']),
      totalCompletedLevels:
          serializer.fromJson<int>(json['totalCompletedLevels']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'avatarIndex': serializer.toJson<int>(avatarIndex),
      'stars': serializer.toJson<int>(stars),
      'gems': serializer.toJson<int>(gems),
      'points': serializer.toJson<int>(points),
      'equippedSkinId': serializer.toJson<String?>(equippedSkinId),
      'equippedBackgroundId': serializer.toJson<String?>(equippedBackgroundId),
      'schoolGrade': serializer.toJson<int>(schoolGrade),
      'currentLevel': serializer.toJson<int>(currentLevel),
      'totalCompletedLevels': serializer.toJson<int>(totalCompletedLevels),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Profile copyWith(
          {String? id,
          String? name,
          int? avatarIndex,
          int? stars,
          int? gems,
          int? points,
          Value<String?> equippedSkinId = const Value.absent(),
          Value<String?> equippedBackgroundId = const Value.absent(),
          int? schoolGrade,
          int? currentLevel,
          int? totalCompletedLevels,
          DateTime? createdAt}) =>
      Profile(
        id: id ?? this.id,
        name: name ?? this.name,
        avatarIndex: avatarIndex ?? this.avatarIndex,
        stars: stars ?? this.stars,
        gems: gems ?? this.gems,
        points: points ?? this.points,
        equippedSkinId:
            equippedSkinId.present ? equippedSkinId.value : this.equippedSkinId,
        equippedBackgroundId: equippedBackgroundId.present
            ? equippedBackgroundId.value
            : this.equippedBackgroundId,
        schoolGrade: schoolGrade ?? this.schoolGrade,
        currentLevel: currentLevel ?? this.currentLevel,
        totalCompletedLevels: totalCompletedLevels ?? this.totalCompletedLevels,
        createdAt: createdAt ?? this.createdAt,
      );
  Profile copyWithCompanion(ProfilesCompanion data) {
    return Profile(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      avatarIndex:
          data.avatarIndex.present ? data.avatarIndex.value : this.avatarIndex,
      stars: data.stars.present ? data.stars.value : this.stars,
      gems: data.gems.present ? data.gems.value : this.gems,
      points: data.points.present ? data.points.value : this.points,
      equippedSkinId: data.equippedSkinId.present
          ? data.equippedSkinId.value
          : this.equippedSkinId,
      equippedBackgroundId: data.equippedBackgroundId.present
          ? data.equippedBackgroundId.value
          : this.equippedBackgroundId,
      schoolGrade:
          data.schoolGrade.present ? data.schoolGrade.value : this.schoolGrade,
      currentLevel: data.currentLevel.present
          ? data.currentLevel.value
          : this.currentLevel,
      totalCompletedLevels: data.totalCompletedLevels.present
          ? data.totalCompletedLevels.value
          : this.totalCompletedLevels,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Profile(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('avatarIndex: $avatarIndex, ')
          ..write('stars: $stars, ')
          ..write('gems: $gems, ')
          ..write('points: $points, ')
          ..write('equippedSkinId: $equippedSkinId, ')
          ..write('equippedBackgroundId: $equippedBackgroundId, ')
          ..write('schoolGrade: $schoolGrade, ')
          ..write('currentLevel: $currentLevel, ')
          ..write('totalCompletedLevels: $totalCompletedLevels, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      avatarIndex,
      stars,
      gems,
      points,
      equippedSkinId,
      equippedBackgroundId,
      schoolGrade,
      currentLevel,
      totalCompletedLevels,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Profile &&
          other.id == this.id &&
          other.name == this.name &&
          other.avatarIndex == this.avatarIndex &&
          other.stars == this.stars &&
          other.gems == this.gems &&
          other.points == this.points &&
          other.equippedSkinId == this.equippedSkinId &&
          other.equippedBackgroundId == this.equippedBackgroundId &&
          other.schoolGrade == this.schoolGrade &&
          other.currentLevel == this.currentLevel &&
          other.totalCompletedLevels == this.totalCompletedLevels &&
          other.createdAt == this.createdAt);
}

class ProfilesCompanion extends UpdateCompanion<Profile> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> avatarIndex;
  final Value<int> stars;
  final Value<int> gems;
  final Value<int> points;
  final Value<String?> equippedSkinId;
  final Value<String?> equippedBackgroundId;
  final Value<int> schoolGrade;
  final Value<int> currentLevel;
  final Value<int> totalCompletedLevels;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ProfilesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.avatarIndex = const Value.absent(),
    this.stars = const Value.absent(),
    this.gems = const Value.absent(),
    this.points = const Value.absent(),
    this.equippedSkinId = const Value.absent(),
    this.equippedBackgroundId = const Value.absent(),
    this.schoolGrade = const Value.absent(),
    this.currentLevel = const Value.absent(),
    this.totalCompletedLevels = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProfilesCompanion.insert({
    required String id,
    required String name,
    this.avatarIndex = const Value.absent(),
    this.stars = const Value.absent(),
    this.gems = const Value.absent(),
    this.points = const Value.absent(),
    this.equippedSkinId = const Value.absent(),
    this.equippedBackgroundId = const Value.absent(),
    this.schoolGrade = const Value.absent(),
    this.currentLevel = const Value.absent(),
    this.totalCompletedLevels = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        createdAt = Value(createdAt);
  static Insertable<Profile> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? avatarIndex,
    Expression<int>? stars,
    Expression<int>? gems,
    Expression<int>? points,
    Expression<String>? equippedSkinId,
    Expression<String>? equippedBackgroundId,
    Expression<int>? schoolGrade,
    Expression<int>? currentLevel,
    Expression<int>? totalCompletedLevels,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (avatarIndex != null) 'avatar_index': avatarIndex,
      if (stars != null) 'stars': stars,
      if (gems != null) 'gems': gems,
      if (points != null) 'points': points,
      if (equippedSkinId != null) 'equipped_skin_id': equippedSkinId,
      if (equippedBackgroundId != null)
        'equipped_background_id': equippedBackgroundId,
      if (schoolGrade != null) 'school_grade': schoolGrade,
      if (currentLevel != null) 'current_level': currentLevel,
      if (totalCompletedLevels != null)
        'total_completed_levels': totalCompletedLevels,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProfilesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<int>? avatarIndex,
      Value<int>? stars,
      Value<int>? gems,
      Value<int>? points,
      Value<String?>? equippedSkinId,
      Value<String?>? equippedBackgroundId,
      Value<int>? schoolGrade,
      Value<int>? currentLevel,
      Value<int>? totalCompletedLevels,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return ProfilesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarIndex: avatarIndex ?? this.avatarIndex,
      stars: stars ?? this.stars,
      gems: gems ?? this.gems,
      points: points ?? this.points,
      equippedSkinId: equippedSkinId ?? this.equippedSkinId,
      equippedBackgroundId: equippedBackgroundId ?? this.equippedBackgroundId,
      schoolGrade: schoolGrade ?? this.schoolGrade,
      currentLevel: currentLevel ?? this.currentLevel,
      totalCompletedLevels: totalCompletedLevels ?? this.totalCompletedLevels,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (avatarIndex.present) {
      map['avatar_index'] = Variable<int>(avatarIndex.value);
    }
    if (stars.present) {
      map['stars'] = Variable<int>(stars.value);
    }
    if (gems.present) {
      map['gems'] = Variable<int>(gems.value);
    }
    if (points.present) {
      map['points'] = Variable<int>(points.value);
    }
    if (equippedSkinId.present) {
      map['equipped_skin_id'] = Variable<String>(equippedSkinId.value);
    }
    if (equippedBackgroundId.present) {
      map['equipped_background_id'] =
          Variable<String>(equippedBackgroundId.value);
    }
    if (schoolGrade.present) {
      map['school_grade'] = Variable<int>(schoolGrade.value);
    }
    if (currentLevel.present) {
      map['current_level'] = Variable<int>(currentLevel.value);
    }
    if (totalCompletedLevels.present) {
      map['total_completed_levels'] = Variable<int>(totalCompletedLevels.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfilesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('avatarIndex: $avatarIndex, ')
          ..write('stars: $stars, ')
          ..write('gems: $gems, ')
          ..write('points: $points, ')
          ..write('equippedSkinId: $equippedSkinId, ')
          ..write('equippedBackgroundId: $equippedBackgroundId, ')
          ..write('schoolGrade: $schoolGrade, ')
          ..write('currentLevel: $currentLevel, ')
          ..write('totalCompletedLevels: $totalCompletedLevels, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _profileIdMeta =
      const VerificationMeta('profileId');
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
      'profile_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES profiles (id) ON DELETE SET NULL'));
  static const VerificationMeta _fullNameMeta =
      const VerificationMeta('fullName');
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
      'full_name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 80),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _passwordHashMeta =
      const VerificationMeta('passwordHash');
  @override
  late final GeneratedColumn<String> passwordHash = GeneratedColumn<String>(
      'password_hash', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _avatarIndexMeta =
      const VerificationMeta('avatarIndex');
  @override
  late final GeneratedColumn<int> avatarIndex = GeneratedColumn<int>(
      'avatar_index', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _accountTypeMeta =
      const VerificationMeta('accountType');
  @override
  late final GeneratedColumn<String> accountType = GeneratedColumn<String>(
      'account_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('standard'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        profileId,
        fullName,
        username,
        passwordHash,
        role,
        avatarIndex,
        isActive,
        accountType,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(Insertable<User> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(_profileIdMeta,
          profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta));
    }
    if (data.containsKey('full_name')) {
      context.handle(_fullNameMeta,
          fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta));
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    }
    if (data.containsKey('password_hash')) {
      context.handle(
          _passwordHashMeta,
          passwordHash.isAcceptableOrUnknown(
              data['password_hash']!, _passwordHashMeta));
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('avatar_index')) {
      context.handle(
          _avatarIndexMeta,
          avatarIndex.isAcceptableOrUnknown(
              data['avatar_index']!, _avatarIndexMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('account_type')) {
      context.handle(
          _accountTypeMeta,
          accountType.isAcceptableOrUnknown(
              data['account_type']!, _accountTypeMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {profileId},
      ];
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      profileId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile_id']),
      fullName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}full_name'])!,
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username']),
      passwordHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}password_hash']),
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!,
      avatarIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}avatar_index'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      accountType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_type'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final String id;
  final String? profileId;
  final String fullName;
  final String? username;
  final String? passwordHash;
  final String role;
  final int avatarIndex;
  final bool isActive;

  /// `standard` for real accounts, `development` for the shared testing
  /// students created by [DevAccountSeeder]. Additive field (schema v5).
  final String accountType;
  final DateTime createdAt;
  final DateTime updatedAt;
  const User(
      {required this.id,
      this.profileId,
      required this.fullName,
      this.username,
      this.passwordHash,
      required this.role,
      required this.avatarIndex,
      required this.isActive,
      required this.accountType,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || profileId != null) {
      map['profile_id'] = Variable<String>(profileId);
    }
    map['full_name'] = Variable<String>(fullName);
    if (!nullToAbsent || username != null) {
      map['username'] = Variable<String>(username);
    }
    if (!nullToAbsent || passwordHash != null) {
      map['password_hash'] = Variable<String>(passwordHash);
    }
    map['role'] = Variable<String>(role);
    map['avatar_index'] = Variable<int>(avatarIndex);
    map['is_active'] = Variable<bool>(isActive);
    map['account_type'] = Variable<String>(accountType);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      profileId: profileId == null && nullToAbsent
          ? const Value.absent()
          : Value(profileId),
      fullName: Value(fullName),
      username: username == null && nullToAbsent
          ? const Value.absent()
          : Value(username),
      passwordHash: passwordHash == null && nullToAbsent
          ? const Value.absent()
          : Value(passwordHash),
      role: Value(role),
      avatarIndex: Value(avatarIndex),
      isActive: Value(isActive),
      accountType: Value(accountType),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<String>(json['id']),
      profileId: serializer.fromJson<String?>(json['profileId']),
      fullName: serializer.fromJson<String>(json['fullName']),
      username: serializer.fromJson<String?>(json['username']),
      passwordHash: serializer.fromJson<String?>(json['passwordHash']),
      role: serializer.fromJson<String>(json['role']),
      avatarIndex: serializer.fromJson<int>(json['avatarIndex']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      accountType: serializer.fromJson<String>(json['accountType']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'profileId': serializer.toJson<String?>(profileId),
      'fullName': serializer.toJson<String>(fullName),
      'username': serializer.toJson<String?>(username),
      'passwordHash': serializer.toJson<String?>(passwordHash),
      'role': serializer.toJson<String>(role),
      'avatarIndex': serializer.toJson<int>(avatarIndex),
      'isActive': serializer.toJson<bool>(isActive),
      'accountType': serializer.toJson<String>(accountType),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  User copyWith(
          {String? id,
          Value<String?> profileId = const Value.absent(),
          String? fullName,
          Value<String?> username = const Value.absent(),
          Value<String?> passwordHash = const Value.absent(),
          String? role,
          int? avatarIndex,
          bool? isActive,
          String? accountType,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      User(
        id: id ?? this.id,
        profileId: profileId.present ? profileId.value : this.profileId,
        fullName: fullName ?? this.fullName,
        username: username.present ? username.value : this.username,
        passwordHash:
            passwordHash.present ? passwordHash.value : this.passwordHash,
        role: role ?? this.role,
        avatarIndex: avatarIndex ?? this.avatarIndex,
        isActive: isActive ?? this.isActive,
        accountType: accountType ?? this.accountType,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      username: data.username.present ? data.username.value : this.username,
      passwordHash: data.passwordHash.present
          ? data.passwordHash.value
          : this.passwordHash,
      role: data.role.present ? data.role.value : this.role,
      avatarIndex:
          data.avatarIndex.present ? data.avatarIndex.value : this.avatarIndex,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      accountType:
          data.accountType.present ? data.accountType.value : this.accountType,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('fullName: $fullName, ')
          ..write('username: $username, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('role: $role, ')
          ..write('avatarIndex: $avatarIndex, ')
          ..write('isActive: $isActive, ')
          ..write('accountType: $accountType, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      profileId,
      fullName,
      username,
      passwordHash,
      role,
      avatarIndex,
      isActive,
      accountType,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.fullName == this.fullName &&
          other.username == this.username &&
          other.passwordHash == this.passwordHash &&
          other.role == this.role &&
          other.avatarIndex == this.avatarIndex &&
          other.isActive == this.isActive &&
          other.accountType == this.accountType &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<String> id;
  final Value<String?> profileId;
  final Value<String> fullName;
  final Value<String?> username;
  final Value<String?> passwordHash;
  final Value<String> role;
  final Value<int> avatarIndex;
  final Value<bool> isActive;
  final Value<String> accountType;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.fullName = const Value.absent(),
    this.username = const Value.absent(),
    this.passwordHash = const Value.absent(),
    this.role = const Value.absent(),
    this.avatarIndex = const Value.absent(),
    this.isActive = const Value.absent(),
    this.accountType = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required String id,
    this.profileId = const Value.absent(),
    required String fullName,
    this.username = const Value.absent(),
    this.passwordHash = const Value.absent(),
    required String role,
    this.avatarIndex = const Value.absent(),
    this.isActive = const Value.absent(),
    this.accountType = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        fullName = Value(fullName),
        role = Value(role),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<User> custom({
    Expression<String>? id,
    Expression<String>? profileId,
    Expression<String>? fullName,
    Expression<String>? username,
    Expression<String>? passwordHash,
    Expression<String>? role,
    Expression<int>? avatarIndex,
    Expression<bool>? isActive,
    Expression<String>? accountType,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (fullName != null) 'full_name': fullName,
      if (username != null) 'username': username,
      if (passwordHash != null) 'password_hash': passwordHash,
      if (role != null) 'role': role,
      if (avatarIndex != null) 'avatar_index': avatarIndex,
      if (isActive != null) 'is_active': isActive,
      if (accountType != null) 'account_type': accountType,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith(
      {Value<String>? id,
      Value<String?>? profileId,
      Value<String>? fullName,
      Value<String?>? username,
      Value<String?>? passwordHash,
      Value<String>? role,
      Value<int>? avatarIndex,
      Value<bool>? isActive,
      Value<String>? accountType,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return UsersCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      passwordHash: passwordHash ?? this.passwordHash,
      role: role ?? this.role,
      avatarIndex: avatarIndex ?? this.avatarIndex,
      isActive: isActive ?? this.isActive,
      accountType: accountType ?? this.accountType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (passwordHash.present) {
      map['password_hash'] = Variable<String>(passwordHash.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (avatarIndex.present) {
      map['avatar_index'] = Variable<int>(avatarIndex.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (accountType.present) {
      map['account_type'] = Variable<String>(accountType.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('fullName: $fullName, ')
          ..write('username: $username, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('role: $role, ')
          ..write('avatarIndex: $avatarIndex, ')
          ..write('isActive: $isActive, ')
          ..write('accountType: $accountType, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LearningLevelsTable extends LearningLevels
    with TableInfo<$LearningLevelsTable, LearningLevel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LearningLevelsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _levelNumberMeta =
      const VerificationMeta('levelNumber');
  @override
  late final GeneratedColumn<int> levelNumber = GeneratedColumn<int>(
      'level_number', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _difficultyMeta =
      const VerificationMeta('difficulty');
  @override
  late final GeneratedColumn<String> difficulty = GeneratedColumn<String>(
      'difficulty', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _topicsMeta = const VerificationMeta('topics');
  @override
  late final GeneratedColumn<String> topics = GeneratedColumn<String>(
      'topics', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _objectivesMeta =
      const VerificationMeta('objectives');
  @override
  late final GeneratedColumn<String> objectives = GeneratedColumn<String>(
      'objectives', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _questionCountMeta =
      const VerificationMeta('questionCount');
  @override
  late final GeneratedColumn<int> questionCount = GeneratedColumn<int>(
      'question_count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _passingScoreMeta =
      const VerificationMeta('passingScore');
  @override
  late final GeneratedColumn<int> passingScore = GeneratedColumn<int>(
      'passing_score', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _timeLimitSecondsMeta =
      const VerificationMeta('timeLimitSeconds');
  @override
  late final GeneratedColumn<int> timeLimitSeconds = GeneratedColumn<int>(
      'time_limit_seconds', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        levelNumber,
        title,
        difficulty,
        topics,
        objectives,
        questionCount,
        passingScore,
        timeLimitSeconds,
        isActive
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'learning_levels';
  @override
  VerificationContext validateIntegrity(Insertable<LearningLevel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('level_number')) {
      context.handle(
          _levelNumberMeta,
          levelNumber.isAcceptableOrUnknown(
              data['level_number']!, _levelNumberMeta));
    } else if (isInserting) {
      context.missing(_levelNumberMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('difficulty')) {
      context.handle(
          _difficultyMeta,
          difficulty.isAcceptableOrUnknown(
              data['difficulty']!, _difficultyMeta));
    } else if (isInserting) {
      context.missing(_difficultyMeta);
    }
    if (data.containsKey('topics')) {
      context.handle(_topicsMeta,
          topics.isAcceptableOrUnknown(data['topics']!, _topicsMeta));
    } else if (isInserting) {
      context.missing(_topicsMeta);
    }
    if (data.containsKey('objectives')) {
      context.handle(
          _objectivesMeta,
          objectives.isAcceptableOrUnknown(
              data['objectives']!, _objectivesMeta));
    } else if (isInserting) {
      context.missing(_objectivesMeta);
    }
    if (data.containsKey('question_count')) {
      context.handle(
          _questionCountMeta,
          questionCount.isAcceptableOrUnknown(
              data['question_count']!, _questionCountMeta));
    } else if (isInserting) {
      context.missing(_questionCountMeta);
    }
    if (data.containsKey('passing_score')) {
      context.handle(
          _passingScoreMeta,
          passingScore.isAcceptableOrUnknown(
              data['passing_score']!, _passingScoreMeta));
    } else if (isInserting) {
      context.missing(_passingScoreMeta);
    }
    if (data.containsKey('time_limit_seconds')) {
      context.handle(
          _timeLimitSecondsMeta,
          timeLimitSeconds.isAcceptableOrUnknown(
              data['time_limit_seconds']!, _timeLimitSecondsMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LearningLevel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LearningLevel(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      levelNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}level_number'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      difficulty: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}difficulty'])!,
      topics: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}topics'])!,
      objectives: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}objectives'])!,
      questionCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}question_count'])!,
      passingScore: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}passing_score'])!,
      timeLimitSeconds: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}time_limit_seconds']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $LearningLevelsTable createAlias(String alias) {
    return $LearningLevelsTable(attachedDatabase, alias);
  }
}

class LearningLevel extends DataClass implements Insertable<LearningLevel> {
  final int id;
  final int levelNumber;
  final String title;
  final String difficulty;
  final String topics;
  final String objectives;
  final int questionCount;
  final int passingScore;
  final int? timeLimitSeconds;
  final bool isActive;
  const LearningLevel(
      {required this.id,
      required this.levelNumber,
      required this.title,
      required this.difficulty,
      required this.topics,
      required this.objectives,
      required this.questionCount,
      required this.passingScore,
      this.timeLimitSeconds,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['level_number'] = Variable<int>(levelNumber);
    map['title'] = Variable<String>(title);
    map['difficulty'] = Variable<String>(difficulty);
    map['topics'] = Variable<String>(topics);
    map['objectives'] = Variable<String>(objectives);
    map['question_count'] = Variable<int>(questionCount);
    map['passing_score'] = Variable<int>(passingScore);
    if (!nullToAbsent || timeLimitSeconds != null) {
      map['time_limit_seconds'] = Variable<int>(timeLimitSeconds);
    }
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  LearningLevelsCompanion toCompanion(bool nullToAbsent) {
    return LearningLevelsCompanion(
      id: Value(id),
      levelNumber: Value(levelNumber),
      title: Value(title),
      difficulty: Value(difficulty),
      topics: Value(topics),
      objectives: Value(objectives),
      questionCount: Value(questionCount),
      passingScore: Value(passingScore),
      timeLimitSeconds: timeLimitSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(timeLimitSeconds),
      isActive: Value(isActive),
    );
  }

  factory LearningLevel.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LearningLevel(
      id: serializer.fromJson<int>(json['id']),
      levelNumber: serializer.fromJson<int>(json['levelNumber']),
      title: serializer.fromJson<String>(json['title']),
      difficulty: serializer.fromJson<String>(json['difficulty']),
      topics: serializer.fromJson<String>(json['topics']),
      objectives: serializer.fromJson<String>(json['objectives']),
      questionCount: serializer.fromJson<int>(json['questionCount']),
      passingScore: serializer.fromJson<int>(json['passingScore']),
      timeLimitSeconds: serializer.fromJson<int?>(json['timeLimitSeconds']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'levelNumber': serializer.toJson<int>(levelNumber),
      'title': serializer.toJson<String>(title),
      'difficulty': serializer.toJson<String>(difficulty),
      'topics': serializer.toJson<String>(topics),
      'objectives': serializer.toJson<String>(objectives),
      'questionCount': serializer.toJson<int>(questionCount),
      'passingScore': serializer.toJson<int>(passingScore),
      'timeLimitSeconds': serializer.toJson<int?>(timeLimitSeconds),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  LearningLevel copyWith(
          {int? id,
          int? levelNumber,
          String? title,
          String? difficulty,
          String? topics,
          String? objectives,
          int? questionCount,
          int? passingScore,
          Value<int?> timeLimitSeconds = const Value.absent(),
          bool? isActive}) =>
      LearningLevel(
        id: id ?? this.id,
        levelNumber: levelNumber ?? this.levelNumber,
        title: title ?? this.title,
        difficulty: difficulty ?? this.difficulty,
        topics: topics ?? this.topics,
        objectives: objectives ?? this.objectives,
        questionCount: questionCount ?? this.questionCount,
        passingScore: passingScore ?? this.passingScore,
        timeLimitSeconds: timeLimitSeconds.present
            ? timeLimitSeconds.value
            : this.timeLimitSeconds,
        isActive: isActive ?? this.isActive,
      );
  LearningLevel copyWithCompanion(LearningLevelsCompanion data) {
    return LearningLevel(
      id: data.id.present ? data.id.value : this.id,
      levelNumber:
          data.levelNumber.present ? data.levelNumber.value : this.levelNumber,
      title: data.title.present ? data.title.value : this.title,
      difficulty:
          data.difficulty.present ? data.difficulty.value : this.difficulty,
      topics: data.topics.present ? data.topics.value : this.topics,
      objectives:
          data.objectives.present ? data.objectives.value : this.objectives,
      questionCount: data.questionCount.present
          ? data.questionCount.value
          : this.questionCount,
      passingScore: data.passingScore.present
          ? data.passingScore.value
          : this.passingScore,
      timeLimitSeconds: data.timeLimitSeconds.present
          ? data.timeLimitSeconds.value
          : this.timeLimitSeconds,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LearningLevel(')
          ..write('id: $id, ')
          ..write('levelNumber: $levelNumber, ')
          ..write('title: $title, ')
          ..write('difficulty: $difficulty, ')
          ..write('topics: $topics, ')
          ..write('objectives: $objectives, ')
          ..write('questionCount: $questionCount, ')
          ..write('passingScore: $passingScore, ')
          ..write('timeLimitSeconds: $timeLimitSeconds, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, levelNumber, title, difficulty, topics,
      objectives, questionCount, passingScore, timeLimitSeconds, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LearningLevel &&
          other.id == this.id &&
          other.levelNumber == this.levelNumber &&
          other.title == this.title &&
          other.difficulty == this.difficulty &&
          other.topics == this.topics &&
          other.objectives == this.objectives &&
          other.questionCount == this.questionCount &&
          other.passingScore == this.passingScore &&
          other.timeLimitSeconds == this.timeLimitSeconds &&
          other.isActive == this.isActive);
}

class LearningLevelsCompanion extends UpdateCompanion<LearningLevel> {
  final Value<int> id;
  final Value<int> levelNumber;
  final Value<String> title;
  final Value<String> difficulty;
  final Value<String> topics;
  final Value<String> objectives;
  final Value<int> questionCount;
  final Value<int> passingScore;
  final Value<int?> timeLimitSeconds;
  final Value<bool> isActive;
  const LearningLevelsCompanion({
    this.id = const Value.absent(),
    this.levelNumber = const Value.absent(),
    this.title = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.topics = const Value.absent(),
    this.objectives = const Value.absent(),
    this.questionCount = const Value.absent(),
    this.passingScore = const Value.absent(),
    this.timeLimitSeconds = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  LearningLevelsCompanion.insert({
    this.id = const Value.absent(),
    required int levelNumber,
    required String title,
    required String difficulty,
    required String topics,
    required String objectives,
    required int questionCount,
    required int passingScore,
    this.timeLimitSeconds = const Value.absent(),
    this.isActive = const Value.absent(),
  })  : levelNumber = Value(levelNumber),
        title = Value(title),
        difficulty = Value(difficulty),
        topics = Value(topics),
        objectives = Value(objectives),
        questionCount = Value(questionCount),
        passingScore = Value(passingScore);
  static Insertable<LearningLevel> custom({
    Expression<int>? id,
    Expression<int>? levelNumber,
    Expression<String>? title,
    Expression<String>? difficulty,
    Expression<String>? topics,
    Expression<String>? objectives,
    Expression<int>? questionCount,
    Expression<int>? passingScore,
    Expression<int>? timeLimitSeconds,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (levelNumber != null) 'level_number': levelNumber,
      if (title != null) 'title': title,
      if (difficulty != null) 'difficulty': difficulty,
      if (topics != null) 'topics': topics,
      if (objectives != null) 'objectives': objectives,
      if (questionCount != null) 'question_count': questionCount,
      if (passingScore != null) 'passing_score': passingScore,
      if (timeLimitSeconds != null) 'time_limit_seconds': timeLimitSeconds,
      if (isActive != null) 'is_active': isActive,
    });
  }

  LearningLevelsCompanion copyWith(
      {Value<int>? id,
      Value<int>? levelNumber,
      Value<String>? title,
      Value<String>? difficulty,
      Value<String>? topics,
      Value<String>? objectives,
      Value<int>? questionCount,
      Value<int>? passingScore,
      Value<int?>? timeLimitSeconds,
      Value<bool>? isActive}) {
    return LearningLevelsCompanion(
      id: id ?? this.id,
      levelNumber: levelNumber ?? this.levelNumber,
      title: title ?? this.title,
      difficulty: difficulty ?? this.difficulty,
      topics: topics ?? this.topics,
      objectives: objectives ?? this.objectives,
      questionCount: questionCount ?? this.questionCount,
      passingScore: passingScore ?? this.passingScore,
      timeLimitSeconds: timeLimitSeconds ?? this.timeLimitSeconds,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (levelNumber.present) {
      map['level_number'] = Variable<int>(levelNumber.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<String>(difficulty.value);
    }
    if (topics.present) {
      map['topics'] = Variable<String>(topics.value);
    }
    if (objectives.present) {
      map['objectives'] = Variable<String>(objectives.value);
    }
    if (questionCount.present) {
      map['question_count'] = Variable<int>(questionCount.value);
    }
    if (passingScore.present) {
      map['passing_score'] = Variable<int>(passingScore.value);
    }
    if (timeLimitSeconds.present) {
      map['time_limit_seconds'] = Variable<int>(timeLimitSeconds.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LearningLevelsCompanion(')
          ..write('id: $id, ')
          ..write('levelNumber: $levelNumber, ')
          ..write('title: $title, ')
          ..write('difficulty: $difficulty, ')
          ..write('topics: $topics, ')
          ..write('objectives: $objectives, ')
          ..write('questionCount: $questionCount, ')
          ..write('passingScore: $passingScore, ')
          ..write('timeLimitSeconds: $timeLimitSeconds, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $StudentLevelProgressTable extends StudentLevelProgress
    with TableInfo<$StudentLevelProgressTable, StudentLevelProgressData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudentLevelProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _profileIdMeta =
      const VerificationMeta('profileId');
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
      'profile_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES profiles (id) ON DELETE CASCADE'));
  static const VerificationMeta _levelIdMeta =
      const VerificationMeta('levelId');
  @override
  late final GeneratedColumn<int> levelId = GeneratedColumn<int>(
      'level_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES learning_levels (id) ON DELETE CASCADE'));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('available'));
  static const VerificationMeta _bestScoreMeta =
      const VerificationMeta('bestScore');
  @override
  late final GeneratedColumn<int> bestScore = GeneratedColumn<int>(
      'best_score', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _attemptsCountMeta =
      const VerificationMeta('attemptsCount');
  @override
  late final GeneratedColumn<int> attemptsCount = GeneratedColumn<int>(
      'attempts_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        profileId,
        levelId,
        status,
        bestScore,
        attemptsCount,
        completedAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'student_level_progress';
  @override
  VerificationContext validateIntegrity(
      Insertable<StudentLevelProgressData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('profile_id')) {
      context.handle(_profileIdMeta,
          profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta));
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('level_id')) {
      context.handle(_levelIdMeta,
          levelId.isAcceptableOrUnknown(data['level_id']!, _levelIdMeta));
    } else if (isInserting) {
      context.missing(_levelIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('best_score')) {
      context.handle(_bestScoreMeta,
          bestScore.isAcceptableOrUnknown(data['best_score']!, _bestScoreMeta));
    }
    if (data.containsKey('attempts_count')) {
      context.handle(
          _attemptsCountMeta,
          attemptsCount.isAcceptableOrUnknown(
              data['attempts_count']!, _attemptsCountMeta));
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {profileId, levelId},
      ];
  @override
  StudentLevelProgressData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudentLevelProgressData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      profileId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile_id'])!,
      levelId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}level_id'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      bestScore: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}best_score'])!,
      attemptsCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}attempts_count'])!,
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $StudentLevelProgressTable createAlias(String alias) {
    return $StudentLevelProgressTable(attachedDatabase, alias);
  }
}

class StudentLevelProgressData extends DataClass
    implements Insertable<StudentLevelProgressData> {
  final int id;
  final String profileId;
  final int levelId;
  final String status;
  final int bestScore;
  final int attemptsCount;
  final DateTime? completedAt;
  final DateTime updatedAt;
  const StudentLevelProgressData(
      {required this.id,
      required this.profileId,
      required this.levelId,
      required this.status,
      required this.bestScore,
      required this.attemptsCount,
      this.completedAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['profile_id'] = Variable<String>(profileId);
    map['level_id'] = Variable<int>(levelId);
    map['status'] = Variable<String>(status);
    map['best_score'] = Variable<int>(bestScore);
    map['attempts_count'] = Variable<int>(attemptsCount);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  StudentLevelProgressCompanion toCompanion(bool nullToAbsent) {
    return StudentLevelProgressCompanion(
      id: Value(id),
      profileId: Value(profileId),
      levelId: Value(levelId),
      status: Value(status),
      bestScore: Value(bestScore),
      attemptsCount: Value(attemptsCount),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory StudentLevelProgressData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudentLevelProgressData(
      id: serializer.fromJson<int>(json['id']),
      profileId: serializer.fromJson<String>(json['profileId']),
      levelId: serializer.fromJson<int>(json['levelId']),
      status: serializer.fromJson<String>(json['status']),
      bestScore: serializer.fromJson<int>(json['bestScore']),
      attemptsCount: serializer.fromJson<int>(json['attemptsCount']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'profileId': serializer.toJson<String>(profileId),
      'levelId': serializer.toJson<int>(levelId),
      'status': serializer.toJson<String>(status),
      'bestScore': serializer.toJson<int>(bestScore),
      'attemptsCount': serializer.toJson<int>(attemptsCount),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  StudentLevelProgressData copyWith(
          {int? id,
          String? profileId,
          int? levelId,
          String? status,
          int? bestScore,
          int? attemptsCount,
          Value<DateTime?> completedAt = const Value.absent(),
          DateTime? updatedAt}) =>
      StudentLevelProgressData(
        id: id ?? this.id,
        profileId: profileId ?? this.profileId,
        levelId: levelId ?? this.levelId,
        status: status ?? this.status,
        bestScore: bestScore ?? this.bestScore,
        attemptsCount: attemptsCount ?? this.attemptsCount,
        completedAt: completedAt.present ? completedAt.value : this.completedAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  StudentLevelProgressData copyWithCompanion(
      StudentLevelProgressCompanion data) {
    return StudentLevelProgressData(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      levelId: data.levelId.present ? data.levelId.value : this.levelId,
      status: data.status.present ? data.status.value : this.status,
      bestScore: data.bestScore.present ? data.bestScore.value : this.bestScore,
      attemptsCount: data.attemptsCount.present
          ? data.attemptsCount.value
          : this.attemptsCount,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudentLevelProgressData(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('levelId: $levelId, ')
          ..write('status: $status, ')
          ..write('bestScore: $bestScore, ')
          ..write('attemptsCount: $attemptsCount, ')
          ..write('completedAt: $completedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, profileId, levelId, status, bestScore,
      attemptsCount, completedAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudentLevelProgressData &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.levelId == this.levelId &&
          other.status == this.status &&
          other.bestScore == this.bestScore &&
          other.attemptsCount == this.attemptsCount &&
          other.completedAt == this.completedAt &&
          other.updatedAt == this.updatedAt);
}

class StudentLevelProgressCompanion
    extends UpdateCompanion<StudentLevelProgressData> {
  final Value<int> id;
  final Value<String> profileId;
  final Value<int> levelId;
  final Value<String> status;
  final Value<int> bestScore;
  final Value<int> attemptsCount;
  final Value<DateTime?> completedAt;
  final Value<DateTime> updatedAt;
  const StudentLevelProgressCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.levelId = const Value.absent(),
    this.status = const Value.absent(),
    this.bestScore = const Value.absent(),
    this.attemptsCount = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  StudentLevelProgressCompanion.insert({
    this.id = const Value.absent(),
    required String profileId,
    required int levelId,
    this.status = const Value.absent(),
    this.bestScore = const Value.absent(),
    this.attemptsCount = const Value.absent(),
    this.completedAt = const Value.absent(),
    required DateTime updatedAt,
  })  : profileId = Value(profileId),
        levelId = Value(levelId),
        updatedAt = Value(updatedAt);
  static Insertable<StudentLevelProgressData> custom({
    Expression<int>? id,
    Expression<String>? profileId,
    Expression<int>? levelId,
    Expression<String>? status,
    Expression<int>? bestScore,
    Expression<int>? attemptsCount,
    Expression<DateTime>? completedAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (levelId != null) 'level_id': levelId,
      if (status != null) 'status': status,
      if (bestScore != null) 'best_score': bestScore,
      if (attemptsCount != null) 'attempts_count': attemptsCount,
      if (completedAt != null) 'completed_at': completedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  StudentLevelProgressCompanion copyWith(
      {Value<int>? id,
      Value<String>? profileId,
      Value<int>? levelId,
      Value<String>? status,
      Value<int>? bestScore,
      Value<int>? attemptsCount,
      Value<DateTime?>? completedAt,
      Value<DateTime>? updatedAt}) {
    return StudentLevelProgressCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      levelId: levelId ?? this.levelId,
      status: status ?? this.status,
      bestScore: bestScore ?? this.bestScore,
      attemptsCount: attemptsCount ?? this.attemptsCount,
      completedAt: completedAt ?? this.completedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (levelId.present) {
      map['level_id'] = Variable<int>(levelId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (bestScore.present) {
      map['best_score'] = Variable<int>(bestScore.value);
    }
    if (attemptsCount.present) {
      map['attempts_count'] = Variable<int>(attemptsCount.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudentLevelProgressCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('levelId: $levelId, ')
          ..write('status: $status, ')
          ..write('bestScore: $bestScore, ')
          ..write('attemptsCount: $attemptsCount, ')
          ..write('completedAt: $completedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ExamRecordsTable extends ExamRecords
    with TableInfo<$ExamRecordsTable, ExamRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExamRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _sessionIdMeta =
      const VerificationMeta('sessionId');
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
      'session_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _profileIdMeta =
      const VerificationMeta('profileId');
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
      'profile_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES profiles (id) ON DELETE CASCADE'));
  static const VerificationMeta _levelIdMeta =
      const VerificationMeta('levelId');
  @override
  late final GeneratedColumn<int> levelId = GeneratedColumn<int>(
      'level_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES learning_levels (id) ON DELETE SET NULL'));
  static const VerificationMeta _sectionMeta =
      const VerificationMeta('section');
  @override
  late final GeneratedColumn<String> section = GeneratedColumn<String>(
      'section', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _difficultyMeta =
      const VerificationMeta('difficulty');
  @override
  late final GeneratedColumn<String> difficulty = GeneratedColumn<String>(
      'difficulty', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _answerModeMeta =
      const VerificationMeta('answerMode');
  @override
  late final GeneratedColumn<String> answerMode = GeneratedColumn<String>(
      'answer_mode', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
      'source', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<int> total = GeneratedColumn<int>(
      'total', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _correctMeta =
      const VerificationMeta('correct');
  @override
  late final GeneratedColumn<int> correct = GeneratedColumn<int>(
      'correct', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _wrongMeta = const VerificationMeta('wrong');
  @override
  late final GeneratedColumn<int> wrong = GeneratedColumn<int>(
      'wrong', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _unansweredMeta =
      const VerificationMeta('unanswered');
  @override
  late final GeneratedColumn<int> unanswered = GeneratedColumn<int>(
      'unanswered', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _starsEarnedMeta =
      const VerificationMeta('starsEarned');
  @override
  late final GeneratedColumn<int> starsEarned = GeneratedColumn<int>(
      'stars_earned', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _gemsEarnedMeta =
      const VerificationMeta('gemsEarned');
  @override
  late final GeneratedColumn<int> gemsEarned = GeneratedColumn<int>(
      'gems_earned', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _pointsEarnedMeta =
      const VerificationMeta('pointsEarned');
  @override
  late final GeneratedColumn<int> pointsEarned = GeneratedColumn<int>(
      'points_earned', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _durationSecondsMeta =
      const VerificationMeta('durationSeconds');
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
      'duration_seconds', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _startedAtMeta =
      const VerificationMeta('startedAt');
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
      'started_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('completed'));
  static const VerificationMeta _dailyDateKeyMeta =
      const VerificationMeta('dailyDateKey');
  @override
  late final GeneratedColumn<String> dailyDateKey = GeneratedColumn<String>(
      'daily_date_key', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        sessionId,
        profileId,
        levelId,
        section,
        title,
        difficulty,
        answerMode,
        source,
        total,
        correct,
        wrong,
        unanswered,
        starsEarned,
        gemsEarned,
        pointsEarned,
        durationSeconds,
        startedAt,
        createdAt,
        status,
        dailyDateKey
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exam_records';
  @override
  VerificationContext validateIntegrity(Insertable<ExamRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(_sessionIdMeta,
          sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta));
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(_profileIdMeta,
          profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta));
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('level_id')) {
      context.handle(_levelIdMeta,
          levelId.isAcceptableOrUnknown(data['level_id']!, _levelIdMeta));
    }
    if (data.containsKey('section')) {
      context.handle(_sectionMeta,
          section.isAcceptableOrUnknown(data['section']!, _sectionMeta));
    } else if (isInserting) {
      context.missing(_sectionMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('difficulty')) {
      context.handle(
          _difficultyMeta,
          difficulty.isAcceptableOrUnknown(
              data['difficulty']!, _difficultyMeta));
    } else if (isInserting) {
      context.missing(_difficultyMeta);
    }
    if (data.containsKey('answer_mode')) {
      context.handle(
          _answerModeMeta,
          answerMode.isAcceptableOrUnknown(
              data['answer_mode']!, _answerModeMeta));
    } else if (isInserting) {
      context.missing(_answerModeMeta);
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('total')) {
      context.handle(
          _totalMeta, total.isAcceptableOrUnknown(data['total']!, _totalMeta));
    } else if (isInserting) {
      context.missing(_totalMeta);
    }
    if (data.containsKey('correct')) {
      context.handle(_correctMeta,
          correct.isAcceptableOrUnknown(data['correct']!, _correctMeta));
    } else if (isInserting) {
      context.missing(_correctMeta);
    }
    if (data.containsKey('wrong')) {
      context.handle(
          _wrongMeta, wrong.isAcceptableOrUnknown(data['wrong']!, _wrongMeta));
    } else if (isInserting) {
      context.missing(_wrongMeta);
    }
    if (data.containsKey('unanswered')) {
      context.handle(
          _unansweredMeta,
          unanswered.isAcceptableOrUnknown(
              data['unanswered']!, _unansweredMeta));
    } else if (isInserting) {
      context.missing(_unansweredMeta);
    }
    if (data.containsKey('stars_earned')) {
      context.handle(
          _starsEarnedMeta,
          starsEarned.isAcceptableOrUnknown(
              data['stars_earned']!, _starsEarnedMeta));
    } else if (isInserting) {
      context.missing(_starsEarnedMeta);
    }
    if (data.containsKey('gems_earned')) {
      context.handle(
          _gemsEarnedMeta,
          gemsEarned.isAcceptableOrUnknown(
              data['gems_earned']!, _gemsEarnedMeta));
    } else if (isInserting) {
      context.missing(_gemsEarnedMeta);
    }
    if (data.containsKey('points_earned')) {
      context.handle(
          _pointsEarnedMeta,
          pointsEarned.isAcceptableOrUnknown(
              data['points_earned']!, _pointsEarnedMeta));
    } else if (isInserting) {
      context.missing(_pointsEarnedMeta);
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
          _durationSecondsMeta,
          durationSeconds.isAcceptableOrUnknown(
              data['duration_seconds']!, _durationSecondsMeta));
    } else if (isInserting) {
      context.missing(_durationSecondsMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(_startedAtMeta,
          startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('daily_date_key')) {
      context.handle(
          _dailyDateKeyMeta,
          dailyDateKey.isAcceptableOrUnknown(
              data['daily_date_key']!, _dailyDateKeyMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExamRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExamRecord(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      sessionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}session_id'])!,
      profileId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile_id'])!,
      levelId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}level_id']),
      section: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}section'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      difficulty: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}difficulty'])!,
      answerMode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}answer_mode'])!,
      source: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source'])!,
      total: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total'])!,
      correct: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}correct'])!,
      wrong: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}wrong'])!,
      unanswered: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}unanswered'])!,
      starsEarned: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}stars_earned'])!,
      gemsEarned: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}gems_earned'])!,
      pointsEarned: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}points_earned'])!,
      durationSeconds: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration_seconds'])!,
      startedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}started_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      dailyDateKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}daily_date_key']),
    );
  }

  @override
  $ExamRecordsTable createAlias(String alias) {
    return $ExamRecordsTable(attachedDatabase, alias);
  }
}

class ExamRecord extends DataClass implements Insertable<ExamRecord> {
  final int id;
  final String sessionId;
  final String profileId;
  final int? levelId;
  final String section;
  final String title;
  final String difficulty;
  final String answerMode;
  final String source;
  final int total;
  final int correct;
  final int wrong;
  final int unanswered;
  final int starsEarned;
  final int gemsEarned;
  final int pointsEarned;
  final int durationSeconds;
  final DateTime? startedAt;
  final DateTime createdAt;
  final String status;
  final String? dailyDateKey;
  const ExamRecord(
      {required this.id,
      required this.sessionId,
      required this.profileId,
      this.levelId,
      required this.section,
      required this.title,
      required this.difficulty,
      required this.answerMode,
      required this.source,
      required this.total,
      required this.correct,
      required this.wrong,
      required this.unanswered,
      required this.starsEarned,
      required this.gemsEarned,
      required this.pointsEarned,
      required this.durationSeconds,
      this.startedAt,
      required this.createdAt,
      required this.status,
      this.dailyDateKey});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<String>(sessionId);
    map['profile_id'] = Variable<String>(profileId);
    if (!nullToAbsent || levelId != null) {
      map['level_id'] = Variable<int>(levelId);
    }
    map['section'] = Variable<String>(section);
    map['title'] = Variable<String>(title);
    map['difficulty'] = Variable<String>(difficulty);
    map['answer_mode'] = Variable<String>(answerMode);
    map['source'] = Variable<String>(source);
    map['total'] = Variable<int>(total);
    map['correct'] = Variable<int>(correct);
    map['wrong'] = Variable<int>(wrong);
    map['unanswered'] = Variable<int>(unanswered);
    map['stars_earned'] = Variable<int>(starsEarned);
    map['gems_earned'] = Variable<int>(gemsEarned);
    map['points_earned'] = Variable<int>(pointsEarned);
    map['duration_seconds'] = Variable<int>(durationSeconds);
    if (!nullToAbsent || startedAt != null) {
      map['started_at'] = Variable<DateTime>(startedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || dailyDateKey != null) {
      map['daily_date_key'] = Variable<String>(dailyDateKey);
    }
    return map;
  }

  ExamRecordsCompanion toCompanion(bool nullToAbsent) {
    return ExamRecordsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      profileId: Value(profileId),
      levelId: levelId == null && nullToAbsent
          ? const Value.absent()
          : Value(levelId),
      section: Value(section),
      title: Value(title),
      difficulty: Value(difficulty),
      answerMode: Value(answerMode),
      source: Value(source),
      total: Value(total),
      correct: Value(correct),
      wrong: Value(wrong),
      unanswered: Value(unanswered),
      starsEarned: Value(starsEarned),
      gemsEarned: Value(gemsEarned),
      pointsEarned: Value(pointsEarned),
      durationSeconds: Value(durationSeconds),
      startedAt: startedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(startedAt),
      createdAt: Value(createdAt),
      status: Value(status),
      dailyDateKey: dailyDateKey == null && nullToAbsent
          ? const Value.absent()
          : Value(dailyDateKey),
    );
  }

  factory ExamRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExamRecord(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      profileId: serializer.fromJson<String>(json['profileId']),
      levelId: serializer.fromJson<int?>(json['levelId']),
      section: serializer.fromJson<String>(json['section']),
      title: serializer.fromJson<String>(json['title']),
      difficulty: serializer.fromJson<String>(json['difficulty']),
      answerMode: serializer.fromJson<String>(json['answerMode']),
      source: serializer.fromJson<String>(json['source']),
      total: serializer.fromJson<int>(json['total']),
      correct: serializer.fromJson<int>(json['correct']),
      wrong: serializer.fromJson<int>(json['wrong']),
      unanswered: serializer.fromJson<int>(json['unanswered']),
      starsEarned: serializer.fromJson<int>(json['starsEarned']),
      gemsEarned: serializer.fromJson<int>(json['gemsEarned']),
      pointsEarned: serializer.fromJson<int>(json['pointsEarned']),
      durationSeconds: serializer.fromJson<int>(json['durationSeconds']),
      startedAt: serializer.fromJson<DateTime?>(json['startedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      status: serializer.fromJson<String>(json['status']),
      dailyDateKey: serializer.fromJson<String?>(json['dailyDateKey']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<String>(sessionId),
      'profileId': serializer.toJson<String>(profileId),
      'levelId': serializer.toJson<int?>(levelId),
      'section': serializer.toJson<String>(section),
      'title': serializer.toJson<String>(title),
      'difficulty': serializer.toJson<String>(difficulty),
      'answerMode': serializer.toJson<String>(answerMode),
      'source': serializer.toJson<String>(source),
      'total': serializer.toJson<int>(total),
      'correct': serializer.toJson<int>(correct),
      'wrong': serializer.toJson<int>(wrong),
      'unanswered': serializer.toJson<int>(unanswered),
      'starsEarned': serializer.toJson<int>(starsEarned),
      'gemsEarned': serializer.toJson<int>(gemsEarned),
      'pointsEarned': serializer.toJson<int>(pointsEarned),
      'durationSeconds': serializer.toJson<int>(durationSeconds),
      'startedAt': serializer.toJson<DateTime?>(startedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'status': serializer.toJson<String>(status),
      'dailyDateKey': serializer.toJson<String?>(dailyDateKey),
    };
  }

  ExamRecord copyWith(
          {int? id,
          String? sessionId,
          String? profileId,
          Value<int?> levelId = const Value.absent(),
          String? section,
          String? title,
          String? difficulty,
          String? answerMode,
          String? source,
          int? total,
          int? correct,
          int? wrong,
          int? unanswered,
          int? starsEarned,
          int? gemsEarned,
          int? pointsEarned,
          int? durationSeconds,
          Value<DateTime?> startedAt = const Value.absent(),
          DateTime? createdAt,
          String? status,
          Value<String?> dailyDateKey = const Value.absent()}) =>
      ExamRecord(
        id: id ?? this.id,
        sessionId: sessionId ?? this.sessionId,
        profileId: profileId ?? this.profileId,
        levelId: levelId.present ? levelId.value : this.levelId,
        section: section ?? this.section,
        title: title ?? this.title,
        difficulty: difficulty ?? this.difficulty,
        answerMode: answerMode ?? this.answerMode,
        source: source ?? this.source,
        total: total ?? this.total,
        correct: correct ?? this.correct,
        wrong: wrong ?? this.wrong,
        unanswered: unanswered ?? this.unanswered,
        starsEarned: starsEarned ?? this.starsEarned,
        gemsEarned: gemsEarned ?? this.gemsEarned,
        pointsEarned: pointsEarned ?? this.pointsEarned,
        durationSeconds: durationSeconds ?? this.durationSeconds,
        startedAt: startedAt.present ? startedAt.value : this.startedAt,
        createdAt: createdAt ?? this.createdAt,
        status: status ?? this.status,
        dailyDateKey:
            dailyDateKey.present ? dailyDateKey.value : this.dailyDateKey,
      );
  ExamRecord copyWithCompanion(ExamRecordsCompanion data) {
    return ExamRecord(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      levelId: data.levelId.present ? data.levelId.value : this.levelId,
      section: data.section.present ? data.section.value : this.section,
      title: data.title.present ? data.title.value : this.title,
      difficulty:
          data.difficulty.present ? data.difficulty.value : this.difficulty,
      answerMode:
          data.answerMode.present ? data.answerMode.value : this.answerMode,
      source: data.source.present ? data.source.value : this.source,
      total: data.total.present ? data.total.value : this.total,
      correct: data.correct.present ? data.correct.value : this.correct,
      wrong: data.wrong.present ? data.wrong.value : this.wrong,
      unanswered:
          data.unanswered.present ? data.unanswered.value : this.unanswered,
      starsEarned:
          data.starsEarned.present ? data.starsEarned.value : this.starsEarned,
      gemsEarned:
          data.gemsEarned.present ? data.gemsEarned.value : this.gemsEarned,
      pointsEarned: data.pointsEarned.present
          ? data.pointsEarned.value
          : this.pointsEarned,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      status: data.status.present ? data.status.value : this.status,
      dailyDateKey: data.dailyDateKey.present
          ? data.dailyDateKey.value
          : this.dailyDateKey,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExamRecord(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('profileId: $profileId, ')
          ..write('levelId: $levelId, ')
          ..write('section: $section, ')
          ..write('title: $title, ')
          ..write('difficulty: $difficulty, ')
          ..write('answerMode: $answerMode, ')
          ..write('source: $source, ')
          ..write('total: $total, ')
          ..write('correct: $correct, ')
          ..write('wrong: $wrong, ')
          ..write('unanswered: $unanswered, ')
          ..write('starsEarned: $starsEarned, ')
          ..write('gemsEarned: $gemsEarned, ')
          ..write('pointsEarned: $pointsEarned, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('startedAt: $startedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('status: $status, ')
          ..write('dailyDateKey: $dailyDateKey')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        sessionId,
        profileId,
        levelId,
        section,
        title,
        difficulty,
        answerMode,
        source,
        total,
        correct,
        wrong,
        unanswered,
        starsEarned,
        gemsEarned,
        pointsEarned,
        durationSeconds,
        startedAt,
        createdAt,
        status,
        dailyDateKey
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExamRecord &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.profileId == this.profileId &&
          other.levelId == this.levelId &&
          other.section == this.section &&
          other.title == this.title &&
          other.difficulty == this.difficulty &&
          other.answerMode == this.answerMode &&
          other.source == this.source &&
          other.total == this.total &&
          other.correct == this.correct &&
          other.wrong == this.wrong &&
          other.unanswered == this.unanswered &&
          other.starsEarned == this.starsEarned &&
          other.gemsEarned == this.gemsEarned &&
          other.pointsEarned == this.pointsEarned &&
          other.durationSeconds == this.durationSeconds &&
          other.startedAt == this.startedAt &&
          other.createdAt == this.createdAt &&
          other.status == this.status &&
          other.dailyDateKey == this.dailyDateKey);
}

class ExamRecordsCompanion extends UpdateCompanion<ExamRecord> {
  final Value<int> id;
  final Value<String> sessionId;
  final Value<String> profileId;
  final Value<int?> levelId;
  final Value<String> section;
  final Value<String> title;
  final Value<String> difficulty;
  final Value<String> answerMode;
  final Value<String> source;
  final Value<int> total;
  final Value<int> correct;
  final Value<int> wrong;
  final Value<int> unanswered;
  final Value<int> starsEarned;
  final Value<int> gemsEarned;
  final Value<int> pointsEarned;
  final Value<int> durationSeconds;
  final Value<DateTime?> startedAt;
  final Value<DateTime> createdAt;
  final Value<String> status;
  final Value<String?> dailyDateKey;
  const ExamRecordsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.profileId = const Value.absent(),
    this.levelId = const Value.absent(),
    this.section = const Value.absent(),
    this.title = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.answerMode = const Value.absent(),
    this.source = const Value.absent(),
    this.total = const Value.absent(),
    this.correct = const Value.absent(),
    this.wrong = const Value.absent(),
    this.unanswered = const Value.absent(),
    this.starsEarned = const Value.absent(),
    this.gemsEarned = const Value.absent(),
    this.pointsEarned = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.status = const Value.absent(),
    this.dailyDateKey = const Value.absent(),
  });
  ExamRecordsCompanion.insert({
    this.id = const Value.absent(),
    required String sessionId,
    required String profileId,
    this.levelId = const Value.absent(),
    required String section,
    required String title,
    required String difficulty,
    required String answerMode,
    required String source,
    required int total,
    required int correct,
    required int wrong,
    required int unanswered,
    required int starsEarned,
    required int gemsEarned,
    required int pointsEarned,
    required int durationSeconds,
    this.startedAt = const Value.absent(),
    required DateTime createdAt,
    this.status = const Value.absent(),
    this.dailyDateKey = const Value.absent(),
  })  : sessionId = Value(sessionId),
        profileId = Value(profileId),
        section = Value(section),
        title = Value(title),
        difficulty = Value(difficulty),
        answerMode = Value(answerMode),
        source = Value(source),
        total = Value(total),
        correct = Value(correct),
        wrong = Value(wrong),
        unanswered = Value(unanswered),
        starsEarned = Value(starsEarned),
        gemsEarned = Value(gemsEarned),
        pointsEarned = Value(pointsEarned),
        durationSeconds = Value(durationSeconds),
        createdAt = Value(createdAt);
  static Insertable<ExamRecord> custom({
    Expression<int>? id,
    Expression<String>? sessionId,
    Expression<String>? profileId,
    Expression<int>? levelId,
    Expression<String>? section,
    Expression<String>? title,
    Expression<String>? difficulty,
    Expression<String>? answerMode,
    Expression<String>? source,
    Expression<int>? total,
    Expression<int>? correct,
    Expression<int>? wrong,
    Expression<int>? unanswered,
    Expression<int>? starsEarned,
    Expression<int>? gemsEarned,
    Expression<int>? pointsEarned,
    Expression<int>? durationSeconds,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? createdAt,
    Expression<String>? status,
    Expression<String>? dailyDateKey,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (profileId != null) 'profile_id': profileId,
      if (levelId != null) 'level_id': levelId,
      if (section != null) 'section': section,
      if (title != null) 'title': title,
      if (difficulty != null) 'difficulty': difficulty,
      if (answerMode != null) 'answer_mode': answerMode,
      if (source != null) 'source': source,
      if (total != null) 'total': total,
      if (correct != null) 'correct': correct,
      if (wrong != null) 'wrong': wrong,
      if (unanswered != null) 'unanswered': unanswered,
      if (starsEarned != null) 'stars_earned': starsEarned,
      if (gemsEarned != null) 'gems_earned': gemsEarned,
      if (pointsEarned != null) 'points_earned': pointsEarned,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (startedAt != null) 'started_at': startedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (status != null) 'status': status,
      if (dailyDateKey != null) 'daily_date_key': dailyDateKey,
    });
  }

  ExamRecordsCompanion copyWith(
      {Value<int>? id,
      Value<String>? sessionId,
      Value<String>? profileId,
      Value<int?>? levelId,
      Value<String>? section,
      Value<String>? title,
      Value<String>? difficulty,
      Value<String>? answerMode,
      Value<String>? source,
      Value<int>? total,
      Value<int>? correct,
      Value<int>? wrong,
      Value<int>? unanswered,
      Value<int>? starsEarned,
      Value<int>? gemsEarned,
      Value<int>? pointsEarned,
      Value<int>? durationSeconds,
      Value<DateTime?>? startedAt,
      Value<DateTime>? createdAt,
      Value<String>? status,
      Value<String?>? dailyDateKey}) {
    return ExamRecordsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      profileId: profileId ?? this.profileId,
      levelId: levelId ?? this.levelId,
      section: section ?? this.section,
      title: title ?? this.title,
      difficulty: difficulty ?? this.difficulty,
      answerMode: answerMode ?? this.answerMode,
      source: source ?? this.source,
      total: total ?? this.total,
      correct: correct ?? this.correct,
      wrong: wrong ?? this.wrong,
      unanswered: unanswered ?? this.unanswered,
      starsEarned: starsEarned ?? this.starsEarned,
      gemsEarned: gemsEarned ?? this.gemsEarned,
      pointsEarned: pointsEarned ?? this.pointsEarned,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      startedAt: startedAt ?? this.startedAt,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      dailyDateKey: dailyDateKey ?? this.dailyDateKey,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (levelId.present) {
      map['level_id'] = Variable<int>(levelId.value);
    }
    if (section.present) {
      map['section'] = Variable<String>(section.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<String>(difficulty.value);
    }
    if (answerMode.present) {
      map['answer_mode'] = Variable<String>(answerMode.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (total.present) {
      map['total'] = Variable<int>(total.value);
    }
    if (correct.present) {
      map['correct'] = Variable<int>(correct.value);
    }
    if (wrong.present) {
      map['wrong'] = Variable<int>(wrong.value);
    }
    if (unanswered.present) {
      map['unanswered'] = Variable<int>(unanswered.value);
    }
    if (starsEarned.present) {
      map['stars_earned'] = Variable<int>(starsEarned.value);
    }
    if (gemsEarned.present) {
      map['gems_earned'] = Variable<int>(gemsEarned.value);
    }
    if (pointsEarned.present) {
      map['points_earned'] = Variable<int>(pointsEarned.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (dailyDateKey.present) {
      map['daily_date_key'] = Variable<String>(dailyDateKey.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExamRecordsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('profileId: $profileId, ')
          ..write('levelId: $levelId, ')
          ..write('section: $section, ')
          ..write('title: $title, ')
          ..write('difficulty: $difficulty, ')
          ..write('answerMode: $answerMode, ')
          ..write('source: $source, ')
          ..write('total: $total, ')
          ..write('correct: $correct, ')
          ..write('wrong: $wrong, ')
          ..write('unanswered: $unanswered, ')
          ..write('starsEarned: $starsEarned, ')
          ..write('gemsEarned: $gemsEarned, ')
          ..write('pointsEarned: $pointsEarned, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('startedAt: $startedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('status: $status, ')
          ..write('dailyDateKey: $dailyDateKey')
          ..write(')'))
        .toString();
  }
}

class $AnswerRecordsTable extends AnswerRecords
    with TableInfo<$AnswerRecordsTable, AnswerRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AnswerRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _examIdMeta = const VerificationMeta('examId');
  @override
  late final GeneratedColumn<int> examId = GeneratedColumn<int>(
      'exam_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES exam_records (id) ON DELETE CASCADE'));
  static const VerificationMeta _profileIdMeta =
      const VerificationMeta('profileId');
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
      'profile_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES profiles (id) ON DELETE CASCADE'));
  static const VerificationMeta _sectionMeta =
      const VerificationMeta('section');
  @override
  late final GeneratedColumn<String> section = GeneratedColumn<String>(
      'section', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _questionKindMeta =
      const VerificationMeta('questionKind');
  @override
  late final GeneratedColumn<String> questionKind = GeneratedColumn<String>(
      'question_kind', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _factKeyMeta =
      const VerificationMeta('factKey');
  @override
  late final GeneratedColumn<String> factKey = GeneratedColumn<String>(
      'fact_key', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _questionTextMeta =
      const VerificationMeta('questionText');
  @override
  late final GeneratedColumn<String> questionText = GeneratedColumn<String>(
      'question_text', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _childAnswerMeta =
      const VerificationMeta('childAnswer');
  @override
  late final GeneratedColumn<String> childAnswer = GeneratedColumn<String>(
      'child_answer', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _correctAnswerMeta =
      const VerificationMeta('correctAnswer');
  @override
  late final GeneratedColumn<String> correctAnswer = GeneratedColumn<String>(
      'correct_answer', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isCorrectMeta =
      const VerificationMeta('isCorrect');
  @override
  late final GeneratedColumn<bool> isCorrect = GeneratedColumn<bool>(
      'is_correct', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_correct" IN (0, 1))'));
  static const VerificationMeta _explanationMeta =
      const VerificationMeta('explanation');
  @override
  late final GeneratedColumn<String> explanation = GeneratedColumn<String>(
      'explanation', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _timeSpentSecondsMeta =
      const VerificationMeta('timeSpentSeconds');
  @override
  late final GeneratedColumn<int> timeSpentSeconds = GeneratedColumn<int>(
      'time_spent_seconds', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _topicIdMeta =
      const VerificationMeta('topicId');
  @override
  late final GeneratedColumn<String> topicId = GeneratedColumn<String>(
      'topic_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        examId,
        profileId,
        section,
        questionKind,
        factKey,
        questionText,
        childAnswer,
        correctAnswer,
        isCorrect,
        explanation,
        timeSpentSeconds,
        topicId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'answer_records';
  @override
  VerificationContext validateIntegrity(Insertable<AnswerRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('exam_id')) {
      context.handle(_examIdMeta,
          examId.isAcceptableOrUnknown(data['exam_id']!, _examIdMeta));
    } else if (isInserting) {
      context.missing(_examIdMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(_profileIdMeta,
          profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta));
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('section')) {
      context.handle(_sectionMeta,
          section.isAcceptableOrUnknown(data['section']!, _sectionMeta));
    } else if (isInserting) {
      context.missing(_sectionMeta);
    }
    if (data.containsKey('question_kind')) {
      context.handle(
          _questionKindMeta,
          questionKind.isAcceptableOrUnknown(
              data['question_kind']!, _questionKindMeta));
    } else if (isInserting) {
      context.missing(_questionKindMeta);
    }
    if (data.containsKey('fact_key')) {
      context.handle(_factKeyMeta,
          factKey.isAcceptableOrUnknown(data['fact_key']!, _factKeyMeta));
    }
    if (data.containsKey('question_text')) {
      context.handle(
          _questionTextMeta,
          questionText.isAcceptableOrUnknown(
              data['question_text']!, _questionTextMeta));
    } else if (isInserting) {
      context.missing(_questionTextMeta);
    }
    if (data.containsKey('child_answer')) {
      context.handle(
          _childAnswerMeta,
          childAnswer.isAcceptableOrUnknown(
              data['child_answer']!, _childAnswerMeta));
    }
    if (data.containsKey('correct_answer')) {
      context.handle(
          _correctAnswerMeta,
          correctAnswer.isAcceptableOrUnknown(
              data['correct_answer']!, _correctAnswerMeta));
    } else if (isInserting) {
      context.missing(_correctAnswerMeta);
    }
    if (data.containsKey('is_correct')) {
      context.handle(_isCorrectMeta,
          isCorrect.isAcceptableOrUnknown(data['is_correct']!, _isCorrectMeta));
    } else if (isInserting) {
      context.missing(_isCorrectMeta);
    }
    if (data.containsKey('explanation')) {
      context.handle(
          _explanationMeta,
          explanation.isAcceptableOrUnknown(
              data['explanation']!, _explanationMeta));
    } else if (isInserting) {
      context.missing(_explanationMeta);
    }
    if (data.containsKey('time_spent_seconds')) {
      context.handle(
          _timeSpentSecondsMeta,
          timeSpentSeconds.isAcceptableOrUnknown(
              data['time_spent_seconds']!, _timeSpentSecondsMeta));
    }
    if (data.containsKey('topic_id')) {
      context.handle(_topicIdMeta,
          topicId.isAcceptableOrUnknown(data['topic_id']!, _topicIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AnswerRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AnswerRecord(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      examId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}exam_id'])!,
      profileId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile_id'])!,
      section: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}section'])!,
      questionKind: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}question_kind'])!,
      factKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}fact_key']),
      questionText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}question_text'])!,
      childAnswer: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}child_answer']),
      correctAnswer: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}correct_answer'])!,
      isCorrect: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_correct'])!,
      explanation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}explanation'])!,
      timeSpentSeconds: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}time_spent_seconds'])!,
      topicId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}topic_id']),
    );
  }

  @override
  $AnswerRecordsTable createAlias(String alias) {
    return $AnswerRecordsTable(attachedDatabase, alias);
  }
}

class AnswerRecord extends DataClass implements Insertable<AnswerRecord> {
  final int id;
  final int examId;
  final String profileId;
  final String section;
  final String questionKind;
  final String? factKey;
  final String questionText;
  final String? childAnswer;
  final String correctAnswer;
  final bool isCorrect;
  final String explanation;
  final int timeSpentSeconds;

  /// Curriculum topic id when the question came from a topic exam.
  final String? topicId;
  const AnswerRecord(
      {required this.id,
      required this.examId,
      required this.profileId,
      required this.section,
      required this.questionKind,
      this.factKey,
      required this.questionText,
      this.childAnswer,
      required this.correctAnswer,
      required this.isCorrect,
      required this.explanation,
      required this.timeSpentSeconds,
      this.topicId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['exam_id'] = Variable<int>(examId);
    map['profile_id'] = Variable<String>(profileId);
    map['section'] = Variable<String>(section);
    map['question_kind'] = Variable<String>(questionKind);
    if (!nullToAbsent || factKey != null) {
      map['fact_key'] = Variable<String>(factKey);
    }
    map['question_text'] = Variable<String>(questionText);
    if (!nullToAbsent || childAnswer != null) {
      map['child_answer'] = Variable<String>(childAnswer);
    }
    map['correct_answer'] = Variable<String>(correctAnswer);
    map['is_correct'] = Variable<bool>(isCorrect);
    map['explanation'] = Variable<String>(explanation);
    map['time_spent_seconds'] = Variable<int>(timeSpentSeconds);
    if (!nullToAbsent || topicId != null) {
      map['topic_id'] = Variable<String>(topicId);
    }
    return map;
  }

  AnswerRecordsCompanion toCompanion(bool nullToAbsent) {
    return AnswerRecordsCompanion(
      id: Value(id),
      examId: Value(examId),
      profileId: Value(profileId),
      section: Value(section),
      questionKind: Value(questionKind),
      factKey: factKey == null && nullToAbsent
          ? const Value.absent()
          : Value(factKey),
      questionText: Value(questionText),
      childAnswer: childAnswer == null && nullToAbsent
          ? const Value.absent()
          : Value(childAnswer),
      correctAnswer: Value(correctAnswer),
      isCorrect: Value(isCorrect),
      explanation: Value(explanation),
      timeSpentSeconds: Value(timeSpentSeconds),
      topicId: topicId == null && nullToAbsent
          ? const Value.absent()
          : Value(topicId),
    );
  }

  factory AnswerRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AnswerRecord(
      id: serializer.fromJson<int>(json['id']),
      examId: serializer.fromJson<int>(json['examId']),
      profileId: serializer.fromJson<String>(json['profileId']),
      section: serializer.fromJson<String>(json['section']),
      questionKind: serializer.fromJson<String>(json['questionKind']),
      factKey: serializer.fromJson<String?>(json['factKey']),
      questionText: serializer.fromJson<String>(json['questionText']),
      childAnswer: serializer.fromJson<String?>(json['childAnswer']),
      correctAnswer: serializer.fromJson<String>(json['correctAnswer']),
      isCorrect: serializer.fromJson<bool>(json['isCorrect']),
      explanation: serializer.fromJson<String>(json['explanation']),
      timeSpentSeconds: serializer.fromJson<int>(json['timeSpentSeconds']),
      topicId: serializer.fromJson<String?>(json['topicId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'examId': serializer.toJson<int>(examId),
      'profileId': serializer.toJson<String>(profileId),
      'section': serializer.toJson<String>(section),
      'questionKind': serializer.toJson<String>(questionKind),
      'factKey': serializer.toJson<String?>(factKey),
      'questionText': serializer.toJson<String>(questionText),
      'childAnswer': serializer.toJson<String?>(childAnswer),
      'correctAnswer': serializer.toJson<String>(correctAnswer),
      'isCorrect': serializer.toJson<bool>(isCorrect),
      'explanation': serializer.toJson<String>(explanation),
      'timeSpentSeconds': serializer.toJson<int>(timeSpentSeconds),
      'topicId': serializer.toJson<String?>(topicId),
    };
  }

  AnswerRecord copyWith(
          {int? id,
          int? examId,
          String? profileId,
          String? section,
          String? questionKind,
          Value<String?> factKey = const Value.absent(),
          String? questionText,
          Value<String?> childAnswer = const Value.absent(),
          String? correctAnswer,
          bool? isCorrect,
          String? explanation,
          int? timeSpentSeconds,
          Value<String?> topicId = const Value.absent()}) =>
      AnswerRecord(
        id: id ?? this.id,
        examId: examId ?? this.examId,
        profileId: profileId ?? this.profileId,
        section: section ?? this.section,
        questionKind: questionKind ?? this.questionKind,
        factKey: factKey.present ? factKey.value : this.factKey,
        questionText: questionText ?? this.questionText,
        childAnswer: childAnswer.present ? childAnswer.value : this.childAnswer,
        correctAnswer: correctAnswer ?? this.correctAnswer,
        isCorrect: isCorrect ?? this.isCorrect,
        explanation: explanation ?? this.explanation,
        timeSpentSeconds: timeSpentSeconds ?? this.timeSpentSeconds,
        topicId: topicId.present ? topicId.value : this.topicId,
      );
  AnswerRecord copyWithCompanion(AnswerRecordsCompanion data) {
    return AnswerRecord(
      id: data.id.present ? data.id.value : this.id,
      examId: data.examId.present ? data.examId.value : this.examId,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      section: data.section.present ? data.section.value : this.section,
      questionKind: data.questionKind.present
          ? data.questionKind.value
          : this.questionKind,
      factKey: data.factKey.present ? data.factKey.value : this.factKey,
      questionText: data.questionText.present
          ? data.questionText.value
          : this.questionText,
      childAnswer:
          data.childAnswer.present ? data.childAnswer.value : this.childAnswer,
      correctAnswer: data.correctAnswer.present
          ? data.correctAnswer.value
          : this.correctAnswer,
      isCorrect: data.isCorrect.present ? data.isCorrect.value : this.isCorrect,
      explanation:
          data.explanation.present ? data.explanation.value : this.explanation,
      timeSpentSeconds: data.timeSpentSeconds.present
          ? data.timeSpentSeconds.value
          : this.timeSpentSeconds,
      topicId: data.topicId.present ? data.topicId.value : this.topicId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AnswerRecord(')
          ..write('id: $id, ')
          ..write('examId: $examId, ')
          ..write('profileId: $profileId, ')
          ..write('section: $section, ')
          ..write('questionKind: $questionKind, ')
          ..write('factKey: $factKey, ')
          ..write('questionText: $questionText, ')
          ..write('childAnswer: $childAnswer, ')
          ..write('correctAnswer: $correctAnswer, ')
          ..write('isCorrect: $isCorrect, ')
          ..write('explanation: $explanation, ')
          ..write('timeSpentSeconds: $timeSpentSeconds, ')
          ..write('topicId: $topicId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      examId,
      profileId,
      section,
      questionKind,
      factKey,
      questionText,
      childAnswer,
      correctAnswer,
      isCorrect,
      explanation,
      timeSpentSeconds,
      topicId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AnswerRecord &&
          other.id == this.id &&
          other.examId == this.examId &&
          other.profileId == this.profileId &&
          other.section == this.section &&
          other.questionKind == this.questionKind &&
          other.factKey == this.factKey &&
          other.questionText == this.questionText &&
          other.childAnswer == this.childAnswer &&
          other.correctAnswer == this.correctAnswer &&
          other.isCorrect == this.isCorrect &&
          other.explanation == this.explanation &&
          other.timeSpentSeconds == this.timeSpentSeconds &&
          other.topicId == this.topicId);
}

class AnswerRecordsCompanion extends UpdateCompanion<AnswerRecord> {
  final Value<int> id;
  final Value<int> examId;
  final Value<String> profileId;
  final Value<String> section;
  final Value<String> questionKind;
  final Value<String?> factKey;
  final Value<String> questionText;
  final Value<String?> childAnswer;
  final Value<String> correctAnswer;
  final Value<bool> isCorrect;
  final Value<String> explanation;
  final Value<int> timeSpentSeconds;
  final Value<String?> topicId;
  const AnswerRecordsCompanion({
    this.id = const Value.absent(),
    this.examId = const Value.absent(),
    this.profileId = const Value.absent(),
    this.section = const Value.absent(),
    this.questionKind = const Value.absent(),
    this.factKey = const Value.absent(),
    this.questionText = const Value.absent(),
    this.childAnswer = const Value.absent(),
    this.correctAnswer = const Value.absent(),
    this.isCorrect = const Value.absent(),
    this.explanation = const Value.absent(),
    this.timeSpentSeconds = const Value.absent(),
    this.topicId = const Value.absent(),
  });
  AnswerRecordsCompanion.insert({
    this.id = const Value.absent(),
    required int examId,
    required String profileId,
    required String section,
    required String questionKind,
    this.factKey = const Value.absent(),
    required String questionText,
    this.childAnswer = const Value.absent(),
    required String correctAnswer,
    required bool isCorrect,
    required String explanation,
    this.timeSpentSeconds = const Value.absent(),
    this.topicId = const Value.absent(),
  })  : examId = Value(examId),
        profileId = Value(profileId),
        section = Value(section),
        questionKind = Value(questionKind),
        questionText = Value(questionText),
        correctAnswer = Value(correctAnswer),
        isCorrect = Value(isCorrect),
        explanation = Value(explanation);
  static Insertable<AnswerRecord> custom({
    Expression<int>? id,
    Expression<int>? examId,
    Expression<String>? profileId,
    Expression<String>? section,
    Expression<String>? questionKind,
    Expression<String>? factKey,
    Expression<String>? questionText,
    Expression<String>? childAnswer,
    Expression<String>? correctAnswer,
    Expression<bool>? isCorrect,
    Expression<String>? explanation,
    Expression<int>? timeSpentSeconds,
    Expression<String>? topicId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (examId != null) 'exam_id': examId,
      if (profileId != null) 'profile_id': profileId,
      if (section != null) 'section': section,
      if (questionKind != null) 'question_kind': questionKind,
      if (factKey != null) 'fact_key': factKey,
      if (questionText != null) 'question_text': questionText,
      if (childAnswer != null) 'child_answer': childAnswer,
      if (correctAnswer != null) 'correct_answer': correctAnswer,
      if (isCorrect != null) 'is_correct': isCorrect,
      if (explanation != null) 'explanation': explanation,
      if (timeSpentSeconds != null) 'time_spent_seconds': timeSpentSeconds,
      if (topicId != null) 'topic_id': topicId,
    });
  }

  AnswerRecordsCompanion copyWith(
      {Value<int>? id,
      Value<int>? examId,
      Value<String>? profileId,
      Value<String>? section,
      Value<String>? questionKind,
      Value<String?>? factKey,
      Value<String>? questionText,
      Value<String?>? childAnswer,
      Value<String>? correctAnswer,
      Value<bool>? isCorrect,
      Value<String>? explanation,
      Value<int>? timeSpentSeconds,
      Value<String?>? topicId}) {
    return AnswerRecordsCompanion(
      id: id ?? this.id,
      examId: examId ?? this.examId,
      profileId: profileId ?? this.profileId,
      section: section ?? this.section,
      questionKind: questionKind ?? this.questionKind,
      factKey: factKey ?? this.factKey,
      questionText: questionText ?? this.questionText,
      childAnswer: childAnswer ?? this.childAnswer,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      isCorrect: isCorrect ?? this.isCorrect,
      explanation: explanation ?? this.explanation,
      timeSpentSeconds: timeSpentSeconds ?? this.timeSpentSeconds,
      topicId: topicId ?? this.topicId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (examId.present) {
      map['exam_id'] = Variable<int>(examId.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (section.present) {
      map['section'] = Variable<String>(section.value);
    }
    if (questionKind.present) {
      map['question_kind'] = Variable<String>(questionKind.value);
    }
    if (factKey.present) {
      map['fact_key'] = Variable<String>(factKey.value);
    }
    if (questionText.present) {
      map['question_text'] = Variable<String>(questionText.value);
    }
    if (childAnswer.present) {
      map['child_answer'] = Variable<String>(childAnswer.value);
    }
    if (correctAnswer.present) {
      map['correct_answer'] = Variable<String>(correctAnswer.value);
    }
    if (isCorrect.present) {
      map['is_correct'] = Variable<bool>(isCorrect.value);
    }
    if (explanation.present) {
      map['explanation'] = Variable<String>(explanation.value);
    }
    if (timeSpentSeconds.present) {
      map['time_spent_seconds'] = Variable<int>(timeSpentSeconds.value);
    }
    if (topicId.present) {
      map['topic_id'] = Variable<String>(topicId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AnswerRecordsCompanion(')
          ..write('id: $id, ')
          ..write('examId: $examId, ')
          ..write('profileId: $profileId, ')
          ..write('section: $section, ')
          ..write('questionKind: $questionKind, ')
          ..write('factKey: $factKey, ')
          ..write('questionText: $questionText, ')
          ..write('childAnswer: $childAnswer, ')
          ..write('correctAnswer: $correctAnswer, ')
          ..write('isCorrect: $isCorrect, ')
          ..write('explanation: $explanation, ')
          ..write('timeSpentSeconds: $timeSpentSeconds, ')
          ..write('topicId: $topicId')
          ..write(')'))
        .toString();
  }
}

class $CurriculumTopicsTable extends CurriculumTopics
    with TableInfo<$CurriculumTopicsTable, CurriculumTopic> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CurriculumTopicsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _gradeMeta = const VerificationMeta('grade');
  @override
  late final GeneratedColumn<int> grade = GeneratedColumn<int>(
      'grade', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _partMeta = const VerificationMeta('part');
  @override
  late final GeneratedColumn<int> part = GeneratedColumn<int>(
      'part', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _unitNameMeta =
      const VerificationMeta('unitName');
  @override
  late final GeneratedColumn<String> unitName = GeneratedColumn<String>(
      'unit_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _pageReferenceMeta =
      const VerificationMeta('pageReference');
  @override
  late final GeneratedColumn<int> pageReference = GeneratedColumn<int>(
      'page_reference', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _generationReadyMeta =
      const VerificationMeta('generationReady');
  @override
  late final GeneratedColumn<bool> generationReady = GeneratedColumn<bool>(
      'generation_ready', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("generation_ready" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, grade, part, title, unitName, pageReference, generationReady];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'curriculum_topics';
  @override
  VerificationContext validateIntegrity(Insertable<CurriculumTopic> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('grade')) {
      context.handle(
          _gradeMeta, grade.isAcceptableOrUnknown(data['grade']!, _gradeMeta));
    } else if (isInserting) {
      context.missing(_gradeMeta);
    }
    if (data.containsKey('part')) {
      context.handle(
          _partMeta, part.isAcceptableOrUnknown(data['part']!, _partMeta));
    } else if (isInserting) {
      context.missing(_partMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('unit_name')) {
      context.handle(_unitNameMeta,
          unitName.isAcceptableOrUnknown(data['unit_name']!, _unitNameMeta));
    } else if (isInserting) {
      context.missing(_unitNameMeta);
    }
    if (data.containsKey('page_reference')) {
      context.handle(
          _pageReferenceMeta,
          pageReference.isAcceptableOrUnknown(
              data['page_reference']!, _pageReferenceMeta));
    }
    if (data.containsKey('generation_ready')) {
      context.handle(
          _generationReadyMeta,
          generationReady.isAcceptableOrUnknown(
              data['generation_ready']!, _generationReadyMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CurriculumTopic map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CurriculumTopic(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      grade: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}grade'])!,
      part: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}part'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      unitName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit_name'])!,
      pageReference: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}page_reference']),
      generationReady: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}generation_ready'])!,
    );
  }

  @override
  $CurriculumTopicsTable createAlias(String alias) {
    return $CurriculumTopicsTable(attachedDatabase, alias);
  }
}

class CurriculumTopic extends DataClass implements Insertable<CurriculumTopic> {
  /// Topic id, e.g. `g4_p2_t2` (see lib/core/curriculum/topic_seed.dart).
  final String id;
  final int grade;
  final int part;
  final String title;
  final String unitName;
  final int? pageReference;
  final bool generationReady;
  const CurriculumTopic(
      {required this.id,
      required this.grade,
      required this.part,
      required this.title,
      required this.unitName,
      this.pageReference,
      required this.generationReady});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['grade'] = Variable<int>(grade);
    map['part'] = Variable<int>(part);
    map['title'] = Variable<String>(title);
    map['unit_name'] = Variable<String>(unitName);
    if (!nullToAbsent || pageReference != null) {
      map['page_reference'] = Variable<int>(pageReference);
    }
    map['generation_ready'] = Variable<bool>(generationReady);
    return map;
  }

  CurriculumTopicsCompanion toCompanion(bool nullToAbsent) {
    return CurriculumTopicsCompanion(
      id: Value(id),
      grade: Value(grade),
      part: Value(part),
      title: Value(title),
      unitName: Value(unitName),
      pageReference: pageReference == null && nullToAbsent
          ? const Value.absent()
          : Value(pageReference),
      generationReady: Value(generationReady),
    );
  }

  factory CurriculumTopic.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CurriculumTopic(
      id: serializer.fromJson<String>(json['id']),
      grade: serializer.fromJson<int>(json['grade']),
      part: serializer.fromJson<int>(json['part']),
      title: serializer.fromJson<String>(json['title']),
      unitName: serializer.fromJson<String>(json['unitName']),
      pageReference: serializer.fromJson<int?>(json['pageReference']),
      generationReady: serializer.fromJson<bool>(json['generationReady']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'grade': serializer.toJson<int>(grade),
      'part': serializer.toJson<int>(part),
      'title': serializer.toJson<String>(title),
      'unitName': serializer.toJson<String>(unitName),
      'pageReference': serializer.toJson<int?>(pageReference),
      'generationReady': serializer.toJson<bool>(generationReady),
    };
  }

  CurriculumTopic copyWith(
          {String? id,
          int? grade,
          int? part,
          String? title,
          String? unitName,
          Value<int?> pageReference = const Value.absent(),
          bool? generationReady}) =>
      CurriculumTopic(
        id: id ?? this.id,
        grade: grade ?? this.grade,
        part: part ?? this.part,
        title: title ?? this.title,
        unitName: unitName ?? this.unitName,
        pageReference:
            pageReference.present ? pageReference.value : this.pageReference,
        generationReady: generationReady ?? this.generationReady,
      );
  CurriculumTopic copyWithCompanion(CurriculumTopicsCompanion data) {
    return CurriculumTopic(
      id: data.id.present ? data.id.value : this.id,
      grade: data.grade.present ? data.grade.value : this.grade,
      part: data.part.present ? data.part.value : this.part,
      title: data.title.present ? data.title.value : this.title,
      unitName: data.unitName.present ? data.unitName.value : this.unitName,
      pageReference: data.pageReference.present
          ? data.pageReference.value
          : this.pageReference,
      generationReady: data.generationReady.present
          ? data.generationReady.value
          : this.generationReady,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CurriculumTopic(')
          ..write('id: $id, ')
          ..write('grade: $grade, ')
          ..write('part: $part, ')
          ..write('title: $title, ')
          ..write('unitName: $unitName, ')
          ..write('pageReference: $pageReference, ')
          ..write('generationReady: $generationReady')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, grade, part, title, unitName, pageReference, generationReady);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CurriculumTopic &&
          other.id == this.id &&
          other.grade == this.grade &&
          other.part == this.part &&
          other.title == this.title &&
          other.unitName == this.unitName &&
          other.pageReference == this.pageReference &&
          other.generationReady == this.generationReady);
}

class CurriculumTopicsCompanion extends UpdateCompanion<CurriculumTopic> {
  final Value<String> id;
  final Value<int> grade;
  final Value<int> part;
  final Value<String> title;
  final Value<String> unitName;
  final Value<int?> pageReference;
  final Value<bool> generationReady;
  final Value<int> rowid;
  const CurriculumTopicsCompanion({
    this.id = const Value.absent(),
    this.grade = const Value.absent(),
    this.part = const Value.absent(),
    this.title = const Value.absent(),
    this.unitName = const Value.absent(),
    this.pageReference = const Value.absent(),
    this.generationReady = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CurriculumTopicsCompanion.insert({
    required String id,
    required int grade,
    required int part,
    required String title,
    required String unitName,
    this.pageReference = const Value.absent(),
    this.generationReady = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        grade = Value(grade),
        part = Value(part),
        title = Value(title),
        unitName = Value(unitName);
  static Insertable<CurriculumTopic> custom({
    Expression<String>? id,
    Expression<int>? grade,
    Expression<int>? part,
    Expression<String>? title,
    Expression<String>? unitName,
    Expression<int>? pageReference,
    Expression<bool>? generationReady,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (grade != null) 'grade': grade,
      if (part != null) 'part': part,
      if (title != null) 'title': title,
      if (unitName != null) 'unit_name': unitName,
      if (pageReference != null) 'page_reference': pageReference,
      if (generationReady != null) 'generation_ready': generationReady,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CurriculumTopicsCompanion copyWith(
      {Value<String>? id,
      Value<int>? grade,
      Value<int>? part,
      Value<String>? title,
      Value<String>? unitName,
      Value<int?>? pageReference,
      Value<bool>? generationReady,
      Value<int>? rowid}) {
    return CurriculumTopicsCompanion(
      id: id ?? this.id,
      grade: grade ?? this.grade,
      part: part ?? this.part,
      title: title ?? this.title,
      unitName: unitName ?? this.unitName,
      pageReference: pageReference ?? this.pageReference,
      generationReady: generationReady ?? this.generationReady,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (grade.present) {
      map['grade'] = Variable<int>(grade.value);
    }
    if (part.present) {
      map['part'] = Variable<int>(part.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (unitName.present) {
      map['unit_name'] = Variable<String>(unitName.value);
    }
    if (pageReference.present) {
      map['page_reference'] = Variable<int>(pageReference.value);
    }
    if (generationReady.present) {
      map['generation_ready'] = Variable<bool>(generationReady.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CurriculumTopicsCompanion(')
          ..write('id: $id, ')
          ..write('grade: $grade, ')
          ..write('part: $part, ')
          ..write('title: $title, ')
          ..write('unitName: $unitName, ')
          ..write('pageReference: $pageReference, ')
          ..write('generationReady: $generationReady, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExamTopicSelectionsTable extends ExamTopicSelections
    with TableInfo<$ExamTopicSelectionsTable, ExamTopicSelection> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExamTopicSelectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _profileIdMeta =
      const VerificationMeta('profileId');
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
      'profile_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES profiles (id) ON DELETE CASCADE'));
  static const VerificationMeta _gradeMeta = const VerificationMeta('grade');
  @override
  late final GeneratedColumn<int> grade = GeneratedColumn<int>(
      'grade', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _partMeta = const VerificationMeta('part');
  @override
  late final GeneratedColumn<int> part = GeneratedColumn<int>(
      'part', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _topicIdsMeta =
      const VerificationMeta('topicIds');
  @override
  late final GeneratedColumn<String> topicIds = GeneratedColumn<String>(
      'topic_ids', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [profileId, grade, part, topicIds, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exam_topic_selections';
  @override
  VerificationContext validateIntegrity(Insertable<ExamTopicSelection> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('profile_id')) {
      context.handle(_profileIdMeta,
          profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta));
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('grade')) {
      context.handle(
          _gradeMeta, grade.isAcceptableOrUnknown(data['grade']!, _gradeMeta));
    } else if (isInserting) {
      context.missing(_gradeMeta);
    }
    if (data.containsKey('part')) {
      context.handle(
          _partMeta, part.isAcceptableOrUnknown(data['part']!, _partMeta));
    } else if (isInserting) {
      context.missing(_partMeta);
    }
    if (data.containsKey('topic_ids')) {
      context.handle(_topicIdsMeta,
          topicIds.isAcceptableOrUnknown(data['topic_ids']!, _topicIdsMeta));
    } else if (isInserting) {
      context.missing(_topicIdsMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {profileId, grade, part};
  @override
  ExamTopicSelection map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExamTopicSelection(
      profileId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile_id'])!,
      grade: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}grade'])!,
      part: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}part'])!,
      topicIds: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}topic_ids'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ExamTopicSelectionsTable createAlias(String alias) {
    return $ExamTopicSelectionsTable(attachedDatabase, alias);
  }
}

class ExamTopicSelection extends DataClass
    implements Insertable<ExamTopicSelection> {
  final String profileId;
  final int grade;
  final int part;

  /// JSON-encoded list of selected topic ids.
  final String topicIds;
  final DateTime updatedAt;
  const ExamTopicSelection(
      {required this.profileId,
      required this.grade,
      required this.part,
      required this.topicIds,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['profile_id'] = Variable<String>(profileId);
    map['grade'] = Variable<int>(grade);
    map['part'] = Variable<int>(part);
    map['topic_ids'] = Variable<String>(topicIds);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ExamTopicSelectionsCompanion toCompanion(bool nullToAbsent) {
    return ExamTopicSelectionsCompanion(
      profileId: Value(profileId),
      grade: Value(grade),
      part: Value(part),
      topicIds: Value(topicIds),
      updatedAt: Value(updatedAt),
    );
  }

  factory ExamTopicSelection.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExamTopicSelection(
      profileId: serializer.fromJson<String>(json['profileId']),
      grade: serializer.fromJson<int>(json['grade']),
      part: serializer.fromJson<int>(json['part']),
      topicIds: serializer.fromJson<String>(json['topicIds']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'profileId': serializer.toJson<String>(profileId),
      'grade': serializer.toJson<int>(grade),
      'part': serializer.toJson<int>(part),
      'topicIds': serializer.toJson<String>(topicIds),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ExamTopicSelection copyWith(
          {String? profileId,
          int? grade,
          int? part,
          String? topicIds,
          DateTime? updatedAt}) =>
      ExamTopicSelection(
        profileId: profileId ?? this.profileId,
        grade: grade ?? this.grade,
        part: part ?? this.part,
        topicIds: topicIds ?? this.topicIds,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  ExamTopicSelection copyWithCompanion(ExamTopicSelectionsCompanion data) {
    return ExamTopicSelection(
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      grade: data.grade.present ? data.grade.value : this.grade,
      part: data.part.present ? data.part.value : this.part,
      topicIds: data.topicIds.present ? data.topicIds.value : this.topicIds,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExamTopicSelection(')
          ..write('profileId: $profileId, ')
          ..write('grade: $grade, ')
          ..write('part: $part, ')
          ..write('topicIds: $topicIds, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(profileId, grade, part, topicIds, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExamTopicSelection &&
          other.profileId == this.profileId &&
          other.grade == this.grade &&
          other.part == this.part &&
          other.topicIds == this.topicIds &&
          other.updatedAt == this.updatedAt);
}

class ExamTopicSelectionsCompanion extends UpdateCompanion<ExamTopicSelection> {
  final Value<String> profileId;
  final Value<int> grade;
  final Value<int> part;
  final Value<String> topicIds;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ExamTopicSelectionsCompanion({
    this.profileId = const Value.absent(),
    this.grade = const Value.absent(),
    this.part = const Value.absent(),
    this.topicIds = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExamTopicSelectionsCompanion.insert({
    required String profileId,
    required int grade,
    required int part,
    required String topicIds,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : profileId = Value(profileId),
        grade = Value(grade),
        part = Value(part),
        topicIds = Value(topicIds),
        updatedAt = Value(updatedAt);
  static Insertable<ExamTopicSelection> custom({
    Expression<String>? profileId,
    Expression<int>? grade,
    Expression<int>? part,
    Expression<String>? topicIds,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (profileId != null) 'profile_id': profileId,
      if (grade != null) 'grade': grade,
      if (part != null) 'part': part,
      if (topicIds != null) 'topic_ids': topicIds,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExamTopicSelectionsCompanion copyWith(
      {Value<String>? profileId,
      Value<int>? grade,
      Value<int>? part,
      Value<String>? topicIds,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return ExamTopicSelectionsCompanion(
      profileId: profileId ?? this.profileId,
      grade: grade ?? this.grade,
      part: part ?? this.part,
      topicIds: topicIds ?? this.topicIds,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (grade.present) {
      map['grade'] = Variable<int>(grade.value);
    }
    if (part.present) {
      map['part'] = Variable<int>(part.value);
    }
    if (topicIds.present) {
      map['topic_ids'] = Variable<String>(topicIds.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExamTopicSelectionsCompanion(')
          ..write('profileId: $profileId, ')
          ..write('grade: $grade, ')
          ..write('part: $part, ')
          ..write('topicIds: $topicIds, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FactStatsTable extends FactStats
    with TableInfo<$FactStatsTable, FactStat> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FactStatsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _profileIdMeta =
      const VerificationMeta('profileId');
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
      'profile_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES profiles (id) ON DELETE CASCADE'));
  static const VerificationMeta _sectionMeta =
      const VerificationMeta('section');
  @override
  late final GeneratedColumn<String> section = GeneratedColumn<String>(
      'section', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _factKeyMeta =
      const VerificationMeta('factKey');
  @override
  late final GeneratedColumn<String> factKey = GeneratedColumn<String>(
      'fact_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _attemptsMeta =
      const VerificationMeta('attempts');
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
      'attempts', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _correctMeta =
      const VerificationMeta('correct');
  @override
  late final GeneratedColumn<int> correct = GeneratedColumn<int>(
      'correct', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastSeenMeta =
      const VerificationMeta('lastSeen');
  @override
  late final GeneratedColumn<DateTime> lastSeen = GeneratedColumn<DateTime>(
      'last_seen', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [profileId, section, factKey, attempts, correct, lastSeen];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fact_stats';
  @override
  VerificationContext validateIntegrity(Insertable<FactStat> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('profile_id')) {
      context.handle(_profileIdMeta,
          profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta));
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('section')) {
      context.handle(_sectionMeta,
          section.isAcceptableOrUnknown(data['section']!, _sectionMeta));
    } else if (isInserting) {
      context.missing(_sectionMeta);
    }
    if (data.containsKey('fact_key')) {
      context.handle(_factKeyMeta,
          factKey.isAcceptableOrUnknown(data['fact_key']!, _factKeyMeta));
    } else if (isInserting) {
      context.missing(_factKeyMeta);
    }
    if (data.containsKey('attempts')) {
      context.handle(_attemptsMeta,
          attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta));
    }
    if (data.containsKey('correct')) {
      context.handle(_correctMeta,
          correct.isAcceptableOrUnknown(data['correct']!, _correctMeta));
    }
    if (data.containsKey('last_seen')) {
      context.handle(_lastSeenMeta,
          lastSeen.isAcceptableOrUnknown(data['last_seen']!, _lastSeenMeta));
    } else if (isInserting) {
      context.missing(_lastSeenMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {profileId, section, factKey};
  @override
  FactStat map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FactStat(
      profileId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile_id'])!,
      section: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}section'])!,
      factKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}fact_key'])!,
      attempts: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}attempts'])!,
      correct: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}correct'])!,
      lastSeen: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_seen'])!,
    );
  }

  @override
  $FactStatsTable createAlias(String alias) {
    return $FactStatsTable(attachedDatabase, alias);
  }
}

class FactStat extends DataClass implements Insertable<FactStat> {
  final String profileId;
  final String section;
  final String factKey;
  final int attempts;
  final int correct;
  final DateTime lastSeen;
  const FactStat(
      {required this.profileId,
      required this.section,
      required this.factKey,
      required this.attempts,
      required this.correct,
      required this.lastSeen});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['profile_id'] = Variable<String>(profileId);
    map['section'] = Variable<String>(section);
    map['fact_key'] = Variable<String>(factKey);
    map['attempts'] = Variable<int>(attempts);
    map['correct'] = Variable<int>(correct);
    map['last_seen'] = Variable<DateTime>(lastSeen);
    return map;
  }

  FactStatsCompanion toCompanion(bool nullToAbsent) {
    return FactStatsCompanion(
      profileId: Value(profileId),
      section: Value(section),
      factKey: Value(factKey),
      attempts: Value(attempts),
      correct: Value(correct),
      lastSeen: Value(lastSeen),
    );
  }

  factory FactStat.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FactStat(
      profileId: serializer.fromJson<String>(json['profileId']),
      section: serializer.fromJson<String>(json['section']),
      factKey: serializer.fromJson<String>(json['factKey']),
      attempts: serializer.fromJson<int>(json['attempts']),
      correct: serializer.fromJson<int>(json['correct']),
      lastSeen: serializer.fromJson<DateTime>(json['lastSeen']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'profileId': serializer.toJson<String>(profileId),
      'section': serializer.toJson<String>(section),
      'factKey': serializer.toJson<String>(factKey),
      'attempts': serializer.toJson<int>(attempts),
      'correct': serializer.toJson<int>(correct),
      'lastSeen': serializer.toJson<DateTime>(lastSeen),
    };
  }

  FactStat copyWith(
          {String? profileId,
          String? section,
          String? factKey,
          int? attempts,
          int? correct,
          DateTime? lastSeen}) =>
      FactStat(
        profileId: profileId ?? this.profileId,
        section: section ?? this.section,
        factKey: factKey ?? this.factKey,
        attempts: attempts ?? this.attempts,
        correct: correct ?? this.correct,
        lastSeen: lastSeen ?? this.lastSeen,
      );
  FactStat copyWithCompanion(FactStatsCompanion data) {
    return FactStat(
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      section: data.section.present ? data.section.value : this.section,
      factKey: data.factKey.present ? data.factKey.value : this.factKey,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      correct: data.correct.present ? data.correct.value : this.correct,
      lastSeen: data.lastSeen.present ? data.lastSeen.value : this.lastSeen,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FactStat(')
          ..write('profileId: $profileId, ')
          ..write('section: $section, ')
          ..write('factKey: $factKey, ')
          ..write('attempts: $attempts, ')
          ..write('correct: $correct, ')
          ..write('lastSeen: $lastSeen')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(profileId, section, factKey, attempts, correct, lastSeen);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FactStat &&
          other.profileId == this.profileId &&
          other.section == this.section &&
          other.factKey == this.factKey &&
          other.attempts == this.attempts &&
          other.correct == this.correct &&
          other.lastSeen == this.lastSeen);
}

class FactStatsCompanion extends UpdateCompanion<FactStat> {
  final Value<String> profileId;
  final Value<String> section;
  final Value<String> factKey;
  final Value<int> attempts;
  final Value<int> correct;
  final Value<DateTime> lastSeen;
  final Value<int> rowid;
  const FactStatsCompanion({
    this.profileId = const Value.absent(),
    this.section = const Value.absent(),
    this.factKey = const Value.absent(),
    this.attempts = const Value.absent(),
    this.correct = const Value.absent(),
    this.lastSeen = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FactStatsCompanion.insert({
    required String profileId,
    required String section,
    required String factKey,
    this.attempts = const Value.absent(),
    this.correct = const Value.absent(),
    required DateTime lastSeen,
    this.rowid = const Value.absent(),
  })  : profileId = Value(profileId),
        section = Value(section),
        factKey = Value(factKey),
        lastSeen = Value(lastSeen);
  static Insertable<FactStat> custom({
    Expression<String>? profileId,
    Expression<String>? section,
    Expression<String>? factKey,
    Expression<int>? attempts,
    Expression<int>? correct,
    Expression<DateTime>? lastSeen,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (profileId != null) 'profile_id': profileId,
      if (section != null) 'section': section,
      if (factKey != null) 'fact_key': factKey,
      if (attempts != null) 'attempts': attempts,
      if (correct != null) 'correct': correct,
      if (lastSeen != null) 'last_seen': lastSeen,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FactStatsCompanion copyWith(
      {Value<String>? profileId,
      Value<String>? section,
      Value<String>? factKey,
      Value<int>? attempts,
      Value<int>? correct,
      Value<DateTime>? lastSeen,
      Value<int>? rowid}) {
    return FactStatsCompanion(
      profileId: profileId ?? this.profileId,
      section: section ?? this.section,
      factKey: factKey ?? this.factKey,
      attempts: attempts ?? this.attempts,
      correct: correct ?? this.correct,
      lastSeen: lastSeen ?? this.lastSeen,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (section.present) {
      map['section'] = Variable<String>(section.value);
    }
    if (factKey.present) {
      map['fact_key'] = Variable<String>(factKey.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (correct.present) {
      map['correct'] = Variable<int>(correct.value);
    }
    if (lastSeen.present) {
      map['last_seen'] = Variable<DateTime>(lastSeen.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FactStatsCompanion(')
          ..write('profileId: $profileId, ')
          ..write('section: $section, ')
          ..write('factKey: $factKey, ')
          ..write('attempts: $attempts, ')
          ..write('correct: $correct, ')
          ..write('lastSeen: $lastSeen, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AchievementRecordsTable extends AchievementRecords
    with TableInfo<$AchievementRecordsTable, AchievementRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AchievementRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _profileIdMeta =
      const VerificationMeta('profileId');
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
      'profile_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES profiles (id) ON DELETE CASCADE'));
  static const VerificationMeta _achievementIdMeta =
      const VerificationMeta('achievementId');
  @override
  late final GeneratedColumn<String> achievementId = GeneratedColumn<String>(
      'achievement_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _unlockedAtMeta =
      const VerificationMeta('unlockedAt');
  @override
  late final GeneratedColumn<DateTime> unlockedAt = GeneratedColumn<DateTime>(
      'unlocked_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [profileId, achievementId, unlockedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'achievement_records';
  @override
  VerificationContext validateIntegrity(Insertable<AchievementRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('profile_id')) {
      context.handle(_profileIdMeta,
          profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta));
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('achievement_id')) {
      context.handle(
          _achievementIdMeta,
          achievementId.isAcceptableOrUnknown(
              data['achievement_id']!, _achievementIdMeta));
    } else if (isInserting) {
      context.missing(_achievementIdMeta);
    }
    if (data.containsKey('unlocked_at')) {
      context.handle(
          _unlockedAtMeta,
          unlockedAt.isAcceptableOrUnknown(
              data['unlocked_at']!, _unlockedAtMeta));
    } else if (isInserting) {
      context.missing(_unlockedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {profileId, achievementId};
  @override
  AchievementRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AchievementRecord(
      profileId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile_id'])!,
      achievementId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}achievement_id'])!,
      unlockedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}unlocked_at'])!,
    );
  }

  @override
  $AchievementRecordsTable createAlias(String alias) {
    return $AchievementRecordsTable(attachedDatabase, alias);
  }
}

class AchievementRecord extends DataClass
    implements Insertable<AchievementRecord> {
  final String profileId;
  final String achievementId;
  final DateTime unlockedAt;
  const AchievementRecord(
      {required this.profileId,
      required this.achievementId,
      required this.unlockedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['profile_id'] = Variable<String>(profileId);
    map['achievement_id'] = Variable<String>(achievementId);
    map['unlocked_at'] = Variable<DateTime>(unlockedAt);
    return map;
  }

  AchievementRecordsCompanion toCompanion(bool nullToAbsent) {
    return AchievementRecordsCompanion(
      profileId: Value(profileId),
      achievementId: Value(achievementId),
      unlockedAt: Value(unlockedAt),
    );
  }

  factory AchievementRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AchievementRecord(
      profileId: serializer.fromJson<String>(json['profileId']),
      achievementId: serializer.fromJson<String>(json['achievementId']),
      unlockedAt: serializer.fromJson<DateTime>(json['unlockedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'profileId': serializer.toJson<String>(profileId),
      'achievementId': serializer.toJson<String>(achievementId),
      'unlockedAt': serializer.toJson<DateTime>(unlockedAt),
    };
  }

  AchievementRecord copyWith(
          {String? profileId, String? achievementId, DateTime? unlockedAt}) =>
      AchievementRecord(
        profileId: profileId ?? this.profileId,
        achievementId: achievementId ?? this.achievementId,
        unlockedAt: unlockedAt ?? this.unlockedAt,
      );
  AchievementRecord copyWithCompanion(AchievementRecordsCompanion data) {
    return AchievementRecord(
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      achievementId: data.achievementId.present
          ? data.achievementId.value
          : this.achievementId,
      unlockedAt:
          data.unlockedAt.present ? data.unlockedAt.value : this.unlockedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AchievementRecord(')
          ..write('profileId: $profileId, ')
          ..write('achievementId: $achievementId, ')
          ..write('unlockedAt: $unlockedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(profileId, achievementId, unlockedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AchievementRecord &&
          other.profileId == this.profileId &&
          other.achievementId == this.achievementId &&
          other.unlockedAt == this.unlockedAt);
}

class AchievementRecordsCompanion extends UpdateCompanion<AchievementRecord> {
  final Value<String> profileId;
  final Value<String> achievementId;
  final Value<DateTime> unlockedAt;
  final Value<int> rowid;
  const AchievementRecordsCompanion({
    this.profileId = const Value.absent(),
    this.achievementId = const Value.absent(),
    this.unlockedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AchievementRecordsCompanion.insert({
    required String profileId,
    required String achievementId,
    required DateTime unlockedAt,
    this.rowid = const Value.absent(),
  })  : profileId = Value(profileId),
        achievementId = Value(achievementId),
        unlockedAt = Value(unlockedAt);
  static Insertable<AchievementRecord> custom({
    Expression<String>? profileId,
    Expression<String>? achievementId,
    Expression<DateTime>? unlockedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (profileId != null) 'profile_id': profileId,
      if (achievementId != null) 'achievement_id': achievementId,
      if (unlockedAt != null) 'unlocked_at': unlockedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AchievementRecordsCompanion copyWith(
      {Value<String>? profileId,
      Value<String>? achievementId,
      Value<DateTime>? unlockedAt,
      Value<int>? rowid}) {
    return AchievementRecordsCompanion(
      profileId: profileId ?? this.profileId,
      achievementId: achievementId ?? this.achievementId,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (achievementId.present) {
      map['achievement_id'] = Variable<String>(achievementId.value);
    }
    if (unlockedAt.present) {
      map['unlocked_at'] = Variable<DateTime>(unlockedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AchievementRecordsCompanion(')
          ..write('profileId: $profileId, ')
          ..write('achievementId: $achievementId, ')
          ..write('unlockedAt: $unlockedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DailyChallengesTable extends DailyChallenges
    with TableInfo<$DailyChallengesTable, DailyChallenge> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyChallengesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _profileIdMeta =
      const VerificationMeta('profileId');
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
      'profile_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES profiles (id) ON DELETE CASCADE'));
  static const VerificationMeta _dateKeyMeta =
      const VerificationMeta('dateKey');
  @override
  late final GeneratedColumn<String> dateKey = GeneratedColumn<String>(
      'date_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _correctMeta =
      const VerificationMeta('correct');
  @override
  late final GeneratedColumn<int> correct = GeneratedColumn<int>(
      'correct', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<int> total = GeneratedColumn<int>(
      'total', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _starsEarnedMeta =
      const VerificationMeta('starsEarned');
  @override
  late final GeneratedColumn<int> starsEarned = GeneratedColumn<int>(
      'stars_earned', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _gemsEarnedMeta =
      const VerificationMeta('gemsEarned');
  @override
  late final GeneratedColumn<int> gemsEarned = GeneratedColumn<int>(
      'gems_earned', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _examIdMeta = const VerificationMeta('examId');
  @override
  late final GeneratedColumn<int> examId = GeneratedColumn<int>(
      'exam_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        profileId,
        dateKey,
        correct,
        total,
        starsEarned,
        gemsEarned,
        examId,
        completedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_challenges';
  @override
  VerificationContext validateIntegrity(Insertable<DailyChallenge> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('profile_id')) {
      context.handle(_profileIdMeta,
          profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta));
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('date_key')) {
      context.handle(_dateKeyMeta,
          dateKey.isAcceptableOrUnknown(data['date_key']!, _dateKeyMeta));
    } else if (isInserting) {
      context.missing(_dateKeyMeta);
    }
    if (data.containsKey('correct')) {
      context.handle(_correctMeta,
          correct.isAcceptableOrUnknown(data['correct']!, _correctMeta));
    } else if (isInserting) {
      context.missing(_correctMeta);
    }
    if (data.containsKey('total')) {
      context.handle(
          _totalMeta, total.isAcceptableOrUnknown(data['total']!, _totalMeta));
    } else if (isInserting) {
      context.missing(_totalMeta);
    }
    if (data.containsKey('stars_earned')) {
      context.handle(
          _starsEarnedMeta,
          starsEarned.isAcceptableOrUnknown(
              data['stars_earned']!, _starsEarnedMeta));
    } else if (isInserting) {
      context.missing(_starsEarnedMeta);
    }
    if (data.containsKey('gems_earned')) {
      context.handle(
          _gemsEarnedMeta,
          gemsEarned.isAcceptableOrUnknown(
              data['gems_earned']!, _gemsEarnedMeta));
    } else if (isInserting) {
      context.missing(_gemsEarnedMeta);
    }
    if (data.containsKey('exam_id')) {
      context.handle(_examIdMeta,
          examId.isAcceptableOrUnknown(data['exam_id']!, _examIdMeta));
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    } else if (isInserting) {
      context.missing(_completedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {profileId, dateKey};
  @override
  DailyChallenge map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyChallenge(
      profileId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile_id'])!,
      dateKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date_key'])!,
      correct: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}correct'])!,
      total: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total'])!,
      starsEarned: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}stars_earned'])!,
      gemsEarned: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}gems_earned'])!,
      examId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}exam_id']),
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at'])!,
    );
  }

  @override
  $DailyChallengesTable createAlias(String alias) {
    return $DailyChallengesTable(attachedDatabase, alias);
  }
}

class DailyChallenge extends DataClass implements Insertable<DailyChallenge> {
  final String profileId;
  final String dateKey;
  final int correct;
  final int total;
  final int starsEarned;
  final int gemsEarned;
  final int? examId;
  final DateTime completedAt;
  const DailyChallenge(
      {required this.profileId,
      required this.dateKey,
      required this.correct,
      required this.total,
      required this.starsEarned,
      required this.gemsEarned,
      this.examId,
      required this.completedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['profile_id'] = Variable<String>(profileId);
    map['date_key'] = Variable<String>(dateKey);
    map['correct'] = Variable<int>(correct);
    map['total'] = Variable<int>(total);
    map['stars_earned'] = Variable<int>(starsEarned);
    map['gems_earned'] = Variable<int>(gemsEarned);
    if (!nullToAbsent || examId != null) {
      map['exam_id'] = Variable<int>(examId);
    }
    map['completed_at'] = Variable<DateTime>(completedAt);
    return map;
  }

  DailyChallengesCompanion toCompanion(bool nullToAbsent) {
    return DailyChallengesCompanion(
      profileId: Value(profileId),
      dateKey: Value(dateKey),
      correct: Value(correct),
      total: Value(total),
      starsEarned: Value(starsEarned),
      gemsEarned: Value(gemsEarned),
      examId:
          examId == null && nullToAbsent ? const Value.absent() : Value(examId),
      completedAt: Value(completedAt),
    );
  }

  factory DailyChallenge.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyChallenge(
      profileId: serializer.fromJson<String>(json['profileId']),
      dateKey: serializer.fromJson<String>(json['dateKey']),
      correct: serializer.fromJson<int>(json['correct']),
      total: serializer.fromJson<int>(json['total']),
      starsEarned: serializer.fromJson<int>(json['starsEarned']),
      gemsEarned: serializer.fromJson<int>(json['gemsEarned']),
      examId: serializer.fromJson<int?>(json['examId']),
      completedAt: serializer.fromJson<DateTime>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'profileId': serializer.toJson<String>(profileId),
      'dateKey': serializer.toJson<String>(dateKey),
      'correct': serializer.toJson<int>(correct),
      'total': serializer.toJson<int>(total),
      'starsEarned': serializer.toJson<int>(starsEarned),
      'gemsEarned': serializer.toJson<int>(gemsEarned),
      'examId': serializer.toJson<int?>(examId),
      'completedAt': serializer.toJson<DateTime>(completedAt),
    };
  }

  DailyChallenge copyWith(
          {String? profileId,
          String? dateKey,
          int? correct,
          int? total,
          int? starsEarned,
          int? gemsEarned,
          Value<int?> examId = const Value.absent(),
          DateTime? completedAt}) =>
      DailyChallenge(
        profileId: profileId ?? this.profileId,
        dateKey: dateKey ?? this.dateKey,
        correct: correct ?? this.correct,
        total: total ?? this.total,
        starsEarned: starsEarned ?? this.starsEarned,
        gemsEarned: gemsEarned ?? this.gemsEarned,
        examId: examId.present ? examId.value : this.examId,
        completedAt: completedAt ?? this.completedAt,
      );
  DailyChallenge copyWithCompanion(DailyChallengesCompanion data) {
    return DailyChallenge(
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      dateKey: data.dateKey.present ? data.dateKey.value : this.dateKey,
      correct: data.correct.present ? data.correct.value : this.correct,
      total: data.total.present ? data.total.value : this.total,
      starsEarned:
          data.starsEarned.present ? data.starsEarned.value : this.starsEarned,
      gemsEarned:
          data.gemsEarned.present ? data.gemsEarned.value : this.gemsEarned,
      examId: data.examId.present ? data.examId.value : this.examId,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyChallenge(')
          ..write('profileId: $profileId, ')
          ..write('dateKey: $dateKey, ')
          ..write('correct: $correct, ')
          ..write('total: $total, ')
          ..write('starsEarned: $starsEarned, ')
          ..write('gemsEarned: $gemsEarned, ')
          ..write('examId: $examId, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(profileId, dateKey, correct, total,
      starsEarned, gemsEarned, examId, completedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyChallenge &&
          other.profileId == this.profileId &&
          other.dateKey == this.dateKey &&
          other.correct == this.correct &&
          other.total == this.total &&
          other.starsEarned == this.starsEarned &&
          other.gemsEarned == this.gemsEarned &&
          other.examId == this.examId &&
          other.completedAt == this.completedAt);
}

class DailyChallengesCompanion extends UpdateCompanion<DailyChallenge> {
  final Value<String> profileId;
  final Value<String> dateKey;
  final Value<int> correct;
  final Value<int> total;
  final Value<int> starsEarned;
  final Value<int> gemsEarned;
  final Value<int?> examId;
  final Value<DateTime> completedAt;
  final Value<int> rowid;
  const DailyChallengesCompanion({
    this.profileId = const Value.absent(),
    this.dateKey = const Value.absent(),
    this.correct = const Value.absent(),
    this.total = const Value.absent(),
    this.starsEarned = const Value.absent(),
    this.gemsEarned = const Value.absent(),
    this.examId = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyChallengesCompanion.insert({
    required String profileId,
    required String dateKey,
    required int correct,
    required int total,
    required int starsEarned,
    required int gemsEarned,
    this.examId = const Value.absent(),
    required DateTime completedAt,
    this.rowid = const Value.absent(),
  })  : profileId = Value(profileId),
        dateKey = Value(dateKey),
        correct = Value(correct),
        total = Value(total),
        starsEarned = Value(starsEarned),
        gemsEarned = Value(gemsEarned),
        completedAt = Value(completedAt);
  static Insertable<DailyChallenge> custom({
    Expression<String>? profileId,
    Expression<String>? dateKey,
    Expression<int>? correct,
    Expression<int>? total,
    Expression<int>? starsEarned,
    Expression<int>? gemsEarned,
    Expression<int>? examId,
    Expression<DateTime>? completedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (profileId != null) 'profile_id': profileId,
      if (dateKey != null) 'date_key': dateKey,
      if (correct != null) 'correct': correct,
      if (total != null) 'total': total,
      if (starsEarned != null) 'stars_earned': starsEarned,
      if (gemsEarned != null) 'gems_earned': gemsEarned,
      if (examId != null) 'exam_id': examId,
      if (completedAt != null) 'completed_at': completedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyChallengesCompanion copyWith(
      {Value<String>? profileId,
      Value<String>? dateKey,
      Value<int>? correct,
      Value<int>? total,
      Value<int>? starsEarned,
      Value<int>? gemsEarned,
      Value<int?>? examId,
      Value<DateTime>? completedAt,
      Value<int>? rowid}) {
    return DailyChallengesCompanion(
      profileId: profileId ?? this.profileId,
      dateKey: dateKey ?? this.dateKey,
      correct: correct ?? this.correct,
      total: total ?? this.total,
      starsEarned: starsEarned ?? this.starsEarned,
      gemsEarned: gemsEarned ?? this.gemsEarned,
      examId: examId ?? this.examId,
      completedAt: completedAt ?? this.completedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (dateKey.present) {
      map['date_key'] = Variable<String>(dateKey.value);
    }
    if (correct.present) {
      map['correct'] = Variable<int>(correct.value);
    }
    if (total.present) {
      map['total'] = Variable<int>(total.value);
    }
    if (starsEarned.present) {
      map['stars_earned'] = Variable<int>(starsEarned.value);
    }
    if (gemsEarned.present) {
      map['gems_earned'] = Variable<int>(gemsEarned.value);
    }
    if (examId.present) {
      map['exam_id'] = Variable<int>(examId.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyChallengesCompanion(')
          ..write('profileId: $profileId, ')
          ..write('dateKey: $dateKey, ')
          ..write('correct: $correct, ')
          ..write('total: $total, ')
          ..write('starsEarned: $starsEarned, ')
          ..write('gemsEarned: $gemsEarned, ')
          ..write('examId: $examId, ')
          ..write('completedAt: $completedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RewardClaimsTable extends RewardClaims
    with TableInfo<$RewardClaimsTable, RewardClaim> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RewardClaimsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _profileIdMeta =
      const VerificationMeta('profileId');
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
      'profile_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES profiles (id) ON DELETE CASCADE'));
  static const VerificationMeta _dateKeyMeta =
      const VerificationMeta('dateKey');
  @override
  late final GeneratedColumn<String> dateKey = GeneratedColumn<String>(
      'date_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dayIndexMeta =
      const VerificationMeta('dayIndex');
  @override
  late final GeneratedColumn<int> dayIndex = GeneratedColumn<int>(
      'day_index', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _starsMeta = const VerificationMeta('stars');
  @override
  late final GeneratedColumn<int> stars = GeneratedColumn<int>(
      'stars', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _gemsMeta = const VerificationMeta('gems');
  @override
  late final GeneratedColumn<int> gems = GeneratedColumn<int>(
      'gems', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _claimedAtMeta =
      const VerificationMeta('claimedAt');
  @override
  late final GeneratedColumn<DateTime> claimedAt = GeneratedColumn<DateTime>(
      'claimed_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [profileId, dateKey, dayIndex, stars, gems, claimedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reward_claims';
  @override
  VerificationContext validateIntegrity(Insertable<RewardClaim> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('profile_id')) {
      context.handle(_profileIdMeta,
          profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta));
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('date_key')) {
      context.handle(_dateKeyMeta,
          dateKey.isAcceptableOrUnknown(data['date_key']!, _dateKeyMeta));
    } else if (isInserting) {
      context.missing(_dateKeyMeta);
    }
    if (data.containsKey('day_index')) {
      context.handle(_dayIndexMeta,
          dayIndex.isAcceptableOrUnknown(data['day_index']!, _dayIndexMeta));
    } else if (isInserting) {
      context.missing(_dayIndexMeta);
    }
    if (data.containsKey('stars')) {
      context.handle(
          _starsMeta, stars.isAcceptableOrUnknown(data['stars']!, _starsMeta));
    } else if (isInserting) {
      context.missing(_starsMeta);
    }
    if (data.containsKey('gems')) {
      context.handle(
          _gemsMeta, gems.isAcceptableOrUnknown(data['gems']!, _gemsMeta));
    } else if (isInserting) {
      context.missing(_gemsMeta);
    }
    if (data.containsKey('claimed_at')) {
      context.handle(_claimedAtMeta,
          claimedAt.isAcceptableOrUnknown(data['claimed_at']!, _claimedAtMeta));
    } else if (isInserting) {
      context.missing(_claimedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {profileId, dateKey};
  @override
  RewardClaim map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RewardClaim(
      profileId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile_id'])!,
      dateKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date_key'])!,
      dayIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}day_index'])!,
      stars: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}stars'])!,
      gems: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}gems'])!,
      claimedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}claimed_at'])!,
    );
  }

  @override
  $RewardClaimsTable createAlias(String alias) {
    return $RewardClaimsTable(attachedDatabase, alias);
  }
}

class RewardClaim extends DataClass implements Insertable<RewardClaim> {
  final String profileId;
  final String dateKey;
  final int dayIndex;
  final int stars;
  final int gems;
  final DateTime claimedAt;
  const RewardClaim(
      {required this.profileId,
      required this.dateKey,
      required this.dayIndex,
      required this.stars,
      required this.gems,
      required this.claimedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['profile_id'] = Variable<String>(profileId);
    map['date_key'] = Variable<String>(dateKey);
    map['day_index'] = Variable<int>(dayIndex);
    map['stars'] = Variable<int>(stars);
    map['gems'] = Variable<int>(gems);
    map['claimed_at'] = Variable<DateTime>(claimedAt);
    return map;
  }

  RewardClaimsCompanion toCompanion(bool nullToAbsent) {
    return RewardClaimsCompanion(
      profileId: Value(profileId),
      dateKey: Value(dateKey),
      dayIndex: Value(dayIndex),
      stars: Value(stars),
      gems: Value(gems),
      claimedAt: Value(claimedAt),
    );
  }

  factory RewardClaim.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RewardClaim(
      profileId: serializer.fromJson<String>(json['profileId']),
      dateKey: serializer.fromJson<String>(json['dateKey']),
      dayIndex: serializer.fromJson<int>(json['dayIndex']),
      stars: serializer.fromJson<int>(json['stars']),
      gems: serializer.fromJson<int>(json['gems']),
      claimedAt: serializer.fromJson<DateTime>(json['claimedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'profileId': serializer.toJson<String>(profileId),
      'dateKey': serializer.toJson<String>(dateKey),
      'dayIndex': serializer.toJson<int>(dayIndex),
      'stars': serializer.toJson<int>(stars),
      'gems': serializer.toJson<int>(gems),
      'claimedAt': serializer.toJson<DateTime>(claimedAt),
    };
  }

  RewardClaim copyWith(
          {String? profileId,
          String? dateKey,
          int? dayIndex,
          int? stars,
          int? gems,
          DateTime? claimedAt}) =>
      RewardClaim(
        profileId: profileId ?? this.profileId,
        dateKey: dateKey ?? this.dateKey,
        dayIndex: dayIndex ?? this.dayIndex,
        stars: stars ?? this.stars,
        gems: gems ?? this.gems,
        claimedAt: claimedAt ?? this.claimedAt,
      );
  RewardClaim copyWithCompanion(RewardClaimsCompanion data) {
    return RewardClaim(
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      dateKey: data.dateKey.present ? data.dateKey.value : this.dateKey,
      dayIndex: data.dayIndex.present ? data.dayIndex.value : this.dayIndex,
      stars: data.stars.present ? data.stars.value : this.stars,
      gems: data.gems.present ? data.gems.value : this.gems,
      claimedAt: data.claimedAt.present ? data.claimedAt.value : this.claimedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RewardClaim(')
          ..write('profileId: $profileId, ')
          ..write('dateKey: $dateKey, ')
          ..write('dayIndex: $dayIndex, ')
          ..write('stars: $stars, ')
          ..write('gems: $gems, ')
          ..write('claimedAt: $claimedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(profileId, dateKey, dayIndex, stars, gems, claimedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RewardClaim &&
          other.profileId == this.profileId &&
          other.dateKey == this.dateKey &&
          other.dayIndex == this.dayIndex &&
          other.stars == this.stars &&
          other.gems == this.gems &&
          other.claimedAt == this.claimedAt);
}

class RewardClaimsCompanion extends UpdateCompanion<RewardClaim> {
  final Value<String> profileId;
  final Value<String> dateKey;
  final Value<int> dayIndex;
  final Value<int> stars;
  final Value<int> gems;
  final Value<DateTime> claimedAt;
  final Value<int> rowid;
  const RewardClaimsCompanion({
    this.profileId = const Value.absent(),
    this.dateKey = const Value.absent(),
    this.dayIndex = const Value.absent(),
    this.stars = const Value.absent(),
    this.gems = const Value.absent(),
    this.claimedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RewardClaimsCompanion.insert({
    required String profileId,
    required String dateKey,
    required int dayIndex,
    required int stars,
    required int gems,
    required DateTime claimedAt,
    this.rowid = const Value.absent(),
  })  : profileId = Value(profileId),
        dateKey = Value(dateKey),
        dayIndex = Value(dayIndex),
        stars = Value(stars),
        gems = Value(gems),
        claimedAt = Value(claimedAt);
  static Insertable<RewardClaim> custom({
    Expression<String>? profileId,
    Expression<String>? dateKey,
    Expression<int>? dayIndex,
    Expression<int>? stars,
    Expression<int>? gems,
    Expression<DateTime>? claimedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (profileId != null) 'profile_id': profileId,
      if (dateKey != null) 'date_key': dateKey,
      if (dayIndex != null) 'day_index': dayIndex,
      if (stars != null) 'stars': stars,
      if (gems != null) 'gems': gems,
      if (claimedAt != null) 'claimed_at': claimedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RewardClaimsCompanion copyWith(
      {Value<String>? profileId,
      Value<String>? dateKey,
      Value<int>? dayIndex,
      Value<int>? stars,
      Value<int>? gems,
      Value<DateTime>? claimedAt,
      Value<int>? rowid}) {
    return RewardClaimsCompanion(
      profileId: profileId ?? this.profileId,
      dateKey: dateKey ?? this.dateKey,
      dayIndex: dayIndex ?? this.dayIndex,
      stars: stars ?? this.stars,
      gems: gems ?? this.gems,
      claimedAt: claimedAt ?? this.claimedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (dateKey.present) {
      map['date_key'] = Variable<String>(dateKey.value);
    }
    if (dayIndex.present) {
      map['day_index'] = Variable<int>(dayIndex.value);
    }
    if (stars.present) {
      map['stars'] = Variable<int>(stars.value);
    }
    if (gems.present) {
      map['gems'] = Variable<int>(gems.value);
    }
    if (claimedAt.present) {
      map['claimed_at'] = Variable<DateTime>(claimedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RewardClaimsCompanion(')
          ..write('profileId: $profileId, ')
          ..write('dateKey: $dateKey, ')
          ..write('dayIndex: $dayIndex, ')
          ..write('stars: $stars, ')
          ..write('gems: $gems, ')
          ..write('claimedAt: $claimedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UnlockedCosmeticsTable extends UnlockedCosmetics
    with TableInfo<$UnlockedCosmeticsTable, UnlockedCosmetic> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UnlockedCosmeticsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _profileIdMeta =
      const VerificationMeta('profileId');
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
      'profile_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES profiles (id) ON DELETE CASCADE'));
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
      'item_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _unlockedAtMeta =
      const VerificationMeta('unlockedAt');
  @override
  late final GeneratedColumn<DateTime> unlockedAt = GeneratedColumn<DateTime>(
      'unlocked_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [profileId, itemId, unlockedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'unlocked_cosmetics';
  @override
  VerificationContext validateIntegrity(Insertable<UnlockedCosmetic> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('profile_id')) {
      context.handle(_profileIdMeta,
          profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta));
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta,
          itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('unlocked_at')) {
      context.handle(
          _unlockedAtMeta,
          unlockedAt.isAcceptableOrUnknown(
              data['unlocked_at']!, _unlockedAtMeta));
    } else if (isInserting) {
      context.missing(_unlockedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {profileId, itemId};
  @override
  UnlockedCosmetic map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UnlockedCosmetic(
      profileId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile_id'])!,
      itemId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_id'])!,
      unlockedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}unlocked_at'])!,
    );
  }

  @override
  $UnlockedCosmeticsTable createAlias(String alias) {
    return $UnlockedCosmeticsTable(attachedDatabase, alias);
  }
}

class UnlockedCosmetic extends DataClass
    implements Insertable<UnlockedCosmetic> {
  final String profileId;
  final String itemId;
  final DateTime unlockedAt;
  const UnlockedCosmetic(
      {required this.profileId,
      required this.itemId,
      required this.unlockedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['profile_id'] = Variable<String>(profileId);
    map['item_id'] = Variable<String>(itemId);
    map['unlocked_at'] = Variable<DateTime>(unlockedAt);
    return map;
  }

  UnlockedCosmeticsCompanion toCompanion(bool nullToAbsent) {
    return UnlockedCosmeticsCompanion(
      profileId: Value(profileId),
      itemId: Value(itemId),
      unlockedAt: Value(unlockedAt),
    );
  }

  factory UnlockedCosmetic.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UnlockedCosmetic(
      profileId: serializer.fromJson<String>(json['profileId']),
      itemId: serializer.fromJson<String>(json['itemId']),
      unlockedAt: serializer.fromJson<DateTime>(json['unlockedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'profileId': serializer.toJson<String>(profileId),
      'itemId': serializer.toJson<String>(itemId),
      'unlockedAt': serializer.toJson<DateTime>(unlockedAt),
    };
  }

  UnlockedCosmetic copyWith(
          {String? profileId, String? itemId, DateTime? unlockedAt}) =>
      UnlockedCosmetic(
        profileId: profileId ?? this.profileId,
        itemId: itemId ?? this.itemId,
        unlockedAt: unlockedAt ?? this.unlockedAt,
      );
  UnlockedCosmetic copyWithCompanion(UnlockedCosmeticsCompanion data) {
    return UnlockedCosmetic(
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      unlockedAt:
          data.unlockedAt.present ? data.unlockedAt.value : this.unlockedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UnlockedCosmetic(')
          ..write('profileId: $profileId, ')
          ..write('itemId: $itemId, ')
          ..write('unlockedAt: $unlockedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(profileId, itemId, unlockedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UnlockedCosmetic &&
          other.profileId == this.profileId &&
          other.itemId == this.itemId &&
          other.unlockedAt == this.unlockedAt);
}

class UnlockedCosmeticsCompanion extends UpdateCompanion<UnlockedCosmetic> {
  final Value<String> profileId;
  final Value<String> itemId;
  final Value<DateTime> unlockedAt;
  final Value<int> rowid;
  const UnlockedCosmeticsCompanion({
    this.profileId = const Value.absent(),
    this.itemId = const Value.absent(),
    this.unlockedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UnlockedCosmeticsCompanion.insert({
    required String profileId,
    required String itemId,
    required DateTime unlockedAt,
    this.rowid = const Value.absent(),
  })  : profileId = Value(profileId),
        itemId = Value(itemId),
        unlockedAt = Value(unlockedAt);
  static Insertable<UnlockedCosmetic> custom({
    Expression<String>? profileId,
    Expression<String>? itemId,
    Expression<DateTime>? unlockedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (profileId != null) 'profile_id': profileId,
      if (itemId != null) 'item_id': itemId,
      if (unlockedAt != null) 'unlocked_at': unlockedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UnlockedCosmeticsCompanion copyWith(
      {Value<String>? profileId,
      Value<String>? itemId,
      Value<DateTime>? unlockedAt,
      Value<int>? rowid}) {
    return UnlockedCosmeticsCompanion(
      profileId: profileId ?? this.profileId,
      itemId: itemId ?? this.itemId,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (unlockedAt.present) {
      map['unlocked_at'] = Variable<DateTime>(unlockedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UnlockedCosmeticsCompanion(')
          ..write('profileId: $profileId, ')
          ..write('itemId: $itemId, ')
          ..write('unlockedAt: $unlockedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProfilesTable profiles = $ProfilesTable(this);
  late final $UsersTable users = $UsersTable(this);
  late final $LearningLevelsTable learningLevels = $LearningLevelsTable(this);
  late final $StudentLevelProgressTable studentLevelProgress =
      $StudentLevelProgressTable(this);
  late final $ExamRecordsTable examRecords = $ExamRecordsTable(this);
  late final $AnswerRecordsTable answerRecords = $AnswerRecordsTable(this);
  late final $CurriculumTopicsTable curriculumTopics =
      $CurriculumTopicsTable(this);
  late final $ExamTopicSelectionsTable examTopicSelections =
      $ExamTopicSelectionsTable(this);
  late final $FactStatsTable factStats = $FactStatsTable(this);
  late final $AchievementRecordsTable achievementRecords =
      $AchievementRecordsTable(this);
  late final $DailyChallengesTable dailyChallenges =
      $DailyChallengesTable(this);
  late final $RewardClaimsTable rewardClaims = $RewardClaimsTable(this);
  late final $UnlockedCosmeticsTable unlockedCosmetics =
      $UnlockedCosmeticsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        profiles,
        users,
        learningLevels,
        studentLevelProgress,
        examRecords,
        answerRecords,
        curriculumTopics,
        examTopicSelections,
        factStats,
        achievementRecords,
        dailyChallenges,
        rewardClaims,
        unlockedCosmetics
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('profiles',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('users', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('profiles',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('student_level_progress', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('learning_levels',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('student_level_progress', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('profiles',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('exam_records', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('learning_levels',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('exam_records', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('exam_records',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('answer_records', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('profiles',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('answer_records', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('profiles',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('exam_topic_selections', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('profiles',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('fact_stats', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('profiles',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('achievement_records', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('profiles',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('daily_challenges', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('profiles',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('reward_claims', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('profiles',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('unlocked_cosmetics', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$ProfilesTableCreateCompanionBuilder = ProfilesCompanion Function({
  required String id,
  required String name,
  Value<int> avatarIndex,
  Value<int> stars,
  Value<int> gems,
  Value<int> points,
  Value<String?> equippedSkinId,
  Value<String?> equippedBackgroundId,
  Value<int> schoolGrade,
  Value<int> currentLevel,
  Value<int> totalCompletedLevels,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$ProfilesTableUpdateCompanionBuilder = ProfilesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<int> avatarIndex,
  Value<int> stars,
  Value<int> gems,
  Value<int> points,
  Value<String?> equippedSkinId,
  Value<String?> equippedBackgroundId,
  Value<int> schoolGrade,
  Value<int> currentLevel,
  Value<int> totalCompletedLevels,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$ProfilesTableReferences
    extends BaseReferences<_$AppDatabase, $ProfilesTable, Profile> {
  $$ProfilesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$UsersTable, List<User>> _usersRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.users,
          aliasName: $_aliasNameGenerator(db.profiles.id, db.users.profileId));

  $$UsersTableProcessedTableManager get usersRefs {
    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.profileId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_usersRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$StudentLevelProgressTable,
      List<StudentLevelProgressData>> _studentLevelProgressRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.studentLevelProgress,
          aliasName: $_aliasNameGenerator(
              db.profiles.id, db.studentLevelProgress.profileId));

  $$StudentLevelProgressTableProcessedTableManager
      get studentLevelProgressRefs {
    final manager = $$StudentLevelProgressTableTableManager(
            $_db, $_db.studentLevelProgress)
        .filter((f) => f.profileId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_studentLevelProgressRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ExamRecordsTable, List<ExamRecord>>
      _examRecordsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.examRecords,
          aliasName:
              $_aliasNameGenerator(db.profiles.id, db.examRecords.profileId));

  $$ExamRecordsTableProcessedTableManager get examRecordsRefs {
    final manager = $$ExamRecordsTableTableManager($_db, $_db.examRecords)
        .filter((f) => f.profileId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_examRecordsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$AnswerRecordsTable, List<AnswerRecord>>
      _answerRecordsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.answerRecords,
              aliasName: $_aliasNameGenerator(
                  db.profiles.id, db.answerRecords.profileId));

  $$AnswerRecordsTableProcessedTableManager get answerRecordsRefs {
    final manager = $$AnswerRecordsTableTableManager($_db, $_db.answerRecords)
        .filter((f) => f.profileId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_answerRecordsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ExamTopicSelectionsTable,
      List<ExamTopicSelection>> _examTopicSelectionsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.examTopicSelections,
          aliasName: $_aliasNameGenerator(
              db.profiles.id, db.examTopicSelections.profileId));

  $$ExamTopicSelectionsTableProcessedTableManager get examTopicSelectionsRefs {
    final manager = $$ExamTopicSelectionsTableTableManager(
            $_db, $_db.examTopicSelections)
        .filter((f) => f.profileId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_examTopicSelectionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$FactStatsTable, List<FactStat>>
      _factStatsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.factStats,
              aliasName:
                  $_aliasNameGenerator(db.profiles.id, db.factStats.profileId));

  $$FactStatsTableProcessedTableManager get factStatsRefs {
    final manager = $$FactStatsTableTableManager($_db, $_db.factStats)
        .filter((f) => f.profileId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_factStatsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$AchievementRecordsTable, List<AchievementRecord>>
      _achievementRecordsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.achievementRecords,
              aliasName: $_aliasNameGenerator(
                  db.profiles.id, db.achievementRecords.profileId));

  $$AchievementRecordsTableProcessedTableManager get achievementRecordsRefs {
    final manager = $$AchievementRecordsTableTableManager(
            $_db, $_db.achievementRecords)
        .filter((f) => f.profileId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_achievementRecordsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$DailyChallengesTable, List<DailyChallenge>>
      _dailyChallengesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.dailyChallenges,
              aliasName: $_aliasNameGenerator(
                  db.profiles.id, db.dailyChallenges.profileId));

  $$DailyChallengesTableProcessedTableManager get dailyChallengesRefs {
    final manager = $$DailyChallengesTableTableManager(
            $_db, $_db.dailyChallenges)
        .filter((f) => f.profileId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_dailyChallengesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$RewardClaimsTable, List<RewardClaim>>
      _rewardClaimsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.rewardClaims,
          aliasName:
              $_aliasNameGenerator(db.profiles.id, db.rewardClaims.profileId));

  $$RewardClaimsTableProcessedTableManager get rewardClaimsRefs {
    final manager = $$RewardClaimsTableTableManager($_db, $_db.rewardClaims)
        .filter((f) => f.profileId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_rewardClaimsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$UnlockedCosmeticsTable, List<UnlockedCosmetic>>
      _unlockedCosmeticsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.unlockedCosmetics,
              aliasName: $_aliasNameGenerator(
                  db.profiles.id, db.unlockedCosmetics.profileId));

  $$UnlockedCosmeticsTableProcessedTableManager get unlockedCosmeticsRefs {
    final manager = $$UnlockedCosmeticsTableTableManager(
            $_db, $_db.unlockedCosmetics)
        .filter((f) => f.profileId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_unlockedCosmeticsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get avatarIndex => $composableBuilder(
      column: $table.avatarIndex, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get stars => $composableBuilder(
      column: $table.stars, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get gems => $composableBuilder(
      column: $table.gems, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get points => $composableBuilder(
      column: $table.points, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get equippedSkinId => $composableBuilder(
      column: $table.equippedSkinId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get equippedBackgroundId => $composableBuilder(
      column: $table.equippedBackgroundId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get schoolGrade => $composableBuilder(
      column: $table.schoolGrade, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get currentLevel => $composableBuilder(
      column: $table.currentLevel, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalCompletedLevels => $composableBuilder(
      column: $table.totalCompletedLevels,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> usersRefs(
      Expression<bool> Function($$UsersTableFilterComposer f) f) {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.profileId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> studentLevelProgressRefs(
      Expression<bool> Function($$StudentLevelProgressTableFilterComposer f)
          f) {
    final $$StudentLevelProgressTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.studentLevelProgress,
        getReferencedColumn: (t) => t.profileId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StudentLevelProgressTableFilterComposer(
              $db: $db,
              $table: $db.studentLevelProgress,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> examRecordsRefs(
      Expression<bool> Function($$ExamRecordsTableFilterComposer f) f) {
    final $$ExamRecordsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.examRecords,
        getReferencedColumn: (t) => t.profileId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExamRecordsTableFilterComposer(
              $db: $db,
              $table: $db.examRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> answerRecordsRefs(
      Expression<bool> Function($$AnswerRecordsTableFilterComposer f) f) {
    final $$AnswerRecordsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.answerRecords,
        getReferencedColumn: (t) => t.profileId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AnswerRecordsTableFilterComposer(
              $db: $db,
              $table: $db.answerRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> examTopicSelectionsRefs(
      Expression<bool> Function($$ExamTopicSelectionsTableFilterComposer f) f) {
    final $$ExamTopicSelectionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.examTopicSelections,
        getReferencedColumn: (t) => t.profileId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExamTopicSelectionsTableFilterComposer(
              $db: $db,
              $table: $db.examTopicSelections,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> factStatsRefs(
      Expression<bool> Function($$FactStatsTableFilterComposer f) f) {
    final $$FactStatsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.factStats,
        getReferencedColumn: (t) => t.profileId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FactStatsTableFilterComposer(
              $db: $db,
              $table: $db.factStats,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> achievementRecordsRefs(
      Expression<bool> Function($$AchievementRecordsTableFilterComposer f) f) {
    final $$AchievementRecordsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.achievementRecords,
        getReferencedColumn: (t) => t.profileId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AchievementRecordsTableFilterComposer(
              $db: $db,
              $table: $db.achievementRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> dailyChallengesRefs(
      Expression<bool> Function($$DailyChallengesTableFilterComposer f) f) {
    final $$DailyChallengesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.dailyChallenges,
        getReferencedColumn: (t) => t.profileId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DailyChallengesTableFilterComposer(
              $db: $db,
              $table: $db.dailyChallenges,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> rewardClaimsRefs(
      Expression<bool> Function($$RewardClaimsTableFilterComposer f) f) {
    final $$RewardClaimsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.rewardClaims,
        getReferencedColumn: (t) => t.profileId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RewardClaimsTableFilterComposer(
              $db: $db,
              $table: $db.rewardClaims,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> unlockedCosmeticsRefs(
      Expression<bool> Function($$UnlockedCosmeticsTableFilterComposer f) f) {
    final $$UnlockedCosmeticsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.unlockedCosmetics,
        getReferencedColumn: (t) => t.profileId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UnlockedCosmeticsTableFilterComposer(
              $db: $db,
              $table: $db.unlockedCosmetics,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get avatarIndex => $composableBuilder(
      column: $table.avatarIndex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get stars => $composableBuilder(
      column: $table.stars, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get gems => $composableBuilder(
      column: $table.gems, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get points => $composableBuilder(
      column: $table.points, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get equippedSkinId => $composableBuilder(
      column: $table.equippedSkinId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get equippedBackgroundId => $composableBuilder(
      column: $table.equippedBackgroundId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get schoolGrade => $composableBuilder(
      column: $table.schoolGrade, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get currentLevel => $composableBuilder(
      column: $table.currentLevel,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalCompletedLevels => $composableBuilder(
      column: $table.totalCompletedLevels,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$ProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get avatarIndex => $composableBuilder(
      column: $table.avatarIndex, builder: (column) => column);

  GeneratedColumn<int> get stars =>
      $composableBuilder(column: $table.stars, builder: (column) => column);

  GeneratedColumn<int> get gems =>
      $composableBuilder(column: $table.gems, builder: (column) => column);

  GeneratedColumn<int> get points =>
      $composableBuilder(column: $table.points, builder: (column) => column);

  GeneratedColumn<String> get equippedSkinId => $composableBuilder(
      column: $table.equippedSkinId, builder: (column) => column);

  GeneratedColumn<String> get equippedBackgroundId => $composableBuilder(
      column: $table.equippedBackgroundId, builder: (column) => column);

  GeneratedColumn<int> get schoolGrade => $composableBuilder(
      column: $table.schoolGrade, builder: (column) => column);

  GeneratedColumn<int> get currentLevel => $composableBuilder(
      column: $table.currentLevel, builder: (column) => column);

  GeneratedColumn<int> get totalCompletedLevels => $composableBuilder(
      column: $table.totalCompletedLevels, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> usersRefs<T extends Object>(
      Expression<T> Function($$UsersTableAnnotationComposer a) f) {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.profileId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> studentLevelProgressRefs<T extends Object>(
      Expression<T> Function($$StudentLevelProgressTableAnnotationComposer a)
          f) {
    final $$StudentLevelProgressTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.studentLevelProgress,
            getReferencedColumn: (t) => t.profileId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$StudentLevelProgressTableAnnotationComposer(
                  $db: $db,
                  $table: $db.studentLevelProgress,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> examRecordsRefs<T extends Object>(
      Expression<T> Function($$ExamRecordsTableAnnotationComposer a) f) {
    final $$ExamRecordsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.examRecords,
        getReferencedColumn: (t) => t.profileId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExamRecordsTableAnnotationComposer(
              $db: $db,
              $table: $db.examRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> answerRecordsRefs<T extends Object>(
      Expression<T> Function($$AnswerRecordsTableAnnotationComposer a) f) {
    final $$AnswerRecordsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.answerRecords,
        getReferencedColumn: (t) => t.profileId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AnswerRecordsTableAnnotationComposer(
              $db: $db,
              $table: $db.answerRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> examTopicSelectionsRefs<T extends Object>(
      Expression<T> Function($$ExamTopicSelectionsTableAnnotationComposer a)
          f) {
    final $$ExamTopicSelectionsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.examTopicSelections,
            getReferencedColumn: (t) => t.profileId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ExamTopicSelectionsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.examTopicSelections,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> factStatsRefs<T extends Object>(
      Expression<T> Function($$FactStatsTableAnnotationComposer a) f) {
    final $$FactStatsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.factStats,
        getReferencedColumn: (t) => t.profileId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FactStatsTableAnnotationComposer(
              $db: $db,
              $table: $db.factStats,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> achievementRecordsRefs<T extends Object>(
      Expression<T> Function($$AchievementRecordsTableAnnotationComposer a) f) {
    final $$AchievementRecordsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.achievementRecords,
            getReferencedColumn: (t) => t.profileId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$AchievementRecordsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.achievementRecords,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> dailyChallengesRefs<T extends Object>(
      Expression<T> Function($$DailyChallengesTableAnnotationComposer a) f) {
    final $$DailyChallengesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.dailyChallenges,
        getReferencedColumn: (t) => t.profileId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DailyChallengesTableAnnotationComposer(
              $db: $db,
              $table: $db.dailyChallenges,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> rewardClaimsRefs<T extends Object>(
      Expression<T> Function($$RewardClaimsTableAnnotationComposer a) f) {
    final $$RewardClaimsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.rewardClaims,
        getReferencedColumn: (t) => t.profileId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RewardClaimsTableAnnotationComposer(
              $db: $db,
              $table: $db.rewardClaims,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> unlockedCosmeticsRefs<T extends Object>(
      Expression<T> Function($$UnlockedCosmeticsTableAnnotationComposer a) f) {
    final $$UnlockedCosmeticsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.unlockedCosmetics,
            getReferencedColumn: (t) => t.profileId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$UnlockedCosmeticsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.unlockedCosmetics,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$ProfilesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProfilesTable,
    Profile,
    $$ProfilesTableFilterComposer,
    $$ProfilesTableOrderingComposer,
    $$ProfilesTableAnnotationComposer,
    $$ProfilesTableCreateCompanionBuilder,
    $$ProfilesTableUpdateCompanionBuilder,
    (Profile, $$ProfilesTableReferences),
    Profile,
    PrefetchHooks Function(
        {bool usersRefs,
        bool studentLevelProgressRefs,
        bool examRecordsRefs,
        bool answerRecordsRefs,
        bool examTopicSelectionsRefs,
        bool factStatsRefs,
        bool achievementRecordsRefs,
        bool dailyChallengesRefs,
        bool rewardClaimsRefs,
        bool unlockedCosmeticsRefs})> {
  $$ProfilesTableTableManager(_$AppDatabase db, $ProfilesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> avatarIndex = const Value.absent(),
            Value<int> stars = const Value.absent(),
            Value<int> gems = const Value.absent(),
            Value<int> points = const Value.absent(),
            Value<String?> equippedSkinId = const Value.absent(),
            Value<String?> equippedBackgroundId = const Value.absent(),
            Value<int> schoolGrade = const Value.absent(),
            Value<int> currentLevel = const Value.absent(),
            Value<int> totalCompletedLevels = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProfilesCompanion(
            id: id,
            name: name,
            avatarIndex: avatarIndex,
            stars: stars,
            gems: gems,
            points: points,
            equippedSkinId: equippedSkinId,
            equippedBackgroundId: equippedBackgroundId,
            schoolGrade: schoolGrade,
            currentLevel: currentLevel,
            totalCompletedLevels: totalCompletedLevels,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<int> avatarIndex = const Value.absent(),
            Value<int> stars = const Value.absent(),
            Value<int> gems = const Value.absent(),
            Value<int> points = const Value.absent(),
            Value<String?> equippedSkinId = const Value.absent(),
            Value<String?> equippedBackgroundId = const Value.absent(),
            Value<int> schoolGrade = const Value.absent(),
            Value<int> currentLevel = const Value.absent(),
            Value<int> totalCompletedLevels = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ProfilesCompanion.insert(
            id: id,
            name: name,
            avatarIndex: avatarIndex,
            stars: stars,
            gems: gems,
            points: points,
            equippedSkinId: equippedSkinId,
            equippedBackgroundId: equippedBackgroundId,
            schoolGrade: schoolGrade,
            currentLevel: currentLevel,
            totalCompletedLevels: totalCompletedLevels,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ProfilesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {usersRefs = false,
              studentLevelProgressRefs = false,
              examRecordsRefs = false,
              answerRecordsRefs = false,
              examTopicSelectionsRefs = false,
              factStatsRefs = false,
              achievementRecordsRefs = false,
              dailyChallengesRefs = false,
              rewardClaimsRefs = false,
              unlockedCosmeticsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (usersRefs) db.users,
                if (studentLevelProgressRefs) db.studentLevelProgress,
                if (examRecordsRefs) db.examRecords,
                if (answerRecordsRefs) db.answerRecords,
                if (examTopicSelectionsRefs) db.examTopicSelections,
                if (factStatsRefs) db.factStats,
                if (achievementRecordsRefs) db.achievementRecords,
                if (dailyChallengesRefs) db.dailyChallenges,
                if (rewardClaimsRefs) db.rewardClaims,
                if (unlockedCosmeticsRefs) db.unlockedCosmetics
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (usersRefs)
                    await $_getPrefetchedData<Profile, $ProfilesTable, User>(
                        currentTable: table,
                        referencedTable:
                            $$ProfilesTableReferences._usersRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProfilesTableReferences(db, table, p0).usersRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.profileId == item.id),
                        typedResults: items),
                  if (studentLevelProgressRefs)
                    await $_getPrefetchedData<Profile, $ProfilesTable, StudentLevelProgressData>(
                        currentTable: table,
                        referencedTable: $$ProfilesTableReferences
                            ._studentLevelProgressRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProfilesTableReferences(db, table, p0)
                                .studentLevelProgressRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.profileId == item.id),
                        typedResults: items),
                  if (examRecordsRefs)
                    await $_getPrefetchedData<Profile, $ProfilesTable,
                            ExamRecord>(
                        currentTable: table,
                        referencedTable:
                            $$ProfilesTableReferences._examRecordsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProfilesTableReferences(db, table, p0)
                                .examRecordsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.profileId == item.id),
                        typedResults: items),
                  if (answerRecordsRefs)
                    await $_getPrefetchedData<Profile, $ProfilesTable,
                            AnswerRecord>(
                        currentTable: table,
                        referencedTable: $$ProfilesTableReferences
                            ._answerRecordsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProfilesTableReferences(db, table, p0)
                                .answerRecordsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.profileId == item.id),
                        typedResults: items),
                  if (examTopicSelectionsRefs)
                    await $_getPrefetchedData<Profile, $ProfilesTable,
                            ExamTopicSelection>(
                        currentTable: table,
                        referencedTable: $$ProfilesTableReferences
                            ._examTopicSelectionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProfilesTableReferences(db, table, p0)
                                .examTopicSelectionsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.profileId == item.id),
                        typedResults: items),
                  if (factStatsRefs)
                    await $_getPrefetchedData<Profile, $ProfilesTable,
                            FactStat>(
                        currentTable: table,
                        referencedTable:
                            $$ProfilesTableReferences._factStatsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProfilesTableReferences(db, table, p0)
                                .factStatsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.profileId == item.id),
                        typedResults: items),
                  if (achievementRecordsRefs)
                    await $_getPrefetchedData<Profile, $ProfilesTable,
                            AchievementRecord>(
                        currentTable: table,
                        referencedTable: $$ProfilesTableReferences
                            ._achievementRecordsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProfilesTableReferences(db, table, p0)
                                .achievementRecordsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.profileId == item.id),
                        typedResults: items),
                  if (dailyChallengesRefs)
                    await $_getPrefetchedData<Profile, $ProfilesTable,
                            DailyChallenge>(
                        currentTable: table,
                        referencedTable: $$ProfilesTableReferences
                            ._dailyChallengesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProfilesTableReferences(db, table, p0)
                                .dailyChallengesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.profileId == item.id),
                        typedResults: items),
                  if (rewardClaimsRefs)
                    await $_getPrefetchedData<Profile, $ProfilesTable,
                            RewardClaim>(
                        currentTable: table,
                        referencedTable: $$ProfilesTableReferences
                            ._rewardClaimsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProfilesTableReferences(db, table, p0)
                                .rewardClaimsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.profileId == item.id),
                        typedResults: items),
                  if (unlockedCosmeticsRefs)
                    await $_getPrefetchedData<Profile, $ProfilesTable,
                            UnlockedCosmetic>(
                        currentTable: table,
                        referencedTable: $$ProfilesTableReferences
                            ._unlockedCosmeticsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProfilesTableReferences(db, table, p0)
                                .unlockedCosmeticsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.profileId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ProfilesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProfilesTable,
    Profile,
    $$ProfilesTableFilterComposer,
    $$ProfilesTableOrderingComposer,
    $$ProfilesTableAnnotationComposer,
    $$ProfilesTableCreateCompanionBuilder,
    $$ProfilesTableUpdateCompanionBuilder,
    (Profile, $$ProfilesTableReferences),
    Profile,
    PrefetchHooks Function(
        {bool usersRefs,
        bool studentLevelProgressRefs,
        bool examRecordsRefs,
        bool answerRecordsRefs,
        bool examTopicSelectionsRefs,
        bool factStatsRefs,
        bool achievementRecordsRefs,
        bool dailyChallengesRefs,
        bool rewardClaimsRefs,
        bool unlockedCosmeticsRefs})>;
typedef $$UsersTableCreateCompanionBuilder = UsersCompanion Function({
  required String id,
  Value<String?> profileId,
  required String fullName,
  Value<String?> username,
  Value<String?> passwordHash,
  required String role,
  Value<int> avatarIndex,
  Value<bool> isActive,
  Value<String> accountType,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$UsersTableUpdateCompanionBuilder = UsersCompanion Function({
  Value<String> id,
  Value<String?> profileId,
  Value<String> fullName,
  Value<String?> username,
  Value<String?> passwordHash,
  Value<String> role,
  Value<int> avatarIndex,
  Value<bool> isActive,
  Value<String> accountType,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$UsersTableReferences
    extends BaseReferences<_$AppDatabase, $UsersTable, User> {
  $$UsersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProfilesTable _profileIdTable(_$AppDatabase db) => db.profiles
      .createAlias($_aliasNameGenerator(db.users.profileId, db.profiles.id));

  $$ProfilesTableProcessedTableManager? get profileId {
    final $_column = $_itemColumn<String>('profile_id');
    if ($_column == null) return null;
    final manager = $$ProfilesTableTableManager($_db, $_db.profiles)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fullName => $composableBuilder(
      column: $table.fullName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get passwordHash => $composableBuilder(
      column: $table.passwordHash, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get avatarIndex => $composableBuilder(
      column: $table.avatarIndex, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get accountType => $composableBuilder(
      column: $table.accountType, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$ProfilesTableFilterComposer get profileId {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.profileId,
        referencedTable: $db.profiles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProfilesTableFilterComposer(
              $db: $db,
              $table: $db.profiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fullName => $composableBuilder(
      column: $table.fullName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get passwordHash => $composableBuilder(
      column: $table.passwordHash,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get avatarIndex => $composableBuilder(
      column: $table.avatarIndex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get accountType => $composableBuilder(
      column: $table.accountType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$ProfilesTableOrderingComposer get profileId {
    final $$ProfilesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.profileId,
        referencedTable: $db.profiles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProfilesTableOrderingComposer(
              $db: $db,
              $table: $db.profiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get passwordHash => $composableBuilder(
      column: $table.passwordHash, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<int> get avatarIndex => $composableBuilder(
      column: $table.avatarIndex, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get accountType => $composableBuilder(
      column: $table.accountType, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ProfilesTableAnnotationComposer get profileId {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.profileId,
        referencedTable: $db.profiles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProfilesTableAnnotationComposer(
              $db: $db,
              $table: $db.profiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$UsersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, $$UsersTableReferences),
    User,
    PrefetchHooks Function({bool profileId})> {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> profileId = const Value.absent(),
            Value<String> fullName = const Value.absent(),
            Value<String?> username = const Value.absent(),
            Value<String?> passwordHash = const Value.absent(),
            Value<String> role = const Value.absent(),
            Value<int> avatarIndex = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<String> accountType = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UsersCompanion(
            id: id,
            profileId: profileId,
            fullName: fullName,
            username: username,
            passwordHash: passwordHash,
            role: role,
            avatarIndex: avatarIndex,
            isActive: isActive,
            accountType: accountType,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> profileId = const Value.absent(),
            required String fullName,
            Value<String?> username = const Value.absent(),
            Value<String?> passwordHash = const Value.absent(),
            required String role,
            Value<int> avatarIndex = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<String> accountType = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              UsersCompanion.insert(
            id: id,
            profileId: profileId,
            fullName: fullName,
            username: username,
            passwordHash: passwordHash,
            role: role,
            avatarIndex: avatarIndex,
            isActive: isActive,
            accountType: accountType,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$UsersTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({profileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (profileId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.profileId,
                    referencedTable: $$UsersTableReferences._profileIdTable(db),
                    referencedColumn:
                        $$UsersTableReferences._profileIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$UsersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, $$UsersTableReferences),
    User,
    PrefetchHooks Function({bool profileId})>;
typedef $$LearningLevelsTableCreateCompanionBuilder = LearningLevelsCompanion
    Function({
  Value<int> id,
  required int levelNumber,
  required String title,
  required String difficulty,
  required String topics,
  required String objectives,
  required int questionCount,
  required int passingScore,
  Value<int?> timeLimitSeconds,
  Value<bool> isActive,
});
typedef $$LearningLevelsTableUpdateCompanionBuilder = LearningLevelsCompanion
    Function({
  Value<int> id,
  Value<int> levelNumber,
  Value<String> title,
  Value<String> difficulty,
  Value<String> topics,
  Value<String> objectives,
  Value<int> questionCount,
  Value<int> passingScore,
  Value<int?> timeLimitSeconds,
  Value<bool> isActive,
});

final class $$LearningLevelsTableReferences
    extends BaseReferences<_$AppDatabase, $LearningLevelsTable, LearningLevel> {
  $$LearningLevelsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$StudentLevelProgressTable,
      List<StudentLevelProgressData>> _studentLevelProgressRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.studentLevelProgress,
          aliasName: $_aliasNameGenerator(
              db.learningLevels.id, db.studentLevelProgress.levelId));

  $$StudentLevelProgressTableProcessedTableManager
      get studentLevelProgressRefs {
    final manager =
        $$StudentLevelProgressTableTableManager($_db, $_db.studentLevelProgress)
            .filter((f) => f.levelId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_studentLevelProgressRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ExamRecordsTable, List<ExamRecord>>
      _examRecordsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.examRecords,
              aliasName: $_aliasNameGenerator(
                  db.learningLevels.id, db.examRecords.levelId));

  $$ExamRecordsTableProcessedTableManager get examRecordsRefs {
    final manager = $$ExamRecordsTableTableManager($_db, $_db.examRecords)
        .filter((f) => f.levelId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_examRecordsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$LearningLevelsTableFilterComposer
    extends Composer<_$AppDatabase, $LearningLevelsTable> {
  $$LearningLevelsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get levelNumber => $composableBuilder(
      column: $table.levelNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get topics => $composableBuilder(
      column: $table.topics, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get objectives => $composableBuilder(
      column: $table.objectives, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get questionCount => $composableBuilder(
      column: $table.questionCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get passingScore => $composableBuilder(
      column: $table.passingScore, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get timeLimitSeconds => $composableBuilder(
      column: $table.timeLimitSeconds,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  Expression<bool> studentLevelProgressRefs(
      Expression<bool> Function($$StudentLevelProgressTableFilterComposer f)
          f) {
    final $$StudentLevelProgressTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.studentLevelProgress,
        getReferencedColumn: (t) => t.levelId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StudentLevelProgressTableFilterComposer(
              $db: $db,
              $table: $db.studentLevelProgress,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> examRecordsRefs(
      Expression<bool> Function($$ExamRecordsTableFilterComposer f) f) {
    final $$ExamRecordsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.examRecords,
        getReferencedColumn: (t) => t.levelId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExamRecordsTableFilterComposer(
              $db: $db,
              $table: $db.examRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$LearningLevelsTableOrderingComposer
    extends Composer<_$AppDatabase, $LearningLevelsTable> {
  $$LearningLevelsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get levelNumber => $composableBuilder(
      column: $table.levelNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get topics => $composableBuilder(
      column: $table.topics, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get objectives => $composableBuilder(
      column: $table.objectives, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get questionCount => $composableBuilder(
      column: $table.questionCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get passingScore => $composableBuilder(
      column: $table.passingScore,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get timeLimitSeconds => $composableBuilder(
      column: $table.timeLimitSeconds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));
}

class $$LearningLevelsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LearningLevelsTable> {
  $$LearningLevelsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get levelNumber => $composableBuilder(
      column: $table.levelNumber, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => column);

  GeneratedColumn<String> get topics =>
      $composableBuilder(column: $table.topics, builder: (column) => column);

  GeneratedColumn<String> get objectives => $composableBuilder(
      column: $table.objectives, builder: (column) => column);

  GeneratedColumn<int> get questionCount => $composableBuilder(
      column: $table.questionCount, builder: (column) => column);

  GeneratedColumn<int> get passingScore => $composableBuilder(
      column: $table.passingScore, builder: (column) => column);

  GeneratedColumn<int> get timeLimitSeconds => $composableBuilder(
      column: $table.timeLimitSeconds, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  Expression<T> studentLevelProgressRefs<T extends Object>(
      Expression<T> Function($$StudentLevelProgressTableAnnotationComposer a)
          f) {
    final $$StudentLevelProgressTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.studentLevelProgress,
            getReferencedColumn: (t) => t.levelId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$StudentLevelProgressTableAnnotationComposer(
                  $db: $db,
                  $table: $db.studentLevelProgress,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> examRecordsRefs<T extends Object>(
      Expression<T> Function($$ExamRecordsTableAnnotationComposer a) f) {
    final $$ExamRecordsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.examRecords,
        getReferencedColumn: (t) => t.levelId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExamRecordsTableAnnotationComposer(
              $db: $db,
              $table: $db.examRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$LearningLevelsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LearningLevelsTable,
    LearningLevel,
    $$LearningLevelsTableFilterComposer,
    $$LearningLevelsTableOrderingComposer,
    $$LearningLevelsTableAnnotationComposer,
    $$LearningLevelsTableCreateCompanionBuilder,
    $$LearningLevelsTableUpdateCompanionBuilder,
    (LearningLevel, $$LearningLevelsTableReferences),
    LearningLevel,
    PrefetchHooks Function(
        {bool studentLevelProgressRefs, bool examRecordsRefs})> {
  $$LearningLevelsTableTableManager(
      _$AppDatabase db, $LearningLevelsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LearningLevelsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LearningLevelsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LearningLevelsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> levelNumber = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> difficulty = const Value.absent(),
            Value<String> topics = const Value.absent(),
            Value<String> objectives = const Value.absent(),
            Value<int> questionCount = const Value.absent(),
            Value<int> passingScore = const Value.absent(),
            Value<int?> timeLimitSeconds = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              LearningLevelsCompanion(
            id: id,
            levelNumber: levelNumber,
            title: title,
            difficulty: difficulty,
            topics: topics,
            objectives: objectives,
            questionCount: questionCount,
            passingScore: passingScore,
            timeLimitSeconds: timeLimitSeconds,
            isActive: isActive,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int levelNumber,
            required String title,
            required String difficulty,
            required String topics,
            required String objectives,
            required int questionCount,
            required int passingScore,
            Value<int?> timeLimitSeconds = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              LearningLevelsCompanion.insert(
            id: id,
            levelNumber: levelNumber,
            title: title,
            difficulty: difficulty,
            topics: topics,
            objectives: objectives,
            questionCount: questionCount,
            passingScore: passingScore,
            timeLimitSeconds: timeLimitSeconds,
            isActive: isActive,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$LearningLevelsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {studentLevelProgressRefs = false, examRecordsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (studentLevelProgressRefs) db.studentLevelProgress,
                if (examRecordsRefs) db.examRecords
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (studentLevelProgressRefs)
                    await $_getPrefetchedData<LearningLevel,
                            $LearningLevelsTable, StudentLevelProgressData>(
                        currentTable: table,
                        referencedTable: $$LearningLevelsTableReferences
                            ._studentLevelProgressRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$LearningLevelsTableReferences(db, table, p0)
                                .studentLevelProgressRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.levelId == item.id),
                        typedResults: items),
                  if (examRecordsRefs)
                    await $_getPrefetchedData<LearningLevel,
                            $LearningLevelsTable, ExamRecord>(
                        currentTable: table,
                        referencedTable: $$LearningLevelsTableReferences
                            ._examRecordsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$LearningLevelsTableReferences(db, table, p0)
                                .examRecordsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.levelId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$LearningLevelsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LearningLevelsTable,
    LearningLevel,
    $$LearningLevelsTableFilterComposer,
    $$LearningLevelsTableOrderingComposer,
    $$LearningLevelsTableAnnotationComposer,
    $$LearningLevelsTableCreateCompanionBuilder,
    $$LearningLevelsTableUpdateCompanionBuilder,
    (LearningLevel, $$LearningLevelsTableReferences),
    LearningLevel,
    PrefetchHooks Function(
        {bool studentLevelProgressRefs, bool examRecordsRefs})>;
typedef $$StudentLevelProgressTableCreateCompanionBuilder
    = StudentLevelProgressCompanion Function({
  Value<int> id,
  required String profileId,
  required int levelId,
  Value<String> status,
  Value<int> bestScore,
  Value<int> attemptsCount,
  Value<DateTime?> completedAt,
  required DateTime updatedAt,
});
typedef $$StudentLevelProgressTableUpdateCompanionBuilder
    = StudentLevelProgressCompanion Function({
  Value<int> id,
  Value<String> profileId,
  Value<int> levelId,
  Value<String> status,
  Value<int> bestScore,
  Value<int> attemptsCount,
  Value<DateTime?> completedAt,
  Value<DateTime> updatedAt,
});

final class $$StudentLevelProgressTableReferences extends BaseReferences<
    _$AppDatabase, $StudentLevelProgressTable, StudentLevelProgressData> {
  $$StudentLevelProgressTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.profiles.createAlias($_aliasNameGenerator(
          db.studentLevelProgress.profileId, db.profiles.id));

  $$ProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<String>('profile_id')!;

    final manager = $$ProfilesTableTableManager($_db, $_db.profiles)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $LearningLevelsTable _levelIdTable(_$AppDatabase db) =>
      db.learningLevels.createAlias($_aliasNameGenerator(
          db.studentLevelProgress.levelId, db.learningLevels.id));

  $$LearningLevelsTableProcessedTableManager get levelId {
    final $_column = $_itemColumn<int>('level_id')!;

    final manager = $$LearningLevelsTableTableManager($_db, $_db.learningLevels)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_levelIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$StudentLevelProgressTableFilterComposer
    extends Composer<_$AppDatabase, $StudentLevelProgressTable> {
  $$StudentLevelProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get bestScore => $composableBuilder(
      column: $table.bestScore, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get attemptsCount => $composableBuilder(
      column: $table.attemptsCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$ProfilesTableFilterComposer get profileId {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.profileId,
        referencedTable: $db.profiles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProfilesTableFilterComposer(
              $db: $db,
              $table: $db.profiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$LearningLevelsTableFilterComposer get levelId {
    final $$LearningLevelsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.levelId,
        referencedTable: $db.learningLevels,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LearningLevelsTableFilterComposer(
              $db: $db,
              $table: $db.learningLevels,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$StudentLevelProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $StudentLevelProgressTable> {
  $$StudentLevelProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get bestScore => $composableBuilder(
      column: $table.bestScore, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get attemptsCount => $composableBuilder(
      column: $table.attemptsCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$ProfilesTableOrderingComposer get profileId {
    final $$ProfilesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.profileId,
        referencedTable: $db.profiles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProfilesTableOrderingComposer(
              $db: $db,
              $table: $db.profiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$LearningLevelsTableOrderingComposer get levelId {
    final $$LearningLevelsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.levelId,
        referencedTable: $db.learningLevels,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LearningLevelsTableOrderingComposer(
              $db: $db,
              $table: $db.learningLevels,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$StudentLevelProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudentLevelProgressTable> {
  $$StudentLevelProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get bestScore =>
      $composableBuilder(column: $table.bestScore, builder: (column) => column);

  GeneratedColumn<int> get attemptsCount => $composableBuilder(
      column: $table.attemptsCount, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ProfilesTableAnnotationComposer get profileId {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.profileId,
        referencedTable: $db.profiles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProfilesTableAnnotationComposer(
              $db: $db,
              $table: $db.profiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$LearningLevelsTableAnnotationComposer get levelId {
    final $$LearningLevelsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.levelId,
        referencedTable: $db.learningLevels,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LearningLevelsTableAnnotationComposer(
              $db: $db,
              $table: $db.learningLevels,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$StudentLevelProgressTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StudentLevelProgressTable,
    StudentLevelProgressData,
    $$StudentLevelProgressTableFilterComposer,
    $$StudentLevelProgressTableOrderingComposer,
    $$StudentLevelProgressTableAnnotationComposer,
    $$StudentLevelProgressTableCreateCompanionBuilder,
    $$StudentLevelProgressTableUpdateCompanionBuilder,
    (StudentLevelProgressData, $$StudentLevelProgressTableReferences),
    StudentLevelProgressData,
    PrefetchHooks Function({bool profileId, bool levelId})> {
  $$StudentLevelProgressTableTableManager(
      _$AppDatabase db, $StudentLevelProgressTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudentLevelProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudentLevelProgressTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudentLevelProgressTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> profileId = const Value.absent(),
            Value<int> levelId = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> bestScore = const Value.absent(),
            Value<int> attemptsCount = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              StudentLevelProgressCompanion(
            id: id,
            profileId: profileId,
            levelId: levelId,
            status: status,
            bestScore: bestScore,
            attemptsCount: attemptsCount,
            completedAt: completedAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String profileId,
            required int levelId,
            Value<String> status = const Value.absent(),
            Value<int> bestScore = const Value.absent(),
            Value<int> attemptsCount = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            required DateTime updatedAt,
          }) =>
              StudentLevelProgressCompanion.insert(
            id: id,
            profileId: profileId,
            levelId: levelId,
            status: status,
            bestScore: bestScore,
            attemptsCount: attemptsCount,
            completedAt: completedAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$StudentLevelProgressTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({profileId = false, levelId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (profileId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.profileId,
                    referencedTable: $$StudentLevelProgressTableReferences
                        ._profileIdTable(db),
                    referencedColumn: $$StudentLevelProgressTableReferences
                        ._profileIdTable(db)
                        .id,
                  ) as T;
                }
                if (levelId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.levelId,
                    referencedTable:
                        $$StudentLevelProgressTableReferences._levelIdTable(db),
                    referencedColumn: $$StudentLevelProgressTableReferences
                        ._levelIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$StudentLevelProgressTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $StudentLevelProgressTable,
        StudentLevelProgressData,
        $$StudentLevelProgressTableFilterComposer,
        $$StudentLevelProgressTableOrderingComposer,
        $$StudentLevelProgressTableAnnotationComposer,
        $$StudentLevelProgressTableCreateCompanionBuilder,
        $$StudentLevelProgressTableUpdateCompanionBuilder,
        (StudentLevelProgressData, $$StudentLevelProgressTableReferences),
        StudentLevelProgressData,
        PrefetchHooks Function({bool profileId, bool levelId})>;
typedef $$ExamRecordsTableCreateCompanionBuilder = ExamRecordsCompanion
    Function({
  Value<int> id,
  required String sessionId,
  required String profileId,
  Value<int?> levelId,
  required String section,
  required String title,
  required String difficulty,
  required String answerMode,
  required String source,
  required int total,
  required int correct,
  required int wrong,
  required int unanswered,
  required int starsEarned,
  required int gemsEarned,
  required int pointsEarned,
  required int durationSeconds,
  Value<DateTime?> startedAt,
  required DateTime createdAt,
  Value<String> status,
  Value<String?> dailyDateKey,
});
typedef $$ExamRecordsTableUpdateCompanionBuilder = ExamRecordsCompanion
    Function({
  Value<int> id,
  Value<String> sessionId,
  Value<String> profileId,
  Value<int?> levelId,
  Value<String> section,
  Value<String> title,
  Value<String> difficulty,
  Value<String> answerMode,
  Value<String> source,
  Value<int> total,
  Value<int> correct,
  Value<int> wrong,
  Value<int> unanswered,
  Value<int> starsEarned,
  Value<int> gemsEarned,
  Value<int> pointsEarned,
  Value<int> durationSeconds,
  Value<DateTime?> startedAt,
  Value<DateTime> createdAt,
  Value<String> status,
  Value<String?> dailyDateKey,
});

final class $$ExamRecordsTableReferences
    extends BaseReferences<_$AppDatabase, $ExamRecordsTable, ExamRecord> {
  $$ExamRecordsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.profiles.createAlias(
          $_aliasNameGenerator(db.examRecords.profileId, db.profiles.id));

  $$ProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<String>('profile_id')!;

    final manager = $$ProfilesTableTableManager($_db, $_db.profiles)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $LearningLevelsTable _levelIdTable(_$AppDatabase db) =>
      db.learningLevels.createAlias(
          $_aliasNameGenerator(db.examRecords.levelId, db.learningLevels.id));

  $$LearningLevelsTableProcessedTableManager? get levelId {
    final $_column = $_itemColumn<int>('level_id');
    if ($_column == null) return null;
    final manager = $$LearningLevelsTableTableManager($_db, $_db.learningLevels)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_levelIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$AnswerRecordsTable, List<AnswerRecord>>
      _answerRecordsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.answerRecords,
              aliasName: $_aliasNameGenerator(
                  db.examRecords.id, db.answerRecords.examId));

  $$AnswerRecordsTableProcessedTableManager get answerRecordsRefs {
    final manager = $$AnswerRecordsTableTableManager($_db, $_db.answerRecords)
        .filter((f) => f.examId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_answerRecordsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ExamRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $ExamRecordsTable> {
  $$ExamRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sessionId => $composableBuilder(
      column: $table.sessionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get section => $composableBuilder(
      column: $table.section, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get answerMode => $composableBuilder(
      column: $table.answerMode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get total => $composableBuilder(
      column: $table.total, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get correct => $composableBuilder(
      column: $table.correct, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get wrong => $composableBuilder(
      column: $table.wrong, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get unanswered => $composableBuilder(
      column: $table.unanswered, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get starsEarned => $composableBuilder(
      column: $table.starsEarned, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get gemsEarned => $composableBuilder(
      column: $table.gemsEarned, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get pointsEarned => $composableBuilder(
      column: $table.pointsEarned, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dailyDateKey => $composableBuilder(
      column: $table.dailyDateKey, builder: (column) => ColumnFilters(column));

  $$ProfilesTableFilterComposer get profileId {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.profileId,
        referencedTable: $db.profiles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProfilesTableFilterComposer(
              $db: $db,
              $table: $db.profiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$LearningLevelsTableFilterComposer get levelId {
    final $$LearningLevelsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.levelId,
        referencedTable: $db.learningLevels,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LearningLevelsTableFilterComposer(
              $db: $db,
              $table: $db.learningLevels,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> answerRecordsRefs(
      Expression<bool> Function($$AnswerRecordsTableFilterComposer f) f) {
    final $$AnswerRecordsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.answerRecords,
        getReferencedColumn: (t) => t.examId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AnswerRecordsTableFilterComposer(
              $db: $db,
              $table: $db.answerRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ExamRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $ExamRecordsTable> {
  $$ExamRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sessionId => $composableBuilder(
      column: $table.sessionId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get section => $composableBuilder(
      column: $table.section, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get answerMode => $composableBuilder(
      column: $table.answerMode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get total => $composableBuilder(
      column: $table.total, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get correct => $composableBuilder(
      column: $table.correct, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get wrong => $composableBuilder(
      column: $table.wrong, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get unanswered => $composableBuilder(
      column: $table.unanswered, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get starsEarned => $composableBuilder(
      column: $table.starsEarned, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get gemsEarned => $composableBuilder(
      column: $table.gemsEarned, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get pointsEarned => $composableBuilder(
      column: $table.pointsEarned,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dailyDateKey => $composableBuilder(
      column: $table.dailyDateKey,
      builder: (column) => ColumnOrderings(column));

  $$ProfilesTableOrderingComposer get profileId {
    final $$ProfilesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.profileId,
        referencedTable: $db.profiles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProfilesTableOrderingComposer(
              $db: $db,
              $table: $db.profiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$LearningLevelsTableOrderingComposer get levelId {
    final $$LearningLevelsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.levelId,
        referencedTable: $db.learningLevels,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LearningLevelsTableOrderingComposer(
              $db: $db,
              $table: $db.learningLevels,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ExamRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExamRecordsTable> {
  $$ExamRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<String> get section =>
      $composableBuilder(column: $table.section, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => column);

  GeneratedColumn<String> get answerMode => $composableBuilder(
      column: $table.answerMode, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<int> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<int> get correct =>
      $composableBuilder(column: $table.correct, builder: (column) => column);

  GeneratedColumn<int> get wrong =>
      $composableBuilder(column: $table.wrong, builder: (column) => column);

  GeneratedColumn<int> get unanswered => $composableBuilder(
      column: $table.unanswered, builder: (column) => column);

  GeneratedColumn<int> get starsEarned => $composableBuilder(
      column: $table.starsEarned, builder: (column) => column);

  GeneratedColumn<int> get gemsEarned => $composableBuilder(
      column: $table.gemsEarned, builder: (column) => column);

  GeneratedColumn<int> get pointsEarned => $composableBuilder(
      column: $table.pointsEarned, builder: (column) => column);

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get dailyDateKey => $composableBuilder(
      column: $table.dailyDateKey, builder: (column) => column);

  $$ProfilesTableAnnotationComposer get profileId {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.profileId,
        referencedTable: $db.profiles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProfilesTableAnnotationComposer(
              $db: $db,
              $table: $db.profiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$LearningLevelsTableAnnotationComposer get levelId {
    final $$LearningLevelsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.levelId,
        referencedTable: $db.learningLevels,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LearningLevelsTableAnnotationComposer(
              $db: $db,
              $table: $db.learningLevels,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> answerRecordsRefs<T extends Object>(
      Expression<T> Function($$AnswerRecordsTableAnnotationComposer a) f) {
    final $$AnswerRecordsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.answerRecords,
        getReferencedColumn: (t) => t.examId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AnswerRecordsTableAnnotationComposer(
              $db: $db,
              $table: $db.answerRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ExamRecordsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExamRecordsTable,
    ExamRecord,
    $$ExamRecordsTableFilterComposer,
    $$ExamRecordsTableOrderingComposer,
    $$ExamRecordsTableAnnotationComposer,
    $$ExamRecordsTableCreateCompanionBuilder,
    $$ExamRecordsTableUpdateCompanionBuilder,
    (ExamRecord, $$ExamRecordsTableReferences),
    ExamRecord,
    PrefetchHooks Function(
        {bool profileId, bool levelId, bool answerRecordsRefs})> {
  $$ExamRecordsTableTableManager(_$AppDatabase db, $ExamRecordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExamRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExamRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExamRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> sessionId = const Value.absent(),
            Value<String> profileId = const Value.absent(),
            Value<int?> levelId = const Value.absent(),
            Value<String> section = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> difficulty = const Value.absent(),
            Value<String> answerMode = const Value.absent(),
            Value<String> source = const Value.absent(),
            Value<int> total = const Value.absent(),
            Value<int> correct = const Value.absent(),
            Value<int> wrong = const Value.absent(),
            Value<int> unanswered = const Value.absent(),
            Value<int> starsEarned = const Value.absent(),
            Value<int> gemsEarned = const Value.absent(),
            Value<int> pointsEarned = const Value.absent(),
            Value<int> durationSeconds = const Value.absent(),
            Value<DateTime?> startedAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> dailyDateKey = const Value.absent(),
          }) =>
              ExamRecordsCompanion(
            id: id,
            sessionId: sessionId,
            profileId: profileId,
            levelId: levelId,
            section: section,
            title: title,
            difficulty: difficulty,
            answerMode: answerMode,
            source: source,
            total: total,
            correct: correct,
            wrong: wrong,
            unanswered: unanswered,
            starsEarned: starsEarned,
            gemsEarned: gemsEarned,
            pointsEarned: pointsEarned,
            durationSeconds: durationSeconds,
            startedAt: startedAt,
            createdAt: createdAt,
            status: status,
            dailyDateKey: dailyDateKey,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String sessionId,
            required String profileId,
            Value<int?> levelId = const Value.absent(),
            required String section,
            required String title,
            required String difficulty,
            required String answerMode,
            required String source,
            required int total,
            required int correct,
            required int wrong,
            required int unanswered,
            required int starsEarned,
            required int gemsEarned,
            required int pointsEarned,
            required int durationSeconds,
            Value<DateTime?> startedAt = const Value.absent(),
            required DateTime createdAt,
            Value<String> status = const Value.absent(),
            Value<String?> dailyDateKey = const Value.absent(),
          }) =>
              ExamRecordsCompanion.insert(
            id: id,
            sessionId: sessionId,
            profileId: profileId,
            levelId: levelId,
            section: section,
            title: title,
            difficulty: difficulty,
            answerMode: answerMode,
            source: source,
            total: total,
            correct: correct,
            wrong: wrong,
            unanswered: unanswered,
            starsEarned: starsEarned,
            gemsEarned: gemsEarned,
            pointsEarned: pointsEarned,
            durationSeconds: durationSeconds,
            startedAt: startedAt,
            createdAt: createdAt,
            status: status,
            dailyDateKey: dailyDateKey,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ExamRecordsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {profileId = false, levelId = false, answerRecordsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (answerRecordsRefs) db.answerRecords
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (profileId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.profileId,
                    referencedTable:
                        $$ExamRecordsTableReferences._profileIdTable(db),
                    referencedColumn:
                        $$ExamRecordsTableReferences._profileIdTable(db).id,
                  ) as T;
                }
                if (levelId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.levelId,
                    referencedTable:
                        $$ExamRecordsTableReferences._levelIdTable(db),
                    referencedColumn:
                        $$ExamRecordsTableReferences._levelIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (answerRecordsRefs)
                    await $_getPrefetchedData<ExamRecord, $ExamRecordsTable,
                            AnswerRecord>(
                        currentTable: table,
                        referencedTable: $$ExamRecordsTableReferences
                            ._answerRecordsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ExamRecordsTableReferences(db, table, p0)
                                .answerRecordsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.examId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ExamRecordsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExamRecordsTable,
    ExamRecord,
    $$ExamRecordsTableFilterComposer,
    $$ExamRecordsTableOrderingComposer,
    $$ExamRecordsTableAnnotationComposer,
    $$ExamRecordsTableCreateCompanionBuilder,
    $$ExamRecordsTableUpdateCompanionBuilder,
    (ExamRecord, $$ExamRecordsTableReferences),
    ExamRecord,
    PrefetchHooks Function(
        {bool profileId, bool levelId, bool answerRecordsRefs})>;
typedef $$AnswerRecordsTableCreateCompanionBuilder = AnswerRecordsCompanion
    Function({
  Value<int> id,
  required int examId,
  required String profileId,
  required String section,
  required String questionKind,
  Value<String?> factKey,
  required String questionText,
  Value<String?> childAnswer,
  required String correctAnswer,
  required bool isCorrect,
  required String explanation,
  Value<int> timeSpentSeconds,
  Value<String?> topicId,
});
typedef $$AnswerRecordsTableUpdateCompanionBuilder = AnswerRecordsCompanion
    Function({
  Value<int> id,
  Value<int> examId,
  Value<String> profileId,
  Value<String> section,
  Value<String> questionKind,
  Value<String?> factKey,
  Value<String> questionText,
  Value<String?> childAnswer,
  Value<String> correctAnswer,
  Value<bool> isCorrect,
  Value<String> explanation,
  Value<int> timeSpentSeconds,
  Value<String?> topicId,
});

final class $$AnswerRecordsTableReferences
    extends BaseReferences<_$AppDatabase, $AnswerRecordsTable, AnswerRecord> {
  $$AnswerRecordsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ExamRecordsTable _examIdTable(_$AppDatabase db) =>
      db.examRecords.createAlias(
          $_aliasNameGenerator(db.answerRecords.examId, db.examRecords.id));

  $$ExamRecordsTableProcessedTableManager get examId {
    final $_column = $_itemColumn<int>('exam_id')!;

    final manager = $$ExamRecordsTableTableManager($_db, $_db.examRecords)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_examIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.profiles.createAlias(
          $_aliasNameGenerator(db.answerRecords.profileId, db.profiles.id));

  $$ProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<String>('profile_id')!;

    final manager = $$ProfilesTableTableManager($_db, $_db.profiles)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$AnswerRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $AnswerRecordsTable> {
  $$AnswerRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get section => $composableBuilder(
      column: $table.section, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get questionKind => $composableBuilder(
      column: $table.questionKind, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get factKey => $composableBuilder(
      column: $table.factKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get questionText => $composableBuilder(
      column: $table.questionText, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get childAnswer => $composableBuilder(
      column: $table.childAnswer, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get correctAnswer => $composableBuilder(
      column: $table.correctAnswer, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCorrect => $composableBuilder(
      column: $table.isCorrect, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get explanation => $composableBuilder(
      column: $table.explanation, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get timeSpentSeconds => $composableBuilder(
      column: $table.timeSpentSeconds,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get topicId => $composableBuilder(
      column: $table.topicId, builder: (column) => ColumnFilters(column));

  $$ExamRecordsTableFilterComposer get examId {
    final $$ExamRecordsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.examId,
        referencedTable: $db.examRecords,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExamRecordsTableFilterComposer(
              $db: $db,
              $table: $db.examRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ProfilesTableFilterComposer get profileId {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.profileId,
        referencedTable: $db.profiles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProfilesTableFilterComposer(
              $db: $db,
              $table: $db.profiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AnswerRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $AnswerRecordsTable> {
  $$AnswerRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get section => $composableBuilder(
      column: $table.section, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get questionKind => $composableBuilder(
      column: $table.questionKind,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get factKey => $composableBuilder(
      column: $table.factKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get questionText => $composableBuilder(
      column: $table.questionText,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get childAnswer => $composableBuilder(
      column: $table.childAnswer, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get correctAnswer => $composableBuilder(
      column: $table.correctAnswer,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCorrect => $composableBuilder(
      column: $table.isCorrect, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get explanation => $composableBuilder(
      column: $table.explanation, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get timeSpentSeconds => $composableBuilder(
      column: $table.timeSpentSeconds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get topicId => $composableBuilder(
      column: $table.topicId, builder: (column) => ColumnOrderings(column));

  $$ExamRecordsTableOrderingComposer get examId {
    final $$ExamRecordsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.examId,
        referencedTable: $db.examRecords,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExamRecordsTableOrderingComposer(
              $db: $db,
              $table: $db.examRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ProfilesTableOrderingComposer get profileId {
    final $$ProfilesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.profileId,
        referencedTable: $db.profiles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProfilesTableOrderingComposer(
              $db: $db,
              $table: $db.profiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AnswerRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AnswerRecordsTable> {
  $$AnswerRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get section =>
      $composableBuilder(column: $table.section, builder: (column) => column);

  GeneratedColumn<String> get questionKind => $composableBuilder(
      column: $table.questionKind, builder: (column) => column);

  GeneratedColumn<String> get factKey =>
      $composableBuilder(column: $table.factKey, builder: (column) => column);

  GeneratedColumn<String> get questionText => $composableBuilder(
      column: $table.questionText, builder: (column) => column);

  GeneratedColumn<String> get childAnswer => $composableBuilder(
      column: $table.childAnswer, builder: (column) => column);

  GeneratedColumn<String> get correctAnswer => $composableBuilder(
      column: $table.correctAnswer, builder: (column) => column);

  GeneratedColumn<bool> get isCorrect =>
      $composableBuilder(column: $table.isCorrect, builder: (column) => column);

  GeneratedColumn<String> get explanation => $composableBuilder(
      column: $table.explanation, builder: (column) => column);

  GeneratedColumn<int> get timeSpentSeconds => $composableBuilder(
      column: $table.timeSpentSeconds, builder: (column) => column);

  GeneratedColumn<String> get topicId =>
      $composableBuilder(column: $table.topicId, builder: (column) => column);

  $$ExamRecordsTableAnnotationComposer get examId {
    final $$ExamRecordsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.examId,
        referencedTable: $db.examRecords,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExamRecordsTableAnnotationComposer(
              $db: $db,
              $table: $db.examRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ProfilesTableAnnotationComposer get profileId {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.profileId,
        referencedTable: $db.profiles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProfilesTableAnnotationComposer(
              $db: $db,
              $table: $db.profiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AnswerRecordsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AnswerRecordsTable,
    AnswerRecord,
    $$AnswerRecordsTableFilterComposer,
    $$AnswerRecordsTableOrderingComposer,
    $$AnswerRecordsTableAnnotationComposer,
    $$AnswerRecordsTableCreateCompanionBuilder,
    $$AnswerRecordsTableUpdateCompanionBuilder,
    (AnswerRecord, $$AnswerRecordsTableReferences),
    AnswerRecord,
    PrefetchHooks Function({bool examId, bool profileId})> {
  $$AnswerRecordsTableTableManager(_$AppDatabase db, $AnswerRecordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AnswerRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AnswerRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AnswerRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> examId = const Value.absent(),
            Value<String> profileId = const Value.absent(),
            Value<String> section = const Value.absent(),
            Value<String> questionKind = const Value.absent(),
            Value<String?> factKey = const Value.absent(),
            Value<String> questionText = const Value.absent(),
            Value<String?> childAnswer = const Value.absent(),
            Value<String> correctAnswer = const Value.absent(),
            Value<bool> isCorrect = const Value.absent(),
            Value<String> explanation = const Value.absent(),
            Value<int> timeSpentSeconds = const Value.absent(),
            Value<String?> topicId = const Value.absent(),
          }) =>
              AnswerRecordsCompanion(
            id: id,
            examId: examId,
            profileId: profileId,
            section: section,
            questionKind: questionKind,
            factKey: factKey,
            questionText: questionText,
            childAnswer: childAnswer,
            correctAnswer: correctAnswer,
            isCorrect: isCorrect,
            explanation: explanation,
            timeSpentSeconds: timeSpentSeconds,
            topicId: topicId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int examId,
            required String profileId,
            required String section,
            required String questionKind,
            Value<String?> factKey = const Value.absent(),
            required String questionText,
            Value<String?> childAnswer = const Value.absent(),
            required String correctAnswer,
            required bool isCorrect,
            required String explanation,
            Value<int> timeSpentSeconds = const Value.absent(),
            Value<String?> topicId = const Value.absent(),
          }) =>
              AnswerRecordsCompanion.insert(
            id: id,
            examId: examId,
            profileId: profileId,
            section: section,
            questionKind: questionKind,
            factKey: factKey,
            questionText: questionText,
            childAnswer: childAnswer,
            correctAnswer: correctAnswer,
            isCorrect: isCorrect,
            explanation: explanation,
            timeSpentSeconds: timeSpentSeconds,
            topicId: topicId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$AnswerRecordsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({examId = false, profileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (examId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.examId,
                    referencedTable:
                        $$AnswerRecordsTableReferences._examIdTable(db),
                    referencedColumn:
                        $$AnswerRecordsTableReferences._examIdTable(db).id,
                  ) as T;
                }
                if (profileId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.profileId,
                    referencedTable:
                        $$AnswerRecordsTableReferences._profileIdTable(db),
                    referencedColumn:
                        $$AnswerRecordsTableReferences._profileIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$AnswerRecordsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AnswerRecordsTable,
    AnswerRecord,
    $$AnswerRecordsTableFilterComposer,
    $$AnswerRecordsTableOrderingComposer,
    $$AnswerRecordsTableAnnotationComposer,
    $$AnswerRecordsTableCreateCompanionBuilder,
    $$AnswerRecordsTableUpdateCompanionBuilder,
    (AnswerRecord, $$AnswerRecordsTableReferences),
    AnswerRecord,
    PrefetchHooks Function({bool examId, bool profileId})>;
typedef $$CurriculumTopicsTableCreateCompanionBuilder
    = CurriculumTopicsCompanion Function({
  required String id,
  required int grade,
  required int part,
  required String title,
  required String unitName,
  Value<int?> pageReference,
  Value<bool> generationReady,
  Value<int> rowid,
});
typedef $$CurriculumTopicsTableUpdateCompanionBuilder
    = CurriculumTopicsCompanion Function({
  Value<String> id,
  Value<int> grade,
  Value<int> part,
  Value<String> title,
  Value<String> unitName,
  Value<int?> pageReference,
  Value<bool> generationReady,
  Value<int> rowid,
});

class $$CurriculumTopicsTableFilterComposer
    extends Composer<_$AppDatabase, $CurriculumTopicsTable> {
  $$CurriculumTopicsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get grade => $composableBuilder(
      column: $table.grade, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get part => $composableBuilder(
      column: $table.part, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unitName => $composableBuilder(
      column: $table.unitName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get pageReference => $composableBuilder(
      column: $table.pageReference, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get generationReady => $composableBuilder(
      column: $table.generationReady,
      builder: (column) => ColumnFilters(column));
}

class $$CurriculumTopicsTableOrderingComposer
    extends Composer<_$AppDatabase, $CurriculumTopicsTable> {
  $$CurriculumTopicsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get grade => $composableBuilder(
      column: $table.grade, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get part => $composableBuilder(
      column: $table.part, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unitName => $composableBuilder(
      column: $table.unitName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get pageReference => $composableBuilder(
      column: $table.pageReference,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get generationReady => $composableBuilder(
      column: $table.generationReady,
      builder: (column) => ColumnOrderings(column));
}

class $$CurriculumTopicsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CurriculumTopicsTable> {
  $$CurriculumTopicsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get grade =>
      $composableBuilder(column: $table.grade, builder: (column) => column);

  GeneratedColumn<int> get part =>
      $composableBuilder(column: $table.part, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get unitName =>
      $composableBuilder(column: $table.unitName, builder: (column) => column);

  GeneratedColumn<int> get pageReference => $composableBuilder(
      column: $table.pageReference, builder: (column) => column);

  GeneratedColumn<bool> get generationReady => $composableBuilder(
      column: $table.generationReady, builder: (column) => column);
}

class $$CurriculumTopicsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CurriculumTopicsTable,
    CurriculumTopic,
    $$CurriculumTopicsTableFilterComposer,
    $$CurriculumTopicsTableOrderingComposer,
    $$CurriculumTopicsTableAnnotationComposer,
    $$CurriculumTopicsTableCreateCompanionBuilder,
    $$CurriculumTopicsTableUpdateCompanionBuilder,
    (
      CurriculumTopic,
      BaseReferences<_$AppDatabase, $CurriculumTopicsTable, CurriculumTopic>
    ),
    CurriculumTopic,
    PrefetchHooks Function()> {
  $$CurriculumTopicsTableTableManager(
      _$AppDatabase db, $CurriculumTopicsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CurriculumTopicsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CurriculumTopicsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CurriculumTopicsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<int> grade = const Value.absent(),
            Value<int> part = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> unitName = const Value.absent(),
            Value<int?> pageReference = const Value.absent(),
            Value<bool> generationReady = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CurriculumTopicsCompanion(
            id: id,
            grade: grade,
            part: part,
            title: title,
            unitName: unitName,
            pageReference: pageReference,
            generationReady: generationReady,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required int grade,
            required int part,
            required String title,
            required String unitName,
            Value<int?> pageReference = const Value.absent(),
            Value<bool> generationReady = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CurriculumTopicsCompanion.insert(
            id: id,
            grade: grade,
            part: part,
            title: title,
            unitName: unitName,
            pageReference: pageReference,
            generationReady: generationReady,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CurriculumTopicsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CurriculumTopicsTable,
    CurriculumTopic,
    $$CurriculumTopicsTableFilterComposer,
    $$CurriculumTopicsTableOrderingComposer,
    $$CurriculumTopicsTableAnnotationComposer,
    $$CurriculumTopicsTableCreateCompanionBuilder,
    $$CurriculumTopicsTableUpdateCompanionBuilder,
    (
      CurriculumTopic,
      BaseReferences<_$AppDatabase, $CurriculumTopicsTable, CurriculumTopic>
    ),
    CurriculumTopic,
    PrefetchHooks Function()>;
typedef $$ExamTopicSelectionsTableCreateCompanionBuilder
    = ExamTopicSelectionsCompanion Function({
  required String profileId,
  required int grade,
  required int part,
  required String topicIds,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$ExamTopicSelectionsTableUpdateCompanionBuilder
    = ExamTopicSelectionsCompanion Function({
  Value<String> profileId,
  Value<int> grade,
  Value<int> part,
  Value<String> topicIds,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$ExamTopicSelectionsTableReferences extends BaseReferences<
    _$AppDatabase, $ExamTopicSelectionsTable, ExamTopicSelection> {
  $$ExamTopicSelectionsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.profiles.createAlias($_aliasNameGenerator(
          db.examTopicSelections.profileId, db.profiles.id));

  $$ProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<String>('profile_id')!;

    final manager = $$ProfilesTableTableManager($_db, $_db.profiles)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ExamTopicSelectionsTableFilterComposer
    extends Composer<_$AppDatabase, $ExamTopicSelectionsTable> {
  $$ExamTopicSelectionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get grade => $composableBuilder(
      column: $table.grade, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get part => $composableBuilder(
      column: $table.part, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get topicIds => $composableBuilder(
      column: $table.topicIds, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$ProfilesTableFilterComposer get profileId {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.profileId,
        referencedTable: $db.profiles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProfilesTableFilterComposer(
              $db: $db,
              $table: $db.profiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ExamTopicSelectionsTableOrderingComposer
    extends Composer<_$AppDatabase, $ExamTopicSelectionsTable> {
  $$ExamTopicSelectionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get grade => $composableBuilder(
      column: $table.grade, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get part => $composableBuilder(
      column: $table.part, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get topicIds => $composableBuilder(
      column: $table.topicIds, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$ProfilesTableOrderingComposer get profileId {
    final $$ProfilesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.profileId,
        referencedTable: $db.profiles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProfilesTableOrderingComposer(
              $db: $db,
              $table: $db.profiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ExamTopicSelectionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExamTopicSelectionsTable> {
  $$ExamTopicSelectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get grade =>
      $composableBuilder(column: $table.grade, builder: (column) => column);

  GeneratedColumn<int> get part =>
      $composableBuilder(column: $table.part, builder: (column) => column);

  GeneratedColumn<String> get topicIds =>
      $composableBuilder(column: $table.topicIds, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ProfilesTableAnnotationComposer get profileId {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.profileId,
        referencedTable: $db.profiles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProfilesTableAnnotationComposer(
              $db: $db,
              $table: $db.profiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ExamTopicSelectionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExamTopicSelectionsTable,
    ExamTopicSelection,
    $$ExamTopicSelectionsTableFilterComposer,
    $$ExamTopicSelectionsTableOrderingComposer,
    $$ExamTopicSelectionsTableAnnotationComposer,
    $$ExamTopicSelectionsTableCreateCompanionBuilder,
    $$ExamTopicSelectionsTableUpdateCompanionBuilder,
    (ExamTopicSelection, $$ExamTopicSelectionsTableReferences),
    ExamTopicSelection,
    PrefetchHooks Function({bool profileId})> {
  $$ExamTopicSelectionsTableTableManager(
      _$AppDatabase db, $ExamTopicSelectionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExamTopicSelectionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExamTopicSelectionsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExamTopicSelectionsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> profileId = const Value.absent(),
            Value<int> grade = const Value.absent(),
            Value<int> part = const Value.absent(),
            Value<String> topicIds = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExamTopicSelectionsCompanion(
            profileId: profileId,
            grade: grade,
            part: part,
            topicIds: topicIds,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String profileId,
            required int grade,
            required int part,
            required String topicIds,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ExamTopicSelectionsCompanion.insert(
            profileId: profileId,
            grade: grade,
            part: part,
            topicIds: topicIds,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ExamTopicSelectionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({profileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (profileId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.profileId,
                    referencedTable: $$ExamTopicSelectionsTableReferences
                        ._profileIdTable(db),
                    referencedColumn: $$ExamTopicSelectionsTableReferences
                        ._profileIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ExamTopicSelectionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExamTopicSelectionsTable,
    ExamTopicSelection,
    $$ExamTopicSelectionsTableFilterComposer,
    $$ExamTopicSelectionsTableOrderingComposer,
    $$ExamTopicSelectionsTableAnnotationComposer,
    $$ExamTopicSelectionsTableCreateCompanionBuilder,
    $$ExamTopicSelectionsTableUpdateCompanionBuilder,
    (ExamTopicSelection, $$ExamTopicSelectionsTableReferences),
    ExamTopicSelection,
    PrefetchHooks Function({bool profileId})>;
typedef $$FactStatsTableCreateCompanionBuilder = FactStatsCompanion Function({
  required String profileId,
  required String section,
  required String factKey,
  Value<int> attempts,
  Value<int> correct,
  required DateTime lastSeen,
  Value<int> rowid,
});
typedef $$FactStatsTableUpdateCompanionBuilder = FactStatsCompanion Function({
  Value<String> profileId,
  Value<String> section,
  Value<String> factKey,
  Value<int> attempts,
  Value<int> correct,
  Value<DateTime> lastSeen,
  Value<int> rowid,
});

final class $$FactStatsTableReferences
    extends BaseReferences<_$AppDatabase, $FactStatsTable, FactStat> {
  $$FactStatsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.profiles.createAlias(
          $_aliasNameGenerator(db.factStats.profileId, db.profiles.id));

  $$ProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<String>('profile_id')!;

    final manager = $$ProfilesTableTableManager($_db, $_db.profiles)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$FactStatsTableFilterComposer
    extends Composer<_$AppDatabase, $FactStatsTable> {
  $$FactStatsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get section => $composableBuilder(
      column: $table.section, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get factKey => $composableBuilder(
      column: $table.factKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get attempts => $composableBuilder(
      column: $table.attempts, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get correct => $composableBuilder(
      column: $table.correct, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastSeen => $composableBuilder(
      column: $table.lastSeen, builder: (column) => ColumnFilters(column));

  $$ProfilesTableFilterComposer get profileId {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.profileId,
        referencedTable: $db.profiles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProfilesTableFilterComposer(
              $db: $db,
              $table: $db.profiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$FactStatsTableOrderingComposer
    extends Composer<_$AppDatabase, $FactStatsTable> {
  $$FactStatsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get section => $composableBuilder(
      column: $table.section, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get factKey => $composableBuilder(
      column: $table.factKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get attempts => $composableBuilder(
      column: $table.attempts, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get correct => $composableBuilder(
      column: $table.correct, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastSeen => $composableBuilder(
      column: $table.lastSeen, builder: (column) => ColumnOrderings(column));

  $$ProfilesTableOrderingComposer get profileId {
    final $$ProfilesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.profileId,
        referencedTable: $db.profiles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProfilesTableOrderingComposer(
              $db: $db,
              $table: $db.profiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$FactStatsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FactStatsTable> {
  $$FactStatsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get section =>
      $composableBuilder(column: $table.section, builder: (column) => column);

  GeneratedColumn<String> get factKey =>
      $composableBuilder(column: $table.factKey, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<int> get correct =>
      $composableBuilder(column: $table.correct, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSeen =>
      $composableBuilder(column: $table.lastSeen, builder: (column) => column);

  $$ProfilesTableAnnotationComposer get profileId {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.profileId,
        referencedTable: $db.profiles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProfilesTableAnnotationComposer(
              $db: $db,
              $table: $db.profiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$FactStatsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FactStatsTable,
    FactStat,
    $$FactStatsTableFilterComposer,
    $$FactStatsTableOrderingComposer,
    $$FactStatsTableAnnotationComposer,
    $$FactStatsTableCreateCompanionBuilder,
    $$FactStatsTableUpdateCompanionBuilder,
    (FactStat, $$FactStatsTableReferences),
    FactStat,
    PrefetchHooks Function({bool profileId})> {
  $$FactStatsTableTableManager(_$AppDatabase db, $FactStatsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FactStatsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FactStatsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FactStatsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> profileId = const Value.absent(),
            Value<String> section = const Value.absent(),
            Value<String> factKey = const Value.absent(),
            Value<int> attempts = const Value.absent(),
            Value<int> correct = const Value.absent(),
            Value<DateTime> lastSeen = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FactStatsCompanion(
            profileId: profileId,
            section: section,
            factKey: factKey,
            attempts: attempts,
            correct: correct,
            lastSeen: lastSeen,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String profileId,
            required String section,
            required String factKey,
            Value<int> attempts = const Value.absent(),
            Value<int> correct = const Value.absent(),
            required DateTime lastSeen,
            Value<int> rowid = const Value.absent(),
          }) =>
              FactStatsCompanion.insert(
            profileId: profileId,
            section: section,
            factKey: factKey,
            attempts: attempts,
            correct: correct,
            lastSeen: lastSeen,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$FactStatsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({profileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (profileId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.profileId,
                    referencedTable:
                        $$FactStatsTableReferences._profileIdTable(db),
                    referencedColumn:
                        $$FactStatsTableReferences._profileIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$FactStatsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FactStatsTable,
    FactStat,
    $$FactStatsTableFilterComposer,
    $$FactStatsTableOrderingComposer,
    $$FactStatsTableAnnotationComposer,
    $$FactStatsTableCreateCompanionBuilder,
    $$FactStatsTableUpdateCompanionBuilder,
    (FactStat, $$FactStatsTableReferences),
    FactStat,
    PrefetchHooks Function({bool profileId})>;
typedef $$AchievementRecordsTableCreateCompanionBuilder
    = AchievementRecordsCompanion Function({
  required String profileId,
  required String achievementId,
  required DateTime unlockedAt,
  Value<int> rowid,
});
typedef $$AchievementRecordsTableUpdateCompanionBuilder
    = AchievementRecordsCompanion Function({
  Value<String> profileId,
  Value<String> achievementId,
  Value<DateTime> unlockedAt,
  Value<int> rowid,
});

final class $$AchievementRecordsTableReferences extends BaseReferences<
    _$AppDatabase, $AchievementRecordsTable, AchievementRecord> {
  $$AchievementRecordsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.profiles.createAlias($_aliasNameGenerator(
          db.achievementRecords.profileId, db.profiles.id));

  $$ProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<String>('profile_id')!;

    final manager = $$ProfilesTableTableManager($_db, $_db.profiles)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$AchievementRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $AchievementRecordsTable> {
  $$AchievementRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get achievementId => $composableBuilder(
      column: $table.achievementId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get unlockedAt => $composableBuilder(
      column: $table.unlockedAt, builder: (column) => ColumnFilters(column));

  $$ProfilesTableFilterComposer get profileId {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.profileId,
        referencedTable: $db.profiles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProfilesTableFilterComposer(
              $db: $db,
              $table: $db.profiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AchievementRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $AchievementRecordsTable> {
  $$AchievementRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get achievementId => $composableBuilder(
      column: $table.achievementId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get unlockedAt => $composableBuilder(
      column: $table.unlockedAt, builder: (column) => ColumnOrderings(column));

  $$ProfilesTableOrderingComposer get profileId {
    final $$ProfilesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.profileId,
        referencedTable: $db.profiles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProfilesTableOrderingComposer(
              $db: $db,
              $table: $db.profiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AchievementRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AchievementRecordsTable> {
  $$AchievementRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get achievementId => $composableBuilder(
      column: $table.achievementId, builder: (column) => column);

  GeneratedColumn<DateTime> get unlockedAt => $composableBuilder(
      column: $table.unlockedAt, builder: (column) => column);

  $$ProfilesTableAnnotationComposer get profileId {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.profileId,
        referencedTable: $db.profiles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProfilesTableAnnotationComposer(
              $db: $db,
              $table: $db.profiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AchievementRecordsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AchievementRecordsTable,
    AchievementRecord,
    $$AchievementRecordsTableFilterComposer,
    $$AchievementRecordsTableOrderingComposer,
    $$AchievementRecordsTableAnnotationComposer,
    $$AchievementRecordsTableCreateCompanionBuilder,
    $$AchievementRecordsTableUpdateCompanionBuilder,
    (AchievementRecord, $$AchievementRecordsTableReferences),
    AchievementRecord,
    PrefetchHooks Function({bool profileId})> {
  $$AchievementRecordsTableTableManager(
      _$AppDatabase db, $AchievementRecordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AchievementRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AchievementRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AchievementRecordsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> profileId = const Value.absent(),
            Value<String> achievementId = const Value.absent(),
            Value<DateTime> unlockedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AchievementRecordsCompanion(
            profileId: profileId,
            achievementId: achievementId,
            unlockedAt: unlockedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String profileId,
            required String achievementId,
            required DateTime unlockedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              AchievementRecordsCompanion.insert(
            profileId: profileId,
            achievementId: achievementId,
            unlockedAt: unlockedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$AchievementRecordsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({profileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (profileId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.profileId,
                    referencedTable:
                        $$AchievementRecordsTableReferences._profileIdTable(db),
                    referencedColumn: $$AchievementRecordsTableReferences
                        ._profileIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$AchievementRecordsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AchievementRecordsTable,
    AchievementRecord,
    $$AchievementRecordsTableFilterComposer,
    $$AchievementRecordsTableOrderingComposer,
    $$AchievementRecordsTableAnnotationComposer,
    $$AchievementRecordsTableCreateCompanionBuilder,
    $$AchievementRecordsTableUpdateCompanionBuilder,
    (AchievementRecord, $$AchievementRecordsTableReferences),
    AchievementRecord,
    PrefetchHooks Function({bool profileId})>;
typedef $$DailyChallengesTableCreateCompanionBuilder = DailyChallengesCompanion
    Function({
  required String profileId,
  required String dateKey,
  required int correct,
  required int total,
  required int starsEarned,
  required int gemsEarned,
  Value<int?> examId,
  required DateTime completedAt,
  Value<int> rowid,
});
typedef $$DailyChallengesTableUpdateCompanionBuilder = DailyChallengesCompanion
    Function({
  Value<String> profileId,
  Value<String> dateKey,
  Value<int> correct,
  Value<int> total,
  Value<int> starsEarned,
  Value<int> gemsEarned,
  Value<int?> examId,
  Value<DateTime> completedAt,
  Value<int> rowid,
});

final class $$DailyChallengesTableReferences extends BaseReferences<
    _$AppDatabase, $DailyChallengesTable, DailyChallenge> {
  $$DailyChallengesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.profiles.createAlias(
          $_aliasNameGenerator(db.dailyChallenges.profileId, db.profiles.id));

  $$ProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<String>('profile_id')!;

    final manager = $$ProfilesTableTableManager($_db, $_db.profiles)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$DailyChallengesTableFilterComposer
    extends Composer<_$AppDatabase, $DailyChallengesTable> {
  $$DailyChallengesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get dateKey => $composableBuilder(
      column: $table.dateKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get correct => $composableBuilder(
      column: $table.correct, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get total => $composableBuilder(
      column: $table.total, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get starsEarned => $composableBuilder(
      column: $table.starsEarned, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get gemsEarned => $composableBuilder(
      column: $table.gemsEarned, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get examId => $composableBuilder(
      column: $table.examId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));

  $$ProfilesTableFilterComposer get profileId {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.profileId,
        referencedTable: $db.profiles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProfilesTableFilterComposer(
              $db: $db,
              $table: $db.profiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DailyChallengesTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyChallengesTable> {
  $$DailyChallengesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get dateKey => $composableBuilder(
      column: $table.dateKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get correct => $composableBuilder(
      column: $table.correct, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get total => $composableBuilder(
      column: $table.total, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get starsEarned => $composableBuilder(
      column: $table.starsEarned, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get gemsEarned => $composableBuilder(
      column: $table.gemsEarned, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get examId => $composableBuilder(
      column: $table.examId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));

  $$ProfilesTableOrderingComposer get profileId {
    final $$ProfilesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.profileId,
        referencedTable: $db.profiles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProfilesTableOrderingComposer(
              $db: $db,
              $table: $db.profiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DailyChallengesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyChallengesTable> {
  $$DailyChallengesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get dateKey =>
      $composableBuilder(column: $table.dateKey, builder: (column) => column);

  GeneratedColumn<int> get correct =>
      $composableBuilder(column: $table.correct, builder: (column) => column);

  GeneratedColumn<int> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<int> get starsEarned => $composableBuilder(
      column: $table.starsEarned, builder: (column) => column);

  GeneratedColumn<int> get gemsEarned => $composableBuilder(
      column: $table.gemsEarned, builder: (column) => column);

  GeneratedColumn<int> get examId =>
      $composableBuilder(column: $table.examId, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);

  $$ProfilesTableAnnotationComposer get profileId {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.profileId,
        referencedTable: $db.profiles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProfilesTableAnnotationComposer(
              $db: $db,
              $table: $db.profiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DailyChallengesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DailyChallengesTable,
    DailyChallenge,
    $$DailyChallengesTableFilterComposer,
    $$DailyChallengesTableOrderingComposer,
    $$DailyChallengesTableAnnotationComposer,
    $$DailyChallengesTableCreateCompanionBuilder,
    $$DailyChallengesTableUpdateCompanionBuilder,
    (DailyChallenge, $$DailyChallengesTableReferences),
    DailyChallenge,
    PrefetchHooks Function({bool profileId})> {
  $$DailyChallengesTableTableManager(
      _$AppDatabase db, $DailyChallengesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyChallengesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyChallengesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyChallengesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> profileId = const Value.absent(),
            Value<String> dateKey = const Value.absent(),
            Value<int> correct = const Value.absent(),
            Value<int> total = const Value.absent(),
            Value<int> starsEarned = const Value.absent(),
            Value<int> gemsEarned = const Value.absent(),
            Value<int?> examId = const Value.absent(),
            Value<DateTime> completedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DailyChallengesCompanion(
            profileId: profileId,
            dateKey: dateKey,
            correct: correct,
            total: total,
            starsEarned: starsEarned,
            gemsEarned: gemsEarned,
            examId: examId,
            completedAt: completedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String profileId,
            required String dateKey,
            required int correct,
            required int total,
            required int starsEarned,
            required int gemsEarned,
            Value<int?> examId = const Value.absent(),
            required DateTime completedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              DailyChallengesCompanion.insert(
            profileId: profileId,
            dateKey: dateKey,
            correct: correct,
            total: total,
            starsEarned: starsEarned,
            gemsEarned: gemsEarned,
            examId: examId,
            completedAt: completedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$DailyChallengesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({profileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (profileId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.profileId,
                    referencedTable:
                        $$DailyChallengesTableReferences._profileIdTable(db),
                    referencedColumn:
                        $$DailyChallengesTableReferences._profileIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$DailyChallengesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DailyChallengesTable,
    DailyChallenge,
    $$DailyChallengesTableFilterComposer,
    $$DailyChallengesTableOrderingComposer,
    $$DailyChallengesTableAnnotationComposer,
    $$DailyChallengesTableCreateCompanionBuilder,
    $$DailyChallengesTableUpdateCompanionBuilder,
    (DailyChallenge, $$DailyChallengesTableReferences),
    DailyChallenge,
    PrefetchHooks Function({bool profileId})>;
typedef $$RewardClaimsTableCreateCompanionBuilder = RewardClaimsCompanion
    Function({
  required String profileId,
  required String dateKey,
  required int dayIndex,
  required int stars,
  required int gems,
  required DateTime claimedAt,
  Value<int> rowid,
});
typedef $$RewardClaimsTableUpdateCompanionBuilder = RewardClaimsCompanion
    Function({
  Value<String> profileId,
  Value<String> dateKey,
  Value<int> dayIndex,
  Value<int> stars,
  Value<int> gems,
  Value<DateTime> claimedAt,
  Value<int> rowid,
});

final class $$RewardClaimsTableReferences
    extends BaseReferences<_$AppDatabase, $RewardClaimsTable, RewardClaim> {
  $$RewardClaimsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.profiles.createAlias(
          $_aliasNameGenerator(db.rewardClaims.profileId, db.profiles.id));

  $$ProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<String>('profile_id')!;

    final manager = $$ProfilesTableTableManager($_db, $_db.profiles)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$RewardClaimsTableFilterComposer
    extends Composer<_$AppDatabase, $RewardClaimsTable> {
  $$RewardClaimsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get dateKey => $composableBuilder(
      column: $table.dateKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get dayIndex => $composableBuilder(
      column: $table.dayIndex, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get stars => $composableBuilder(
      column: $table.stars, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get gems => $composableBuilder(
      column: $table.gems, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get claimedAt => $composableBuilder(
      column: $table.claimedAt, builder: (column) => ColumnFilters(column));

  $$ProfilesTableFilterComposer get profileId {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.profileId,
        referencedTable: $db.profiles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProfilesTableFilterComposer(
              $db: $db,
              $table: $db.profiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RewardClaimsTableOrderingComposer
    extends Composer<_$AppDatabase, $RewardClaimsTable> {
  $$RewardClaimsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get dateKey => $composableBuilder(
      column: $table.dateKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get dayIndex => $composableBuilder(
      column: $table.dayIndex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get stars => $composableBuilder(
      column: $table.stars, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get gems => $composableBuilder(
      column: $table.gems, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get claimedAt => $composableBuilder(
      column: $table.claimedAt, builder: (column) => ColumnOrderings(column));

  $$ProfilesTableOrderingComposer get profileId {
    final $$ProfilesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.profileId,
        referencedTable: $db.profiles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProfilesTableOrderingComposer(
              $db: $db,
              $table: $db.profiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RewardClaimsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RewardClaimsTable> {
  $$RewardClaimsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get dateKey =>
      $composableBuilder(column: $table.dateKey, builder: (column) => column);

  GeneratedColumn<int> get dayIndex =>
      $composableBuilder(column: $table.dayIndex, builder: (column) => column);

  GeneratedColumn<int> get stars =>
      $composableBuilder(column: $table.stars, builder: (column) => column);

  GeneratedColumn<int> get gems =>
      $composableBuilder(column: $table.gems, builder: (column) => column);

  GeneratedColumn<DateTime> get claimedAt =>
      $composableBuilder(column: $table.claimedAt, builder: (column) => column);

  $$ProfilesTableAnnotationComposer get profileId {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.profileId,
        referencedTable: $db.profiles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProfilesTableAnnotationComposer(
              $db: $db,
              $table: $db.profiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RewardClaimsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RewardClaimsTable,
    RewardClaim,
    $$RewardClaimsTableFilterComposer,
    $$RewardClaimsTableOrderingComposer,
    $$RewardClaimsTableAnnotationComposer,
    $$RewardClaimsTableCreateCompanionBuilder,
    $$RewardClaimsTableUpdateCompanionBuilder,
    (RewardClaim, $$RewardClaimsTableReferences),
    RewardClaim,
    PrefetchHooks Function({bool profileId})> {
  $$RewardClaimsTableTableManager(_$AppDatabase db, $RewardClaimsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RewardClaimsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RewardClaimsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RewardClaimsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> profileId = const Value.absent(),
            Value<String> dateKey = const Value.absent(),
            Value<int> dayIndex = const Value.absent(),
            Value<int> stars = const Value.absent(),
            Value<int> gems = const Value.absent(),
            Value<DateTime> claimedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RewardClaimsCompanion(
            profileId: profileId,
            dateKey: dateKey,
            dayIndex: dayIndex,
            stars: stars,
            gems: gems,
            claimedAt: claimedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String profileId,
            required String dateKey,
            required int dayIndex,
            required int stars,
            required int gems,
            required DateTime claimedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              RewardClaimsCompanion.insert(
            profileId: profileId,
            dateKey: dateKey,
            dayIndex: dayIndex,
            stars: stars,
            gems: gems,
            claimedAt: claimedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$RewardClaimsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({profileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (profileId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.profileId,
                    referencedTable:
                        $$RewardClaimsTableReferences._profileIdTable(db),
                    referencedColumn:
                        $$RewardClaimsTableReferences._profileIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$RewardClaimsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RewardClaimsTable,
    RewardClaim,
    $$RewardClaimsTableFilterComposer,
    $$RewardClaimsTableOrderingComposer,
    $$RewardClaimsTableAnnotationComposer,
    $$RewardClaimsTableCreateCompanionBuilder,
    $$RewardClaimsTableUpdateCompanionBuilder,
    (RewardClaim, $$RewardClaimsTableReferences),
    RewardClaim,
    PrefetchHooks Function({bool profileId})>;
typedef $$UnlockedCosmeticsTableCreateCompanionBuilder
    = UnlockedCosmeticsCompanion Function({
  required String profileId,
  required String itemId,
  required DateTime unlockedAt,
  Value<int> rowid,
});
typedef $$UnlockedCosmeticsTableUpdateCompanionBuilder
    = UnlockedCosmeticsCompanion Function({
  Value<String> profileId,
  Value<String> itemId,
  Value<DateTime> unlockedAt,
  Value<int> rowid,
});

final class $$UnlockedCosmeticsTableReferences extends BaseReferences<
    _$AppDatabase, $UnlockedCosmeticsTable, UnlockedCosmetic> {
  $$UnlockedCosmeticsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.profiles.createAlias(
          $_aliasNameGenerator(db.unlockedCosmetics.profileId, db.profiles.id));

  $$ProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<String>('profile_id')!;

    final manager = $$ProfilesTableTableManager($_db, $_db.profiles)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$UnlockedCosmeticsTableFilterComposer
    extends Composer<_$AppDatabase, $UnlockedCosmeticsTable> {
  $$UnlockedCosmeticsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get itemId => $composableBuilder(
      column: $table.itemId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get unlockedAt => $composableBuilder(
      column: $table.unlockedAt, builder: (column) => ColumnFilters(column));

  $$ProfilesTableFilterComposer get profileId {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.profileId,
        referencedTable: $db.profiles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProfilesTableFilterComposer(
              $db: $db,
              $table: $db.profiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$UnlockedCosmeticsTableOrderingComposer
    extends Composer<_$AppDatabase, $UnlockedCosmeticsTable> {
  $$UnlockedCosmeticsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get itemId => $composableBuilder(
      column: $table.itemId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get unlockedAt => $composableBuilder(
      column: $table.unlockedAt, builder: (column) => ColumnOrderings(column));

  $$ProfilesTableOrderingComposer get profileId {
    final $$ProfilesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.profileId,
        referencedTable: $db.profiles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProfilesTableOrderingComposer(
              $db: $db,
              $table: $db.profiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$UnlockedCosmeticsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UnlockedCosmeticsTable> {
  $$UnlockedCosmeticsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<DateTime> get unlockedAt => $composableBuilder(
      column: $table.unlockedAt, builder: (column) => column);

  $$ProfilesTableAnnotationComposer get profileId {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.profileId,
        referencedTable: $db.profiles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProfilesTableAnnotationComposer(
              $db: $db,
              $table: $db.profiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$UnlockedCosmeticsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UnlockedCosmeticsTable,
    UnlockedCosmetic,
    $$UnlockedCosmeticsTableFilterComposer,
    $$UnlockedCosmeticsTableOrderingComposer,
    $$UnlockedCosmeticsTableAnnotationComposer,
    $$UnlockedCosmeticsTableCreateCompanionBuilder,
    $$UnlockedCosmeticsTableUpdateCompanionBuilder,
    (UnlockedCosmetic, $$UnlockedCosmeticsTableReferences),
    UnlockedCosmetic,
    PrefetchHooks Function({bool profileId})> {
  $$UnlockedCosmeticsTableTableManager(
      _$AppDatabase db, $UnlockedCosmeticsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UnlockedCosmeticsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UnlockedCosmeticsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UnlockedCosmeticsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> profileId = const Value.absent(),
            Value<String> itemId = const Value.absent(),
            Value<DateTime> unlockedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UnlockedCosmeticsCompanion(
            profileId: profileId,
            itemId: itemId,
            unlockedAt: unlockedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String profileId,
            required String itemId,
            required DateTime unlockedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              UnlockedCosmeticsCompanion.insert(
            profileId: profileId,
            itemId: itemId,
            unlockedAt: unlockedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$UnlockedCosmeticsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({profileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (profileId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.profileId,
                    referencedTable:
                        $$UnlockedCosmeticsTableReferences._profileIdTable(db),
                    referencedColumn: $$UnlockedCosmeticsTableReferences
                        ._profileIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$UnlockedCosmeticsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UnlockedCosmeticsTable,
    UnlockedCosmetic,
    $$UnlockedCosmeticsTableFilterComposer,
    $$UnlockedCosmeticsTableOrderingComposer,
    $$UnlockedCosmeticsTableAnnotationComposer,
    $$UnlockedCosmeticsTableCreateCompanionBuilder,
    $$UnlockedCosmeticsTableUpdateCompanionBuilder,
    (UnlockedCosmetic, $$UnlockedCosmeticsTableReferences),
    UnlockedCosmetic,
    PrefetchHooks Function({bool profileId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProfilesTableTableManager get profiles =>
      $$ProfilesTableTableManager(_db, _db.profiles);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$LearningLevelsTableTableManager get learningLevels =>
      $$LearningLevelsTableTableManager(_db, _db.learningLevels);
  $$StudentLevelProgressTableTableManager get studentLevelProgress =>
      $$StudentLevelProgressTableTableManager(_db, _db.studentLevelProgress);
  $$ExamRecordsTableTableManager get examRecords =>
      $$ExamRecordsTableTableManager(_db, _db.examRecords);
  $$AnswerRecordsTableTableManager get answerRecords =>
      $$AnswerRecordsTableTableManager(_db, _db.answerRecords);
  $$CurriculumTopicsTableTableManager get curriculumTopics =>
      $$CurriculumTopicsTableTableManager(_db, _db.curriculumTopics);
  $$ExamTopicSelectionsTableTableManager get examTopicSelections =>
      $$ExamTopicSelectionsTableTableManager(_db, _db.examTopicSelections);
  $$FactStatsTableTableManager get factStats =>
      $$FactStatsTableTableManager(_db, _db.factStats);
  $$AchievementRecordsTableTableManager get achievementRecords =>
      $$AchievementRecordsTableTableManager(_db, _db.achievementRecords);
  $$DailyChallengesTableTableManager get dailyChallenges =>
      $$DailyChallengesTableTableManager(_db, _db.dailyChallenges);
  $$RewardClaimsTableTableManager get rewardClaims =>
      $$RewardClaimsTableTableManager(_db, _db.rewardClaims);
  $$UnlockedCosmeticsTableTableManager get unlockedCosmetics =>
      $$UnlockedCosmeticsTableTableManager(_db, _db.unlockedCosmetics);
}
