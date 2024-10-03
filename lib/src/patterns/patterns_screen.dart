import 'package:flutter/material.dart';
import 'package:sewing_information/models/Pattern.dart';
import 'package:sewing_information/service/database_api_service.dart';
import 'package:sewing_information/src/patterns/add_new_pattern.dart';
//import 'dart:developer' as developer;

class PatternsScreen extends StatefulWidget {
  const PatternsScreen({super.key});

  @override
  State<PatternsScreen> createState() => _PatternScreenState();
}

class _PatternScreenState extends State<PatternsScreen> {
  List<Pattern> _patterns = [];
  bool _isLoading = true;

  void _fetchPatterns() async {
    final patterns = await DatabaseApiService.getPatterns();
    setState(() {
      _patterns = List<Pattern>.from(patterns);
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    // Deteremine if this is the best place to fetch patterns or if it needs to be in build
    _fetchPatterns();
  }

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
      body: _isLoading ? CircularProgressIndicator() : patternCard(),
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
      itemCount: _patterns.length,
      separatorBuilder: (BuildContext context, int index) =>
          const Divider(height: 1),
      itemBuilder: (context, index) => ListTile(
          title: Text(_patterns[index].name),
          subtitle: Text(_patterns[index].description ?? "")),
    );
  }
}
