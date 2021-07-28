import 'package:wssistance/logic/stats/enumerations/enum_slots.dart';
import 'package:wssistance/logic/stats/enumerations/enum_stats.dart';
import 'package:wssistance/logic/stats/statslot.dart';
import 'package:wssistance/logic/util/enumerations/enumerations.dart';

class StatHelper {
  static Slot getWeaponSlot(WeaponType type) {
    return _weaponMapping[type]!;
  }

  static Slot getArmorSlot(ArmorSlotType type) {
    return _armorMapping[type]!;
  }

  static Slot getAccessorySlot(AccessoryType type) {
    return _accessoryMapping[type]!;
  }

  static double getWeaponDelay(WeaponType type) {
    return _weaponDelayMapping[type]!;
  }

  static int getLevelChange(Quality quality) {
    return _qualityMapping[quality]!;
  }

  static int getArmorTypeChange(ArmorType armorType) {
    switch (armorType) {
      case ArmorType.cloth:
        return 1000;
      case ArmorType.light:
        return 2000;
      default:
        return 3000;
    }
  }

  static double getValue(TypeStat type, Slot slot, int level, bool isCrit) {
    if (isCrit) {
      if (_isCrittable(type) && _isWeaponSlot(slot)) {
        return _mapF[_valuesCrit[slot]![type]]!.call(level);
      }
      level += 4;
    }
    return _mapF[_values[slot]![type]]!.call(level);
  }

  static bool _isCrittable(TypeStat stat) {
    return (stat == TypeStat.criticalHit ||
        stat == TypeStat.accuracy ||
        stat == TypeStat.penetration ||
        stat == TypeStat.block);
  }

  static bool _isWeaponSlot(Slot slot) {
    int index = slot.index;
    int lowIndex = Slot.oneHandedSwordMain.index;
    int highIndex = Slot.crossbowMain.index;
    return (index <= highIndex && index >= lowIndex);
  }

  static bool isPercent(TypeStat type) {
    return _mapP[type] ?? true;
  }

  static List<StatSlot> getAvailableEnchantments(Slot slot, int lvl) {
    List<StatSlot> list = [];
    _values[slot]!.keys.toList().forEach((element) {
      list.add(StatSlot(level: lvl, slot: slot, type: element));
      list.add(StatSlot(level: lvl, slot: slot, type: element, isCrit: true));
    });
    return list;
  }

  static bool isOneHanded(Slot slot) {
    if (_slotsMap['oneHandedWeapon']!.contains(slot)) return true;
    return false;
  }

  static bool isTwoHanded(Slot slot) {
    if (_slotsMap['twoHandedWeapon']!.contains(slot)) return true;
    return false;
  }

  static bool isWeapon(Slot slot) {
    return isOneHanded(slot) || isTwoHanded(slot);
  }

  static bool isCrittable(TypeStat stat) {
    return (stat == TypeStat.criticalHit ||
        stat == TypeStat.accuracy ||
        stat == TypeStat.penetration ||
        stat == TypeStat.block);
  }

  static bool isWeaponSlot(Slot slot) {
    int index = slot.index;
    int lowIndex = Slot.oneHandedSwordMain.index;
    int highIndex = Slot.crossbowMain.index;
    return (index <= highIndex && index >= lowIndex);
  }

  static bool isMagicalArmorSlot(Slot slot) {
    return (slot == Slot.neckMain || slot == Slot.ringMain);
  }

  static bool isAmplifiable(TypeStat stat) {
    return (stat == TypeStat.physicalDamage ||
        stat == TypeStat.magicalDamage ||
        stat == TypeStat.physicalDefence ||
        stat == TypeStat.magicalDefence);
  }
}

const Map<TypeStat, bool> _mapP = {
  TypeStat.physicalDamage: false,
  TypeStat.magicalDamage: false,
  TypeStat.physicalDamageAugmentation: true,
  TypeStat.magicalDamageAugmentation: true,
  TypeStat.criticalHit: true,
  TypeStat.accuracy: true,
  TypeStat.attackSpeed: true,
  TypeStat.penetration: true,
  TypeStat.cooldown: true,
  TypeStat.stun: true,
  TypeStat.rage: true,
  TypeStat.ferocity: true,
  TypeStat.attackStrength: true,
  TypeStat.depthsFury: true,
  TypeStat.piercingAttack: true,
  TypeStat.criticalModifier: false,
  TypeStat.physicalDefence: false,
  TypeStat.physicalDefenceAugmentation: true,
  TypeStat.magicalDefence: false,
  TypeStat.magicalDefenceAugmentation: true,
  TypeStat.dodge: true,
  TypeStat.resilience: true,
  TypeStat.parry: true,
  TypeStat.block: true,
  TypeStat.stealHealth: true,
  TypeStat.damageReflection: true,
  TypeStat.solidity: true,
  TypeStat.resistance: true,
  TypeStat.health: false,
  TypeStat.healthAugmentation: true,
  TypeStat.healthRegeneration: false,
  TypeStat.healthRegenerationSpeed: true,
  TypeStat.healthRegenerationAugmentation: true,
  TypeStat.energyAugmentation: true,
  TypeStat.energyRegenerationAugmentation: true,
  TypeStat.oxygenCapacity: false,
  TypeStat.speed: true,
  TypeStat.incomingDamageAugmentation: true,
  TypeStat.incomingHealingAugmentation: true,
  TypeStat.buffDurationAugmentation: true,
  TypeStat.energy: false,
  TypeStat.energyRegeneration: false,
  TypeStat.energyRegenerationSpeed: true,
  TypeStat.slowingOxygenConsumption: true,
  TypeStat.oxygenRegeneration: true,
  TypeStat.speedUnderWater: true,
};
final Map<String, Function> _mapF = {
  'CD2': (int lvl) => ((lvl == 4)
      ? 1.7
      : ((lvl ~/ 3) * 7 + (lvl % 3) * 2 + ((lvl % 3 == 0) ? 0 : 1) + 8) / 10),
  'CD1': (int lvl) => (((((lvl == 4)
                          ? 1.7
                          : ((lvl ~/ 3) * 7 +
                                  (lvl % 3) * 2 +
                                  ((lvl % 3 == 0) ? 0 : 1) +
                                  8) /
                              10) /
                      2) *
                  10)
              .toInt() /
          10.0)
      .toDouble(),
  'CDCrys': (int lvl) => (((lvl ~/ 2) * 3 + (lvl % 2) * 2 + 9) / 10).toDouble(),
  'StunCrys1': (int lvl) => ((5.0 + lvl) / 10).toDouble(),
  'StunCrys2': (int lvl) => ((5.0 + lvl) / 10) * 2.0,
  'RageCrys': (int lvl) => (5.0 + lvl * 2) / 10,
  'FerocityCrys1': (int lvl) =>
      (((lvl ~/ 2) * 9 + (lvl % 2) * 4 + 5) / 10).toDouble(),
  'FerocityCrys2': (int lvl) =>
      (((lvl ~/ 2) * 15 + (lvl % 2) * 7 + 5) / 10).toDouble(),
  'FerocityMain1': (int lvl) =>
      (((0.0100555 * lvl * lvl + 0.158465 * lvl + 1.36858) * 10).toInt() / 10)
          .toDouble(),
  'FerocityMain2': (int lvl) =>
      (((0.0148696 * lvl * lvl + 0.295613 * lvl + 2.63779 + 0.01) * 10)
                  .toInt() /
              10)
          .toDouble(),
  'DepthsfuryCrys1': (int lvl) =>
      (((lvl ~/ 2) * 7 + (lvl % 2) * 3 + 5) / 10).toDouble(),
  'DepthsfuryCrys2': (int lvl) => ((7 * lvl + 5) / 10).toDouble(),
  'DepthsfuryMain1': (int lvl) => (lvl == 30) ? 9.3 : 8.4,
  'DepthsfuryMain2': (int lvl) => (lvl == 30) ? 18.0 : 16.3,
  'Uni': (int lvl) => (lvl) / 10.0,
  'Uni2': (int lvl) => (lvl) / 5.0,
  'Uni10': (int lvl) => (lvl) / 1.0,
  'Uni10+3': (int lvl) => (lvl) / 1.0 + 3,
  'Uni10+6': (int lvl) => (lvl) / 1.0 + 6,
  'Uni2+3': (int lvl) => (2 * lvl + 6.0) / 10,
  'Uni4+3': (int lvl) => (2 * lvl + 6.0) / 5,
  'UniDiv2+2': (int lvl) => (lvl / 2 + 2.0) / 10,
  'Uni2+4': (int lvl) => (2 * lvl + 8.0) / 10,
  'EnergyRegen': (int lvl) => (lvl / 2 + 2.0).floorToDouble(),
  'EnergyRegenCrys': (int lvl) => (lvl / 2).ceilToDouble(),
  'EnergyRegenShield': (int lvl) => 14.0,
  'Uni+3': (int lvl) => (lvl + 3.0) / 10,
  'Uni+4': (int lvl) => (lvl + 4.0) / 10,
  'Uni+5': (int lvl) => (lvl + 5.0) / 10,
  'Uni+7': (int lvl) => (lvl + 7.0) / 10,
  'UniConst30': (int lvl) => 30.0,
  'UniConst15': (int lvl) => 15.0,
  'UniConst7.5': (int lvl) => 7.5,
  'UniConst10': (int lvl) => 10,
  'UniConst5': (int lvl) => 5.0,
  'UniConst2.5': (int lvl) => 2.5,
  'SolidityRune': (int lvl) =>
      (((lvl ~/ 2) * 3 + (lvl % 2) * 1 + 2) / 10).toDouble(),
  'PDCape': (int lvl) =>
      (0.0289476 * lvl * lvl + 1.0182 * lvl + 6.04427).round().toDouble(),
  'PDNeck': (int lvl) =>
      (0.0309138 * lvl * lvl + 0.812741 * lvl + 4.92729).round().toDouble(),
  'PDRing': (int lvl) =>
      (0.0295285 * lvl * lvl + 0.440562 * lvl + 1.35339).round().toDouble(),
  'Percent': (int lvl) => (lvl).toDouble(),
  'PercentAS': (int lvl) => (lvl / 10).toDouble(),
  'MDCape': (int lvl) =>
      (0.0131854 * lvl * lvl + 0.836243 * lvl + 4.35718).round().toDouble(),
  'MDNeck': (int lvl) =>
      (0.0129746 * lvl * lvl + 0.686658 * lvl + 2.95856).round().toDouble(),
  'piercingAttackRing': (int lvl) {
    switch (lvl) {
      case 30:
        return 1.9;
      case 25:
        return 1.6;
      case 20:
        return 1.3;
      case 15:
        return 1.0;
      case 10:
        return 0.7;
      default:
        return 0.4;
    }
  },
  'MDRingBeltHands': (int lvl) =>
      (0.01116598 * lvl * lvl + 0.620629 * lvl + 1.96036).round().toDouble(),
  'MDBody': (int lvl) => ((lvl < 19)
          ? (0.0126938 * lvl * lvl + 0.621842 * lvl + 2.74656)
          : (0.0197437 * lvl * lvl + 0.227988 * lvl + 8.49391))
      .round()
      .toDouble(),
  'MDSetbonus': (int lvl) =>
      (0.0178571 * lvl * lvl + 0.792857 * lvl + 14.9429).round().toDouble(),
  'BodySetBonus': (int lvl) =>
      (((lvl < 19)
                  ? (0.120844 * lvl + 0.411352)
                  : (0.000203531 * lvl * lvl + 0.111648 * lvl + 0.499936)) *
              10)
          .round()
          .toDouble() /
      10,
  'BodySetBonus+1': (int lvl) =>
      (((lvl < 19)
                      ? (0.120844 * lvl + 0.411352)
                      : (0.000203531 * lvl * lvl + 0.111648 * lvl + 0.499936)) *
                  10)
              .round()
              .toDouble() /
          10 +
      0.1,
  'AccuracyMain2': (int lvl) =>
      (((lvl ~/ 5) * 11 + (lvl % 5) * 2 + 8) / 10).toDouble(),
  'CritSpeed2': (int lvl) =>
      ((lvl < 19)
              ? (0.000245098 * lvl * lvl + 0.235049 * lvl + 0.901471) * 10
              : (-0.000424575 * lvl + 0.261713 * lvl + 0.606269) * 10)
          .toInt() /
      10.0,
  'BlockBody': (int lvl) =>
      ((lvl < 19)
              ? (0.000592544 * lvl * lvl + 0.0965406 * lvl + 0.349972) * 10
              : (0.000332826 * lvl * lvl + 0.0945955 * lvl + 0.457861) * 10)
          .toInt() /
      10.0,
  'BlockBody+1': (int lvl) =>
      ((lvl < 19)
                  ? (0.000592544 * lvl * lvl + 0.0965406 * lvl + 0.349972) * 10
                  : (0.000332826 * lvl * lvl + 0.0945955 * lvl + 0.457861) * 10)
              .toInt() /
          10.0 +
      0.1,
  'HealthRune': (int lvl) => ((lvl < 19)
          ? ((lvl == 2)
              ? 22
              : (-0.00522446 * lvl * lvl + 5.56366 * lvl + 9.59069))
          : 0.00322497 * lvl * lvl + 5.28186 * lvl + 12.4453)
      .roundToDouble(),
  'DefenceRune': (int lvl) => ((lvl < 19)
          ? (0.406816 * lvl * lvl + 4.06628 * lvl + 56.6192)
          : (0.409264 * lvl * lvl + 4.03238 * lvl + 56.5917))
      .roundToDouble(),
  'AxeCrys': (int lvl) => ((lvl < 19)
          ? ((lvl == 15)
              ? 24
              : (0.0212718 * lvl * lvl + 1.04284 * lvl + 4.07169))
          : ((lvl == 24)
              ? 42
              : ((lvl == 28)
                  ? 50
                  : (0.0180995 * lvl * lvl + 1.32262 * lvl - 0.709955))))
      .roundToDouble(),
  'MaceCrys': (int lvl) => ((lvl < 19)
          ? (0.020641 * lvl + 1.21165 * lvl + 3.88242)
          : (0.0193086 * lvl * lvl + 1.44631 * lvl - 0.48812))
      .roundToDouble(),
  'DaggerCrys': (int lvl) =>
      ((lvl == 30) ? 43 : (0.0184447 * lvl * lvl + 0.738008 * lvl + 3.72906))
          .roundToDouble(),
  'SwordCrys': (int lvl) =>
      (0.0216613 * lvl * lvl + 0.890602 * lvl + 4.00647).roundToDouble(),
  'SpearCrys': (int lvl) => ((lvl < 19)
          ? ((lvl == 15)
              ? 38
              : (0.0281593 * lvl * lvl + 1.57431 * lvl + 7.49945))
          : (lvl < 27)
              ? (0.047619 * lvl * lvl + 1.19048 * lvl + 8.10714)
              : ((lvl < 31)
                  ? (0.25 * lvl * lvl - 10.95 * lvl + 188.45)
                  : (-0.25 * lvl * lvl + 19.95 * lvl - 288.25)))
      .roundToDouble(),
  'StealHealthRune': (int lvl) =>
      ((lvl < 19)
              ? ((-0.00388009 * lvl * lvl + 1.35232 * lvl + 8.15292))
              : (-0.000184517 * lvl * lvl + 1.29703 * lvl + 8.28057))
          .roundToDouble() /
      10,
  'BowCrys': (int lvl) => ((lvl < 18)
          ? (0.032663 * lvl * lvl + 1.1806 * lvl + 5.91396)
          : (0.0418417 * lvl * lvl + 0.566211 * lvl + 15.1604))
      .roundToDouble(),
  'CrossbowCrys': (int lvl) => ((lvl < 18)
          ? ((lvl == 15)
              ? 36
              : (0.0385423 * lvl * lvl + 1.38421 * lvl + 7.19059))
          : (0.0336134 * lvl * lvl + 1.60084 * lvl + 4.5084))
      .roundToDouble(),
  'TwohandedMagCrys': (int lvl) => (3 * lvl + 5).roundToDouble(),
  'TwohandedPhysCrys': (int lvl) =>
      (0.0370629 * lvl * lvl + 1.30168 * lvl + 7.70778).roundToDouble(),
  'MagCrys': (int lvl) => (4.0 + 2 * lvl),
  'TwohandedMagMain': (int lvl) => (lvl < 19
          ? (0.0815941 * lvl * lvl + 3.6132 * lvl + 25.5746)
          : ((lvl == 21)
              ? 137
              : (0.0799201 * lvl * lvl + 3.67433 * lvl + 25.2268)))
      .roundToDouble(),
  'OnehandedMagMain': (int lvl) => ((lvl < 19)
          ? (0.0527224 * lvl * lvl + 1.90506 * lvl + 17.3994)
          : ((lvl < 26)
              ? (0.0357143 * lvl * lvl + 2.75 * lvl + 6.78571)
              : (0.101852 * lvl * lvl * lvl -
                  8.61905 * lvl * lvl +
                  247.47 * lvl -
                  2295.94)))
      .roundToDouble(),
  'DaggerMain': (int lvl) => ((lvl < 19)
          ? (0.094363 * lvl * lvl + 4.21856 * lvl + 30.2791)
          : 0.0849151 * lvl * lvl + 4.75425 * lvl + 22.96)
      .roundToDouble(),
  'SwordMain': (int lvl) => ((lvl < 19)
          ? (0.0000797213 * lvl * lvl * lvl +
              0.11074 * lvl * lvl +
              4.93801 * lvl +
              35.699)
          : 0.100899 * lvl * lvl + 5.48252 * lvl + 29.3087)
      .roundToDouble(),
  'AxeMain': (int lvl) => ((lvl < 19)
          ? (0.123652 * lvl * lvl + 5.42511 * lvl + 39.4091)
          : 0.119381 * lvl * lvl + 5.61888 * lvl + 37.013)
      .roundToDouble(),
  'MaceMain': (int lvl) => ((lvl < 19)
          ? 0.130463 * lvl * lvl + 5.99444 * lvl + 42.635
          : 0.136863 * lvl * lvl + 5.82717 * lvl + 43.8651)
      .roundToDouble(),
  'TwohandedMain': (int lvl) => ((lvl < 19)
          ? 0.176667 * lvl * lvl + 7.92169 * lvl + 57.2658
          : 0.173826 * lvl * lvl + 8.16583 * lvl + 54.0869)
      .roundToDouble(),
  'SpearMain': (int lvl) => ((lvl < 15)
          ? ((lvl == 3) ? 88 : 0.18956 * lvl * lvl + 8.44231 * lvl + 60.4396)
          : 0.182921 * lvl * lvl + 8.74252 * lvl + 56.9435)
      .roundToDouble(),
  'StealHealthCape': (int lvl) =>
      (((lvl < 19)
                  ? 0.000142705 * lvl * lvl + 0.106466 * lvl + 0.356379
                  : -0.00202117 * lvl * lvl + 0.207757 * lvl - 0.822928) *
              10)
          .roundToDouble() /
      10,
  'StealHealthRing': (int lvl) =>
      ((0.0000343629 * lvl * lvl + 0.0471427 * lvl + 0.252344) * 10)
          .roundToDouble() /
      10,
  'StealHealthNeck': (int lvl) =>
      ((0.0000883715 * lvl * lvl + 0.0878494 * lvl + 0.368715) * 10)
          .roundToDouble() /
      10,
  'PhysicalDefenceBody': (int lvl) {
    int mode = lvl ~/ 1000;
    int x = lvl % 1000;
    switch (mode) {
      case 1:
        {
          return ((x < 18)
                  ? (0.00142476 * x * x + 6.37941 * x + 27.4255)
                  : (-0.00343407 * x * x + 6.57514 * x + 25.1942))
              .roundToDouble();
        }
      case 2:
        {
          return ((x < 18)
                  ? (-0.00245177 * x * x + 9.55273 * x + 41.0008)
                  : (-0.00192961 * x * x + 9.58101 * x + 40.4415))
              .roundToDouble();
        }
      case 3:
        {
          return ((x < 18)
                  ? ((x == 12)
                      ? 210
                      : -0.004514968 * x * x + 13.0045 * x + 55.1029)
                  : ((x == 32)
                      ? 468
                      : 0.00618132 * x * x + 12.5837 * x + 59.6398))
              .roundToDouble();
        }
      default:
        {
          return 0.0;
        }
    }
  },
  'PhysicalDefence': (int lvl) {
    int mode = lvl ~/ 1000;
    int x = lvl % 1000;
    switch (mode) {
      case 1:
        {
          return ((x < 18)
                  ? (0.00086008 * x * x + 4.07527 * x + 17.596)
                  : (4.10549 * x + 17.3099))
              .roundToDouble();
        }
      case 2:
        {
          return ((x < 18)
                  ? (0.00148409 * x * x + 6.05885 * x + 26.6972)
                  : (6.10549 * x + 26.3099))
              .roundToDouble();
        }
      case 3:
        {
          return ((x < 18)
                  ? -0.000641292 * x * x + 8.31183 * x + 35.6125
                  : -0.00206044 * x * x + 8.39959 * x + 34.4695)
              .roundToDouble();
        }
      default:
        {
          return 0.0;
        }
    }
  },
  'HealthMain': (int lvl) => ((lvl < 18)
          ? -0.000148097 * lvl * lvl + 7.80885 * lvl + 33.3077
          : 0.000236278 * lvl * lvl + 7.786 * lvl + 33.599)
      .roundToDouble(),
  'HealthNeckCape': (int lvl) => (77.0 + 9 * lvl),
  'HealthShield': (int lvl) => (24.0 + 8 * lvl),
  'HealthRing': (int lvl) =>
      (((lvl ~/ 2) * 15 + (lvl % 2) * 7 + 53)).toDouble(),
  'ShieldDefence': (int lvl) => (50.0 + 11 * lvl).toDouble(),
  'MagicalDefenceSecondMain': (int lvl) => 108.0 + 16 * lvl,
  'MagicalDefenceCape': (int lvl) => 103.0 + 15 * lvl,
  'HealthSetBonus': (int lvl) => 77.0 + 9 * lvl,
  'MagicalDefenceSetBonus': (int lvl) => 74.0 + 22 * lvl,
  'PhysicalDefenceSetBonus': (int lvl) => 67.0 + 22 * lvl,
  'MagicalDefenceNeck': (int lvl) =>
      (((lvl ~/ 5) * 101 + (lvl % 5) * 20 + 69)).toDouble(),
  'MagicalDefenceRing': (int lvl) =>
      (((lvl ~/ 5) * 66 + (lvl % 5) * 13 + 48)).toDouble(),
  'Dodge2': (int lvl) => (lvl + 2) / 5.0,
  'Crit1Doubled': (int lvl) =>
      (0.000203963 * lvl * lvl + 0.231387 * lvl + 0.964336),
  'Crit2Doubled': (int lvl) => (0.479091 * lvl + 1.81818),
  'Accuracy1Doubled': (int lvl) =>
      (0.000203963 * lvl * lvl + 0.231387 * lvl + 0.964336),
  'Accuracy2Doubled': (int lvl) =>
      (0.000203963 * lvl * lvl + 0.431387 * lvl + 1.76434),
  'RingResistance': (int lvl) =>
      (-0.0223214 * lvl * lvl + 1.6875 * lvl - 11.6429).roundToDouble() / 10.0,
  'RingResilience': (int lvl) =>
      (-0.000228093 * lvl * lvl + 0.621525 * lvl + 1.46118).roundToDouble() /
      10.0,
  'BowMain': (int lvl) => ((lvl < 19)
          ? 0.157443 * lvl * lvl + 6.91157 * lvl + 49.7819
          : 0.156344 * lvl * lvl + 6.95754 * lvl + 49.2348)
      .roundToDouble(),
  'CrossbowMain': (int lvl) => ((lvl < 19)
          ? ((lvl == 4)
              ? 95
              : ((lvl == 6)
                  ? 115
                  : 0.187734 * lvl * lvl + 8.10497 * lvl + 59.0661))
          : 0.189311 * lvl * lvl + 7.9026 * lvl + 62.3886)
      .roundToDouble(),
  'StealHealth1Main': (int lvl) =>
      (0.00011378 * lvl * lvl + 0.797868 * lvl + 3.16642).roundToDouble() /
      10.0,
  'StealHealth2Main': (int lvl) =>
      (-0.00188587 * lvl * lvl + 1.66217 * lvl + 5.9727).roundToDouble() / 10.0,
  'CritAS1Main': (int lvl) =>
      (((lvl ~/ 5) * 6 + (lvl % 5) * 1 + 4)).toDouble() / 10,
  'AccuracyMain': (int lvl) =>
      (((lvl ~/ 10) * 11 + (lvl % 10) * 1 + 4)).toDouble() / 10,
  'ShieldBlock': (int lvl) =>
      ((lvl < 23)
              ? (-0.000275087 * lvl * lvl + 1.20912 * lvl + 3.13154)
              : 1.19048 * lvl + 3.45238)
          .roundToDouble() /
      10,
  'ShieldDoubleBlock': (int lvl) =>
      (0.00103636 * lvl * lvl + 2.35549 * lvl + 7.22292).toDouble() / 10,
};

final Map<Slot, Map<TypeStat, String>> _valuesCrit = {
  Slot.oneHandedAxeMain: {
    TypeStat.accuracy: 'Accuracy1Doubled',
  },
  Slot.daggerMain: {
    TypeStat.penetration: 'Uni2+3',
  },
  Slot.oneHandedMaceMain: {TypeStat.penetration: 'Uni2+3'},
  Slot.oneHandedSwordMain: {TypeStat.criticalHit: 'Crit1Doubled'},
  Slot.shieldMain: {TypeStat.block: 'ShieldDoubleBlock'},
  Slot.twoHandedAxeMain: {TypeStat.criticalHit: 'Crit2Doubled'},
  Slot.twoHandedMaceMain: {TypeStat.accuracy: 'Accuracy2Doubled'},
  Slot.twoHandedSwordMain: {TypeStat.penetration: 'Uni4+3'},
  Slot.spearMain: {TypeStat.criticalHit: 'Crit2Doubled'},
  Slot.staffMain: {
    TypeStat.penetration: 'Uni4+3',
    TypeStat.criticalHit: 'Crit2Doubled',
    TypeStat.accuracy: 'Accuracy2Doubled'
  },
  Slot.bowMain: {
    TypeStat.penetration: 'Uni4+3',
    TypeStat.criticalHit: 'Crit2Doubled',
  },
  Slot.crossbowMain: {TypeStat.accuracy: 'Accuracy2Doubled'}
};
final Map<Slot, Map<TypeStat, String>> _values = {
  Slot.setBonus: {
    TypeStat.cooldown: 'CD2',
    TypeStat.magicalDamage: 'MDSetbonus',
    TypeStat.criticalHit: 'BodySetBonus',
    TypeStat.dodge: 'BodySetBonus',
    TypeStat.resilience: 'BodySetBonus',
    TypeStat.parry: 'BodySetBonus',
    TypeStat.resistance: 'BodySetBonus',
    TypeStat.block: 'Uni+4',
    TypeStat.attackSpeed: 'BodySetBonus',
    TypeStat.penetration: 'BodySetBonus',
    TypeStat.accuracy: 'BodySetBonus',
    TypeStat.healthRegeneration: 'Uni10+3',
    TypeStat.health: 'HealthSetBonus',
    TypeStat.physicalDefence: 'PhysicalDefenceSetBonus',
    TypeStat.magicalDefence: 'MagicalDefenceSetBonus' //
  },
  Slot.headMain: {
    TypeStat.cooldown: 'CD2',
    TypeStat.criticalHit: 'Uni+3',
    TypeStat.energy: 'Uni10+3',
    TypeStat.resilience: 'Uni+3',
    TypeStat.resistance: 'Uni+3',
    TypeStat.accuracy: 'Uni+3',
    TypeStat.parry: 'Uni+3',
    TypeStat.damageReflection: 'Percent',
    TypeStat.stealHealth: 'UniDiv2+2',
    TypeStat.physicalDefence: 'PhysicalDefence',
    TypeStat.health: 'HealthMain',
    TypeStat.healthAugmentation: 'UniConst15',
    TypeStat.slowingOxygenConsumption: 'UniConst30' //
  },
  Slot.handsMain: {
    TypeStat.magicalDamage: 'MDRingBeltHands',
    TypeStat.penetration: 'Uni+3',
    TypeStat.criticalHit: 'Uni+3',
    TypeStat.accuracy: 'Uni+3',
    TypeStat.stealHealth: 'UniDiv2+2',
    TypeStat.energy: 'Uni10+3',
    TypeStat.damageReflection: 'Percent',
    TypeStat.resistance: 'Uni+3',
    TypeStat.resilience: 'Uni+3',
    TypeStat.physicalDefence: 'PhysicalDefence',
    TypeStat.health: 'HealthMain',
    TypeStat.healthAugmentation: 'UniConst15' //
  },
  Slot.bootsMain: {
    TypeStat.cooldown: 'CD2',
    TypeStat.criticalHit: 'Uni+3',
    TypeStat.energy: 'Uni10+3',
    TypeStat.resilience: 'Uni+3',
    TypeStat.resistance: 'Uni+3',
    TypeStat.damageReflection: 'Percent',
    TypeStat.stealHealth: 'UniDiv2+2',
    TypeStat.energyRegeneration: 'EnergyRegen',
    TypeStat.parry: 'Uni+3',
    TypeStat.physicalDefence: 'PhysicalDefence',
    TypeStat.health: 'HealthMain',
    TypeStat.healthAugmentation: 'UniConst15',
    TypeStat.speedUnderWater: 'Percent' //
  },
  Slot.chestMain: {
    TypeStat.magicalDamage: 'MDBody',
    TypeStat.stealHealth: 'UniDiv2+2',
    TypeStat.criticalHit: 'BodySetBonus',
    TypeStat.dodge: 'BodySetBonus',
    TypeStat.resilience: 'BodySetBonus',
    TypeStat.resistance: 'BodySetBonus',
    TypeStat.block: 'BodyBlock',
    TypeStat.damageReflection: 'Percent',
    TypeStat.energy: 'Uni10+3',
    TypeStat.magicalDefence: 'MagicalDefenceSecondMain',
    TypeStat.physicalDefence: 'PhysicalDefenceBody',
    TypeStat.health: 'HealthMain',
    TypeStat.healthAugmentation: 'UniConst15' //
  },
  Slot.beltMain: {
    TypeStat.magicalDamage: 'MDRingBeltHands',
    TypeStat.cooldown: 'CD2',
    TypeStat.parry: 'Uni+3',
    TypeStat.accuracy: 'Uni+3',
    TypeStat.criticalHit: 'Uni+3',
    TypeStat.resilience: 'Uni+3',
    TypeStat.attackSpeed: 'Uni+3',
    TypeStat.block: 'BodyBlock',
    TypeStat.physicalDefence: 'PhysicalDefence',
    TypeStat.health: 'HealthMain',
    TypeStat.healthAugmentation: 'UniConst15' //
  },
  Slot.neckMain: {
    TypeStat.piercingAttack: 'Uni+3',
    TypeStat.magicalDamage: 'MDNeck',
    TypeStat.physicalDamage: 'PDNeck',
    TypeStat.penetration: 'Uni+3',
    TypeStat.resilience: 'Uni+3',
    TypeStat.resistance: 'Uni+3',
    TypeStat.energy: 'Uni10+3',
    TypeStat.energyRegeneration: 'EnergyRegen',
    TypeStat.attackSpeed: 'BodySetBonus',
    TypeStat.dodge: 'BlockBody+1',
    TypeStat.stealHealth: 'StealHealthNeck',
    TypeStat.magicalDefence: 'MagicalDefenceNeck',
    TypeStat.rage: 'BodySetBonus+1',
    TypeStat.health: 'HealthNeckCape',
    TypeStat.solidity: 'BodySetBonus+1',
    TypeStat.healthAugmentation: 'UniConst7.5',
    TypeStat.physicalDamageAugmentation: 'Percent',
    TypeStat.magicalDamageAugmentation: 'Percent', //
  },
  Slot.capeMain: {
    TypeStat.piercingAttack: 'Uni+3',
    TypeStat.rage: 'BodySetBonus+1',
    TypeStat.magicalDamage: 'MDCape',
    TypeStat.health: 'HealthNeckCape',
    TypeStat.stealHealth: 'StealHealthCape',
    TypeStat.parry: 'Uni+3',
    TypeStat.resilience: 'Uni+3',
    TypeStat.physicalDamage: 'PDCape',
    TypeStat.resistance: 'Uni+3',
    TypeStat.energyRegeneration: 'EnergyRegen',
    TypeStat.magicalDefence: 'MagicalDefenceCape',
    TypeStat.dodge: 'Uni+3',
    TypeStat.solidity: 'BodySetBonus+1',
    TypeStat.energy: 'Uni10+6',
    TypeStat.attackSpeed: 'Uni+3',
    TypeStat.physicalDamageAugmentation: 'Percent',
    TypeStat.magicalDamageAugmentation: 'Percent', //
  },
  Slot.ringMain: {
    TypeStat.accuracy: 'Uni+3',
    TypeStat.piercingAttack: 'piercingAttackRing',
    TypeStat.rage: 'Uni+3',
    TypeStat.magicalDamage: 'MDRingBeltHands',
    TypeStat.health: 'HealthRing',
    TypeStat.stealHealth: 'StealHealthRing',
    TypeStat.magicalDefence: 'MagicalDefenceRing',
    TypeStat.physicalDamage: 'PDRing',
    TypeStat.solidity: 'Uni+3',
    TypeStat.dodge: 'Uni+3',
    TypeStat.energy: 'Uni10+3',
    TypeStat.healthRegeneration: 'Uni10+3',
    TypeStat.block: 'Uni+3',
    TypeStat.resilience: 'RingResilience',
    TypeStat.resistance: 'RingResistance',
    TypeStat.healthAugmentation: 'UniConst10',
    TypeStat.physicalDamageAugmentation: 'Percent',
    TypeStat.magicalDamageAugmentation: 'Percent', //
  },
  Slot.headCrystal: {
    TypeStat.cooldown: 'CDCrys',
    TypeStat.accuracy: 'Uni+7',
    TypeStat.energy: 'Uni10' //
  },
  Slot.handsCrystal: {
    TypeStat.accuracy: 'Uni+7',
    TypeStat.attackSpeed: 'Uni+7',
    TypeStat.penetration: 'Uni' //
  },
  Slot.bootsCrystal: {
    TypeStat.cooldown: 'CDCrys',
    TypeStat.attackSpeed: 'Uni+7',
    TypeStat.stun: 'Uni+5' //
  },
  Slot.chestCrystal: {
    TypeStat.attackSpeed: 'Uni+7',
    TypeStat.rage: 'RageCrys',
    TypeStat.energy: 'Uni10' //
  },
  Slot.beltCrystal: {
    TypeStat.criticalHit: 'Uni+7',
    TypeStat.piercingAttack: 'Uni+7',
    TypeStat.energyRegeneration: 'EnergyRegenCrys' //
  },
  Slot.neckCrystal: {
    TypeStat.accuracy: 'Uni+7',
    TypeStat.criticalHit: 'Uni+7' //
  },
  Slot.capeCrystal: {
    TypeStat.criticalHit: 'Uni+7',
    TypeStat.piercingAttack: 'Uni+7',
    TypeStat.energy: 'Uni10' //
  },
  Slot.ringCrystal: {
    TypeStat.cooldown: 'CDCrys',
    TypeStat.penetration: 'Uni',
    TypeStat.energyRegeneration: 'EnergyRegenCrys' //
  },
  Slot.oneHandedCrystal: {}, //
  Slot.twoHandedCrystal: {}, //
  Slot.headRune: {
    TypeStat.solidity: 'SolidityRune',
    TypeStat.physicalDefence: 'DefenceRune',
    TypeStat.magicalDefence: 'DefenceRune',
    TypeStat.resistance: 'Uni+4', //
  },
  Slot.handsRune: {
    TypeStat.physicalDefence: 'DefenceRune',
    TypeStat.magicalDefence: 'DefenceRune',
    TypeStat.resilience: 'Uni+7', //
  },
  Slot.bootsRune: {
    TypeStat.physicalDefence: 'DefenceRune',
    TypeStat.magicalDefence: 'DefenceRune',
    TypeStat.resilience: 'Uni+7',
    TypeStat.resistance: 'Uni+4' //
  },
  Slot.chestRune: {
    TypeStat.physicalDefence: 'DefenceRune',
    TypeStat.magicalDefence: 'DefenceRune',
    TypeStat.resilience: 'Uni+7', //
  },
  Slot.beltRune: {
    TypeStat.solidity: 'SolidityRune',
    TypeStat.health: 'HealthRune',
    TypeStat.block: 'Uni',
    TypeStat.damageReflection: 'Uni+4',
    TypeStat.resilience: 'Uni+7' //
  },
  Slot.neckRune: {
    TypeStat.stealHealth: 'StealHealthRune',
    TypeStat.health: 'HealthRune',
    TypeStat.resistance: 'Uni+4',
    TypeStat.healthRegeneration: 'Uni+10', //
  },
  Slot.capeRune: {
    TypeStat.solidity: 'SolidityRune',
    TypeStat.stealHealth: 'StealHealthRune',
    TypeStat.parry: 'Uni',
    TypeStat.healthRegeneration: 'Uni+10', //
  },
  Slot.ringRune: {
    TypeStat.dodge: 'Uni+7',
    TypeStat.stealHealth: 'StealHealthRune',
    TypeStat.health: 'HealthRune' //
  },
  Slot.oneHandedRune: {},
  Slot.twoHandedRune: {},
  Slot.oneHandedSwordMain: {
    TypeStat.cooldown: 'CD2',
    TypeStat.ferocity: 'FerocityMain1',
    TypeStat.depthsFury: 'DepthsfuryMain1',
    TypeStat.physicalDamage: 'SwordMain',
    TypeStat.magicalDamage: 'OnehandedMagMain',
    TypeStat.stun: 'UniConst2.5',
    TypeStat.piercingAttack: 'UniConst5',
    TypeStat.rage: 'UniConst5',
    TypeStat.parry: 'Uni+3',
    TypeStat.accuracy: 'AccuracyMain',
    TypeStat.criticalHit: 'CritAS1Main',
    TypeStat.attackSpeed: 'CritAS1Main',
    TypeStat.penetration: 'Uni+3',
    TypeStat.attackStrength: 'PercentAS',
    TypeStat.stealHealth: 'StealHealth1Main' //
  },
  Slot.oneHandedMaceMain: {
    TypeStat.physicalDamage: 'MaceMain',
    TypeStat.cooldown: 'CD2',
    TypeStat.ferocity: 'FerocityMain1',
    TypeStat.depthsFury: 'DepthsfuryMain1',
    TypeStat.magicalDamage: 'OnehandedMagMain',
    TypeStat.stun: 'UniConst2.5',
    TypeStat.piercingAttack: 'UniConst5',
    TypeStat.rage: 'UniConst5',
    TypeStat.parry: 'Uni+3',
    TypeStat.accuracy: 'AccuracyMain',
    TypeStat.criticalHit: 'CritAS1Main',
    TypeStat.attackSpeed: 'CritAS1Main',
    TypeStat.penetration: 'Uni+3',
    TypeStat.attackStrength: 'PercentAS',
    TypeStat.stealHealth: 'StealHealth1Main' //
  },
  Slot.oneHandedAxeMain: {
    TypeStat.physicalDamage: 'AxeMain',
    TypeStat.cooldown: 'CD2',
    TypeStat.ferocity: 'FerocityMain1',
    TypeStat.depthsFury: 'DepthsfuryMain1',
    TypeStat.stun: 'UniConst2.5',
    TypeStat.piercingAttack: 'UniConst5',
    TypeStat.rage: 'UniConst5',
    TypeStat.parry: 'Uni+3',
    TypeStat.accuracy: 'AccuracyMain',
    TypeStat.criticalHit: 'CritAS1Main',
    TypeStat.attackSpeed: 'CritAS1Main',
    TypeStat.penetration: 'Uni+3',
    TypeStat.attackStrength: 'PercentAS',
    TypeStat.stealHealth: 'StealHealth1Main' //
  },
  Slot.daggerMain: {
    TypeStat.physicalDamage: 'DaggerMain',
    TypeStat.cooldown: 'CD2',
    TypeStat.ferocity: 'FerocityMain1',
    TypeStat.depthsFury: 'DepthsfuryMain1',
    TypeStat.stun: 'UniConst2.5',
    TypeStat.piercingAttack: 'UniConst5',
    TypeStat.rage: 'UniConst5',
    TypeStat.parry: 'Uni+3',
    TypeStat.accuracy: 'AccuracyMain',
    TypeStat.criticalHit: 'CritAS1Main',
    TypeStat.attackSpeed: 'CritAS1Main',
    TypeStat.penetration: 'Uni+3',
    TypeStat.attackStrength: 'PercentAS',
    TypeStat.stealHealth: 'StealHealth1Main' //
  },
  Slot.shieldMain: {
    TypeStat.ferocity: 'FerocityMain1',
    TypeStat.depthsFury: 'DepthsfuryMain1',
    TypeStat.health: 'HealthShield',
    TypeStat.stealHealth: 'StealHealth1Main',
    TypeStat.physicalDefence: 'ShieldDefence',
    TypeStat.energyRegeneration: 'EnergyRegenShield',
    TypeStat.healthRegeneration: 'Uni10+3',
    TypeStat.rage: 'UniConst5',
    TypeStat.block: 'ShieldBlock',
    TypeStat.parry: 'Uni+3',
    TypeStat.attackStrength: 'PercentAS',
    TypeStat.stun: 'UniConst2.5',
    TypeStat.piercingAttack: 'UniConst5', //
  },
  Slot.twoHandedSwordMain: {
    TypeStat.ferocity: 'FerocityMain2',
    TypeStat.depthsFury: 'DepthsfuryMain2',
    TypeStat.attackSpeed: 'CritSpeed2',
    TypeStat.accuracy: 'AccuracyMain2',
    TypeStat.physicalDamage: 'TwohandedMain',
    TypeStat.stun: 'UniConst5',
    TypeStat.piercingAttack: 'UniConst10',
    TypeStat.rage: 'UniConst10',
    TypeStat.parry: 'Uni2+3',
    TypeStat.criticalHit: 'CritSpeed2',
    TypeStat.penetration: 'Uni2+3',
    TypeStat.attackStrength: 'PercentAS',
    TypeStat.stealHealth: 'StealHealth2Main' //
  },
  Slot.twoHandedMaceMain: {
    TypeStat.cooldown: 'CD2',
    TypeStat.ferocity: 'FerocityMain2',
    TypeStat.depthsFury: 'DepthsfuryMain2',
    TypeStat.physicalDamage: 'TwohandedMain',
    TypeStat.magicalDamage: 'TwohandedMagMain',
    TypeStat.accuracy: 'AccuracyMain2',
    TypeStat.stun: 'UniConst5',
    TypeStat.piercingAttack: 'UniConst10',
    TypeStat.rage: 'UniConst10',
    TypeStat.parry: 'Uni2+3',
    TypeStat.criticalHit: 'CritSpeed2',
    TypeStat.penetration: 'Uni2+3',
    TypeStat.attackStrength: 'PercentAS',
    TypeStat.stealHealth: 'StealHealth2Main' //
  },
  Slot.twoHandedAxeMain: {
    TypeStat.ferocity: 'FerocityMain2',
    TypeStat.depthsFury: 'DepthsfuryMain2',
    TypeStat.accuracy: 'AccuracyMain2',
    TypeStat.physicalDamage: 'TwohandedMain',
    TypeStat.stun: 'UniConst5',
    TypeStat.piercingAttack: 'UniConst10',
    TypeStat.rage: 'UniConst10',
    TypeStat.parry: 'Uni2+3',
    TypeStat.criticalHit: 'CritSpeed2',
    TypeStat.penetration: 'Uni2+3',
    TypeStat.attackStrength: 'PercentAS',
    TypeStat.stealHealth: 'StealHealth2Main' //
  },
  Slot.spearMain: {
    TypeStat.cooldown: 'CD2',
    TypeStat.ferocity: 'FerocityMain2',
    TypeStat.depthsFury: 'DepthsfuryMain2',
    TypeStat.physicalDamage: 'SpearMain',
    TypeStat.magicalDamage: 'TwohandedMagMain',
    TypeStat.accuracy: 'AccuracyMain2',
    TypeStat.stun: 'UniConst5',
    TypeStat.piercingAttack: 'UniConst10',
    TypeStat.rage: 'UniConst10',
    TypeStat.parry: 'Uni2+3',
    TypeStat.criticalHit: 'CritSpeed2',
    TypeStat.penetration: 'Uni2+3',
    TypeStat.attackStrength: 'PercentAS',
    TypeStat.stealHealth: 'StealHealth2Main' //
  },
  Slot.staffMain: {
    TypeStat.cooldown: 'CD2',
    TypeStat.ferocity: 'FerocityMain2',
    TypeStat.depthsFury: 'DepthsfuryMain2',
    TypeStat.magicalDamage: 'TwohandedMagMain',
    TypeStat.accuracy: 'AccuracyMain2',
    TypeStat.stun: 'UniConst5',
    TypeStat.piercingAttack: 'UniConst10',
    TypeStat.rage: 'UniConst10',
    TypeStat.criticalHit: 'CritSpeed2',
    TypeStat.penetration: 'Uni2+3',
    TypeStat.attackStrength: 'PercentAS',
    TypeStat.stealHealth: 'StealHealth2Main' //
  },
  Slot.bowMain: {
    TypeStat.cooldown: 'CD2',
    TypeStat.ferocity: 'FerocityMain2',
    TypeStat.depthsFury: 'DepthsfuryMain2',
    TypeStat.physicalDamage: 'BowMain',
    TypeStat.accuracy: 'AccuracyMain2',
    TypeStat.stun: 'UniConst5',
    TypeStat.piercingAttack: 'UniConst10',
    TypeStat.rage: 'UniConst10',
    TypeStat.criticalHit: 'CritSpeed2',
    TypeStat.penetration: 'Uni2+3',
    TypeStat.attackStrength: 'PercentAS',
    TypeStat.stealHealth: 'StealHealth2Main' //
  },
  Slot.crossbowMain: {
    TypeStat.cooldown: 'CD2',
    TypeStat.ferocity: 'FerocityMain2',
    TypeStat.depthsFury: 'DepthsfuryMain2',
    TypeStat.physicalDamage: 'CrossbowMain',
    TypeStat.accuracy: 'AccuracyMain2',
    TypeStat.stun: 'UniConst5',
    TypeStat.piercingAttack: 'UniConst10',
    TypeStat.rage: 'UniConst10',
    TypeStat.criticalHit: 'CritSpeed2',
    TypeStat.penetration: 'Uni2+3',
    TypeStat.attackStrength: 'PercentAS',
    TypeStat.stealHealth: 'StealHealth2Main' //
  },
  Slot.oneHandedSwordCrystal: {
    TypeStat.ferocity: 'FerocityCrys1',
    TypeStat.depthsFury: 'DepthsfuryCrys1',
    TypeStat.physicalDamage: 'SwordCrys',
    TypeStat.stun: 'Uni+5' //
  },
  Slot.oneHandedMaceCrystal: {
    TypeStat.ferocity: 'FerocityCrys1',
    TypeStat.depthsFury: 'DepthsfuryCrys1',
    TypeStat.physicalDamage: 'MaceCrys',
    TypeStat.magicalDamage: 'MagCrys',
    TypeStat.stun: 'Uni+5' //
  },
  Slot.oneHandedAxeCrystal: {
    TypeStat.ferocity: 'FerocityCrys1',
    TypeStat.depthsFury: 'DepthsfuryCrys1',
    TypeStat.physicalDamage: 'AxeCrys',
    TypeStat.stun: 'Uni+5' //
  },
  Slot.daggerCrystal: {
    TypeStat.ferocity: 'FerocityCrys1',
    TypeStat.depthsFury: 'DepthsfuryCrys1',
    TypeStat.physicalDamage: 'DaggerCrys',
    TypeStat.stun: 'Uni+5' //
  },
  Slot.shieldCrystal: {
    TypeStat.ferocity: 'FerocityCrys1',
    TypeStat.depthsFury: 'DepthsfuryCrys1',
    TypeStat.accuracy: 'Uni+7',
    TypeStat.stun: 'Uni+5' //
  },
  Slot.twoHandedSwordCrystal: {
    TypeStat.ferocity: 'FerocityCrys2',
    TypeStat.depthsFury: 'DepthsfuryCrys2',
    TypeStat.stun: 'Uni2+4',
    TypeStat.physicalDamage: 'TwohandedPhysCrys' //
  },
  Slot.twoHandedMaceCrystal: {
    TypeStat.ferocity: 'FerocityCrys2',
    TypeStat.depthsFury: 'DepthsfuryCrys2',
    TypeStat.magicalDamage: 'TwohandedMagCrys',
    TypeStat.stun: 'Uni2+4',
    TypeStat.physicalDamage: 'TwohandedPhysCrys' //
  },
  Slot.twoHandedAxeCrystal: {
    TypeStat.ferocity: 'FerocityCrys2',
    TypeStat.depthsFury: 'DepthsfuryCrys2',
    TypeStat.stun: 'Uni2+4',
    TypeStat.physicalDamage: 'TwohandedPhysCrys' //
  },
  Slot.spearCrystal: {
    TypeStat.ferocity: 'FerocityCrys2',
    TypeStat.depthsFury: 'DepthsfuryCrys2',
    TypeStat.stun: 'Uni2+4',
    TypeStat.physicalDamage: 'SpearCrys',
    TypeStat.magicalDamage: 'TwohandedMagCrys', //
  },
  Slot.staffCrystal: {
    TypeStat.ferocity: 'FerocityCrys2',
    TypeStat.depthsFury: 'DepthsfuryCrys2',
    TypeStat.magicalDamage: 'MagCrys',
    TypeStat.stun: 'Uni2+4', //
  },
  Slot.bowCrystal: {
    TypeStat.ferocity: 'FerocityCrys2',
    TypeStat.depthsFury: 'DepthsfuryCrys2',
    TypeStat.stun: 'Uni2+4',
    TypeStat.physicalDamage: 'BowCrys' //
  },
  Slot.crossbowCrystal: {
    TypeStat.ferocity: 'FerocityCrys2',
    TypeStat.depthsFury: 'DepthsfuryCrys2',
    TypeStat.stun: 'Uni2+4',
    TypeStat.physicalDamage: 'CrossBowCrys' //
  },
  Slot.oneHandedSwordRune: {
    TypeStat.parry: 'Uni',
    TypeStat.dodge: 'Uni+7',
    TypeStat.damageReflection: 'Uni+4', //
  },
  Slot.oneHandedMaceRune: {
    TypeStat.parry: 'Uni',
    TypeStat.dodge: 'Uni+7',
    TypeStat.damageReflection: 'Uni+4', //
  },
  Slot.oneHandedAxeRune: {
    TypeStat.parry: 'Uni',
    TypeStat.dodge: 'Uni+7',
    TypeStat.damageReflection: 'Uni+4', //
  },
  Slot.daggerRune: {
    TypeStat.parry: 'Uni',
    TypeStat.dodge: 'Uni+7',
    TypeStat.damageReflection: 'Uni+4', //
  },
  Slot.shieldRune: {
    TypeStat.damageReflection: 'Uni+4',
    TypeStat.block: 'Uni',
    TypeStat.health: 'HealthRune',
    TypeStat.physicalDefence: 'DefenceRune',
    TypeStat.magicalDefence: 'DefenceRune',
    TypeStat.healthRegeneration: 'Uni10' //
  },
  Slot.twoHandedSwordRune: {
    TypeStat.parry: 'Uni2',
    TypeStat.dodge: 'Dodge2',
    TypeStat.damageReflection: 'Uni2+4' //
  },
  Slot.twoHandedMaceRune: {
    TypeStat.parry: 'Uni2',
    TypeStat.dodge: 'Dodge2',
    TypeStat.damageReflection: 'Uni2+4' //
  },
  Slot.twoHandedAxeRune: {
    TypeStat.parry: 'Uni2',
    TypeStat.dodge: 'Dodge2',
    TypeStat.damageReflection: 'Uni2+4' //
  },
  Slot.spearRune: {
    TypeStat.parry: 'Uni2',
    TypeStat.dodge: 'Dodge2',
    TypeStat.damageReflection: 'Uni2+4' //
  },
  Slot.staffRune: {
    TypeStat.dodge: 'Dodge2',
    TypeStat.damageReflection: 'Uni2+4' //
  },
  Slot.bowRune: {
    TypeStat.dodge: 'Dodge2',
    TypeStat.damageReflection: 'Uni2+4' //
  },
  Slot.crossbowRune: {
    TypeStat.dodge: 'Dodge2',
    TypeStat.damageReflection: 'Uni2+4' //
  },
};

const Map<String, List<Slot>> _slotsMap = {
  'oneHandedWeapon': [
    Slot.oneHandedMain,
    Slot.oneHandedSwordMain,
    Slot.oneHandedMaceMain,
    Slot.oneHandedAxeMain,
    Slot.daggerMain,
    Slot.shieldMain,
  ],
  'twoHandedWeapon': [
    Slot.twoHandedMain,
    Slot.twoHandedSwordMain,
    Slot.twoHandedMaceMain,
    Slot.twoHandedAxeMain,
    Slot.spearMain,
    Slot.staffMain,
    Slot.bowMain,
    Slot.crossbowMain
  ]
};

const Map<Quality, int> _qualityMapping = {
  Quality.grey: -3,
  Quality.green: -2,
  Quality.blue: -1,
  Quality.purple: 0,
  Quality.red: 0,
  Quality.store: 5,
  Quality.quest: -3
};

const Map<WeaponType, Slot> _weaponMapping = {
  WeaponType.oneHandedSword: Slot.oneHandedSwordMain,
  WeaponType.oneHandedMace: Slot.oneHandedMaceMain,
  WeaponType.oneHandedAxe: Slot.oneHandedAxeMain,
  WeaponType.dagger: Slot.daggerMain,
  WeaponType.shield: Slot.shieldMain,
  WeaponType.twoHandedSword: Slot.twoHandedSwordMain,
  WeaponType.twoHandedMace: Slot.twoHandedMaceMain,
  WeaponType.twoHandedAxe: Slot.twoHandedAxeMain,
  WeaponType.spear: Slot.spearMain,
  WeaponType.staff: Slot.staffMain,
  WeaponType.bow: Slot.bowMain,
  WeaponType.crossbow: Slot.crossbowMain,
};

const Map<ArmorSlotType, Slot> _armorMapping = {
  ArmorSlotType.head: Slot.headMain,
  ArmorSlotType.hands: Slot.handsMain,
  ArmorSlotType.boots: Slot.bootsMain,
  ArmorSlotType.chest: Slot.chestMain,
  ArmorSlotType.belt: Slot.beltMain,
};

const Map<AccessoryType, Slot> _accessoryMapping = {
  AccessoryType.amulet: Slot.neckMain,
  AccessoryType.ring: Slot.ringMain,
  AccessoryType.cape: Slot.capeMain,
};

const Map<WeaponType, double> _weaponDelayMapping = {
  WeaponType.oneHandedSword: 2.0,
  WeaponType.oneHandedMace: 2.4,
  WeaponType.oneHandedAxe: 2.2,
  WeaponType.dagger: 1.7,
  WeaponType.twoHandedSword: 3.2,
  WeaponType.twoHandedMace: 3.2,
  WeaponType.twoHandedAxe: 3.2,
  WeaponType.spear: 3.4,
  WeaponType.staff: 3.1,
  WeaponType.bow: 3.3,
  WeaponType.crossbow: 3.9,
};
