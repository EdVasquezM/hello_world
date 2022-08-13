import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of the app.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to the testing app: this is the title',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Welcome to the testing app: this is de AppBar'),
        ),
        body: const Center(
          child: DoubleScreen(),
        )
      ),
    );
  }
}

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
