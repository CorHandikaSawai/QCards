import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Free Quizme',
      theme: ThemeData.dark(),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Title of the Subject"),
        centerTitle: true,
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: const EdgeInsets.all(5.0),
              height: screenSize.height * 0.4,
              color: Colors.black12,
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'Consectetur excepteur culpa sint quis aute anim id. Duis nulla excepteur officia mollit proident Lorem laboris consequat ad tempor aute cupidatat qui est. Irure eiusmod occaecat exercitation laborum eiusmod deserunt cillum adipisicing.',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: screenSize.height * 0.5,
              child: GridView.count(
                crossAxisCount: 2,
                children: const [
                  Answer(),
                  Answer(),
                  Answer(),
                  Answer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Answer extends StatelessWidget {
  const Answer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: const Center(child: Text('Answer A')),
      color: Colors.black12,
    );
  }
}
