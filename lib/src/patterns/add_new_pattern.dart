import 'package:flutter/material.dart';
import 'package:sewing_information/service/database_api_service.dart';
import 'package:sewing_information/src/utils/tag_box.dart';
import 'package:textfield_tags/textfield_tags.dart';
//import 'dart:developer' as developer;

enum PatternManufactors {
  burda,
  mcCall,
  simplicity,
  vogue,
  butterick,
  kwikSew,
  newLook,
  other
}

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

  late StringTagController _stringTagController;
  late double _distanceToField;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _distanceToField = MediaQuery.of(context).size.width;
  }

  @override
  void initState() {
    super.initState();
    _stringTagController = StringTagController();
  }

  @override
  void dispose() {
    super.dispose();
    _stringTagController.dispose();
  }

  void addNewPattern() {
    _formKey.currentState!.save();
    DatabaseApiService.createPattern(_patternName, _patternDescription,
        _selectedManufactor!.name, _stringTagController.getTags!);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add new pattern"),
      content: SizedBox(
        height: 400,
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
                padding: const EdgeInsets.only(
                    top: 16, bottom: 10, left: 8, right: 8),
                child: DropdownButtonFormField(
                    validator: (value) {
                      if (value == null) {
                        return "Please select a manufactor";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Manufactor",
                      border: const OutlineInputBorder(),
                    ),
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
              TextTag(
                  stringTagController: _stringTagController,
                  distanceToField: _distanceToField),
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
