class CompanyAuthorized {
  final bool? companyAuthorizedActive;
  final String? companyAuthorizedUID;
  final String? companyAuthorizedName;
  final List<String>? companyAuthorizedJobList;

  CompanyAuthorized({
    this.companyAuthorizedActive = true,
    this.companyAuthorizedUID,
    this.companyAuthorizedName,
    this.companyAuthorizedJobList,
  });
}
