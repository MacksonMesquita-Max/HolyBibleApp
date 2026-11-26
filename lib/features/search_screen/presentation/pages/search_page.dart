import 'package:flutter/material.dart';

import '../../../../shared/widgets/inputs/search_input.dart';
import '../../application/use_cases/search_content_use_case.dart';
import '../../domain/entities/search_results.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({required this.searchContentUseCase, super.key});

  final SearchContentUseCase searchContentUseCase;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _queryController = TextEditingController();

  SearchResults? _results;
  String? _errorMessage;
  String? _searchedQuery;
  bool _isLoading = false;

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  Future<void> _search(String query) async {
    final normalizedQuery = query.trim();
    if (normalizedQuery.isEmpty || _isLoading) {
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _results = null;
      _searchedQuery = normalizedQuery;
    });

    try {
      final results = await widget.searchContentUseCase.execute(
        normalizedQuery,
      );
      if (!mounted) return;
      setState(() => _results = results);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Não foi possível concluir a pesquisa.';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Pesquisa')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: SearchInput(
                      controller: _queryController,
                      autofocus: true,
                      enabled: !_isLoading,
                      hintText: 'Referência bíblica, título ou trecho de hino',
                      onSubmitted: _search,
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: 56,
                    child: FilledButton(
                      onPressed: _isLoading
                          ? null
                          : () => _search(_queryController.text),
                      child: const Icon(Icons.search_rounded),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(child: _buildContent(theme)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final errorMessage = _errorMessage;
    if (errorMessage != null) {
      return Center(
        child: Text(
          errorMessage,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.error,
          ),
        ),
      );
    }

    final results = _results;
    if (results == null) {
      return Center(
        child: Text(
          'Pesquise uma referência bíblica ou um hino.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return ListView(
      children: [
        Text(
          'Resultados para “${_searchedQuery ?? ''}”',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 20),
        _buildBibleResults(theme, results),
        const SizedBox(height: 20),
        _buildHymnResults(theme, results),
      ],
    );
  }

  Widget _buildBibleResults(ThemeData theme, SearchResults results) {
    Widget message(String text, {bool isError = false}) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          text,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isError
                ? theme.colorScheme.error
                : theme.colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    final passage = results.passage;
    final content = !results.isBibleReferenceQuery
        ? message('Na Bíblia, pesquise por referência, como “John 3:16”.')
        : results.bibleUnavailable
        ? message('Não foi possível consultar a Bíblia agora.', isError: true)
        : passage == null
        ? message('Nenhuma passagem correspondente foi encontrada.')
        : _buildPassage(theme, passage);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bíblia (${_translationLabel(passage)})',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        content,
      ],
    );
  }

  Widget _buildPassage(ThemeData theme, ScripturePassageMatch passage) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              passage.reference,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            for (final verse in passage.verses) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: RichText(
                  text: TextSpan(
                    style: theme.textTheme.bodyMedium,
                    children: [
                      TextSpan(
                        text: '${verse.number}  ',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(text: verse.text),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _translationLabel(ScripturePassageMatch? passage) {
    final translation = passage?.translationName.trim();
    if (translation == null || translation.isEmpty) {
      return 'KJV';
    }
    return translation;
  }

  Widget _buildHymnResults(ThemeData theme, SearchResults results) {
    final content = results.harpaUnavailable
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'Não foi possível pesquisar hinos agora.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          )
        : results.hymns.isEmpty
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'Nenhum hino correspondente foi encontrado.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          )
        : Card(
            margin: EdgeInsets.zero,
            child: Column(
              children: [
                for (var index = 0; index < results.hymns.length; index++) ...[
                  if (index > 0) const Divider(height: 1),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          theme.colorScheme.surfaceContainerHighest,
                      child: Text(
                        '${results.hymns[index].number}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    title: Text(results.hymns[index].title),
                    subtitle: const Text('Harpa Cristã'),
                    trailing: const Icon(Icons.music_note_rounded),
                  ),
                ],
              ],
            ),
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Harpa Cristã',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        content,
      ],
    );
  }
}
