import 'package:flutter/material.dart';

void main() {
  runApp(const WorkoutTrackerApp());
}

class WorkoutTrackerApp extends StatelessWidget {
  const WorkoutTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Workout Tracker',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const WorkoutHomePage(),
    );
  }
}

class WorkoutHomePage extends StatefulWidget {
  const WorkoutHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WorkoutHomePageState createState() => _WorkoutHomePageState();
}

class _WorkoutHomePageState extends State<WorkoutHomePage> {
  final List<Map<String, dynamic>> _workouts = [];
  final TextEditingController _exerciseController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  String _selectedType = 'Cardio';
  String _selectedTime = 'Morning';
  String _selectedDay = 'Monday';

  // Filter parameters
  String? _filterDay;
  String? _filterTime;

  String? _errorMessage;
  void _addWorkout() {
    // Validate inputs
    if (_exerciseController.text.isEmpty ||
        _durationController.text.isEmpty ||
        _caloriesController.text.isEmpty) {
      setState(() {
        _errorMessage = 'All fields are required!';
      });
      return;
    }

    if (int.tryParse(_durationController.text) == null ||
        int.tryParse(_caloriesController.text) == null) {
      setState(() {
        _errorMessage = 'Duration and Calories must be numeric!';
      });
      return;
    }

    // Add workout to the list
    setState(() {
      _workouts.add({
        'exercise': _exerciseController.text,
        'duration': int.parse(_durationController.text),
        'calories': int.parse(_caloriesController.text),
        'type': _selectedType,
        'notes': _notesController.text,
        'day': _selectedDay,
        'time': _selectedTime,
      });
      _errorMessage = null; // Clear error message
    });

    // Clear input fields
    _exerciseController.clear();
    _durationController.clear();
    _caloriesController.clear();
    _notesController.clear();
    _selectedType = 'Cardio';
    _selectedDay = 'Monday';
    _selectedTime = 'Morning';
  }

  void _deleteWorkout(int index) {
    setState(() {
      _workouts.removeAt(index);
    });
  }

  void _deleteAllWorkouts() {
    setState(() {
      _workouts.clear();
    });
  }

  int get _totalCalories {
    return _workouts.fold<int>(
      0, // Initial value
      (sum, workout) => sum + (workout['calories'] as int),
    );
  }

  List<Map<String, dynamic>> get _filteredWorkouts {
    return _workouts.where((workout) {
      final matchesDay = _filterDay == null || workout['day'] == _filterDay;
      final matchesTime = _filterTime == null || workout['time'] == _filterTime;
      return matchesDay && matchesTime;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Workout Tracker'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (_errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.only(bottom: 10),
                  color: Colors.red[100],
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      _exerciseController,
                      'Exercise',
                      const Key('exerciseField'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildTextField(
                      _durationController,
                      'Duration (min)',
                      const Key('durationField'),
                      TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      _caloriesController,
                      'Calories Burned',
                      const Key('caloriesField'),
                      TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedType,
                      key: const Key('workoutTypeDropdown'),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedType = newValue!;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Workout Type',
                        border: OutlineInputBorder(),
                      ),
                      items: <String>['Cardio', 'Strength', 'Flexibility']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _buildTextField(
                _notesController,
                'Notes',
                const Key('notesField'),
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedDay,
                      key: const Key('dayDropdown'),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedDay = newValue!; // Update _selectedDay
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Day',
                        border: OutlineInputBorder(),
                      ),
                      items: <String>[
                        'Monday',
                        'Tuesday',
                        'Wednesday',
                        'Thursday',
                        'Friday',
                        'Saturday',
                        'Sunday'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedTime,
                      key: const Key('timeDropdown'),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedTime = newValue!; // Update _selectedTime
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Time',
                        border: OutlineInputBorder(),
                      ),
                      items: <String>['Morning', 'Evening', 'Night']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    key: const Key('addWorkoutButton'),
                    onPressed: _addWorkout,
                    child: const Text('Add Workout',
                        style: TextStyle(color: Colors.black)),
                  ),
                  ElevatedButton(
                    key: const Key('deleteAllWorkoutsButton'),
                    onPressed: _deleteAllWorkouts,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text(
                      'Delete All Workouts',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
              const Divider(),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _filterDay,
                      key: const Key('filterDayDropdown'),
                      onChanged: (String? newValue) {
                        setState(() {
                          _filterDay = newValue; // Update _filterDay
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Filter by Day',
                        border: OutlineInputBorder(),
                      ),
                      items: <String?>[
                        null,
                        'Monday',
                        'Tuesday',
                        'Wednesday',
                        'Thursday',
                        'Friday',
                        'Saturday',
                        'Sunday'
                      ].map<DropdownMenuItem<String>>((String? value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value ?? 'All Days'),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _filterTime,
                      key: const Key('filterTimeDropdown'),
                      onChanged: (String? newValue) {
                        setState(() {
                          _filterTime = newValue; // Update _filterTime
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Filter by Time',
                        border: OutlineInputBorder(),
                      ),
                      items: <String?>[null, 'Morning', 'Evening', 'Night']
                          .map<DropdownMenuItem<String>>((String? value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value ?? 'All Times'),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _filteredWorkouts.length,
                itemBuilder: (ctx, index) {
                  final workout = _filteredWorkouts[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 4,
                    child: ListTile(
                      title: Text(
                        workout['exercise'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Type: ${workout['type']}, Duration: ${workout['duration']} min, '
                        'Calories: ${workout['calories']}\nNotes: ${workout['notes']}\nDay: ${workout['day']}, Time: ${workout['time']}',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteWorkout(index),
                        color: Colors.red,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              Text(
                'Total Calories Burned: $_totalCalories',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    Key key, [
    TextInputType keyboardType = TextInputType.text,
  ]) {
    return TextField(
      key: key,
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      ),
      keyboardType: keyboardType,
    );
  }
}
