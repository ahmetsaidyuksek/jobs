import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jobs/UI/company/company_authorized.dart';
import 'package:jobs/utilities/database/database.dart';
import 'package:jobs/utilities/models/company_model.dart';

class AddCompanyPage extends StatefulWidget {
  const AddCompanyPage({super.key});

  @override
  State<AddCompanyPage> createState() => _AddCompanyPageState();
}

class _AddCompanyPageState extends State<AddCompanyPage> {
  TextEditingController companyNameController = TextEditingController();

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
        title: const Text("Create Company"),
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
                  controller: companyNameController,
                  maxLength: 200,
                  maxLines: 1,
                  minLines: 1,
                  validator: (value) {
                    if (value == "") {
                      return "Company name can't be null";
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    hintText: "Company Name",
                    prefixIcon: Icon(Icons.business_rounded),
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              TextButton(
                onPressed: () {
                  if (companyNameController.text != "") {
                    createCompany(
                      userUID: FirebaseAuth.instance.currentUser!.uid,
                      company: Company(
                        companyName: companyNameController.text.toString(),
                      ),
                    ).then((value) {
                      if (value.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return AddCompanyAuthorizedPage(
                                companyUID: value,
                              );
                            },
                          ),
                        ).then((value) {
                          if (value) {
                            Navigator.pop(context, true);
                          }
                        });
                      }
                    });
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: const Text("Company name can't be null"),
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
                  "Create Company",
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
