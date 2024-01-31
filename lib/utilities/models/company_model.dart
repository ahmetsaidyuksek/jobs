class Company {
  final bool? companyActive;
  final String? companyUID;
  final String? companyName;
  final List<String>? companyAuthorizedList;
  final List<String>? companyJobList;

  Company({
    this.companyActive = true,
    this.companyUID,
    this.companyName,
    this.companyAuthorizedList,
    this.companyJobList,
  });
}
