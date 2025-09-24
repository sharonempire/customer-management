import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:management_software/features/application/lead_management/controller/lead_management_controller.dart';

class SearchLeadsWidget extends ConsumerStatefulWidget {
  const SearchLeadsWidget({super.key});

  @override
  ConsumerState<SearchLeadsWidget> createState() => _SearchLeadsWidgetState();
}

class _SearchLeadsWidgetState extends ConsumerState<SearchLeadsWidget> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    final initialQuery = ref.read(leadMangementcontroller).searchQuery;
    _controller = TextEditingController(text: initialQuery);
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    ref.read(leadMangementcontroller.notifier).changeSearchQuery(value);
    setState(() {});
  }

  void _clearQuery() {
    if (_controller.text.isEmpty) return;
    _controller.clear();
    _onQueryChanged('');
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final searchQuery = ref.watch(
      leadMangementcontroller.select((state) => state.searchQuery),
    );

    if (searchQuery != _controller.text) {
      _controller
        ..text = searchQuery
        ..selection = TextSelection.fromPosition(
          TextPosition(offset: searchQuery.length),
        );
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Row(
          children: [
            SizedBox(
              width: 350,
              height: 40,
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                onChanged: _onQueryChanged,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  labelText: 'Search leads...',
                  labelStyle: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.grey,
                    size: 18,
                  ),
                  suffixIcon:
                      _controller.text.isEmpty
                          ? null
                          : IconButton(
                            tooltip: 'Clear search',
                            icon: const Icon(Icons.clear, size: 16),
                            color: Colors.grey,
                            onPressed: _clearQuery,
                          ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 8,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 1.5,
                    ),
                  ),
                ),
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
