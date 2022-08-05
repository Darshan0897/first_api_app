import 'dart:convert';
import 'package:first_api_app/view/student_detail.dart';
import 'package:first_api_app/view/students.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/student_model.dart';
import '../utils/app_config.dart';

class StudentList extends StatefulWidget {
  const StudentList({Key? key}) : super(key: key);

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  List<Student> students = [];
  List<Student> allstudents = [];
  bool isLoading = false;
  //bool isSearching = false;
  bool isdeleting = false;
  String query = '';

  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    students = students;
    getStudents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context, builder: (context) => const Students());
          },
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          title: TextFormField(
            onChanged: (v) {
              query = v;
            },
            onEditingComplete: () {
              List<Student> newList = [];
              for (var st in allstudents) {
                if (st.firstName!.toLowerCase().contains(query) ||
                    st.lastName!.toLowerCase().contains(query)) {
                  newList.add(st);
                }
              }
              setState(() {
                if (newList.isNotEmpty) {
                  students = newList;
                } else {
                  students = allstudents;
                }
              });
            },
            decoration: const InputDecoration(hintText: "Search Name"),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                  onTap: () {
                    getStudents();
                  },
                  child: const Icon(Icons.rotate_left)),
            ),
          ],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator.adaptive())
            : students.isEmpty
                ? const Center(child: Text("No Students"))
                : ListView.builder(
                    itemCount: students.length,
                    itemBuilder: (context, index) => ListTile(
                      onTap: isLoading
                          ? null
                          : () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => StudentDetail(
                                          student: students[index]))));
                            },
                      title: Text(
                          "${students[index].firstName} ${students[index].lastName}"),
                      leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage("${students[index].avatar}")),
                      trailing: IconButton(
                          onPressed: isdeleting
                              ? null
                              : () {
                                  deletStudentApi(students[index].id);
                                },
                          icon: Icon(Icons.delete,
                              color: isdeleting ? Colors.grey : Colors.red)),
                    ),
                  ));
  }

  void getStudents() async {
    setState(() => isLoading = true);
    students.clear();
    http.Response response =
        await http.get(Uri.parse("${AppConfig.baseUrl}/students"));
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      var decoded = jsonDecode(response.body);
      print(decoded.runtimeType);

      if (decoded is List) {
        for (var stud in decoded) {
          students.add(Student.fromMap(stud as Map<String, dynamic>));
        }
        allstudents = students;
      }
      setState(() => isLoading = false);
    }
  }

  deletStudentApi(id) async {
    setState(() => isdeleting = true);
    http.Response response =
        await http.delete(Uri.parse("${AppConfig.baseUrl}/students/$id"));
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      getStudents();
      setState(() => isdeleting = false);
    }
  }
}
