import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/debouncer.dart';
import '../bloc/breeds_bloc.dart';
import '../bloc/breeds_event.dart';

class BreedSearchBar extends StatefulWidget {
  const BreedSearchBar({super.key, required this.controller});
  final TextEditingController controller;
  @override
  State<BreedSearchBar> createState() => _BreedSearchBarState();
}

class _BreedSearchBarState extends State<BreedSearchBar> {
  final Debouncer _debouncer = Debouncer();

  @override
  void dispose() {
    _debouncer.dispose();
    widget.controller.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {});
    _debouncer.run(() {
      if (query.isEmpty) {
        context.read<BreedsBloc>().add(const ClearSearchEvent());
      } else {
        context.read<BreedsBloc>().add(SearchBreedsEvent(query));
      }
    });
  }

  void _onClear() {
    widget.controller.clear();
    widget.controller.text = '';
    setState(() {});
    context.read<BreedsBloc>().add(const ClearSearchEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: widget.controller,
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Search breeds...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: widget.controller.text.isNotEmpty
              ? IconButton(icon: const Icon(Icons.clear), onPressed: _onClear)
              : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}
