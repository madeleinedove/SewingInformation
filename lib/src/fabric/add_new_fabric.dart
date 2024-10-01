import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:developer' as developer;

import 'package:intl/intl.dart';

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

  final storageRef = FirebaseStorage.instance.ref();
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref("fabrics");

  //Image Picker function to get image from gallery
  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  //Image Picker function to get image from camera
  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  //Show options to get image from camera or gallery
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
    final newPostKey = databaseRef.push().key;

    String formattedDate = DateFormat('yyyyMMddkkmm').format(DateTime.now());
    final imageRef = storageRef.child("fabrics/$formattedDate");
    try {
      await imageRef.putFile(_image!);
      final url = await imageRef.getDownloadURL();
      final Map<String, Map> updates = {};
      updates['$newPostKey'] = {
        'name': _patternName,
        'description': _patternDescription,
        'url': url,
        'tags': {"tag1", "tag2"}
      };

      databaseRef.update(updates);
    } catch (e) {
      developer.log(e.toString());
    }
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
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 24.0),
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
                      // Save the data to the database
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
