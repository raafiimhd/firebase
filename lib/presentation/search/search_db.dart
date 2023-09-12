import 'package:db_me/presentation/studentdetails/student_details.dart';
import 'package:db_me/db/functions/db_functions.dart';
import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  String _searchQuery = '';
  List<AddStudentDataToFirebase> _filteredStudents = [];

  @override
  void initState() {
    super.initState();
    studentListNotifier.addListener(_updateFilteredStudents);
    _updateFilteredStudents();
  }

  @override
  void dispose() {
    studentListNotifier.removeListener(_updateFilteredStudents);
    super.dispose();
  }

  void _updateFilteredStudents() {
    final allStudents = studentListNotifier.value;
    setState(() {
      _filteredStudents = allStudents
          .where((student) => student.studentName
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    fetchAndPopulateStudents();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                  _updateFilteredStudents();
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Search by name',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredStudents.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ScreenDetails(
                              student: _filteredStudents[index],
                              index: index,
                            ),
                          ),
                        );
                      },
                      title: Text(_filteredStudents[index].studentName),
                    ),
                    const Divider(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> fetchAndPopulateStudents() async {
  // Fetch students from Firestore or your data source
  final List<AddStudentDataToFirebase> students = await fetchStudents();

  // Update the studentListNotifier with the retrieved data
  studentListNotifier.value = students;
}
