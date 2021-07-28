import 'package:wssistance/logic/items/equipment/accessory.dart';
import 'package:wssistance/logic/util/enumerations/enumerations.dart';
import 'package:wssistance/logic/util/idGenerator/id_generator.dart';
import 'package:wssistance/logic/util/store/store.dart';

class AccessoryInitial {
  final int id, lvl, adj, noun, des, q, sc, bc, bv, s2, s3, s4;
  AccessoryInitial.fromList(List<dynamic> l)
      : id = IdGenerator.nextId,
        lvl = l[0],
        adj = l[1],
        noun = l[2],
        des = l[3],
        q = l[4],
        sc = l[5],
        bc = l[6],
        bv = l[7],
        s2 = l[8],
        s3 = l[9],
        s4 = l[10];
  AccessoryInitial.fromListWithId(List<dynamic> l, int inputId)
      : id = inputId,
        lvl = l[0],
        adj = l[1],
        noun = l[2],
        des = l[3],
        q = l[4],
        sc = l[5],
        bc = l[6],
        bv = l[7],
        s2 = l[8],
        s3 = l[9],
        s4 = l[10];

  AccessoryType get type {
    return AccessoryType.values[Store.getReferenceFromNounId(noun) - 1];
  }

  ParameterType get paramType {
    return ParameterType.equipping;
  }

  Quality get quality => Store.itq(q);
  String get name => Store.formName(adj, noun, des);
  Accessory get toItem {
    return Accessory(
        id: id,
        name: Store.formName(adj, noun, des),
        lvl: lvl,
        accessoryType: type,
        paramType: paramType,
        quality: Store.itq(q),
        statList: Store.lts(s2, s3, s4));
  }
}
