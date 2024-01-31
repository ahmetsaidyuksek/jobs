import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jobs/UI/authorization/authorization.dart';
import 'package:jobs/UI/company/company_list.dart';
import 'package:jobs/UI/home.dart';
import 'package:jobs/UI/job/new_job.dart';
import 'package:jobs/UI/settings/settings.dart';
import 'package:jobs/UI/splash_screen/splash_screen.dart';
import 'package:jobs/firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Jobs());
}

class Jobs extends StatefulWidget {
  const Jobs({super.key});

  @override
  State<Jobs> createState() => _JobsState();
}

class _JobsState extends State<Jobs> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/": (context) => const SplashScreen(),
        "/signInPage": (context) => const SignInPage(),
        "/home": (context) => const HomePage(),
        "/newJobPage": (context) => const NewJobPage(),
        "/settingsPage": (context) => const Settings(),
        "/companyListPage": (context) => const CompanyListPage(),
      },
    );
  }
}
