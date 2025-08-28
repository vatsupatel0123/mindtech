class PackageModel {
  int? packageId;
  String? packageTitle;
  String? packageDesc;
  double? originalAmount;
  double? netAmount;
  String? duration;

  PackageModel(
      {this.packageId,
        this.packageTitle,
        this.packageDesc,
        this.originalAmount,
        this.netAmount,
        this.duration});

  PackageModel.fromJson(Map<String, dynamic> json) {
    packageId = json['package_id'];
    packageTitle = json['package_title'];
    packageDesc = json['package_desc'];
    originalAmount = double.parse(json['original_amount'].toString());
    netAmount = double.parse(json['net_amount'].toString());
    duration = json['duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['package_id'] = this.packageId;
    data['package_title'] = this.packageTitle;
    data['package_desc'] = this.packageDesc;
    data['original_amount'] = this.originalAmount;
    data['net_amount'] = this.netAmount;
    data['duration'] = this.duration;
    return data;
  }
}
