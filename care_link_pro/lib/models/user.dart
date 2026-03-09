class User {
  int id;
  String firstName;
  String lastName;
  String race;
  String ssn;
  String image;
  String gender;
  String inmateRefId;
  String agencyId;
  String agencyName;
  String cognitivePersonId;
  String indexId;
  String email;
  String username;
  String activationCode;
  String dob;
  String displayName;
  String contactNumber;
  String phoneNo;
  String photo;
  String personId;
  String countryCode;
  String maritalStatus;
  String refId;
  String status;
  String lmsUserId;
  String type;
  String goalPercentage;
  String indexIdInmate;
  bool active;
  int encounterId;
  String tenantId;
  int paroleOfficerId;
  String name;
  bool statusBool;
  bool aliasMatch;



Map<String, dynamic>? address;

Map<String, dynamic>? contact;

Map<String, dynamic>? inmateSummary;


  List<dynamic>? roles;
  List<dynamic>? addresses;
  List<dynamic>? services;


  User({
    this.id = 0,
    this.firstName = "",
    this.lastName = "",
    this.race = "",
    this.ssn = "",
    this.image = "",
    this.gender = "",
    this.inmateRefId = "",
    this.agencyId = "",
    this.agencyName = "",
    this.cognitivePersonId = "",
    this.indexId = "",
    this.email = "",
    this.username = "",
    this.activationCode = "",
    this.dob = "",
    this.displayName = "",
    this.contactNumber = "",
    this.phoneNo = "",
    this.photo = "",
    this.personId = "",
    this.countryCode = "",
    this.maritalStatus = "",
    this.refId = "",
    this.status = "",
    this.lmsUserId = "",
    this.type = "",
    this.goalPercentage = "",
    this.indexIdInmate = "",
    this.active = true,
    this.encounterId = 0,
    this.tenantId = "",
    this.paroleOfficerId = 0,
    this.name = "",
    this.statusBool = false,
    this.aliasMatch = false,
    this.address,
    this.contact,
    this.inmateSummary,
    this.roles = const [],
    this.addresses = const [],
    this.services = const [],


  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"] ?? 0,
      firstName: json["firstName"] ?? "",
      lastName: json["lastName"] ?? "",
      race: json["race"] ?? "",
      ssn: json["ssn"] ?? "",
      image: json["image"] ?? "",
      gender: json["gender"] ?? "",
      inmateRefId: json["inmateRefId"] ?? "",
      agencyId: json["agencyId"] ?? "",
      agencyName: json["agencyName"] ?? "",
      cognitivePersonId: json["cognitivePersonId"] ?? "",
      indexId: json["refId"] ?? "",
      email: json["email"] ?? "",
      username: json["username"] ?? "",
      activationCode: json["activationCode"] ?? "",
      dob: json["dob"] ?? "",
      displayName: json["displayName"] ?? "",
      contactNumber: json["contactNumber"] ?? "",
      phoneNo: json["phoneNo"] ?? "",
      photo: json["photo"] ?? "",
      personId: json["personId"] ?? "",
      countryCode: json["countryCode"] ?? "",
      maritalStatus: json["maritalStatus"] ?? "",
      refId: json["refId"] ?? "",
      status: json["status"] ?? "",
      lmsUserId: json["lmsUserId"] ?? "",
      type: json["type"] ?? "",
      goalPercentage: json["goalPercentage"] ?? "",
      indexIdInmate: json["indexId"] ?? "",
      active: json["active"] ?? true,
      encounterId: json["encounterId"] ?? 0,
      tenantId: json["tenantId"] ?? "",
      paroleOfficerId: json["paroleOfficerId"] ?? 0,
      name: json["name"] ?? "",
      statusBool: json["statusBool"] ?? false,
      aliasMatch: json["aliasMatch"] ?? false,

            address: json['assignedDetails'] != null ? Map<String, dynamic>.from(json['address']) : null,

            contact: json['contact'] != null ? Map<String, dynamic>.from(json['contact']) : null,
            inmateSummary: json['inmateSummary'] != null ? Map<String, dynamic>.from(json['inmateSummary']) : null,

      roles: json['roles'] != null ? List<dynamic>.from(json['roles']) : null,
      addresses: json['addresses'] != null ? List<dynamic>.from(json['addresses']) : null,
      services: json['services'] != null ? List<dynamic>.from(json['services']) : null


      
    );
  }

Map<String, dynamic> toJson() {
  return {
    "id": id,
    "firstName": firstName,
    "lastName": lastName,
    "race": race,
    "ssn": ssn,
    "image": image,
    "gender": gender,
    "inmateRefId": inmateRefId,
    "agencyId": agencyId,
    "agencyName": agencyName,
    "cognitivePersonId": cognitivePersonId,
    "indexId": indexId,
    "email": email,
    "username": username,
    "activationCode": activationCode,
    "dob": dob,
    "displayName": displayName,
    "contactNumber": contactNumber,
    "phoneNo": phoneNo,
    "photo": photo,
    "personId": personId,
    "countryCode": countryCode,
    "maritalStatus": maritalStatus,
    "refId": refId,
    "status": status,
    "lmsUserId": lmsUserId,
    "type": type,
    "goalPercentage": goalPercentage,
    "indexIdInmate": indexIdInmate,
    "active": active,
    "encounterId": encounterId,
    "tenantId": tenantId,
    "paroleOfficerId": paroleOfficerId,
    "name": name,
    "statusBool": statusBool,
    "aliasMatch": aliasMatch,
    "address": address,
    "contact": contact,
    "inmateSummary": inmateSummary,
    "roles": roles,
    "addresses": addresses,
    "services": services,
  };
}

}