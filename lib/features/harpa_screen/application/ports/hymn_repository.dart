import '../../domain/entities/hymn.dart';

abstract interface class HymnRepository {
  Future<Hymn> getByNumber(int number);
}
