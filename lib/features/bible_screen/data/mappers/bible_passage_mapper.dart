import '../../domain/entities/bible_passage.dart';
import '../../domain/entities/bible_verse.dart';
import '../models/bible_passage_model.dart';
import '../models/bible_verse_model.dart';

extension BiblePassageModelMapper on BiblePassageModel {
  BiblePassage toEntity() {
    return BiblePassage(
      reference: reference,
      verses: verses.map((verse) => verse.toEntity()).toList(growable: false),
      translationId: translationId,
      translationName: translationName,
    );
  }
}

extension BibleVerseModelMapper on BibleVerseModel {
  BibleVerse toEntity() {
    return BibleVerse(
      bookId: bookId,
      bookName: bookName,
      chapter: chapter,
      verse: verse,
      text: text,
    );
  }
}
