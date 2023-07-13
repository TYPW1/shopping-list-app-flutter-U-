import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:new_app/data/categories.dart';
import 'package:new_app/models/grocery_item.dart';
import 'package:new_app/widgets/new_item.dart';
import 'package:new_app/widgets/search_delegate.dart';
import 'package:http/http.dart' as http;

enum SortOptions {
  name,
  quantity,
  category,
  purchasedStatus,
}

enum FilterOptions {
  all,
  vegetables,
  fruits,
  meat,
  dairy,
  carbs,
  sweets,
  spices,
  convenience,
  hygiene,
  others,
}

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];
  var _isLoading = true;
  String? _error;
  SortOptions _sortOption = SortOptions.name;
  FilterOptions _filterOption = FilterOptions.all;

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
          description: item.value["description"], // New field
          price: item.value["price"], // New field
          isPurchased: item.value["isPurchased"], // New field
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
      (item) =>
          item.name.toLowerCase() == newItem.name.toLowerCase() &&
          item.category == newItem.category,
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

  void _sortList() {
    setState(() {
      switch (_sortOption) {
        case SortOptions.name:
          _groceryItems.sort((a, b) => a.name.compareTo(b.name));
          break;
        case SortOptions.quantity:
          _groceryItems.sort((a, b) => a.quantity.compareTo(b.quantity));
          break;
        case SortOptions.category:
          _groceryItems
              .sort((a, b) => a.category.title.compareTo(b.category.title));
          break;
        case SortOptions.purchasedStatus:
          _groceryItems.sort((a, b) =>
              (a.isPurchased ? 1 : 0).compareTo(b.isPurchased ? 1 : 0));
          break;
      }
    });
  }

  void _filterList() {
    setState(() {
      if (_filterOption == FilterOptions.all) {
        _loadItems();
      } else {
        _groceryItems = _groceryItems.where((item) {
          return item.category.title.toLowerCase() ==
              _filterOption.toString().split('.').last;
        }).toList();
      }
    });
  }

  GroceryItem? _selectedItem;

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text('No Items added yet.'),
    );
    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (context, index) => Dismissible(
          onDismissed: (direction) {
            _removeItem(_groceryItems[index]);
          },
          key: ValueKey(_groceryItems[index].id),
          child: ListTile(
            title: Text(
              _groceryItems[index].name,
              style: TextStyle(
                decoration: _groceryItems[index].isPurchased
                    ? TextDecoration.lineThrough
                    : null,
              ),
            ),
            tileColor: _groceryItems[index] == _selectedItem
                ? Colors.yellow
                : null, // Highlight the selected item
            subtitle: Text(
              '${_groceryItems[index].description}\nPrice:${_groceryItems[index].price.toStringAsFixed(2)} FCFA',
            ),
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/icons/${_groceryItems[index].category.title.toLowerCase()}.png',
                width: 24,
                height: 24,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_groceryItems[index].quantity.toString()),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _removeItem(_groceryItems[index]);
                  },
                ),
              ],
            ),
          ),
        ),
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
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final selectedItem = await showSearch(
                context: context,
                delegate: DataSearch(_groceryItems),
              );
              setState(() {
                _selectedItem = selectedItem;
              });
            },
          ),
          DropdownButton<SortOptions>(
            value: _sortOption,
            onChanged: (SortOptions? newValue) {
              if (newValue != null) {
                setState(() {
                  _sortOption = newValue;
                });
                _sortList();
              }
            },
            items: const <DropdownMenuItem<SortOptions>>[
              DropdownMenuItem<SortOptions>(
                value: SortOptions.name,
                child: Text('Sort by Name'),
              ),
              DropdownMenuItem<SortOptions>(
                value: SortOptions.quantity,
                child: Text('Sort by Quantity'),
              ),
              DropdownMenuItem<SortOptions>(
                value: SortOptions.category,
                child: Text('Sort by Category'),
              ),
              DropdownMenuItem<SortOptions>(
                value: SortOptions.purchasedStatus,
                child: Text('Sort by Purchased Status'),
              ),
            ],
          ),
          DropdownButton<FilterOptions>(
            value: _filterOption,
            onChanged: (FilterOptions? newValue) {
              if (newValue != null) {
                setState(() {
                  _filterOption = newValue;
                });
                _filterList();
              }
            },
            items: FilterOptions.values.map((FilterOptions filterOption) {
              return DropdownMenuItem<FilterOptions>(
                value: filterOption,
                child: Text(
                    'Filter by ${filterOption.toString().split('.').last}'),
              );
            }).toList(),
          ),
          IconButton(onPressed: _addItem, icon: const Icon(Icons.add)),
        ],
      ),
      body: content,
    );
  }
}
