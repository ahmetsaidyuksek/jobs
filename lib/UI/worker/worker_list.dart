import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jobs/UI/worker/new_worker.dart';
import 'package:jobs/utilities/database/database.dart';
import 'package:jobs/utilities/models/worker_model.dart';

class WorkerListPage extends StatefulWidget {
  const WorkerListPage({super.key});

  @override
  State<WorkerListPage> createState() => _WorkerListPageState();
}

class _WorkerListPageState extends State<WorkerListPage> {
  TextEditingController workerNameController = TextEditingController();

  List<Worker> workerList = <Worker>[];

  Future<bool> getWorkersList() async {
    workerList = await getWorkerList(userUID: FirebaseAuth.instance.currentUser!.uid);
    if (workerList.isNotEmpty) return true;
    return false;
  }

  sortWorkerListValue({required String value}) {
    if (value.isEmpty) {
      workerList.sort((a, b) => a.workerName.toString().compareTo(b.workerName.toString()));
    } else {
      workerList.sort((a, b) {
        bool containsA = a.workerName.toString().toLowerCase().contains(value.toString().toLowerCase());
        bool containsB = b.workerName.toString().toLowerCase().contains(value.toString().toLowerCase());

        if (containsA && !containsB) {
          return -1;
        } else if (!containsA && containsB) {
          return 1;
        } else {
          return a.workerName.toString().compareTo(b.workerName.toString());
        }
      });
    }

    setState(() {});
  }

  sortWorkerList() {
    workerList.sort((a, b) => a.workerName.toString().compareTo(b.workerName.toString()));
    setState(() {});
  }

  @override
  void initState() {
    getWorkersList().then((value) {
      if (value) {
        sortWorkerList();
        setState(() {});
      }
    });

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
        title: const Text("Worker List"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const AddNewWorkerPage();
                  },
                ),
              ).then((value) async {
                if (value) {
                  getWorkersList().then((value) {
                    if (value) {
                      sortWorkerList();
                      setState(() {});
                    }
                  });
                }
              });
            },
            icon: const Icon(Icons.person_add_alt_rounded),
          ),
        ],
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
                child: TextField(
                  controller: workerNameController,
                  maxLines: 1,
                  minLines: 1,
                  maxLength: 100,
                  onChanged: (value) {
                    sortWorkerListValue(value: value);
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person_rounded),
                    hintText: "Worker Name",
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: workerList.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: Key(workerList[index].workerUID.toString()),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        child: const Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      onDismissed: (direction) {
                        deleteWorker(
                          userUID: FirebaseAuth.instance.currentUser!.uid,
                          workerUID: workerList[index].workerUID.toString(),
                        ).then((value) {
                          if (value) {
                            workerList.removeAt(index);
                          }
                        });
                        setState(() {});
                      },
                      child: Card(
                        elevation: 16,
                        color: Colors.teal.shade900,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: SizedBox(
                          height: 75,
                          child: Center(
                            child: ListTile(
                              leading: const Icon(
                                Icons.person_rounded,
                                size: 32,
                                color: Colors.white,
                              ),
                              title: Text(
                                workerList[index].workerName.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  deleteWorker(
                                    userUID: FirebaseAuth.instance.currentUser!.uid,
                                    workerUID: workerList[index].workerUID.toString(),
                                  ).then((value) {
                                    if (value) {
                                      workerList.removeAt(index);
                                    }
                                  });
                                  setState(() {});
                                },
                                icon: Icon(
                                  Icons.delete_forever_rounded,
                                  color: Colors.red.shade400,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
/*InkWell( Add This v1.1
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return WorkerJobListPage;
                              },
                            ),
                          );
                        },
                        child: ListTile(
                          leading: const Icon(Icons.business_rounded),
                          title: Text(
                            workerList[index].workerName.toString(),
                          ),
                          trailing: const Icon(Icons.arrow_right_rounded),
                        ),
                      ),*/