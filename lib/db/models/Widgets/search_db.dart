
import 'package:db_me/db/functions/db_functions.dart';
import 'package:db_me/db/models/Widgets/student_details.dart';
import 'package:db_me/db/models/db_models.dart';
import 'package:flutter/material.dart';



class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
         appBar: AppBar(
          title: Text('Search'),
          actions: [
            IconButton(onPressed: (){
              showSearch(
                
                  context: context,
                  delegate: MySearchDelight(),
                );
            }, icon: Icon(Icons.search),
            )
          ],
         ),
    );
  }
}

class MySearchDelight extends SearchDelegate{
  @override
  List<Widget>? buildActions(BuildContext context) {
    return <Widget> [
    IconButton(onPressed: (){
        if(query.isEmpty){
          close(context, null);
        }else{
          query='';
        }
    }, icon:Icon(Icons.close) 
    )
    ];
  }
 
  
  @override
  Widget? buildLeading(BuildContext context) {
    IconButton(onPressed: ()=> close(context, null), 
    icon: Icon(Icons.arrow_back));
   }
  
  @override
  Widget buildResults(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: studentListNotifier,
      builder: (BuildContext context, List<StudentModel> value, Widget? child) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: ListView.builder(
              itemCount: value.length,
              itemBuilder: (context, index) {
                if (value[index].name.toLowerCase().contains(
                      query.toLowerCase(),
                    )) {
                  return Column(
                    children: [
                      ListTile(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ScreenDetails(
                                name: value[index].name,
                                age: value[index].age.toString(),
                                contact: value[index].contact.toString(),
                                domain: value[index].domain,
                              ),
                            ),
                          );
                        },
                        title: Text(value[index].name),
                      ),
                      const Divider()
                    ],
                  );
                } else {
                  return const Text('Student not found',
                  style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),);
                }
              },
            ),
          ),
        );
      },
    );
  }

  
  @override
  Widget buildSuggestions(BuildContext context) {
        return ValueListenableBuilder(
      valueListenable: studentListNotifier,
      builder: (BuildContext context, List<StudentModel> value, Widget? child) {
        return Padding(
          padding: const EdgeInsets.only(top: 20),
          child: ListView.builder(
            itemCount: value.length,
            itemBuilder: (context, index) {
              if (value[index].name.toLowerCase().contains(
                    query.toLowerCase(),
                  )) {
                return Column(
                  children: [
                    ListTile(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ScreenDetails(
                              name: value[index].name,
                              age: value[index].age.toString(),
                              domain: value[index].domain,
                              contact: value[index].contact.toString(),
                            ),
                          ),
                        );
                      },

                    ),
                    const Divider()
                  ],
                );
              } else {
                return Container();
              }
            },
          ),
        );
      },
    );
  }
}