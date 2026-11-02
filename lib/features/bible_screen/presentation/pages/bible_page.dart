import 'package:flutter/material.dart';

import '../../application/dto/passage_request.dart';
import '../../application/use_cases/get_passage_use_case.dart';
import '../../domain/entities/bible_passage.dart';
import '../../domain/exceptions/bible_api_exception.dart';

class BiblePage extends StatefulWidget {
  const BiblePage({
    required this.getPassageUseCase,
    required this.bottomNavigationBar,
    super.key,
  });

  final GetPassageUseCase getPassageUseCase;
  final Widget bottomNavigationBar;

  @override
  State<BiblePage> createState() => _BiblePageState();
}

class _BiblePageState extends State<BiblePage> {
  final TextEditingController _referenceController = TextEditingController(
    text: 'João 3:16',
  );

  bool _isLoading = false;
  String? _errorMessage;
  BiblePassage? _passage;

  @override
  void dispose() {
    _referenceController.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final passage = await widget.getPassageUseCase.execute(
        PassageRequest(reference: _referenceController.text),
      );
      if (!mounted) return;
      setState(() => _passage = passage);
    } on ArgumentError catch (error) {
      if (!mounted) return;
      setState(() {
        _errorMessage = error.message?.toString() ?? 'Referência inválida.';
      });
    } on BibleApiException catch (error) {
      if (!mounted) return;
      setState(() => _errorMessage = error.message);
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
      appBar: AppBar(title: const Text('Bíblia')),
      bottomNavigationBar: widget.bottomNavigationBar,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _referenceController,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (_) => _search(),
                      decoration: const InputDecoration(
                        labelText: 'Referência',
                        hintText: 'Ex.: João 3:16',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(
                    onPressed: _isLoading ? null : _search,
                    child: const Text('Buscar'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(child: _buildResult(theme)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResult(ThemeData theme) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final error = _errorMessage;
    if (error != null) {
      return Center(
        child: Text(
          error,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.error,
          ),
        ),
      );
    }

    final passage = _passage;
    if (passage == null) {
      return Center(
        child: Text(
          'Digite uma referência para começar.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          passage.reference,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          passage.translationName,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.separated(
            itemCount: passage.verses.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final verse = passage.verses[index];

              return RichText(
                text: TextSpan(
                  style: theme.textTheme.bodyLarge,
                  children: [
                    TextSpan(
                      text: '${verse.verse}  ',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    TextSpan(text: verse.text),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
