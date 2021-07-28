import 'package:flutter/services.dart';
import 'package:wssistance/logic/items/item.dart';
import 'package:wssistance/logic/stats/enumerations/enum_stats.dart';
import 'package:wssistance/logic/stats/setbonus.dart';
import 'package:wssistance/logic/util/enumerations/enumerations.dart';
import 'package:wssistance/logic/util/idGenerator/id_generator.dart';
import 'package:wssistance/logic/util/initials/accessory_initial.dart';
import 'package:wssistance/logic/util/initials/armor_initial.dart';
import 'package:wssistance/logic/util/initials/weapon_initial.dart';
import 'package:wssistance/logic/util/string/strings.dart';

import 'package:csv/csv.dart';

class Store {
  static Map<int, Noun> _nounMap = {};
  static Map<int, Des> _desMap = {};
  static Map<int, Adj> _adjMap = {};
  static Map<int, AdjHelp> _adjHelpMap = {};
  static Map<int, AccessoryInitial> _accessoryMap = {};
  static Map<int, WeaponInitial> _weaponMap = {};
  static Map<int, ArmorInitial> _armorMap = {};
  static Map<int, SetBonus> _setBonusMap = {};
  static bool loaded = false;

  static Item getItem(Type initialType, int itemId) {
    switch (initialType) {
      case WeaponInitial:
        {
          return _weaponMap[itemId]!.toItem;
        }
      case ArmorInitial:
        {
          return _armorMap[itemId]!.toItem;
        }
      default:
        {
          return _accessoryMap[itemId]!.toItem;
        }
    }
  }

  static int getReferenceFromNounId(int id) => _nounMap[id]!.ref;
  static SetBonus getSetBonusFromId(int sb) => _setBonusMap[sb]!;
  //static instance(int id) => _weaponMap[id];
  static List<ArmorInitial> getAvailableArmor(
      List<ArmorType> types, ArmorSlotType slotType, int lvl) {
    List<ArmorInitial> q = [];
    _armorMap.forEach((key, value) {
      if (value.armorSlotType == slotType &&
          types.contains(value.armorType) &&
          value.lvl <= lvl) {
        q.add(value);
      }
    });
    q.sort((ArmorInitial a, ArmorInitial b) => b.lvl - a.lvl);
    return q;
  }

  static List<WeaponInitial> getAvailableWeapon(
      List<WeaponType> types, int lvl) {
    List<WeaponInitial> q = [];
    _weaponMap.forEach((key, value) {
      if (types.contains(value.type) && value.lvl <= lvl) q.add(value);
    });
    q.sort((WeaponInitial a, WeaponInitial b) => b.lvl - a.lvl);
    return q;
  }

  static List<AccessoryInitial> getAvailableAccessory(
      AccessoryType type, int lvl) {
    List<AccessoryInitial> q = [];
    _accessoryMap.forEach((key, value) {
      if (type == value.type && value.lvl <= lvl) q.add(value);
    });
    q.sort((AccessoryInitial a, AccessoryInitial b) => b.lvl - a.lvl);
    return q;
  }

  ///Transforms `int` into `Quality`
  static Quality itq(int q) => Quality.values[q - 1];

  ///Transforms `int` into `TypeStat`
  static TypeStat itts(int i) => TypeStat.values[i - 1];

  ///Transforms three `int`s to `List<TypeStat>[3]`
  static List<TypeStat> lts(int s2, int s3, int s4) {
    List<TypeStat> l = [];
    l..add(itts(s2))..add(itts(s3))..add(itts(s4));
    return l;
  }

  static dynamic loadFromAssets(String path) async {
    final data = await rootBundle.loadString('assets/$path');
    return CsvToListConverter().convert(data);
  }

  static String formName(int adj, int noun, int des) {
    if (!loaded) return 'NotLoaded';
    String ret;
    if (adj != -1) {
      if (_adjMap[adj] == null || _nounMap[noun] == null) return '[NotFound]';
      ret = _fluc(_adjMap[adj]!.value) +
          _ending(noun, adj) +
          ' ' +
          _nounMap[noun]!.value;
    } else {
      ret = _fluc(_nounMap[noun]!.value);
    }
    if (des != -1) {
      if (_desMap[des] == null) return '[Description error]';
      ret += ' ' + _desMap[des]!.value;
    }
    return ret;
  }

  /// Returns appropriate russian ending to adjective with given ids of `Noun` and `Adjective`.
  static String _ending(int noun, int adj) {
    switch (_nounMap[noun]!.gender) {
      case 1:
        return _adjHelpMap[_adjMap[adj]!.relAdj]!.m;
      case 2:
        return _adjHelpMap[_adjMap[adj]!.relAdj]!.w;
      case 3:
        return _adjHelpMap[_adjMap[adj]!.relAdj]!.nb;
      case 4:
        return _adjHelpMap[_adjMap[adj]!.relAdj]!.p;
      default:
        return '[Ending not found]';
    }
  }

  /// Returns `s` with uppercased first letter.
  static String _fluc(String s) {
    return s.substring(0, 1).toUpperCase() + s.substring(1);
  }

  static Future loadFromCSV() async {
    if (loaded) return;
    await _loadStrings();
    await _loadWeapon();
    await _loadArmor();
    await _loadAccessory();
    await _loadSetBonus();

    loaded = true;
    print('loaded. id counter: ${IdGenerator.nextId}');
  }

  static _loadSetBonus() async {
    dynamic fields;
    fields = await loadFromAssets('csv/misc/setbonus.csv');

    fields.forEach((element) {
      _setBonusMap[element[0]] = SetBonus.fromList(element);
    });
  }

  static _loadWeapon() async {
    dynamic fields;
    List<String> l = [];
    ['craft', 'predel', 'bal', 'arena', 'spring'].forEach((element) {
      element = 'csv/weapon/$element.csv';
    });
    try {
      l.forEach((element) async {
        fields = await loadFromAssets(element);
        int i;
        fields.forEach((element) {
          i = IdGenerator.nextId;
          _weaponMap[i] = WeaponInitial.fromListWithId(element, i);
        });
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  static _loadArmor() async {
    dynamic fields;
    List<String> l = [];
    ['craft', 'predel', 'bal', 'arena', 'spring']..forEach((element) {
        l.add('csv/weapon/$element.csv');
      });
    l.forEach((element) async {
      fields = await loadFromAssets(element);
      int i;
      fields.forEach((element) {
        i = IdGenerator.nextId;
        _armorMap[i] = ArmorInitial.fromListWithId(element, i);
      });
    });
  }

  static _loadAccessory() async {
    dynamic fields;
    List<String> l = [];
    ['vel', 'predel', 'bal', 'dr'].forEach((element) {
      l.add('csv/accessory/$element.csv');
    });
    l.forEach((element) async {
      fields = await loadFromAssets(element);
      int i;
      fields.forEach((element) {
        i = IdGenerator.nextId;
        _accessoryMap[i] = AccessoryInitial.fromListWithId(element, i);
      });
    });
  }

  static _loadStrings() async {
    dynamic fields = await loadFromAssets('csv/strings/noun.csv');
    fields.forEach((element) {
      _nounMap[element[0]] = Noun.fromList(element);
    });
    fields = await loadFromAssets('csv/strings/des.csv');
    fields.forEach((element) {
      _desMap[element[0]] = Des.fromList(element);
    });
    fields = await loadFromAssets('csv/strings/adj.csv');
    fields.forEach((element) {
      _adjMap[element[0]] = Adj.fromList(element);
    });
    fields = await loadFromAssets('csv/strings/adjhelp.csv');
    fields.forEach((element) {
      _adjHelpMap[element[0]] = AdjHelp.fromList(element);
    });
  }
}
