import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jobs/UI/company/company_details.dart';
import 'package:jobs/UI/company/new_company.dart';
import 'package:jobs/utilities/database/database.dart' as database;
import 'package:jobs/utilities/models/company_model.dart';

class CompanyListPage extends StatefulWidget {
  const CompanyListPage({super.key});

  @override
  State<CompanyListPage> createState() => _CompanyListPageState();
}

class _CompanyListPageState extends State<CompanyListPage> {
  TextEditingController companyController = TextEditingController();

  List<Company> companyList = [];

  getCompanyList() async {
    companyList = await database.getCompanyList(userUID: FirebaseAuth.instance.currentUser!.uid);
    companyList.sort((a, b) => a.companyName.toString().compareTo(b.companyName.toString()));
    setState(() {});
  }

  @override
  void initState() {
    getCompanyList();
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
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text("Company List"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const AddCompanyPage();
                  },
                ),
              ).then((value) {
                if (value) {
                  getCompanyList();
                }
              });
            },
            icon: const Icon(Icons.add_business_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 25,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextField(
                  controller: companyController,
                  maxLines: 1,
                  minLines: 1,
                  maxLength: 200,
                  decoration: const InputDecoration(
                    hintText: "Company Name",
                    prefixIcon: Icon(
                      Icons.business_rounded,
                    ),
                  ),
                ),
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: companyList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return CompanyDetailsPage(
                                  company: companyList[index],
                                );
                              },
                            ),
                          );
                        },
                        child: ListTile(
                          leading: const Icon(Icons.business_rounded),
                          title: Text(companyList[index].companyName.toString()),
                          trailing: const Icon(Icons.arrow_right_rounded),
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
