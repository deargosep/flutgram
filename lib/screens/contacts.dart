import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ContactsScreen extends HookWidget {
  const ContactsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final search = useState(false);
    void onSearch() {
      search.value = !search.value;
    }

    return Scaffold(
      appBar: AppBar(
        title: search.value ? Text('Contacts') : Search(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onSearch,
        child: Icon(Icons.search),
      ),
      body: Center(
        child: Text('hi'),
      ),
    );
  }
}

class Search extends HookWidget {
  const Search({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final search = useTextEditingController();
    return TextField(
      controller: search,
    );
  }
}
