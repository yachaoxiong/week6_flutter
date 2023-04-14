import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Shopping List')),
        body: ShoppingList(),
      ),
    );
  }
}

class ShoppingList extends StatefulWidget {
  @override
  _ShoppingListState createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  List<String> items = [];
  TextEditingController _itemController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      items = prefs.getStringList('items') ?? [];
    });
  }

  Future<void> _addItem(String item) async {
    if (item.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      items.add(item);
      prefs.setStringList('items', items);
      _itemController.clear();
      setState(() {});
    }
  }

  Future<void> _removeItem(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    items.removeAt(index);
    prefs.setStringList('items', items);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _itemController,
                  decoration: InputDecoration(labelText: 'Enter item name'),
                ),
              ),
              IconButton(
                onPressed: () => _addItem(_itemController.text),
                icon: Icon(Icons.add),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(items[index]),
                trailing: IconButton(
                  onPressed: () => _removeItem(index),
                  icon: Icon(Icons.delete),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
