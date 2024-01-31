import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jobs/UI/job/job_details.dart';
import 'package:jobs/UI/job/new_job.dart';
import 'package:jobs/UI/settings/settings.dart';
import 'package:jobs/utilities/models/job_model.dart';
import 'package:jobs/utilities/database/database.dart' as database;
import 'package:jobs/utilities/models/worker_model.dart';
import 'package:money_formatter/money_formatter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Worker>> getWorkerList({
    required String userUID,
    required List<String> workerUIDList,
  }) async {
    List<Worker> workerList = [];

    if (workerUIDList.isNotEmpty) {
      for (var workerUID in workerUIDList) {
        workerList.add(
          await database.getWorker(
            userUID: userUID,
            workerUID: workerUID,
          ),
        );
      }
    }

    return workerList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const Settings();
                  },
                ),
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: StreamBuilder(
            stream: FirebaseDatabase.instance.ref("/${FirebaseAuth.instance.currentUser!.uid}/jobs/").orderByChild("jobStatus").onValue,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) return const CircularProgressIndicator();
              if (snapshot.data!.snapshot.value != null) {
                Map jobData = Map.from(snapshot.data!.snapshot.value as Map);

                List<Job> jobList = [];

                jobData.forEach((key, value) {
                  print(value["jobStatus"]);
                  jobList.add(Job(
                    jobActive: value["jobActive"],
                    jobUID: value["jobUID"],
                    jobTitle: value["jobTitle"],
                    jobStatus: value["jobStatus"],
                    jobCompanyUID: value["jobCompanyUID"],
                    jobCompanyAuthorizedUID: value["jobCompanyAuthorizedUID"],
                    jobAgreementPriceCurrency: value["jobAgreementPriceCurrency"],
                    jobPriceCurrency: value["jobPriceCurrency"],
                    jobAgreementDate: value["jobAgreementDate"],
                    jobStartDate: value["jobStartDate"],
                    jobCompletionDate: value["jobCompletionDate"],
                    jobEstimatedStartDate: value["jobEstimatedStartDate"],
                    jobEstimatedCompletionDate: value["jobEstimatedCompletionDate"],
                    jobAgreementPrice: double.tryParse(value["jobAgreementPrice"].toString()),
                    jobPrice: double.tryParse(value["jobPrice"].toString()),
                    jobWorkerList: List<String>.from(value["jobWorkerList"] ?? []),
                    jobMaterialList: value["jobMaterialList"],
                    jobUsedMaterialList: value["jobUsedMaterialList"],
                  ));
                });

                return SizedBox(
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: Center(
                      child: Wrap(
                        direction: Axis.horizontal,
                        spacing: 16,
                        runSpacing: 16,
                        alignment: WrapAlignment.start,
                        runAlignment: WrapAlignment.center,
                        children: jobList.map((job) {
                          return SizedBox(
                            height: MediaQuery.of(context).orientation.name == "portrait" ? MediaQuery.of(context).size.height * 0.3 : MediaQuery.of(context).size.height * 0.4,
                            width: MediaQuery.of(context).orientation.name == "portrait" ? MediaQuery.of(context).size.width * 0.9 : MediaQuery.of(context).size.width * 0.4,
                            child: Card(
                              color: Colors.blueGrey.shade400,
                              elevation: 48,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return JobDetailsPage(jobUID: job.jobUID.toString());
                                      },
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 16,
                                        left: 16,
                                        right: 16,
                                        bottom: 8,
                                      ),
                                      child: ListTile(
                                        title: Text(
                                          job.jobTitle.toString(),
                                          softWrap: true,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                          ),
                                        ),
                                        subtitle: Wrap(
                                          children: [
                                            FutureBuilder(
                                              future: database.getCompany(
                                                userUID: FirebaseAuth.instance.currentUser!.uid,
                                                companyUID: job.jobCompanyUID.toString(),
                                              ),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState == ConnectionState.waiting) return const CircularProgressIndicator();
                                                if (snapshot.data == null) return const SizedBox.shrink();

                                                return Text(
                                                  snapshot.data!.companyName.toString(),
                                                  softWrap: true,
                                                  style: TextStyle(
                                                    color: Colors.grey.shade200,
                                                    fontSize: 14,
                                                  ),
                                                );
                                              },
                                            ),
                                            Text(
                                              " - ",
                                              style: TextStyle(
                                                color: Colors.grey.shade200,
                                                fontSize: 14,
                                              ),
                                            ),
                                            FutureBuilder(
                                              future: database.getCompanyAuthorized(
                                                userUID: FirebaseAuth.instance.currentUser!.uid,
                                                companyUID: job.jobCompanyUID.toString(),
                                                companyAuthorizedUID: job.jobCompanyAuthorizedUID.toString(),
                                              ),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState == ConnectionState.waiting) return const CircularProgressIndicator();
                                                if (snapshot.data == null) return const SizedBox.shrink();

                                                return Text(
                                                  snapshot.data!.companyAuthorizedName.toString(),
                                                  softWrap: true,
                                                  style: TextStyle(
                                                    color: Colors.grey.shade200,
                                                    fontSize: 14,
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                        trailing: Text(
                                          job.jobStatus.toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 32,
                                      ),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Agreement Price: ${MoneyFormatter(amount: job.jobAgreementPrice!.toDouble()).output.nonSymbol} ${job.jobAgreementPriceCurrency}",
                                          style: GoogleFonts.roboto(
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    job.jobWorkerList!.isNotEmpty
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                              top: 8,
                                              left: 16,
                                              right: 16,
                                              bottom: 16,
                                            ),
                                            child: FutureBuilder(
                                              future: getWorkerList(
                                                userUID: FirebaseAuth.instance.currentUser!.uid,
                                                workerUIDList: job.jobWorkerList!,
                                              ),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState == ConnectionState.waiting) return const CircularProgressIndicator();
                                                if (snapshot.data == null) return const SizedBox.shrink();

                                                return Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: SingleChildScrollView(
                                                    scrollDirection: Axis.horizontal,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: snapshot.data!.map((worker) {
                                                        return Card(
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(16),
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(16),
                                                            child: Text(
                                                              worker.workerName!.toString(),
                                                            ),
                                                          ),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),

        /*SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 16,
                bottom: 16,
              ),
              child: Wrap(
                direction: Axis.horizontal,
                spacing: 16,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                runAlignment: WrapAlignment.center,
                children: jobList.map((job) {
                  return 
                  );
                }).toList(),
              ),
            ),
          ),
        ),*/
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const NewJobPage();
              },
            ),
          ).then(
            (value) {
              if (value) {
                setState(() {});
              }
            },
          );
        },
        label: const Text("New Job"),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
