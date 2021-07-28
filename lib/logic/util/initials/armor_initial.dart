import 'package:wssistance/logic/items/equipment/armor.dart';
import 'package:wssistance/logic/util/enumerations/enumerations.dart';
import 'package:wssistance/logic/util/store/store.dart';

class ArmorInitial {
  final int id,
      lvl,
      type,
      atype,
      adj,
      noun,
      des,
      q,
      sc,
      bc,
      bv,
      s2,
      s3,
      s4,
      sb,
      pc;
  ArmorInitial.fromListWithId(List<dynamic> l, int inputId)
      : id = inputId,
        lvl = l[0],
        type = l[1],
        atype = l[2],
        adj = l[3],
        noun = l[4],
        des = l[5],
        q = l[6],
        sc = l[7],
        bc = l[8],
        bv = l[9],
        s2 = l[10],
        s3 = l[11],
        s4 = l[12],
        sb = l[13],
        pc = l[14];
  Quality get quality => Store.itq(q);
  ArmorType get armorType => ArmorType.values[atype - 1];
  ArmorSlotType get armorSlotType => ArmorSlotType.values[type - 1];
  ParameterType get paramType => ParameterType.equipping;
  Armor get toItem {
    return Armor(
        id: id,
        name: Store.formName(adj, noun, des),
        lvl: lvl,
        armorType: armorType,
        armorSlotType: armorSlotType,
        quality: Store.itq(q),
        paramType: paramType,
        statList: Store.lts(s2, s3, s4),
        inputSetBonus: Store.getSetBonusFromId(sb));
  }

  String get name => Store.formName(adj, noun, des);
}
