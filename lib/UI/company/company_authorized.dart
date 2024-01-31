import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jobs/utilities/database/database.dart';
import 'package:jobs/utilities/models/company_authorized_model.dart';

class AddCompanyAuthorizedPage extends StatefulWidget {
  final String companyUID;
  const AddCompanyAuthorizedPage({
    super.key,
    required this.companyUID,
  });

  @override
  State<AddCompanyAuthorizedPage> createState() => _AddCompanyAuthorizedPageState();
}

class _AddCompanyAuthorizedPageState extends State<AddCompanyAuthorizedPage> {
  TextEditingController authorizedController = TextEditingController();

  List<CompanyAuthorized> companyAuthorizedList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text("Add Company Authorized"),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: companyAuthorizedList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 16,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(companyAuthorizedList[index].companyAuthorizedName.toString()),
                        trailing: Text((index + 1).toString()),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: authorizedController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person),
                    labelText: "Authorized",
                    hintText: "Authorized",
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        if (authorizedController.text != "") {
                          companyAuthorizedList.add(
                            CompanyAuthorized(companyAuthorizedName: authorizedController.text),
                          );
                          authorizedController.clear();
                          setState(() {});
                        }
                      },
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (companyAuthorizedList.isNotEmpty) {
                    addCompanyAuthorizedList(userUID: FirebaseAuth.instance.currentUser!.uid, companyUID: widget.companyUID, companyAuthorizedList: companyAuthorizedList).then((value) {
                      if (value) {
                        Navigator.pop(context, true);
                      }
                    });
                  } else {
                    Navigator.pop(context, false);
                  }
                },
                child: const Text("Add Authorized"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
