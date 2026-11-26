import 'package:flutter/material.dart';

import '../../../../shared/widgets/buttons/icon_action_button.dart';
import '../../../../shared/widgets/inputs/search_input.dart';
import '../../application/use_cases/search_content_use_case.dart';
import '../../domain/entities/search_results.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({
    required this.searchContentUseCase,
    required this.onOpenBibleReference,
    required this.onOpenHymn,
    super.key,
  });

  final SearchContentUseCase searchContentUseCase;
  final ValueChanged<String> onOpenBibleReference;
  final ValueChanged<int> onOpenHymn;

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
                    width: 56,
                    height: 56,
                    child: IconActionButton(
                      icon: Icons.search_rounded,
                      tooltip: 'Pesquisar',
                      onPressed: _isLoading
                          ? null
                          : () => _search(_queryController.text),
                      style: IconButton.styleFrom(
                        minimumSize: const Size(56, 56),
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
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

    final hasBibleShortcut = results.passage != null;
    final hasHymnShortcuts = results.hymns.isNotEmpty;
    final noShortcuts = !hasBibleShortcut && !hasHymnShortcuts;

    return ListView(
      children: [
        Text(
          'Atalhos para “${_searchedQuery ?? ''}”',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        if (hasBibleShortcut) _buildBibleShortcut(theme, results),
        if (!hasBibleShortcut) _buildBibleStatus(theme, results),
        const SizedBox(height: 16),
        if (hasHymnShortcuts)
          _buildHymnShortcuts(theme, results)
        else
          _buildHarpaStatus(theme, results),
        if (noShortcuts &&
            !results.bibleUnavailable &&
            !results.harpaUnavailable)
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Text(
              'Nenhum atalho encontrado para essa pesquisa.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBibleShortcut(ThemeData theme, SearchResults results) {
    final passage = results.passage!;
    final searchedReference = _searchedQuery ?? passage.reference;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bíblia',
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Card(
          margin: EdgeInsets.zero,
          child: ListTile(
            leading: Icon(
              Icons.menu_book_outlined,
              color: theme.colorScheme.primary,
            ),
            title: Text(passage.reference),
            subtitle: Text(
              '${passage.verses.length} versículos · ${passage.translationName}',
            ),
            trailing: const Icon(Icons.arrow_forward_rounded),
            onTap: () => widget.onOpenBibleReference(searchedReference),
          ),
        ),
      ],
    );
  }

  Widget _buildBibleStatus(ThemeData theme, SearchResults results) {
    final message = !results.isBibleReferenceQuery
        ? 'A Bíblia permite buscar por referência, como “John 3:16”.'
        : results.bibleUnavailable
        ? 'A Bíblia está indisponível no momento.'
        : 'Nenhuma passagem correspondente foi encontrada.';

    return _SearchSectionStatus(
      title: 'Bíblia',
      message: message,
      isError: results.bibleUnavailable,
    );
  }

  Widget _buildHymnShortcuts(ThemeData theme, SearchResults results) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Harpa Cristã',
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Card(
          margin: EdgeInsets.zero,
          child: Column(
            children: [
              for (var index = 0; index < results.hymns.length; index++) ...[
                if (index > 0) const Divider(height: 1),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    child: Text(
                      '${results.hymns[index].number}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  title: Text(results.hymns[index].title),
                  subtitle: Text('Hino ${results.hymns[index].number} · Abrir'),
                  trailing: const Icon(Icons.arrow_forward_rounded),
                  onTap: () => widget.onOpenHymn(results.hymns[index].number),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHarpaStatus(ThemeData theme, SearchResults results) {
    return _SearchSectionStatus(
      title: 'Harpa Cristã',
      message: results.harpaUnavailable
          ? 'A Harpa Cristã está indisponível no momento.'
          : 'Nenhum hino correspondente foi encontrado.',
      isError: results.harpaUnavailable,
    );
  }
}

class _SearchSectionStatus extends StatelessWidget {
  const _SearchSectionStatus({
    required this.title,
    required this.message,
    this.isError = false,
  });

  final String title;
  final String message;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isError
                  ? theme.colorScheme.error
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}
