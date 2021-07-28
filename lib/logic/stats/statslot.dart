import 'package:wssistance/logic/stats/enumerations/enum_slots.dart';
import 'package:wssistance/logic/stats/enumerations/enum_stats.dart';
import 'package:wssistance/logic/stats/stathelper.dart';
import 'package:wssistance/logic/util/enumerations/enumerations.dart';

class StatSlot {
  final TypeStat type;
  double value;
  int level;
  final Slot slot;
  final bool isPercent;
  final bool isCrit;
  StatSlot({
    required this.type,
    required this.slot,
    required this.level,
    this.isCrit = false,
  })  : value = StatHelper.getValue(type, slot, level, isCrit),
        isPercent = StatHelper.isPercent(type);
  StatSlot.withQuality(
      {required this.type,
      required this.slot,
      required int level,
      this.isCrit = false,
      required Quality quality})
      : level = level + StatHelper.getLevelChange(quality),
        isPercent = StatHelper.isPercent(type),
        value = StatHelper.getValue(
            type, slot, level + StatHelper.getLevelChange(quality), isCrit);
}

class AmplifiableStatSlot extends StatSlot {
  int _actualValue;
  int ampLevel;

  AmplifiableStatSlot(
      {required TypeStat type, required Slot slot, required int level})
      : _actualValue = StatHelper.getValue(type, slot, level, false).toInt(),
        ampLevel = 0,
        super(
          type: type,
          slot: slot,
          level: level,
          isCrit: false,
        );

  int get actualValue => _actualValue;

  double get value => actualValue.toDouble();

  int amplifySlot(int ampLevel) {
    if (!StatHelper.isAmplifiable(type)) return 0;
    this.ampLevel = ampLevel;
    this._actualValue = (value +
            value *
                (_ampValues[(StatHelper.isWeapon(slot))
                        ? 'WeaponPercent'
                        : ((StatHelper.isMagicalArmorSlot(slot))
                            ? 'MAPercent'
                            : 'PAPercent')]![ampLevel] /
                    100.0) +
            _ampValues[(StatHelper.isWeapon(slot)
                ? ((StatHelper.isOneHanded(slot))
                    ? 'Weapon1Bonus'
                    : 'Weapon2Bonus')
                : 'ArmorBonus')]![ampLevel])
        .toInt();
    return this._actualValue;
  }
}

final Map<String, List<int>> _ampValues = {
  'WeaponPercent': [0, 2, 4, 6, 10, 14, 21, 33, 49, 66, 86],
  'PAPercent': [0, 6, 10, 15, 24, 27, 53, 72, 98, 134, 185],
  'MAPercent': [0, 11, 18, 25, 35, 47, 63, 85, 115, 152, 200],
  'Weapon1Bonus': List.generate(11, (index) => index),
  'Weapon2Bonus': List.generate(11, (index) => 2 * index),
  'ArmorBonus': List.generate(11, (index) => (index == 0) ? 0 : (6 + 4 * index))
};
