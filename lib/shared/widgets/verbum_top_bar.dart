import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class VerbumTopBar extends StatelessWidget implements PreferredSizeWidget {
  const VerbumTopBar({required this.logoAsset, super.key});

  static const double _height = 64;

  final String logoAsset;

  @override
  Size get preferredSize => const Size.fromHeight(_height);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      toolbarHeight: _height,
      centerTitle: false,
      automaticallyImplyLeading: false,
      titleSpacing: 20,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SvgPicture.asset(logoAsset, width: 36, height: 36),
          ),
          const SizedBox(width: 10),
          Text(
            'Verbum',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: IconButton(
            onPressed: () {},
            tooltip: 'Buscar',
            icon: const Icon(Icons.search_rounded),
            style: IconButton.styleFrom(
              foregroundColor: theme.colorScheme.onSurfaceVariant,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: theme.colorScheme.outlineVariant),
              ),
            ),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(
          height: 1,
          thickness: 1,
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.55),
        ),
      ),
    );
  }
}
