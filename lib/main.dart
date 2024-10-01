import 'package:flutter/material.dart';
import 'src/fabric/fabric.dart';
import 'src/patterns/pattern.dart';
import 'src/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:developer' as developer;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Sewing Information'),
    );
  }
  //   return FutureBuilder(
  //     // Initialize FlutterFire
  //     future: Firebase.initializeApp(
  //         options: DefaultFirebaseOptions.currentPlatform),
  //     builder: (context, snapshot) {
  //       // Check for errors
  //       // if (snapshot.hasError) {
  //       //   return SomethingWentWrong();
  //       // }

  //       // Once complete, show your application
  //       if (snapshot.connectionState == ConnectionState.done) {

  //       }

  //       // Otherwise, show something whilst waiting for initialization to complete
  //       return const CircularProgressIndicator();
  //     },
  //   );
  // }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List _patterns = [];
  late List _fabrics = [];
  final DatabaseReference database = FirebaseDatabase.instance.ref("/fabrics");

  @override
  void initState() {
    super.initState();
    readJson();
  }

  Future<void> readJson() async {
    developer.log("Reading");

    // database.onValue.listen((event) {
    //   developer.log("Got data");
    //   final response = event.snapshot.value as Map;
    //   var patternsJson = response["patterns"];
    //   var patterns = [];
    //   var fabrics = [];
    //   patternsJson.values.forEach((v) => patterns.add(PatternInfo.fromJson(v)));

    //   var fabricsJson = response["fabrics"];
    //   fabricsJson.values.forEach((v) => fabrics.add(FabricInfo.fromJson(v)));

    //   setState(() {
    //     _patterns = patterns;
    //     _fabrics = fabrics;
    //   });
    // });

    final response = await database.get();
    if (response.exists) {
      developer.log(response.value.toString());
    } else {
      developer.log("No data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: HomeScreen(patterns: _patterns, fabrics: _fabrics));
  }
}
