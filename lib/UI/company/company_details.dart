import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jobs/UI/company/company_authorized.dart';
import 'package:jobs/utilities/database/database.dart' as database;
import 'package:jobs/utilities/models/company_model.dart';

class CompanyDetailsPage extends StatefulWidget {
  final Company company;
  const CompanyDetailsPage({
    super.key,
    required this.company,
  });

  @override
  State<CompanyDetailsPage> createState() => _CompanyDetailsPageState();
}

class _CompanyDetailsPageState extends State<CompanyDetailsPage> {
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
        title: const Text("Company Details"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 48,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 32,
                    ),
                    Text(
                      widget.company.companyName.toString(),
                      style: GoogleFonts.roboto(
                        fontSize: 32,
                        shadows: [
                          const Shadow(
                            blurRadius: 6,
                            color: Colors.black54,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Delete Company"),
                              content: const Text("Do you want a delete company"),
                              actions: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(Icons.cancel_outlined),
                                ),
                                IconButton(
                                  onPressed: () {
                                    database
                                        .deleteCompany(
                                      userUID: FirebaseAuth.instance.currentUser!.uid,
                                      companyUID: widget.company.companyUID.toString(),
                                    )
                                        .then((value) {
                                      if (value) {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      }
                                    });
                                  },
                                  icon: const Icon(Icons.done_outline_rounded),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.delete_forever_rounded,
                        color: Colors.red,
                        size: 32,
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    )
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  spacing: 16,
                  runSpacing: 8,
                  direction: Axis.horizontal,
                  children: [
                    Container(
                      height: 350,
                      width: MediaQuery.of(context).orientation.name == "portrait" ? MediaQuery.of(context).size.width / 1.4 : MediaQuery.of(context).size.width / 2.4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.brown.shade400,
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Stack(
                              alignment: Alignment.centerRight,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Authorized List",
                                    style: GoogleFonts.roboto(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return AddCompanyAuthorizedPage(companyUID: widget.company.companyUID.toString());
                                            },
                                          ),
                                        ).then((value) {
                                          if (value) {
                                            setState(() {});
                                          }
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.person_add_rounded,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            color: Colors.white,
                            height: 8,
                            indent: 4,
                            endIndent: 4,
                            thickness: 2,
                          ),
                          FutureBuilder(
                            future: database.getCompanyAuthorizedList(
                              userUID: FirebaseAuth.instance.currentUser!.uid,
                              companyUID: widget.company.companyUID.toString(),
                            ),
                            builder: (context, companyAuthorized) {
                              if (companyAuthorized.connectionState == ConnectionState.waiting) return const CircularProgressIndicator();
                              if (companyAuthorized.data == null) return Container();

                              return Expanded(
                                child: ListView.builder(
                                  itemCount: companyAuthorized.data!.length,
                                  itemBuilder: (context, index) {
                                    return Dismissible(
                                      key: Key(companyAuthorized.data![index].companyAuthorizedUID.toString()),
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
                                      direction: DismissDirection.endToStart,
                                      onDismissed: (direction) {
                                        database
                                            .deleteCompanyAuthorized(
                                          userUID: FirebaseAuth.instance.currentUser!.uid,
                                          companyUID: widget.company.companyUID.toString(),
                                          companyAuthorizedUID: companyAuthorized.data![index].companyAuthorizedUID.toString(),
                                        )
                                            .then((value) {
                                          if (value) {
                                            companyAuthorized.data!.removeAt(index);
                                          }
                                        });
                                        setState(() {});
                                      },
                                      child: Card(
                                        child: ListTile(
                                          leading: const Icon(Icons.person_rounded),
                                          title: Text(
                                            companyAuthorized.data![index].companyAuthorizedName.toString(),
                                            style: GoogleFonts.roboto(
                                              color: Colors.black,
                                              fontSize: 18,
                                            ),
                                          ),
                                          //trailing: const Icon(Icons.arrow_right_rounded), Add Authorized Details, Job List, on v1.1
                                          trailing: IconButton(
                                            onPressed: () {
                                              database
                                                  .deleteCompanyAuthorized(
                                                userUID: FirebaseAuth.instance.currentUser!.uid,
                                                companyUID: widget.company.companyUID.toString(),
                                                companyAuthorizedUID: companyAuthorized.data![index].companyAuthorizedUID.toString(),
                                              )
                                                  .then((value) {
                                                if (value) {
                                                  companyAuthorized.data!.removeAt(index);
                                                }
                                              });
                                              setState(() {});
                                            },
                                            icon: const Icon(
                                              Icons.delete_forever_rounded,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}