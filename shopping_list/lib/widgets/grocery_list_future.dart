import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // can be anyname
import 'package:shopping_list/data/categories.dart';

import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widgets/new_item.dart';

class GroceryListFuture extends StatefulWidget {
  const GroceryListFuture({super.key});

  @override
  State<GroceryListFuture> createState() {
    return _GroceryListFutureState();
  }
}

class _GroceryListFutureState extends State<GroceryListFuture> {
  List<GroceryItem> _groceryItems = [];
  late Future<List<GroceryItem>> _loadedItems;

  Future<List<GroceryItem>> _loadItems() async {
    final url = Uri.https(
        'flutter-app-f04f0-default-rtdb.firebaseio.com', 'shopping-list.json');

    // try {
    final res = await http.get(url);

    if (res.statusCode >= 400) {
      throw Exception('Failed to fetch data. Please try again');
      // setState(() {
      //   _errorMsg = "Failed to fetch data. Please try again";
      // });
    }

    if (res.body == 'null') {
      // setState(() {
      //   isLoaded = false;
      // });
      return [];
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

    // setState(() {
    //   _groceryItems = _loadItems;
    //   isLoaded = false;
    // });

    return _loadItems;
    // } catch (err) {
    //   setState(() {
    //     _errorMsg = "Something went wrong";
    //   });
    // }
  }

  @override
  void initState() {
    super.initState();
    _loadedItems = _loadItems();
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

    return Scaffold(
      appBar: AppBar(
        title: Text('Your grocery'),
        actions: [IconButton(onPressed: _addItem, icon: const Icon(Icons.add))],
      ),
      body: FutureBuilder(
        future: _loadedItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          if (snapshot.data!.isEmpty) {
            return const Center(child: Text("You has no item"));
          } 

          final groceries = snapshot.data!;
            
           return ListView.builder(
              itemCount: groceries.length,
              itemBuilder: (cxt, index) => Dismissible(
                onDismissed: (direction) {
                  setState(() {
                    _removeitem(groceries[index]);
                  });
                },
                key: ValueKey(groceries[index].id),
                child: ListTile(
                  title: Text(
                    groceries[index].name,
                  ),
                  leading: Container(
                    width: 24,
                    height: 24,
                    color: groceries[index].category.color,
                  ),
                  trailing: Text((groceries[index].quantity).toString()),
                ),
              ),
            );
        },
      ),
    );
  }
}
