import 'package:wssistance/logic/stats/enumerations/enum_slots.dart';
import 'package:wssistance/logic/stats/setbonus.dart';
import 'package:wssistance/logic/stats/stathelper.dart';
import 'package:wssistance/logic/stats/statslot.dart';
import 'package:wssistance/logic/util/enumerations/enumerations.dart';

abstract class Item {
  int id;
  int cost = 0;
  String name;
  Quality quality;
  Item([this.id = -1, this.name = 'Sample item', this.quality = Quality.grey]);
}

mixin Parameters on Item {
  late ParameterType parameterType;
}

mixin Slots on Item {
  late AmplifiableStatSlot firstSlot;
  late List<StatSlot> mainSlotsList;

  late StatSlot crystalSlot;
  late StatSlot runeSlot;
  List<StatSlot> getAvailableEnchantments(Slot slot, int lvl) {
    return StatHelper.getAvailableEnchantments(slot, lvl);
  }

  void changeCrystal(StatSlot slot) {
    crystalSlot = slot;
  }

  void changeRune(StatSlot slot) {
    runeSlot = slot;
  }

  List<StatSlot> get statSlotList {
    List<StatSlot> list = [firstSlot];
    list.addAll(mainSlotsList);
    return list;
  }

  int get ampLevel => firstSlot.ampLevel;
  void amplify(int lvl) {
    firstSlot.amplifySlot(lvl);
  }
}

mixin SetBonusMixin on Item {
  late List<StatSlot> statSlotSetBonusList;
  late SetBonus setBonus;
}
