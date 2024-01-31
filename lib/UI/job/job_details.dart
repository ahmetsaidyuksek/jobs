import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jobs/utilities/database/database.dart' as database;
import 'package:jobs/utilities/models/job_model.dart';

class JobDetailsPage extends StatefulWidget {
  final String jobUID;
  const JobDetailsPage({
    super.key,
    required this.jobUID,
  });

  @override
  State<JobDetailsPage> createState() => _JobDetailsPageState();
}

class _JobDetailsPageState extends State<JobDetailsPage> {
  Job job = Job();

  getJobDetails({
    required String userUID,
    required String jobUID,
  }) async {
    job = await database.getJob(userUID: userUID, jobUID: jobUID);
    setState(() {});
  }

  @override
  void initState() {
    getJobDetails(
      userUID: FirebaseAuth.instance.currentUser!.uid,
      jobUID: widget.jobUID,
    );
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
        title: const Text("Job Details"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: SafeArea(
        child: SizedBox.expand(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 32,
                    bottom: 32,
                  ),
                  child: Text(
                    job.jobTitle.toString(),
                    style: const TextStyle(
                      fontSize: 18,
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
