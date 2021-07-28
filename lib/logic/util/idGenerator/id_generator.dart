class IdGenerator {
  static int _currentId = 1;
  static int get nextId {
    return ++_currentId;
  }
}
