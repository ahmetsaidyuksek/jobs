import 'package:jobs/utilities/models/worker_model.dart';

class SelectableWorker {
  bool? workerSelected;
  final Worker? worker;

  SelectableWorker({
    this.workerSelected,
    this.worker,
  });
}
