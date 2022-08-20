import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hello_world/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';
import 'login_page.dart';

void main() {
  runApp(
      MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.blueGrey,
          ),
          home: const MyApp()
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of the app.
  @override
  Widget build(BuildContext context) {
    initializeFirebaseAuth();
    return Scaffold(
      appBar: AppBar(
        title: const Text('AppBar title'),
        leading: IconButton (
          icon: const Icon(Icons.menu),
          onPressed: () {
            //TODO show menu
          },
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(_createRoute());
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.lightGreen,
                //padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                //shadowColor: Colors.grey
              ),
              icon: const Icon(Icons.login_rounded),
              label: const Text("Log in")
            ),
          )
        ],
      ),
      body: const Center(
        child: DoubleScreen(),
      )
    );
  }

  void initializeFirebaseAuth() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099); //erase this line for production purposes
  }
}
// to manage the navigation and animation to another page (login_page)
Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const LoginPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      var curve = Curves.ease;
      final tween = Tween(begin: begin, end: end);
      final  curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: curve,
      );
      return SlideTransition(
        position: tween.animate(curvedAnimation),
        child: child,
      );
    },
  );
}

//divide the screen to have two showings, those two can be copied to another file
class DoubleScreen extends StatefulWidget {
  const DoubleScreen({Key? key}) : super(key: key);
  @override
  State<DoubleScreen> createState() => _DoubleScreenState();
}

class _DoubleScreenState extends State<DoubleScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const <Widget>[
        Expanded(
          child: Center(child: MyHomePage())
        ),
        Expanded(
          child: Center(child: RandomWords())
        ),
      ]
    );
  }
}

//widget with a infinite random number list
class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);
  @override
  State<RandomWords> createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = [];
  final _biggerFont = const TextStyle(fontSize: 18);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: /*1*/ (context, i) {
        if (i.isOdd) return const Divider(); /*2*/
        final index = i ~/ 2; /*3*/
        if (index >= _suggestions.length) {
          _suggestions.add(Random()); /*4*/
        }
        return ListTile(
          title: Text(
            _suggestions[index] = Random().nextInt(100).toString(),
            style: _biggerFont,
          ),
        );
      },
    );
  }
}

//widget with a number counter just pushing a floating button
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have clicked the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
