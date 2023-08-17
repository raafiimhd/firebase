import 'package:db_me/db/functions/db_functions.dart';
import 'package:db_me/Widgets/student_details.dart';
import 'package:db_me/db/models/model.dart';
import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  String _searchQuery = '';
  List<StudentModel> _filteredStudents = [];

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
    setState(() {
      _filteredStudents = studentListNotifier.value
          .where((student) =>
              student.name.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                              name: _filteredStudents[index].name,
                              age: _filteredStudents[index].age,
                              contact: _filteredStudents[index].contact,
                              domain: _filteredStudents[index].domain,
                            ),
                          ),
                        );
                      },
                      title: Text(_filteredStudents[index].name),
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
