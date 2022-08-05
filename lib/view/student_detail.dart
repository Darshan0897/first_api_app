import 'dart:convert';
import 'package:first_api_app/models/student_model.dart';
import 'package:first_api_app/view/students_edit.dart';
import 'package:first_api_app/view/students_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/app_config.dart';

class StudentDetail extends StatefulWidget {
  const StudentDetail({Key? key, required this.student}) : super(key: key);
  final Student student;

  @override
  State<StudentDetail> createState() => _StudentDetailState();
}

class _StudentDetailState extends State<StudentDetail> {
  Student? student;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getUserDetals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: isLoading
              ? const Text("Students detail")
              : Text("${student?.firstName} ${student?.lastName}"),
          actions: [
            GestureDetector(
                onTap: () => edit(context),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.edit),
                ))
          ],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator.adaptive())
            : Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage("${student?.avatar}"),
                                fit: BoxFit.cover)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "First name: ${student?.firstName}",
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                      Text(
                        "Last name: ${student?.lastName}",
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ));
  }

  void getUserDetals() async {
    setState(() => isLoading = true);
    http.Response response = await http
        .get(Uri.parse("${AppConfig.baseUrl}/students/${widget.student.id}"));
    print(response.statusCode);
    if (response.statusCode == 200) {
      var decoded = jsonDecode(response.body);
      student = Student.fromMap(decoded);
      setState(() => isLoading = false);
    }
  }

  edit(BuildContext context) async {
    bool?  isEdited = await showDialog(
        context: context,
        builder: (context) => StudentsEdit(studentedit: widget.student));

    if (isEdited == true) {

      
      Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) =>const StudentList())));
    }
  }
}  

      
          
        
  
