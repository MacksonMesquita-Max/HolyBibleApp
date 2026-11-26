import '../../domain/entities/random_hymn.dart';

class RandomHymnModel {
  const RandomHymnModel({required this.title});

  factory RandomHymnModel.fromJson(Map<String, dynamic> json) {
    final hymn = json['hymn'];
    if (hymn is! Map<String, dynamic>) {
      throw const FormatException('Resposta inválida ao carregar o hino.');
    }

    final title = hymn['title'];
    if (title is! String || title.trim().isEmpty) {
      throw const FormatException('O hino retornado não possui título.');
    }

    return RandomHymnModel(title: title.trim());
  }

  final String title;

  RandomHymn toEntity() => RandomHymn(title: title);
}
