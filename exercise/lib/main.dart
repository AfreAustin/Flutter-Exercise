import 'package:flutter/material.dart';

void main() => runApp(ExerciseApp());

class Exercise {
  final String name;
  final String description;
  final String category;
  final String iconFile;

  const Exercise(this.name, this.description, this.category, this.iconFile);
}

class ExerciseApp extends StatelessWidget {
  const ExerciseApp({super.key});

  // display app within device UI
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Exercise App', // OS task switcher title
      home: SafeArea(
        child: PageNavigation(),
      ),
      debugShowCheckedModeBanner: false, // hide debug banner
    );
  }
}

// structure of the whole app
class PageNavigation extends StatefulWidget {
  const PageNavigation({super.key});

  @override
  State<PageNavigation> createState() => _PageNavigationState();
}

// change route shown based on chosen nav option
class _PageNavigationState extends State<PageNavigation> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int i) {
          setState(() {
            currentPageIndex = i;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(icon: Icon(Icons.alarm), label: "Routine"),
          NavigationDestination(icon: Icon(Icons.yard), label: "Exercises"),
          NavigationDestination(icon: Icon(Icons.person), label: "Profile")
        ],
      ),
      body: <Widget>[
        RoutinePage(),
        ExercisesPage(
          exercises: generateExercises(),
        ),
        ProfilePage(),
      ][currentPageIndex],
    );
  }
}

// parse list of exercises from (file or database? DECIDE)
// then sorts list by category
List<Exercise> generateExercises() {
  return List.generate(
    20,
    (i) => Exercise(
      'Exercise $i',
      'Exercise $i description',
      'category',
      'iconFile.png',
    ),
  );
}

// show the set routine of a user -------------------------------------------------------------
class RoutinePage extends StatelessWidget {
  const RoutinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Routine Page"),
    );
  }
}

// show the list of exercises available -------------------------------------------------------
class ExercisesPage extends StatelessWidget {
  const ExercisesPage({super.key, required this.exercises});

  final List<Exercise> exercises;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // TODO: convert to toggle button
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const <Widget>[
            Text("List View "),
            Icon(Icons.arrow_drop_down),
          ],
        ),
        // TODO: change according to which view
        Expanded(
          child: SizedBox(
            height: double.maxFinite,
            child: ListView.builder(
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ExerciseDetail(exercise: exercises[index]),
                      ),
                    );
                  },
                  leading: FlutterLogo(), // Icon(exercises[index].icon),
                  title: Text(exercises[index].name),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class ExerciseDetail extends StatelessWidget {
  const ExerciseDetail({super.key, required this.exercise});

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(exercise.name)),
      body: Center(
        child: Column(
          children: [
            FlutterLogo(), // Icon(exercise.iconFile),
            Text(exercise.description),
          ],
        ),
      ),
    );
  }
}

// show the user their details and settings ---------------------------------------------------
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Profile Page"),
    );
  }
}

/*
Row(
  mainAxisAlignment: MainAxisAlignment.end,
  children: const <Widget>[
    Text("List View "),
    Icon(Icons.arrow_drop_down),
  ],
),

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
*/
