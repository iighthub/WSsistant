import 'package:wssistance/logic/items/item.dart';
import 'package:wssistance/logic/stats/enumerations/enum_stats.dart';
import 'package:wssistance/logic/stats/setbonus.dart';
import 'package:wssistance/logic/stats/stathelper.dart';
import 'package:wssistance/logic/stats/statslot.dart';
import 'package:wssistance/logic/util/enumerations/enumerations.dart';
import 'package:wssistance/logic/util/mixins/level.dart';

class Armor extends Item with Level, Parameters, Slots, SetBonusMixin {
  late ArmorType armorType;
  late ArmorSlotType armorSlotType;
  Armor(
      {required int id,
      required String name,
      required int lvl,
      required ArmorType armorType,
      required ArmorSlotType armorSlotType,
      required ParameterType paramType,
      required List<TypeStat> statList,
      required SetBonus inputSetBonus,
      required Quality quality})
      : super(id, name, quality) {
    for (int i = 0; i < 3; ++i) {
      mainSlotsList[i] = StatSlot(
        level: lvl + StatHelper.getLevelChange(quality),
        type: statList[i],
        slot: StatHelper.getArmorSlot(armorSlotType),
        isCrit: false,
      );
    }
    setBonus = inputSetBonus;
    firstSlot = AmplifiableStatSlot(
        level: lvl +
            StatHelper.getArmorTypeChange(armorType) +
            StatHelper.getLevelChange(quality),
        slot: StatHelper.getArmorSlot(armorSlotType),
        type: TypeStat.physicalDefence);
    this.armorSlotType = armorSlotType;
    this.armorType = armorType;
    parameterType = paramType;
    this.level = lvl;
  }
  String get name => ((ampLevel != 0) ? '+$ampLevel' : '') + super.name;
}
