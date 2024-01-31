import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jobs/utilities/database/database.dart';
import 'package:jobs/utilities/models/worker_model.dart';

class AddNewWorkerPage extends StatefulWidget {
  const AddNewWorkerPage({super.key});

  @override
  State<AddNewWorkerPage> createState() => _AddNewWorkerPageState();
}

class _AddNewWorkerPageState extends State<AddNewWorkerPage> {
  TextEditingController workerNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text("Add New Worker"),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextFormField(
                  controller: workerNameController,
                  maxLength: 200,
                  maxLines: 1,
                  minLines: 1,
                  validator: (value) {
                    if (value == "") {
                      return "Worker name can't be null";
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    hintText: "Worker Name",
                    prefixIcon: Icon(Icons.business_rounded),
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              TextButton(
                onPressed: () {
                  if (workerNameController.text != "") {
                    createWorker(
                      userUID: FirebaseAuth.instance.currentUser!.uid,
                      worker: Worker(
                        workerName: workerNameController.text.toString(),
                      ),
                    ).then((value) {
                      if (value) {
                        Navigator.pop(context, true);
                      }
                    });
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: const Text("Worker name can't be null"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: const Text(
                  "Add New Worker",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
