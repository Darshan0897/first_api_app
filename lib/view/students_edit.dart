import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/student_model.dart';
import '../utils/app_config.dart';

class StudentsEdit extends StatefulWidget {
  const StudentsEdit({Key? key, required this.studentedit}) : super(key: key);
  final Student studentedit;

  @override
  State<StudentsEdit> createState() => _StudentsEditState();
}

class _StudentsEditState extends State<StudentsEdit> {
   TextEditingController firstnamecontroller = TextEditingController();
  TextEditingController lastnamecontroller = TextEditingController();
  // TextEditingController emailcontroller = TextEditingController();
  TextEditingController avatarcontroller = TextEditingController();
  Student? studentedit;
  bool isLoading = false;

  @override
  void initState() {
    studentedit = widget.studentedit;
    firstnamecontroller.text=widget.studentedit.firstName!;
    lastnamecontroller.text=widget.studentedit.lastName!;
    avatarcontroller.text=widget.studentedit.avatar!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(child: Text("Edit")),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            TextFormField(
              controller: firstnamecontroller,
                decoration: const InputDecoration(
                    labelText: "First Name", border: OutlineInputBorder()),
                ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: lastnamecontroller,
                decoration: const InputDecoration(
                    labelText: "Last Name", border: OutlineInputBorder()),
               ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: avatarcontroller,
                decoration: const InputDecoration(
                    labelText: "Image", border: OutlineInputBorder()),
                ),
           const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: isLoading? null:() => updateDate(context), child: const Text("Update"))
          ],
        ),
      ),
    );
  }

  updateDate(context) async {
    setState(() =>isLoading = true);
    http.Response response = await http.put(
        Uri.parse("${AppConfig.baseUrl}/students/${widget.studentedit.id}"),
        body: {
          "firstName": firstnamecontroller.text,
          "avatar":
              avatarcontroller.text,
          "lastName": lastnamecontroller.text,
        });

    if (response.statusCode ==200) {
      setState(() => isLoading = false);
      Navigator.pop(context, true);
    }
  }
}
