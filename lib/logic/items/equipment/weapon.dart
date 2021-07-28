import 'package:wssistance/logic/items/item.dart';
import 'package:wssistance/logic/stats/enumerations/enum_stats.dart';
import 'package:wssistance/logic/stats/stathelper.dart';
import 'package:wssistance/logic/stats/statslot.dart';
import 'package:wssistance/logic/util/enumerations/enumerations.dart';
import 'package:wssistance/logic/util/mixins/level.dart';

class Weapon extends Item with Level, Parameters, Slots {
  WeaponType weaponType;
  late double attackDelay;
  Weapon(
      {required int id,
      required String name,
      required int lvl,
      required this.weaponType,
      required ParameterType paramType,
      required TypeStat firstStat,
      required List<TypeStat> statList,
      required Quality quality,
      int pc = 0})
      : super(id, name, quality) {
    firstSlot = AmplifiableStatSlot(
        level: lvl + (pc == 1 ? 1 : 0),
        slot: StatHelper.getWeaponSlot(weaponType),
        type: firstStat);
    for (int i = 0; i < 3; ++i) {
      mainSlotsList[i] = StatSlot(
        level: lvl + StatHelper.getLevelChange(quality),
        type: statList[i],
        slot: StatHelper.getWeaponSlot(weaponType),
        isCrit: (i == 1 && pc > 1),
      );
    }
    attackDelay = StatHelper.getWeaponDelay(weaponType);
    parameterType = paramType;
    this.level = lvl;
  }
  int get damage => this.firstSlot.actualValue;
  String get name => ((ampLevel != 0) ? '+$ampLevel' : '') + super.name;
}
