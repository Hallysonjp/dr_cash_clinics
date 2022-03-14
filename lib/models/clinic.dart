class Clinic {
  int? id;
  String? tradingName;
  String? city;
  String? state;
  int? clinicTypeId;
  String? clinicType;
  String? phoneNumber;
  bool? isActive;

  Clinic(
      {this.id,
        this.tradingName,
        this.city,
        this.state,
        this.clinicTypeId,
        this.clinicType,
        this.phoneNumber,
        this.isActive});

  Clinic.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tradingName = json['tradingName'];
    city = json['city'];
    state = json['state'];
    clinicTypeId = json['clinicTypeId'];
    clinicType = json['clinicType'];
    phoneNumber = json['phoneNumber'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tradingName'] = this.tradingName;
    data['city'] = this.city;
    data['state'] = this.state;
    data['clinicTypeId'] = this.clinicTypeId;
    data['clinicType'] = this.clinicType;
    data['phoneNumber'] = this.phoneNumber;
    data['isActive'] = this.isActive;
    return data;
  }
}