import 'package:flutter/material.dart';
import 'package:sewing_information/src/patterns/pattern.dart';
//import 'dart:developer' as developer;

class AddNewPatternScreen extends StatefulWidget {
  const AddNewPatternScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AddNewPatternScreenState();
}

class _AddNewPatternScreenState extends State<AddNewPatternScreen> {
  PatternManufactors? _selectedManufactor;
  String _patternName = "";
  String _patternDescription = "";

  final _formKey = GlobalKey<FormState>();

  void addNewPattern() {
    // _formKey.currentState!.save();
    // final newPostKey = ref.push().key;

    // final Map<String, Map> updates = {};
    // updates['$newPostKey'] = {
    //   'name': _patternName,
    //   'description': _patternDescription,
    //   'manufactor': _selectedManufactor!.name,
    //   'tags': {"tag1", "tag2"}
    // };

    // ref.update(updates);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add new pattern"),
      content: SizedBox(
        height: 300,
        width: 350,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a pattern name";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: "Pattern name",
                ),
                onSaved: (value) {
                  _patternName = value!;
                },
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a pattern description";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: "Pattern description",
                ),
                onSaved: (value) {
                  _patternDescription = value!;
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 24.0),
                child: DropdownButtonFormField(
                    validator: (value) {
                      if (value == null) {
                        return "Please select a manufactor";
                      }
                      return null;
                    },
                    focusColor: Colors.transparent,
                    value: _selectedManufactor,
                    isExpanded: true,
                    items: PatternManufactors.values
                        .map((e) =>
                            DropdownMenuItem(value: e, child: Text(e.name)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedManufactor = value as PatternManufactors;
                      });
                    }),
              ),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Save the data to the database
                      Navigator.of(context).pop();
                      addNewPattern();
                    }
                  },
                  child: const Text("Submit"))
            ],
          ),
        ),
      ),
    );
  }
}
