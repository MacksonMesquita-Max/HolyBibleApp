import '../../domain/entities/random_hymn.dart';

abstract interface class RandomHymnRepository {
  Future<RandomHymn> getRandomHymn();
}
