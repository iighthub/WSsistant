import 'package:wssistance/logic/util/store/store.dart';

mixin Name {
  late int adj;
  late int noun;
  late int des;
  String get name => Store.formName(adj, noun, des);
}
