import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jobs/UI/authorization/authorization.dart';
import 'package:jobs/UI/company/company_list.dart';
import 'package:jobs/UI/worker/worker_list.dart';
import 'package:jobs/utilities/authentication/authentication.dart';
import 'package:jobs/utilities/database/database.dart';
import 'package:jobs/utilities/models/user_model.dart' as user_model;

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  user_model.User user = user_model.User();

  getUserData({
    required String userUID,
  }) async {
    user = await getUser(userUID: userUID);
    setState(() {});
  }

  @override
  void initState() {
    getUserData(userUID: FirebaseAuth.instance.currentUser!.uid);
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
        title: const Text("Settings"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text(
                  "Hi, ${user.userName}",
                  style: const TextStyle(
                    fontSize: 32,
                  ),
                ),
              ),
            ),
            const Divider(),
            InkWell(
              onTap: () {},
              child: const ListTile(
                leading: Icon(
                  Icons.account_circle,
                  size: 48,
                ),
                title: Text("Account Details"),
                subtitle: Text("Change Name, Change E-mail, Change Password, ETC."),
                trailing: Icon(Icons.arrow_right),
              ),
            ),
            const Divider(),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const CompanyListPage();
                    },
                  ),
                );
              },
              child: const ListTile(
                leading: Icon(
                  Icons.business_rounded,
                  size: 48,
                ),
                title: Text("Company List"),
                subtitle: Text("Add Company, Edit Company, Add Company Authorized, ETC."),
                trailing: Icon(Icons.arrow_right),
              ),
            ),
            const Divider(),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const WorkerListPage();
                    },
                  ),
                );
              },
              child: const ListTile(
                leading: Icon(
                  Icons.person_rounded,
                  size: 48,
                ),
                title: Text("Worker List"),
                subtitle: Text("Add Worker, See Workers Jobs, ETC."),
                trailing: Icon(Icons.arrow_right),
              ),
            ),
            const Divider(),
            const Spacer(),
            const Divider(),
            InkWell(
              onTap: () {
                signOut().then((value) {
                  if (value) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const SignInPage();
                        },
                      ),
                      (route) => false,
                    );
                  }
                });
              },
              child: const ListTile(
                title: Text("Log Out"),
                trailing: Icon(Icons.logout),
                iconColor: Colors.red,
                textColor: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
