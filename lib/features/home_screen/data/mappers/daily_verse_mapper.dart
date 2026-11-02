import '../../domain/entities/daily_verse.dart';
import '../models/daily_verse_model.dart';

extension DailyVerseModelMapper on DailyVerseModel {
  DailyVerse toEntity() {
    return DailyVerse(
      bookId: bookId,
      bookName: bookName,
      chapter: chapter,
      verse: verse,
      text: text,
      translationId: translationId,
      translationName: translationName,
    );
  }
}
