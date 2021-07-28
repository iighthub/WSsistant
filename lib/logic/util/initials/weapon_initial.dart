import 'package:wssistance/logic/items/equipment/weapon.dart';
import 'package:wssistance/logic/stats/enumerations/enum_stats.dart';
import 'package:wssistance/logic/util/enumerations/enumerations.dart';
import 'package:wssistance/logic/util/idGenerator/id_generator.dart';
import 'package:wssistance/logic/util/store/store.dart';

class WeaponInitial {
  final int id, lvl, adj, noun, des, q, sc, bc, bv, s1, s2, s3, s4, pc;
  WeaponInitial(this.id, this.lvl, this.adj, this.noun, this.des, this.q,
      this.sc, this.bc, this.bv, this.s1, this.s2, this.s3, this.s4, this.pc);
  WeaponInitial.fromList(List<dynamic> l)
      : id = IdGenerator.nextId,
        lvl = l[0],
        adj = l[1],
        noun = l[2],
        des = l[3],
        q = l[4],
        sc = l[5],
        bc = l[6],
        bv = l[7],
        s1 = l[8],
        s2 = l[9],
        s3 = l[10],
        s4 = l[11],
        pc = l[12];
  WeaponInitial.fromListWithId(List<dynamic> l, int inputId)
      : id = inputId,
        lvl = l[0],
        adj = l[1],
        noun = l[2],
        des = l[3],
        q = l[4],
        sc = l[5],
        bc = l[6],
        bv = l[7],
        s1 = l[8],
        s2 = l[9],
        s3 = l[10],
        s4 = l[11],
        pc = l[12];
  WeaponType get type =>
      WeaponType.values[Store.getReferenceFromNounId(noun) - 1];
  ParameterType get paramType => ParameterType.equipping;
  Quality get quality => Store.itq(q);
  TypeStat get firstStat =>
      s1 == 1 ? TypeStat.physicalDamage : TypeStat.magicalDamage;
  Weapon get toItem {
    return Weapon(
        id: id,
        name: Store.formName(adj, noun, des),
        lvl: lvl,
        weaponType: type,
        paramType: paramType,
        firstStat: firstStat,
        statList: Store.lts(s2, s3, s4),
        quality: quality,
        pc: pc);
  }

  String get name => Store.formName(adj, noun, des);
}
