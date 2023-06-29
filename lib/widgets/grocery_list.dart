import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:new_app/data/categories.dart';
import 'package:new_app/models/grocery_item.dart';
import 'package:new_app/widgets/new_item.dart';
import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];
  var _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.https(
        'flutter-prep-5c57d-default-rtdb.firebaseio.com', 'shopping-list.json');
    try {
      final response = await http.get(url);
      if (response.statusCode >= 400) {
        setState(() {
          _error = "An error occured While fetching data!";
        });
      }
      if (response.body == 'null') {
        setState(() {
          _isLoading = false;
        });
        return;
      }
      final Map<String, dynamic> listData = json.decode(response.body);
      final List<GroceryItem> loadedItems = [];
      for (final item in listData.entries) {
        final category = categories.entries
            .firstWhere(
                (catItem) => catItem.value.title == item.value['category'])
            .value;
        loadedItems.add(GroceryItem(
          id: item.key,
          name: item.value["name"],
          quantity: item.value["quantity"],
          category: category,
        ));
      }
      setState(() {
        _groceryItems = loadedItems;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _error = "An error occured";
      });
    }
  }

  void _addItem() async {
    final newItem =
        await Navigator.of(context).push<GroceryItem>(MaterialPageRoute(
      builder: (context) => const NewItem(),
    ));
    if (newItem == null) {
      return;
    }

    var foundIndex = _groceryItems.indexWhere(
      (item) => item.name == newItem.name && item.category == newItem.category,
    );

    setState(() {
      if (foundIndex != -1) {
        // Replace the found item with a new one with incremented quantity
        _groceryItems[foundIndex] = GroceryItem(
          id: _groceryItems[foundIndex].id,
          name: _groceryItems[foundIndex].name,
          category: _groceryItems[foundIndex].category,
          quantity: _groceryItems[foundIndex].quantity + newItem.quantity,
        );
      } else {
        // Add the new item to the list
        _groceryItems.add(newItem);
      }
    });
  }

  void _removeItem(GroceryItem item) async {
    final index = _groceryItems.indexOf(item);
    setState(() {
      _groceryItems.remove(item);
    });

    final url = Uri.https('flutter-prep-5c57d-default-rtdb.firebaseio.com',
        'shopping-list/${item.id}.json');

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      setState(() {
        _groceryItems.insert(index, item);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text('No Items added yet.'),
    );
    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemBuilder: (context, index) => Dismissible(
          onDismissed: (direction) {
            _removeItem(_groceryItems[index]);
          },
          key: ValueKey(_groceryItems[index].id),
          child: ListTile(
            title: Text(_groceryItems[index].name),
            leading: Container(
              width: 24,
              height: 24,
              color: _groceryItems[index].category.color,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize
                  .min, // make the Row take minimum horizontal space
              children: [
                Text(_groceryItems[index]
                    .quantity
                    .toString()), // display item quantity
                IconButton(
                  // add IconButton
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _removeItem(
                        _groceryItems[index]); // call the remove item function
                  },
                ),
              ],
            ),
          ),

          /* child: ListTile(
            title: Text(_groceryItems[index].name),
            leading: Container(
              width: 24,
              height: 24,
              color: _groceryItems[index].category.color,
            ),
            trailing: Text(_groceryItems[index].quantity.toString()),
          ), */
        ),
        itemCount: _groceryItems.length,
      );
    }
    if (_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      content = Center(
        child: Text(_error!),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Groceries"),
        actions: [IconButton(onPressed: _addItem, icon: const Icon(Icons.add))],
      ),
      body: content,
    );
  }
}
