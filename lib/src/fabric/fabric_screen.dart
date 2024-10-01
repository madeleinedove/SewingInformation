import 'package:flutter/material.dart';
import 'package:sewing_information/src/fabric/fabric.dart';
//import 'package:flutter_chips_input/flutter_chips_input.dart';
//import 'dart:developer' as developer;

class FabricScreen extends StatelessWidget {
  const FabricScreen({super.key, required this.fabrics});
  final List fabrics;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    int widthCard = 300;
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
          itemBuilder: (context, index) => fabricCard(fabrics[index]),
          itemCount: fabrics.length),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return const AlertDialog(
                  title: Text("Add new fabric"),
                  content: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          labelText: "fabric name",
                        ),
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: "fabric description",
                        ),
                      ),
                    ],
                  ),
                );
              });
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
      ),
    );
  }

  SizedBox fabricCard(FabricInfo fabric) {
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
                  fabric.description,
                  style: TextStyle(color: Colors.black.withOpacity(0.6)),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(6.0),
                      child: FadeInImage.assetNetwork(
                          placeholder: 'assets/loading.gif',
                          image: fabric.url))),
            ],
          ),
        ),
      ),
    );
  }
}


// ChipsInput(chipBuilder: (context, state, profile) {
//                         return InputChip(
//                           key: ObjectKey(profile),
//                           label: Text(profile.toString()),
//                           onDeleted: () {
//                             state.deleteChip(profile);
//                           },
//                           materialTapTargetSize:
//                               MaterialTapTargetSize.shrinkWrap,
//                         );
//                       }, suggestionBuilder: (context, state, profile) {
//                         return ListTile(
//                           title: Text(profile.toString()),
//                           onTap: () {
//                             state.selectSuggestion(profile);
//                           },
//                         );
//                       }, findSuggestions: (String query) {
//                         if (query.isNotEmpty) {
//                           return [
//                             "tag1",
//                             "tag2",
//                             "tag3",
//                             "tag4",
//                             "tag5",
//                             "tag6",
//                             "tag7",
//                             "tag8",
//                             "tag9",
//                             "tag10"
//                           ].where((profile) {
//                             return profile.contains(query);
//                           }).toList(growable: false);
//                         } else {
//                           return const [];
//                         }
//                       }, onChanged: (data) {
//                         developer.log(data.toString());
//                       })