import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jobs/UI/company/company_authorized.dart';
import 'package:jobs/UI/job/add_workers.dart';
import 'package:jobs/utilities/database/database.dart' as database;
import 'package:jobs/utilities/models/company_authorized_model.dart';
import 'package:jobs/utilities/models/company_model.dart';
import 'package:jobs/utilities/models/job_model.dart';

class NewJobPage extends StatefulWidget {
  const NewJobPage({super.key});

  @override
  State<NewJobPage> createState() => _NewJobPageState();
}

class _NewJobPageState extends State<NewJobPage> {
  TextEditingController jobTitle = TextEditingController();

  TextEditingController agreementPrice = TextEditingController();
  String dropdownValue = "TL";
  double agreementPriceValue = 0.0;

  String companyValue = "Company";
  String authorizedValue = "Authorized";
  int jobStatusDropDownValue = 0;

  List<Company> companyList = <Company>[];
  List<DropdownMenuItem> dropdownCompanyList = <DropdownMenuItem>[];
  List<DropdownMenuItem> dropdownAuthorizedList = <DropdownMenuItem>[];

  int agreementDate = DateTime.now().millisecondsSinceEpoch;
  int estimatedStartDate = 0;
  int estimatedCompletionDate = 0;

  selectDate(String type) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime(DateTime.now().year + 100),
      initialDatePickerMode: DatePickerMode.day,
    );

    if (date != null) {
      switch (type) {
        case "agreementDate":
          setState(() {
            agreementDate = date.millisecondsSinceEpoch;
          });
          break;
        case "estimatedStartDate":
          setState(() {
            estimatedStartDate = date.millisecondsSinceEpoch;
          });
          break;
        case "estimatedCompletionDate":
          setState(() {
            estimatedCompletionDate = date.millisecondsSinceEpoch;
          });
          break;
        default:
      }
    }
  }

  String formatDate(int date) {
    String formattedDate =
        "${DateTime.fromMillisecondsSinceEpoch(date).day}/${DateTime.fromMillisecondsSinceEpoch(date).month}/${DateTime.fromMillisecondsSinceEpoch(date).year}";
    return formattedDate;
  }

  getCompanyList({required String userUID}) async {
    companyList = await database.getCompanyList(userUID: userUID);
    dropdownCompanyList.clear();
    if (companyList.isNotEmpty) {
      dropdownCompanyList.add(
        const DropdownMenuItem(
          value: "Company",
          child: Text(
            "Select Company",
          ),
        ),
      );

      for (var companyData in companyList) {
        dropdownCompanyList.add(
          DropdownMenuItem(
            value: companyData.companyUID.toString(),
            child: Text(
              companyData.companyName.toString(),
            ),
          ),
        );
      }
    } else {
      dropdownCompanyList.add(
        const DropdownMenuItem(
          value: "Company",
          child: Text(
            "Select Company",
          ),
        ),
      );
    }
    setState(() {});
  }

  getAuthorizedList(
      {required String userUID, required String companyUID}) async {
    authorizedValue = "Authorized";
    dropdownAuthorizedList.clear();

    dropdownAuthorizedList.add(
      const DropdownMenuItem(
        value: "Authorized",
        child: Text(
          "Select Authorized",
        ),
      ),
    );

    List<CompanyAuthorized> companyAuthorizedList =
        await database.getCompanyAuthorizedList(
      userUID: userUID,
      companyUID: companyUID,
    );

    if (companyAuthorizedList.isNotEmpty) {
      dropdownAuthorizedList.addAll(
        companyAuthorizedList.map(
          (companyAuthorized) {
            return DropdownMenuItem(
              value: companyAuthorized.companyAuthorizedUID,
              child: Text(
                companyAuthorized.companyAuthorizedName.toString(),
              ),
            );
          },
        ),
      );
    }
    setState(() {});
  }

  Widget _buildDateCard(String title, String dateText, VoidCallback onPressed) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 8),
            TextButton(
              onPressed: onPressed,
              style: TextButton.styleFrom(
                primary: Colors.deepPurple,
              ),
              child: Text(
                dateText,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.deepPurple,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    getCompanyList(userUID: FirebaseAuth.instance.currentUser!.uid);

    super.initState();
  }

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
        title: const Text("Add New Job"),
      ),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 16,
                            ),
                            child: DropdownButton(
                              value: jobStatusDropDownValue,
                              items: const [
                                DropdownMenuItem(
                                  value: 0,
                                  child: Text("Waiting"),
                                ),
                                DropdownMenuItem(
                                  value: 1,
                                  child: Text("Ongoing"),
                                ),
                                DropdownMenuItem(
                                  value: 2,
                                  child: Text("Complate"),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  jobStatusDropDownValue = value!;
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 16,
                              bottom: 16,
                            ),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: TextField(
                                controller: jobTitle,
                                maxLength: 400,
                                maxLines: 5,
                                minLines: 1,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                  labelText: "Job Title",
                                  hintText: "Job Title",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 32),
                            child: Wrap(
                              spacing: 16,
                              runSpacing: 16,
                              alignment: WrapAlignment.center,
                              runAlignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              direction: Axis.horizontal,
                              children: [
                                SizedBox(
                                  width: 250,
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButtonFormField(
                                      items: dropdownCompanyList,
                                      value: companyValue,
                                      dropdownColor: Colors.grey.shade500,
                                      onChanged: (value) {
                                        setState(() {
                                          companyValue = value;
                                          getAuthorizedList(
                                            userUID: FirebaseAuth
                                                .instance.currentUser!.uid,
                                            companyUID: value,
                                          );
                                        });
                                      },
                                      borderRadius: BorderRadius.circular(16),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        prefixIcon: const Icon(Icons.business),
                                      ),
                                    ),
                                  ),
                                ),
                                companyValue != "Company"
                                    ? SizedBox(
                                        width: 350,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            SizedBox(
                                              width: 250,
                                              child:
                                                  DropdownButtonHideUnderline(
                                                child: DropdownButtonFormField(
                                                  items: dropdownAuthorizedList,
                                                  value: authorizedValue,
                                                  dropdownColor:
                                                      Colors.grey.shade500,
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                    ),
                                                    prefixIcon: const Icon(
                                                        Icons.person),
                                                  ),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      authorizedValue = value;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 50,
                                              child: IconButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) {
                                                        return AddCompanyAuthorizedPage(
                                                          companyUID:
                                                              companyValue,
                                                        );
                                                      },
                                                    ),
                                                  ).then((value) {
                                                    if (value) {
                                                      getAuthorizedList(
                                                        userUID: FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid,
                                                        companyUID:
                                                            companyValue,
                                                      );
                                                    }
                                                    setState(() {});
                                                  });
                                                },
                                                icon: const Icon(Icons.add),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                              ],
                            ),
                          ),
                          Container(
                            width: 300,
                            height: 125,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(32),
                              color: Colors.amber,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Text(
                                  "Agreement Price",
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: (250 / 4) * 2,
                                      child: TextField(
                                        controller: agreementPrice,
                                        textAlign: TextAlign.end,
                                        inputFormatters: [
                                          CurrencyInputFormatter(
                                            thousandSeparator:
                                                ThousandSeparator.Comma,
                                            onValueChange: (value) {
                                              agreementPriceValue =
                                                  value as double;
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                        textInputAction: TextInputAction.done,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          hintText: "Price",
                                          fillColor: Colors.white,
                                          filled: true,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    SizedBox(
                                      width: (250 / 4) * 1.6,
                                      child: DropdownButtonFormField(
                                        items: const [
                                          DropdownMenuItem(
                                            value: "TL",
                                            child: Text("TL"),
                                          ),
                                          DropdownMenuItem(
                                            value: "USD",
                                            child: Text("USD"),
                                          ),
                                          DropdownMenuItem(
                                            value: "EURO",
                                            child: Text("EURO"),
                                          ),
                                        ],
                                        value: dropdownValue,
                                        decoration: InputDecoration(
                                          fillColor: Colors.white,
                                          filled: true,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            dropdownValue = value as String;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.deepPurple,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.deepPurple.withOpacity(0.3),
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                children: [
                                  _buildDateCard(
                                    "Agreement Date",
                                    formatDate(agreementDate),
                                    () => selectDate("agreementDate"),
                                  ),
                                  _buildDateCard(
                                    "Estimated Start Date",
                                    estimatedStartDate != 0
                                        ? formatDate(estimatedStartDate)
                                        : "Please select a date",
                                    () => selectDate("estimatedStartDate"),
                                  ),
                                  _buildDateCard(
                                    "Estimated Completion Date",
                                    estimatedCompletionDate != 0
                                        ? formatDate(estimatedCompletionDate)
                                        : "Please select a date",
                                    () => selectDate("estimatedCompletionDate"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Divider(
                  color: Colors.grey.shade500,
                  thickness: 1,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: TextButton(
                    onPressed: () {
                      database
                          .addNewJob(
                        userUID: FirebaseAuth.instance.currentUser!.uid,
                        job: Job(
                          jobActive: true,
                          jobTitle: jobTitle.text.toString(),
                          jobStatus: jobStatusDropDownValue.toInt(),
                          jobCompanyUID: companyValue.toString(),
                          jobCompanyAuthorizedUID: authorizedValue.toString(),
                          jobAgreementPriceCurrency: dropdownValue.toString(),
                          jobPriceCurrency: dropdownValue.toString(),
                          jobAgreementDate: agreementDate.toInt(),
                          jobStartDate: null,
                          jobCompletionDate: null,
                          jobEstimatedStartDate: estimatedStartDate.toInt(),
                          jobEstimatedCompletionDate:
                              estimatedCompletionDate.toInt(),
                          jobAgreementPrice: agreementPriceValue.toDouble(),
                          jobPrice: agreementPriceValue.toDouble(),
                          jobWorkerList: null,
                          jobMaterialList: [],
                          jobUsedMaterialList: [],
                        ),
                      )
                          .then((value) {
                        if (value != "") {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return AddWorkers(
                                  jobUID: value,
                                );
                              },
                            ),
                            (route) => false,
                          );
                        } else {
                          Fluttertoast.showToast(
                            msg: "Job Creation Went Wrong",
                            toastLength: Toast.LENGTH_LONG,
                          );
                        }
                      });
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text(
                      "Add Workers",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
