import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:new_app/data/categories.dart';
import 'package:new_app/models/grocery_item.dart';
import '../models/category.dart';
import 'package:http/http.dart' as http;

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  double _enteredQty = 1;
  var _enteredDescription = ''; // New variable
  double _enteredPrice = 0.0; // New variable
  bool _isPurchased = false; // New variable
  var _selectedCategory = categories[Categories.vegetables]!;
  var _isSending = false;

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _isSending = true;
      _formKey.currentState!.save();

      final url = Uri.https('flutter-prep-5c57d-default-rtdb.firebaseio.com',
          'shopping-list.json');

      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'name': _enteredName,
            'quantity': _enteredQty.toInt(),
            'category': _selectedCategory.title,
            'description': _enteredDescription, // New field
            'price': _enteredPrice, // New field
            'isPurchased': _isPurchased, // New field
          }));

      final Map<String, dynamic> resData = json.decode(response.body);
      // ignore: use_build_context_synchronously
      if (!context.mounted) {
        return;
      }
      Navigator.of(context).pop(GroceryItem(
        id: resData['name'],
        name: _enteredName,
        quantity: _enteredQty.toInt(),
        category: _selectedCategory,
        description: _enteredDescription, // New field
        price: _enteredPrice, // New field
        isPurchased: _isPurchased, // New field
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add a new item"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text("Name"),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length == 1 ||
                      value.trim().length > 50) {
                    return 'Enter an Item name';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _enteredName = newValue!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text("Description"),
                ),
                validator: (value) {
                  if (value == null || value.trim().length > 100) {
                    return 'Must be less than 100 characters.';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _enteredDescription = newValue!;
                },
              ),
              TextFormField(
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: false),
                decoration: const InputDecoration(label: Text('Price')),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      int.tryParse(value) == null ||
                      int.parse(value) < 0) {
                    return 'Must be a valid non-negative integer.';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _enteredPrice = double.parse(
                      newValue!);
                },
              ),
              CheckboxListTile(
                title: const Text('Purchased'),
                value: _isPurchased,
                onChanged: (newValue) {
                  setState(() {
                    _isPurchased = newValue!;
                  });
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text('Quantity: ${_enteredQty.round()}'),
                        Slider(
                          value: _enteredQty,
                          min: 1,
                          max: 100,
                          divisions: 99,
                          label: _enteredQty.round().toString(),
                          onChanged: (double newValue) {
                            setState(() {
                              _enteredQty = newValue.roundToDouble();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _selectedCategory,
                      items: [
                        for (final category in categories.entries)
                          DropdownMenuItem(
                              value: category.value,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(
                                      'assets/icons/${category.value.title.toLowerCase()}.png',
                                      height: 24,
                                      width: 24,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text(category.value.title)
                                ],
                              ))
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: _isSending
                          ? null
                          : () {
                              _formKey.currentState!.reset();
                              setState(() {
                                _enteredQty = 1; // Reset the quantity slider
                                _selectedCategory = categories[Categories
                                    .vegetables]!; // Reset the category dropdown
                                _enteredDescription =
                                    ''; // Reset the description field
                                _enteredPrice = 0.0; // Reset the price field
                                _isPurchased =
                                    false; // Reset the purchased status
                              });
                            },
                      child: const Text("Reset")),
                  ElevatedButton(
                    onPressed: _isSending ? null : _saveItem,
                    child: _isSending
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(),
                          )
                        : const Text("Add Item"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
