import 'package:flutter/material.dart';
import 'package:new_app/models/grocery_item.dart';

class DataSearch extends SearchDelegate<GroceryItem?> {
  final List<GroceryItem> listExample;

  DataSearch(this.listExample);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? listExample
        : listExample
            .where((item) =>
                item.name.toLowerCase().startsWith(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(suggestionList[index].name),
        onTap: () {
          // Here you can handle the click event
          // For example, you can close the search and pass the selected item
          close(context, suggestionList[index]);
        },
      ),
    );
  }
}
