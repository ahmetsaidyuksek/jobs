import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jobs/UI/home.dart';
import 'package:jobs/utilities/models/worker_model.dart';
import 'package:jobs/utilities/models/worker_select_model.dart';

import 'package:jobs/utilities/database/database.dart' as database;

class AddWorkers extends StatefulWidget {
  final String jobUID;
  const AddWorkers({
    super.key,
    required this.jobUID,
  });

  @override
  State<AddWorkers> createState() => _AddWorkersState();
}

class _AddWorkersState extends State<AddWorkers> {
  TextEditingController workerController = TextEditingController();

  List<Worker> workerList = <Worker>[];
  List<SelectableWorker> selectableWorkerList = <SelectableWorker>[];
  List<String> selectedWorkersList = <String>[];

  getWorkersList({required String userUID}) async {
    workerList = await database.getWorkerList(userUID: userUID);
    selectableWorkerList.clear();

    if (workerList.isNotEmpty) {
      for (var worker in workerList) {
        selectableWorkerList.add(
          SelectableWorker(
            workerSelected: false,
            worker: worker,
          ),
        );
      }
      sortSelectableWorker();
    }
    setState(() {});
  }

  sortSelectableWorker() {
    selectableWorkerList.sort((a, b) {
      if (a.workerSelected == true && b.workerSelected == false) {
        return -1;
      } else if (a.workerSelected == false && b.workerSelected == true) {
        return 1;
      }
      return a.worker!.workerName.toString().compareTo(b.worker!.workerName.toString());
    });
    setState(() {});
  }

  @override
  void initState() {
    getWorkersList(userUID: FirebaseAuth.instance.currentUser!.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text("Add Workers"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            TextField(
              controller: workerController,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {
                    if (workerController.text != "") {
                      if (selectableWorkerList.isNotEmpty) {
                        bool contains = false;
                        for (var item in selectableWorkerList) {
                          if (item.worker!.workerName.toString() == workerController.text.toString()) {
                            contains = true;
                          }
                        }

                        if (!contains) {
                          database
                              .createWorker(
                            userUID: FirebaseAuth.instance.currentUser!.uid,
                            worker: Worker(
                              workerName: workerController.text.toString(),
                            ),
                          )
                              .then((value) {
                            if (value) {
                              workerController.clear();
                              getWorkersList(userUID: FirebaseAuth.instance.currentUser!.uid);
                            }
                          });
                        }
                      } else {
                        database
                            .createWorker(
                          userUID: FirebaseAuth.instance.currentUser!.uid,
                          worker: Worker(
                            workerName: workerController.text.toString(),
                          ),
                        )
                            .then(
                          (value) {
                            if (value) {
                              workerController.clear();
                              getWorkersList(userUID: FirebaseAuth.instance.currentUser!.uid);
                            }
                          },
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.add),
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: 32,
                ),
                child: ListView.builder(
                  itemCount: selectableWorkerList.length,
                  itemBuilder: (context, index) {
                    return CheckboxListTile(
                      secondary: const Icon(Icons.person),
                      title: Text(
                        selectableWorkerList[index].worker!.workerName.toString(),
                      ),
                      value: selectableWorkerList[index].workerSelected,
                      onChanged: (value) {
                        selectableWorkerList[index].workerSelected = value;
                        if (value as bool) {
                          if (!selectedWorkersList.contains(selectableWorkerList[index].worker!.workerUID.toString())) {
                            selectedWorkersList.add(selectableWorkerList[index].worker!.workerUID.toString());
                          }
                        } else {
                          if (selectedWorkersList.contains(selectableWorkerList[index].worker!.workerUID.toString())) {
                            selectedWorkersList.remove(selectableWorkerList[index].worker!.workerUID.toString());
                          }
                        }
                        setState(() {});
                      },
                    );
                  },
                ),
              ),
            ),
            const Divider(
              color: Colors.black,
            ),
            const SizedBox(
              height: 8,
            ),
            TextButton(
              onPressed: () {
                database
                    .addWorkersToJob(
                  userUID: FirebaseAuth.instance.currentUser!.uid,
                  jobUID: widget.jobUID,
                  workerList: selectedWorkersList,
                )
                    .then((value) {
                  if (value) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const HomePage();
                        },
                      ),
                      (route) => false,
                    );
                  }
                });
              },
              child: const Text("Add Workers"),
            ),
            const SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }
}
