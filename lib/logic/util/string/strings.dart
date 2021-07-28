class Des {
  // ignore: unused_field
  final int _id;
  final String _ru;
  // ignore: unused_field
  final String _eng;
  Des(this._id, [this._ru = '', this._eng = '']);
  Des.fromList(List<dynamic> l)
      : _id = l[0],
        _ru = l[1],
        _eng = '';
  String get value => _ru;
}

class Noun {
  // ignore: unused_field
  final int _id;
  final String value;
  final int _ref;
  final int gender;
  Noun(this._id, this.value, this._ref, this.gender);
  Noun.fromList(List<dynamic> l)
      : _id = l[0],
        value = l[1],
        _ref = l[2],
        gender = l[3];
  int get ref => _ref;
}

class Adj {
  // ignore: unused_field
  final int _id;
  final String _ru;
  final int _relatedAdjHelp;
  // ignore: unused_field
  final String _eng;
  Adj(this._id, this._ru, this._relatedAdjHelp, [this._eng = '']);
  Adj.fromList(List<dynamic> l)
      : _id = l[0],
        _ru = l[1],
        _relatedAdjHelp = l[2],
        _eng = '';
  String get value => _ru;
  int get relAdj => _relatedAdjHelp;
}

class AdjHelp {
  final int _id;
  final String m;
  final String w;
  final String nb;
  final String p;
  AdjHelp(this._id, this.m, this.w, this.nb, this.p);
  AdjHelp.fromList(List<dynamic> l)
      : _id = l[0],
        m = l[1],
        w = l[2],
        nb = l[3],
        p = l[4];
  int get id => _id;
}
