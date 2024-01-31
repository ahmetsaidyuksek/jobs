class Job {
  final bool? jobActive;
  final String? jobUID;
  final String? jobTitle;
  final int? jobStatus;
  final String? jobCompanyUID;
  final String? jobCompanyAuthorizedUID;
  final String? jobAgreementPriceCurrency;
  final String? jobPriceCurrency;
  final int? jobAgreementDate;
  final int? jobStartDate;
  final int? jobCompletionDate;
  final int? jobEstimatedStartDate;
  final int? jobEstimatedCompletionDate;
  final double? jobAgreementPrice;
  final double? jobPrice;
  final List<String>? jobWorkerList;
  final List? jobMaterialList;
  final List? jobUsedMaterialList;

  Job({
    this.jobActive = true,
    this.jobUID,
    this.jobTitle,
    this.jobStatus,
    this.jobCompanyUID,
    this.jobCompanyAuthorizedUID,
    this.jobAgreementPriceCurrency,
    this.jobPriceCurrency,
    this.jobAgreementDate,
    this.jobStartDate,
    this.jobCompletionDate,
    this.jobEstimatedStartDate,
    this.jobEstimatedCompletionDate,
    this.jobAgreementPrice,
    this.jobPrice,
    this.jobWorkerList,
    this.jobMaterialList,
    this.jobUsedMaterialList,
  });
}
