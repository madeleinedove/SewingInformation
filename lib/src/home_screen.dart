import 'package:flutter/material.dart';
import 'package:sewing_information/service/patterns_api_service.dart';
import 'package:sewing_information/src/fabric/add_new_fabric.dart';
import 'package:sewing_information/src/fabric/fabric_screen.dart';
import 'package:sewing_information/src/patterns/add_new_pattern.dart';
import 'package:sewing_information/src/patterns/patterns_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.databaseApiService});

  final DatabaseApiService databaseApiService;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 100,
          child: ListView(
            children: ListTile.divideTiles(
              context: context,
              tiles: [
                ListTile(
                  title: const Text("Patterns"),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded),
                  onTap: () => {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PatternsScreen(
                            databaseApiService: databaseApiService)))
                  },
                ),
                ListTile(
                  title: const Text("Fabric"),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded),
                  onTap: () => {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => FabricScreen(fabrics: [])))
                  },
                ),
              ],
            ).toList(),
          ),
        ),
        const Divider(thickness: 5.0),
        const Text(
          "Quick Add",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          textAlign: TextAlign.left,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const AddNewPatternScreen();
                        });
                  },
                  child: const Text("Add new Pattern")),
              const Spacer(),
              ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const AddNewFabricScreen();
                        });
                  },
                  child: const Text("Add new fabric")),
            ],
          ),
        )
      ],
    );
  }
}
