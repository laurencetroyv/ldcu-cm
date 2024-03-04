import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchContainer extends ConsumerWidget {
  const SearchContainer(this._searchController,
      {super.key, required this.data});
  final SearchController _searchController;
  final List data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SearchAnchor(
        searchController: _searchController,
        headerTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        isFullScreen: false,
        builder: (context, controller) {
          return SearchBar(
            leading: const Icon(Icons.search),
            padding: const MaterialStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 16.0),
            ),
            controller: controller,
            onTap: () => controller.openView(),
            textStyle: const MaterialStatePropertyAll(
              TextStyle(fontWeight: FontWeight.w500),
            ),
            shape: const MaterialStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                side: BorderSide.none,
              ),
            ),
            constraints: const BoxConstraints(minHeight: 48, maxHeight: 48),
          );
        },
        suggestionsBuilder: (context, controller) {
          return data.map((item) {
            return ListTile(
              title: Text(item),
              onTap: () {},
            );
          }).toList();
        },
      ),
    );
  }
}
