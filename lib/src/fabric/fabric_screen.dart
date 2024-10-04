import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:sewing_information/service/database_api_service.dart';
import 'package:sewing_information/models/Fabric.dart';
import 'package:sewing_information/service/storage_service.dart';
import 'package:sewing_information/src/fabric/add_new_fabric.dart';
//import 'package:flutter_chips_input/flutter_chips_input.dart';
//import 'dart:developer' as developer;

class FabricScreen extends StatefulWidget {
  const FabricScreen({super.key});

  @override
  State<FabricScreen> createState() => _FabricScreenState();
}

class _FabricScreenState extends State<FabricScreen> {
  List<Fabric> fabrics = [];

  StorageService storageService = StorageService();

  void _fetchFabrics() async {
    final fabrics = await DatabaseApiService.getFabrics();
    setState(() {
      this.fabrics = List<Fabric>.from(fabrics);
    });
  }

  @override
  void initState() {
    super.initState();
    // Deteremine if this is the best place to fetch patterns or if it needs to be in build
    _fetchFabrics();
  }

  // void _launchURL(String fabricUrl) async {
  //   final Uri url = Uri.parse(fabricUrl);
  //   if (!await launchUrl(url)) {
  //     throw Exception('Could not launch $url');
  //   }
  // }

  Future<ImageProvider> getImage(String key) async {
    return Image.memory(
            Uint8List.fromList(await storageService.downloadToMemory(key)))
        .image;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    int widthCard = 250;
    int countRow = width ~/ widthCard;

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
        title: const Text("Fabrics"),
        actions: [
          Builder(builder: (context) {
            return IconButton(
              icon: const Icon(Icons.filter_alt_outlined),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          })
        ],
      ),
      drawer: const Drawer(child: Text("Filter")),
      body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: countRow),
          shrinkWrap: true,
          itemBuilder: (context, index) => FutureBuilder(
              future: getImage(fabrics[index].imageKey ?? ""),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else {
                  final data = snapshot.data as ImageProvider;
                  return fabricCard(fabrics[index], data);
                }
              }),
          itemCount: fabrics.length),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return const AddNewFabricScreen();
              }).then((value) => _fetchFabrics());
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
      ),
    );
  }

  SizedBox fabricCard(Fabric fabric, ImageProvider fabricImage) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(fabric.name),
                subtitle: Text(
                  fabric.description ?? "",
                  style: TextStyle(color: Colors.black.withOpacity(0.6)),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: FadeInImage(
                          placeholder: AssetImage('assets/loading.gif'),
                          image: fabricImage,
                          height: 250))),
            ],
          ),
        ),
      ),
    );
  }
}