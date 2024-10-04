import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sewing_information/service/database_api_service.dart';
import 'package:sewing_information/service/storage_service.dart';
import 'package:textfield_tags/textfield_tags.dart';

import '../utils/tag_box.dart';

class AddNewFabricScreen extends StatefulWidget {
  const AddNewFabricScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AddNewFabricScreenState();
}

class _AddNewFabricScreenState extends State<AddNewFabricScreen> {
  String _patternName = "";
  String _patternDescription = "";
  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  File? _image;

  StorageService storageService = StorageService();

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

  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future showOptions() async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: const Text('Photo Gallery'),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from gallery
              getImageFromGallery();
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Camera'),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from camera
              getImageFromCamera();
            },
          ),
        ],
      ),
    );
  }

  Future<void> addNewFabric() async {
    _formKey.currentState!.save();
    String formattedDate = DateFormat('yyyyMMddkkmm').format(DateTime.now());
    storageService.uploadFile('public/$formattedDate', _image!.path);
    DatabaseApiService.createFabric(_patternName, _patternDescription,
        'public/$formattedDate', _stringTagController.getTags!);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add new fabric"),
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
                    return "Please enter fabric name";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: "Fabric name",
                ),
                onSaved: (value) {
                  _patternName = value!;
                },
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a fabric description";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: "Fabric description",
                ),
                onSaved: (value) {
                  _patternDescription = value!;
                },
              ),
              TextTag(
                  stringTagController: _stringTagController,
                  distanceToField: _distanceToField),
              Padding(
                padding: const EdgeInsets.only(
                    top: 16, bottom: 10, left: 8, right: 8),
                child: ElevatedButton(
                  onPressed: () {
                    showOptions();
                  },
                  child: const Text("Add new Fabric"),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.of(context).pop();
                      addNewFabric();
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
