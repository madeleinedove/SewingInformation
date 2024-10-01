import 'package:flutter/material.dart';
import 'package:sewing_information/src/patterns/add_new_pattern.dart';
//import 'dart:developer' as developer;

class PatternsScreen extends StatelessWidget {
  const PatternsScreen({super.key, required this.patterns});
  final List patterns;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              size: 25,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Patterns"),
          actions: [
            Builder(builder: (context) {
              return IconButton(
                icon: const Icon(Icons.filter_alt_outlined),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            })
          ]),
      drawer: const Drawer(child: Text("Filter")),
      body: patternCard(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return const AddNewPatternScreen();
              });
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
      ),
    );
  }

  ListView patternCard() {
    return ListView.separated(
      itemCount: patterns.length,
      separatorBuilder: (BuildContext context, int index) =>
          const Divider(height: 1),
      itemBuilder: (context, index) => ListTile(
          title: Text(patterns[index].name),
          subtitle: Text(patterns[index].description)),
    );
  }
}
