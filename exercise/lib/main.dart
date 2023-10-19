import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

void main() => runApp(ExerciseApp());

class Exercise {
  final String name;
  final String description;
  final String category;
  final IconData iconFile;

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
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
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
    return ChangeNotifierProvider(
      create: (context) => RoutineModel(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: Text("EXERCISE APP"),
          centerTitle: true,
        ),
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int i) {
            setState(() {
              currentPageIndex = i;
            });
          },
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
          RoutinePage(routine: generateExercises()),
          ExercisesPage(exercises: generateExercises()),
          ProfilePage(),
        ][currentPageIndex],
      ),
    );
  }
}

class RoutineModel extends ChangeNotifier {
  final List<Exercise> _exercises = [];

  UnmodifiableListView<Exercise> get exercises =>
      UnmodifiableListView(_exercises);

  void add(Exercise exercise) {
    _exercises.add(exercise);
    // add to some external file/DB
    notifyListeners();
  }
}

// TODO: Figure out where to get exercises from
// parse list of exercises from ...
// then sorts list by category
List<Exercise> generateExercises() {
  return List.generate(
    10,
    (i) => Exercise(
      'Exercise $i',
      'Exercise $i description',
      'Exercise $i category',
      Icons.sports_martial_arts,
    ),
  );
}

// show the set routine of a user -------------------------------------------------------------
class RoutinePage extends StatefulWidget {
  const RoutinePage({super.key, required this.routine});

  final List<Exercise> routine;

  @override
  State<RoutinePage> createState() => _RoutinePageState();
}

class _RoutinePageState extends State<RoutinePage> {
  var f = NumberFormat('#.#%');
  int currDay = 20;
  int maxDay = 30;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 20.0),
        SizedBox(
          height: 80.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent,
                    borderRadius: BorderRadius.circular(50.0)),
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Text(
                      f.format(currDay / maxDay),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 60.0,
                      width: 60.0,
                      child: CircularProgressIndicator(
                        strokeCap: StrokeCap.round,
                        strokeWidth: 7.0,
                        color: Colors.lightGreenAccent,
                        backgroundColor: Colors.black26,
                        value: currDay / maxDay,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                (maxDay - currDay == 0)
                    ? "COMPLETED!"
                    : " DAY ${maxDay - currDay}",
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  debugPrint(
                      "Pressed"); // TODO: Implement Start Exercise function
                },
                child: Icon(Icons.play_arrow),
              ),
            ],
          ),
        ),
        Divider(
          height: 20.0,
          indent: 10.0,
          endIndent: 10.0,
        ),
        Flexible(
          child: Consumer<RoutineModel>(
            builder: (context, routine, child) => ListView.builder(
              itemCount: routine.exercises.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text("#REPS  ${routine.exercises[index].name}"),
                  trailing: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExerciseDetail(
                              exercise: routine.exercises[index]),
                        ),
                      );
                    },
                    icon: Icon(Icons.visibility),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

// Exercises Route  ---------------------------------------------------------------------------
enum View { list, card, grid }

// show all availalbe exercises
class ExercisesPage extends StatefulWidget {
  const ExercisesPage({super.key, required this.exercises});

  final List<Exercise> exercises;

  @override
  State<ExercisesPage> createState() => _ExercisesPageState();
}

// Display exercises based on view chosen
class _ExercisesPageState extends State<ExercisesPage> {
  View viewType = View.list;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 20.0),
        SegmentedButton(
          onSelectionChanged: (Set<View> selectedView) {
            setState(() {
              viewType = selectedView.first;
            });
          },
          selected: <View>{viewType},
          showSelectedIcon: false,
          segments: const <ButtonSegment<View>>[
            ButtonSegment(
              value: View.list,
              label: Text("List"),
              icon: Icon(Icons.list),
            ),
            ButtonSegment(
              value: View.card,
              label: Text("Card"),
              icon: Icon(Icons.view_carousel_outlined),
            ),
            ButtonSegment(
              value: View.grid,
              label: Text("Grid"),
              icon: Icon(Icons.grid_view),
            )
          ],
        ),
        SizedBox(height: 10.0),
        Flexible(
          child: switch (viewType) {
            View.list => ListExercises(exercises: widget.exercises),
            View.card => Center(
                child: Text("TO BE IMPLEMENTED"),
              ), // TODO: implement card view
            View.grid => Center(
                child: Text("TO BE DESIGNED"),
              ), // TODO: design gridview
          },
        ),
      ],
    );
  }
}

// show exercises in list view
class ListExercises extends StatefulWidget {
  const ListExercises({super.key, required this.exercises});

  final List<Exercise> exercises;

  @override
  State<ListExercises> createState() => _ListExercisesState();
}

// format of List View
class _ListExercisesState extends State<ListExercises> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: widget.exercises.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ExerciseDetail(exercise: widget.exercises[index]),
              ),
            );
          },
          visualDensity: VisualDensity(vertical: 4.0),
          leading: Icon(
            widget.exercises[index].iconFile,
            size: 50.0,
          ),
          title: Text(
            widget.exercises[index].name,
            style: const TextStyle(
              fontSize: 15.0,
            ),
          ),
          trailing: IconButton.filledTonal(
            onPressed: () {
              Provider.of<RoutineModel>(context, listen: false)
                  .add(widget.exercises[index]);
              debugPrint("Added ${widget.exercises[index].name}");
            }, // TODO: add exercise to routine function
            icon: Icon(Icons.add),
            tooltip: "Add to Routine",
          ),
        );
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }
}

// from List View, display the details of an exercise
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
            SizedBox(height: 10.0),
            Icon(
              exercise.iconFile,
              size: 200.0,
            ),
            SizedBox(height: 10.0),
            Text(exercise.category),
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
