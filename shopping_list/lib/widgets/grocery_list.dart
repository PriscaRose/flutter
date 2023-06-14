import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // can be anyname
import 'package:shopping_list/data/categories.dart';

import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() {
    return _GroceryListState();
  }
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];
  bool isLoaded = true;
  String? _errorMsg;

  void _loadItems() async {
    final url = Uri.https(
        'flutter-app-f04f0-default-rtdb.firebaseio.com', 'shopping-list.json');

    try {
      final res = await http.get(url);

      if (res.statusCode >= 400) {
        setState(() {
          _errorMsg = "Failed to fetch data. Please try again";
        });
      }

      if (res.body == 'null') {
        setState(() {
          isLoaded = false;
        });
        return;
      }

      final Map<String, dynamic> listData = json.decode(res.body);
      final List<GroceryItem> _loadItems = [];

      for (final item in listData.entries) {
        final category = categories.entries
            .firstWhere((el) => el.value.title == item.value['category'])
            .value;
        _loadItems.add(GroceryItem(
            id: item.key,
            name: item.value['name'],
            quantity: item.value['quantity'],
            category: category));
      }

      setState(() {
        _groceryItems = _loadItems;
        isLoaded = false;
      });
    } catch (err) {
      setState(() {
        _errorMsg = "Something went wrong";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
        MaterialPageRoute(builder: (cxt) => const NewItem()));

    if (newItem == null) return;

    setState(() {
      _groceryItems.add(newItem);
    });
  }

  void _removeitem(GroceryItem item) async {
    final index = _groceryItems.indexOf(item);

    setState(() {
      _groceryItems.remove(item);
    });

    final url = Uri.https('flutter-app-f04f0-default-rtdb.firebaseio.com',
        'shopping-list/${item.id}.json');
    final res = await http.get(url);

    if (res.statusCode >= 400) {
      setState(() {
        _groceryItems.insert(index, item);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(child: Text("You has no item"));

    if (isLoaded) {
      content = const Center(child: CircularProgressIndicator());
    }

    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (cxt, index) => Dismissible(
          onDismissed: (direction) {
            setState(() {
              _removeitem(_groceryItems[index]);
            });
          },
          key: ValueKey(_groceryItems[index].id),
          child: ListTile(
            title: Text(
              _groceryItems[index].name,
            ),
            leading: Container(
              width: 24,
              height: 24,
              color: _groceryItems[index].category.color,
            ),
            trailing: Text((_groceryItems[index].quantity).toString()),
          ),
        ),
      );
    }

    if (_errorMsg != null) {
      content = Center(child: Text(_errorMsg!));
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Your grocery'),
          actions: [
            IconButton(onPressed: _addItem, icon: const Icon(Icons.add))
          ],
        ),
        body: content);
  }
}
