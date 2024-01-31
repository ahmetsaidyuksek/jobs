import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jobs/utilities/models/company_authorized_model.dart';
import 'package:jobs/utilities/models/company_model.dart';
import 'package:jobs/utilities/models/job_model.dart';
import 'package:jobs/utilities/models/user_model.dart';
import 'package:jobs/utilities/models/worker_model.dart';

//Jobs

Future<bool> addWorkersToJob({required String userUID, required String jobUID, required List<String> workerList}) async {
  bool workersAded = false;

  try {
    await FirebaseDatabase.instance.ref("/$userUID/jobs/$jobUID/").update({
      "jobWorkerList": List<String>.from(workerList),
    }).then((value) {
      workersAded = true;
    });
  } catch (error) {
    Fluttertoast.showToast(
      msg: error.toString(),
      toastLength: Toast.LENGTH_LONG,
    );
  }

  return workersAded;
}

Future<Job> getJob({
  required String userUID,
  required String jobUID,
}) async {
  Job job = Job();

  try {
    await FirebaseDatabase.instance.ref("/$userUID/jobs/$jobUID/").get().then((value) {
      if (value.value != null) {
        Map jobData = Map.from(value.value as Map);
        job = Job(
          jobActive: jobData["jobActive"] as bool,
          jobUID: jobData["jobUID"],
          jobTitle: jobData["jobTitle"],
          jobStatus: jobData["jobStatus"],
          jobCompanyUID: jobData["jobCompanyUID"],
          jobCompanyAuthorizedUID: jobData["jobCompanyAuthorizedUID"],
          jobAgreementPriceCurrency: jobData["jobAgreementPriceCurrency"],
          jobPriceCurrency: jobData["jobPriceCurrency"],
          jobAgreementDate: jobData["jobAgreementDate"],
          jobStartDate: jobData["jobStartDate"],
          jobCompletionDate: jobData["jobCompletionDate"],
          jobEstimatedStartDate: jobData["jobEstimatedStartDate"],
          jobEstimatedCompletionDate: jobData["jobEstimatedCompletionDate"],
          jobAgreementPrice: double.parse(jobData["jobAgreementPrice"].toString()),
          jobPrice: double.parse(jobData["jobPrice"].toString()),
          jobWorkerList: List<String>.from(jobData["jobWorkerList"] ?? []),
          jobMaterialList: List.from(jobData["jobMaterialList"] ?? []),
          jobUsedMaterialList: List.from(jobData["jobUsedMaterialList"] ?? []),
        );
      }
    });
  } catch (error) {
    Fluttertoast.showToast(
      msg: error.toString(),
      toastLength: Toast.LENGTH_LONG,
    );
  }

  return job;
}

Future<List<Job>> getJobList({
  required String userUID,
}) async {
  List<Job> jobList = [];

  try {
    await FirebaseDatabase.instance.ref("/$userUID/jobs/").get().then((value) {
      if (value.value != null) {
        Map jobData = Map.from(value.value as Map);
        for (var job in jobData.values) {
          if (job["jobActive"] ?? false) {
            jobList.add(
              Job(
                jobActive: job["jobActive"] as bool,
                jobUID: job["jobUID"],
                jobTitle: job["jobTitle"],
                jobStatus: job["jobStatus"],
                jobCompanyUID: job["jobCompanyUID"],
                jobCompanyAuthorizedUID: job["jobCompanyAuthorizedUID"],
                jobAgreementPriceCurrency: job["jobAgreementPriceCurrency"],
                jobPriceCurrency: job["jobPriceCurrency"],
                jobAgreementDate: job["jobAgreementDate"],
                jobStartDate: job["jobStartDate"],
                jobCompletionDate: job["jobCompletionDate"],
                jobEstimatedStartDate: job["jobEstimatedStartDate"],
                jobEstimatedCompletionDate: job["jobEstimatedCompletionDate"],
                jobAgreementPrice: double.parse(job["jobAgreementPrice"].toString()),
                jobPrice: double.parse(job["jobPrice"].toString()),
                jobWorkerList: List<String>.from(job["jobWorkerList"] ?? []),
                jobMaterialList: List.from(job["jobMaterialList"] ?? []),
                jobUsedMaterialList: List.from(job["jobUsedMaterialList"] ?? []),
              ),
            );
          }
        }
      }
    });
    /*.get().then((value) {
      if (value.value != null) {
        Map jobData = Map.from(value.value as Map);
        for (var job in jobData.values) {
          if (job["jobActive"] ?? false) {
            jobList.add(
              Job(
                jobActive: job["jobActive"] as bool,
                jobUID: job["jobUID"],
                jobTitle: job["jobTitle"],
                jobStatus: job["jobStatus"],
                jobCompanyUID: job["jobCompanyUID"],
                jobCompanyAuthorizedUID: job["jobCompanyAuthorizedUID"],
                jobAgreementPriceCurrency: job["jobAgreementPriceCurrency"],
                jobPriceCurrency: job["jobPriceCurrency"],
                jobAgreementDate: job["jobAgreementDate"],
                jobStartDate: job["jobStartDate"],
                jobCompletionDate: job["jobCompletionDate"],
                jobEstimatedStartDate: job["jobEstimatedStartDate"],
                jobEstimatedCompletionDate: job["jobEstimatedCompletionDate"],
                jobAgreementPrice: double.parse(job["jobAgreementPrice"].toString()),
                jobPrice: double.parse(job["jobPrice"].toString()),
                jobWorkerList: List<String>.from(job["jobWorkerList"] ?? []),
                jobMaterialList: List.from(job["jobMaterialList"] ?? []),
                jobUsedMaterialList: List.from(job["jobUsedMaterialList"] ?? []),
              ),
            );
          }
        }
      }
    });*/
  } catch (error) {
    Fluttertoast.showToast(
      msg: error.toString(),
      toastLength: Toast.LENGTH_LONG,
    );
  }

  return jobList;
}

Future<String> addNewJob({
  required String userUID,
  required Job job,
}) async {
  String jobUID = "";

  try {
    var jobUID2 = FirebaseDatabase.instance.ref("/$userUID/jobs/").push();

    await jobUID2.set({
      "jobActive": job.jobActive,
      "jobUID": jobUID2.key.toString(),
      "jobTitle": job.jobTitle,
      "jobStatus": job.jobStatus,
      "jobCompanyUID": job.jobCompanyUID,
      "jobCompanyAuthorizedUID": job.jobCompanyAuthorizedUID,
      "jobAgreementPriceCurrency": job.jobAgreementPriceCurrency,
      "jobPriceCurrency": job.jobPriceCurrency,
      "jobAgreementDate": job.jobAgreementDate,
      "jobStartDate": job.jobStartDate,
      "jobCompletionDate": job.jobCompletionDate,
      "jobEstimatedStartDate": job.jobEstimatedStartDate,
      "jobEstimatedCompletionDate": job.jobEstimatedCompletionDate,
      "jobAgreementPrice": job.jobAgreementPrice,
      "jobPrice": job.jobPrice,
      "jobWorkerList": job.jobWorkerList,
      "jobMaterialList": job.jobMaterialList,
      "jobUsedMaterialList": job.jobUsedMaterialList,
    }).then((value) {
      jobUID = jobUID2.key.toString();
    });
  } catch (error) {
    Fluttertoast.showToast(
      msg: error.toString(),
      toastLength: Toast.LENGTH_LONG,
    );
  }

  return jobUID;
}

//Company

//Delete Company by userUID and companyUID
Future<bool> deleteCompany({required String userUID, required String companyUID}) async {
  bool companyDeleted = false;

  try {
    await FirebaseFirestore.instance.collection("users").doc(userUID).collection("companyList").doc(companyUID).delete().then((value) async {
      await FirebaseFirestore.instance.collection("users").doc(userUID).collection("companyList").doc(companyUID).collection("companyAuthorizedList").get().then((value) {
        for (var element in value.docs) {
          element.reference.delete();
        }
        companyDeleted = true;
      });
    });
  } catch (error) {
    Fluttertoast.showToast(
      msg: error.toString(),
      toastLength: Toast.LENGTH_LONG,
    );
  }

  return companyDeleted;
}

Future<CompanyAuthorized> getCompanyAuthorized({
  required String userUID,
  required String companyUID,
  required String companyAuthorizedUID,
}) async {
  CompanyAuthorized companyAuthorized = CompanyAuthorized();

  try {
    await FirebaseFirestore.instance.collection("users").doc(userUID).collection("companyList").doc(companyUID).collection("companyAuthorizedList").doc(companyAuthorizedUID).get().then((value) {
      if (value.data() != null) {
        companyAuthorized = CompanyAuthorized(
          companyAuthorizedActive: value.data()!["companyAuthorizedActive"],
          companyAuthorizedUID: value.data()!["companyAuthorizedUID"],
          companyAuthorizedName: value.data()!["companyAuthorizedName"],
          companyAuthorizedJobList: value.data()!["companyAuthorizedJobList"],
        );
      }
    });
  } catch (error) {
    Fluttertoast.showToast(
      msg: error.toString(),
      toastLength: Toast.LENGTH_LONG,
    );
  }

  return companyAuthorized;
}

//Add company userUID and company
Future<String> createCompany({
  required String userUID,
  required Company company,
}) async {
  String companyUID = "";

  try {
    await FirebaseFirestore.instance.collection("users").doc(userUID).collection("companyList").add({
      "companyActive": true,
      "companyName": company.companyName,
      "companyJobList": company.companyJobList,
    }).then((value) async {
      if (value.id.isNotEmpty) {
        companyUID = value.id.toString();
        await FirebaseFirestore.instance.collection("users").doc(userUID).collection("companyList").doc(value.id.toString()).update({
          "companyUID": value.id.toString(),
        });
      }
    });
  } catch (error) {
    Fluttertoast.showToast(
      msg: error.toString(),
      toastLength: Toast.LENGTH_LONG,
    );
  }

  return companyUID;
}

//Get company userUID and companyUID
Future<Company> getCompany({
  required String userUID,
  required String companyUID,
}) async {
  Company company = Company();

  try {
    await FirebaseFirestore.instance.collection("users").doc(userUID).collection("companyList").doc(companyUID).get().then((value) async {
      if (value.data() != null) {
        company = Company(
          companyActive: value.data()!["companyActive"] ?? false,
          companyUID: value.data()!["companyUID"],
          companyName: value.data()!["companyName"],
          companyAuthorizedList: await getCompanyAuthorizedListString(
            userUID: userUID,
            companyUID: companyUID,
          ),
          companyJobList: List.from((value.data()!["companyJobList"] ?? [])),
        );
      }
    });
  } catch (error) {
    Fluttertoast.showToast(
      msg: error.toString(),
      toastLength: Toast.LENGTH_LONG,
    );
  }

  return company;
}

//Add Company Authorized as List
Future<bool> addCompanyAuthorizedList({
  required String userUID,
  required String companyUID,
  required List<CompanyAuthorized> companyAuthorizedList,
}) async {
  bool companyAuthorizedAdded = false;

  try {
    for (var companyAuthorized in companyAuthorizedList) {
      await FirebaseFirestore.instance.collection("users").doc(userUID).collection("companyList").doc(companyUID).collection("companyAuthorizedList").add({
        "companyAuthorizedActive": true,
        "companyAuthorizedName": companyAuthorized.companyAuthorizedName.toString(),
        "companyAuthorizedJobList": companyAuthorized.companyAuthorizedJobList,
      }).then((value) async {
        if (value.id.isNotEmpty) {
          await FirebaseFirestore.instance.collection("users").doc(userUID).collection("companyList").doc(companyUID).collection("companyAuthorizedList").doc(value.id).update({
            "companyAuthorizedUID": value.id.toString(),
          }).then((value) {
            companyAuthorizedAdded = true;
          });
        }
      });
    }
  } catch (error) {
    Fluttertoast.showToast(
      msg: error.toString(),
      toastLength: Toast.LENGTH_LONG,
    );
  }

  return companyAuthorizedAdded;
}

//Add Company Authorized
Future<bool> addCompanyAuthorized({
  required String userUID,
  required String companyUID,
  required String companyAuthorizedName,
}) async {
  bool companyAuthorizedAdded = false;

  try {
    await FirebaseFirestore.instance.collection("users").doc(userUID).collection("companyList").doc(companyUID).collection("companyAuthorizedList").add({
      "companyAuthorizedName": companyAuthorizedName,
    }).then((value) async {
      if (value.id.isNotEmpty) {
        await FirebaseFirestore.instance.collection("users").doc(userUID).collection("companyList").doc(companyUID).collection("companyAuthorizedList").doc(value.id).update({}).then((value) {
          companyAuthorizedAdded = true;
        });
      }
    });
  } catch (error) {
    Fluttertoast.showToast(
      msg: error.toString(),
      toastLength: Toast.LENGTH_LONG,
    );
  }

  return companyAuthorizedAdded;
}

//Delete Company Authorized
Future<bool> deleteCompanyAuthorized({
  required String userUID,
  required String companyUID,
  required String companyAuthorizedUID,
}) async {
  bool companyAuthorizedDeleted = false;

  try {
    await FirebaseFirestore.instance.collection("users").doc(userUID).collection("companyList").doc(companyUID).collection("companyAuthorizedList").doc(companyAuthorizedUID).delete().then((value) {
      companyAuthorizedDeleted = true;
    });
  } catch (error) {
    Fluttertoast.showToast(
      msg: error.toString(),
      toastLength: Toast.LENGTH_LONG,
    );
  }

  return companyAuthorizedDeleted;
}

//Get company authorized list with companyUID and userUID
Future<List<CompanyAuthorized>> getCompanyAuthorizedList({
  required String userUID,
  required String companyUID,
}) async {
  List<CompanyAuthorized> companyAuthorizedList = [];

  try {
    await FirebaseFirestore.instance.collection("users").doc(userUID).collection("companyList").doc(companyUID).collection("companyAuthorizedList").get().then((value) {
      if (value.docs.isNotEmpty) {
        for (var companyAuthorized in value.docs) {
          companyAuthorizedList.add(
            CompanyAuthorized(
              companyAuthorizedActive: companyAuthorized.data()["companyAuthorizedActive"],
              companyAuthorizedUID: companyAuthorized.data()["companyAuthorizedUID"],
              companyAuthorizedName: companyAuthorized.data()["companyAuthorizedName"],
              companyAuthorizedJobList: companyAuthorized.data()["companyAuthorizedJobList"],
            ),
          );
        }
      }
    });
  } catch (error) {
    Fluttertoast.showToast(
      msg: error.toString(),
      toastLength: Toast.LENGTH_LONG,
    );
  }

  return companyAuthorizedList;
}

Future<List<String>> getCompanyAuthorizedListString({
  required String userUID,
  required String companyUID,
}) async {
  List<String> companyAuthorizedListString = [];

  try {
    await FirebaseFirestore.instance.collection("users").doc(userUID).collection("companyList").doc(companyUID).collection("companyAuthorizedList").get().then((value) {
      if (value.docs.isNotEmpty) {
        for (var companyAuthorized in value.docs) {
          if (!companyAuthorizedListString.contains(companyAuthorized.data()["companyAuthorizedUID"])) {
            companyAuthorizedListString.add(companyAuthorized.data()["companyAuthorizedUID"]);
          }
        }
      }
    });
  } catch (error) {
    Fluttertoast.showToast(
      msg: error.toString(),
      toastLength: Toast.LENGTH_LONG,
    );
  }

  return companyAuthorizedListString;
}

//Get Company List with userUID
Future<List<Company>> getCompanyList({required String userUID}) async {
  List<Company> companyList = [];

  try {
    await FirebaseFirestore.instance.collection("users").doc(userUID).collection("companyList").get().then((value) async {
      if (value.docs.isNotEmpty) {
        for (var company in value.docs) {
          companyList.add(
            Company(
              companyActive: company.data()["companyActive"],
              companyUID: company.data()["companyUID"],
              companyName: company.data()["companyName"],
              companyAuthorizedList: await getCompanyAuthorizedListString(
                userUID: userUID,
                companyUID: company.data()["companyUID"],
              ),
              companyJobList: List.from((company.data()["companyJobList"] ?? <String>[])),
            ),
          );
        }
      }
    });
  } catch (error) {
    Fluttertoast.showToast(
      msg: error.toString(),
      toastLength: Toast.LENGTH_LONG,
    );
  }

  return companyList;
}

//Users

Future<User> getUser({
  required String userUID,
}) async {
  User user = User();

  try {
    await FirebaseFirestore.instance.collection("users").doc(userUID).get().then((value) {
      if (value.data() != null) {
        user = User(
          userActive: value.data()!["userActive"] ?? false,
          userUID: value.data()!["userUID"],
          userName: value.data()!["userName"],
          userEmail: value.data()!["userEmail"],
          userPhoneNumber: value.data()!["userPhoneNumber"],
          userCompanyName: value.data()!["userCompanyName"],
          userJoinTime: value.data()!["userJoinTime"].millisecondsSinceEpoch,
        );
      }
    });
  } catch (error) {
    Fluttertoast.showToast(
      msg: error.toString(),
      toastLength: Toast.LENGTH_LONG,
    );
  }

  return user;
}

//Workers

//Get workerJobList with userUID and workerUID
Future<List<Job>> getWorkerJobs({
  required String userUID,
  required String workerUID,
}) async {
  List<Job> workerJobList = <Job>[];
  List<String> workersJobsList = <String>[];

  try {
    await FirebaseFirestore.instance.collection("users").doc(userUID).collection("workerList").doc(workerUID).get().then((value) {
      if (value.data() != null) {
        Map workerData = Map.from(value.data() as Map);

        workersJobsList = workerData["workerJobList"] ?? [];
      }
    });
    if (workersJobsList.isNotEmpty) {
      await FirebaseDatabase.instance.ref("/$userUID/jobs/").once().then((value) {
        if (value.snapshot.value != null) {
          Map jobData = Map.from(value.snapshot.value as Map);

          for (var job in jobData.values) {
            if (workersJobsList.contains(job["jobUID"])) {
              workerJobList.add(Job(
                jobActive: job["jobActive"] ?? false,
                jobUID: job["jobUID"] ?? "",
                jobTitle: job["jobTitle"] ?? "",
                jobStatus: job["jobStatus"] ?? "",
                jobCompanyUID: job["jobCompanyUID"] ?? "",
                jobCompanyAuthorizedUID: job["jobCompanyAuthorizedUID"] ?? "",
                jobAgreementPriceCurrency: job["jobAgreementPriceCurrency"] ?? "",
                jobPriceCurrency: job["jobPriceCurrency"] ?? "",
                jobAgreementDate: job["jobAgreementDate"] ?? 0,
                jobStartDate: job["jobStartDate"] ?? 0,
                jobCompletionDate: job["jobCompletionDate"] ?? 0,
                jobEstimatedStartDate: job["jobEstimatedStartDate"] ?? 0,
                jobEstimatedCompletionDate: job["jobEstimatedCompletionDate"] ?? 0,
                jobAgreementPrice: job["jobAgreementPrice"] ?? 0.0,
                jobPrice: job["jobPrice"] ?? 0.0,
                jobWorkerList: job["jobWorkerList"] ?? [],
                jobMaterialList: job["materialList"] ?? [],
                jobUsedMaterialList: job["jobUsedMaterialList"] ?? [],
              ));
            }
          }
        }
      });
    }
  } catch (error) {
    Fluttertoast.showToast(
      msg: error.toString(),
      toastLength: Toast.LENGTH_LONG,
    );
  }

  return workerJobList;
}

//Delete worker userUID and workerUID
Future<bool> deleteWorker({
  required String userUID,
  required String workerUID,
}) async {
  bool workerDeleted = false;

  try {
    await FirebaseFirestore.instance.collection("users").doc(userUID).collection("workerList").doc(workerUID).delete().then((value) {
      workerDeleted = true;
    });
  } catch (error) {
    Fluttertoast.showToast(
      msg: error.toString(),
      toastLength: Toast.LENGTH_LONG,
    );
  }

  return workerDeleted;
}

//Get all the workers with userUID
Future<List<Worker>> getWorkerList({
  required String userUID,
}) async {
  List<Worker> workerList = <Worker>[];

  try {
    await FirebaseFirestore.instance.collection("users").doc(userUID).collection("workerList").get().then((value) {
      if (value.docs.isNotEmpty) {
        for (var workerData in value.docs) {
          workerList.add(
            Worker(
              workerActive: workerData["workerActive"] ?? false,
              workerUID: workerData["workerUID"] ?? "",
              workerName: workerData["workerName"] ?? "",
              workerJobList: List.from(workerData["workerJobList"] ?? []),
            ),
          );
        }
      }
    });
  } catch (error) {
    Fluttertoast.showToast(
      msg: error.toString(),
      toastLength: Toast.LENGTH_LONG,
    );
  }

  return workerList;
}

//Get worker with userUID and workerUID
Future<Worker> getWorker({
  required String userUID,
  required String workerUID,
}) async {
  Worker worker = Worker();

  try {
    await FirebaseFirestore.instance.collection("users").doc(userUID).collection("workerList").doc(workerUID).get().then((value) {
      if (value.data() != null) {
        Map workerData = Map.from(value.data() as Map);

        worker = Worker(
          workerActive: workerData["workerActive"] ?? false,
          workerUID: workerData["workerUID"] ?? "",
          workerName: workerData["workerName"] ?? "",
          workerJobList: workerData["workerJobList"] ?? [],
        );
      }
    });
  } catch (error) {
    Fluttertoast.showToast(
      msg: error.toString(),
      toastLength: Toast.LENGTH_LONG,
    );
  }

  return worker;
}

//Create worker with userUID and Worker
Future<bool> createWorker({
  required String userUID,
  required Worker worker,
}) async {
  bool workerCreated = false;

  try {
    await FirebaseFirestore.instance.collection("users").doc(userUID).collection("workerList").add({
      "workerActive": worker.workerActive,
      "workerName": worker.workerName,
      "workerJobList": worker.workerJobList,
    }).then((value) async {
      if (value.id.isNotEmpty) {
        await FirebaseFirestore.instance.collection("users").doc(userUID).collection("workerList").doc(value.id).update({
          "workerUID": value.id.toString(),
        }).then((value) {
          workerCreated = true;
        });
      }
    });
  } catch (error) {
    Fluttertoast.showToast(
      msg: error.toString(),
      toastLength: Toast.LENGTH_LONG,
    );
  }

  return workerCreated;
}
