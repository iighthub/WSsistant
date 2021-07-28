import 'package:wssistance/logic/items/item.dart';
import 'package:wssistance/logic/stats/enumerations/enum_stats.dart';
import 'package:wssistance/logic/stats/stathelper.dart';
import 'package:wssistance/logic/stats/statslot.dart';
import 'package:wssistance/logic/util/enumerations/enumerations.dart';
import 'package:wssistance/logic/util/mixins/level.dart';

class Accessory extends Item with Level, Parameters, Slots {
  late AccessoryType accessoryType;
  Accessory({
    required int id,
    required String name,
    required int lvl,
    required AccessoryType accessoryType,
    required ParameterType paramType,
    required Quality quality,
    required List<TypeStat> statList,
  }) : super(id, name, quality) {
    firstSlot = AmplifiableStatSlot(
        level: lvl + StatHelper.getLevelChange(quality),
        slot: StatHelper.getAccessorySlot(accessoryType),
        type: TypeStat.magicalDefence);
    for (int i = 0; i < 3; ++i) {
      mainSlotsList[i] = StatSlot(
        level: lvl + StatHelper.getLevelChange(quality),
        type: statList[i],
        slot: StatHelper.getAccessorySlot(accessoryType),
        isCrit: false,
      );
    }
    this.accessoryType = accessoryType;
    parameterType = paramType;
    this.level = lvl;
  }
  @override
  String get name => ((ampLevel != 0) ? '+$ampLevel ' : '') + super.name;
}
