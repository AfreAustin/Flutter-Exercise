import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    return MaterialApp(
      title: 'Exercise App', // OS task switcher title
      theme: ThemeData(
        colorScheme: ColorScheme.dark(primary: Colors.purple),
        useMaterial3: true,
      ),
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
        indicatorColor: Theme.of(context).indicatorColor,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
              icon: Icon(Icons.timer_sharp), label: "Routine"),
          NavigationDestination(
              icon: Icon(Icons.sports_gymnastics), label: "Exercises"),
          NavigationDestination(
              icon: Icon(Icons.scoreboard_rounded), label: "Statistics")
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
class RoutinePage extends StatefulWidget {
  const RoutinePage({super.key});

  @override
  State<RoutinePage> createState() => _RoutinePageState();
}

class _RoutinePageState extends State<RoutinePage> {
  var f = NumberFormat('###.#%');
  int currDay = 3;
  int maxDay = 30;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 20.0),
        DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.white),
            color: Colors.deepOrange,
          ),
          child: SizedBox(
            height: 100.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Stack(
                  children: [
                    Text(
                      f.format(currDay / maxDay),
                    ),
                    CircularProgressIndicator(
                      strokeCap: StrokeCap.round,
                      backgroundColor: Colors.black,
                      value: currDay / maxDay,
                    ),
                  ],
                ),
                Text(
                  "Progress: ${((maxDay - currDay == 0) ? "Completed!" : "${maxDay - currDay} days left")}",
                ),
                ElevatedButton(
                  onPressed: () {
                    debugPrint("Pressed");
                  },
                  child: Icon(Icons.play_arrow),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20.0),
        SizedBox(
          height: MediaQuery.of(context).size.height - 220.0,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
            ),
            child: ListView.builder(
              itemCount: 20,
              itemBuilder: (context, index) {
                return ListTile(
                  isThreeLine: true,
                  leading: FlutterLogo(),
                  title: Text("Exercise"),
                  subtitle: Text("  "),
                );
              },
            ),
          ),
        ),
      ],
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
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int alarmTime = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text("Identifier?"),
        ListTile(
          title: Text("Reminder Alarm: $alarmTime"),
        ),
        Text("Stats"),
      ],
    );
  }
}
