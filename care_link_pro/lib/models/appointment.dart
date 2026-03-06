import 'package:care_link_pro/models/program_attributes';
import 'package:care_link_pro/models/progress';

class Appointment {
  int? id;
  String? serviceType;
  String? serviceTypeName;
  String? status;
  String? startDateTime;
  String? endDateTime;
  String? createDate;
  String? source;
  String? url;
  String? programRefId;
  String? type;
  String? assignedBy;
  String? assignName;
  String? inmateId;
  String? virtualMeetingId;
  String? scheduledDateTime;



  ProgramAttributes? programAttributes;
  Progress? progress;
  List<dynamic>? inmateEvents;
  List<dynamic>? addressDTO;
Map<String, dynamic>? assignedDetails;


  Appointment({
    this.id,
    this.serviceType,
    this.serviceTypeName,
    this.status,
    this.startDateTime,
    this.endDateTime,
    this.createDate,
    this.source,
    this.url,
    this.programRefId,
    this.type,
    this.assignedBy,
    this.assignName,
    this.inmateId,
    this.virtualMeetingId,
    this.programAttributes,
    this.progress,
    this.inmateEvents,
    this.addressDTO,
    this.assignedDetails,
    this.scheduledDateTime,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
       id: json['id'],
    serviceType: json['serviceType']?.toString(),
    serviceTypeName: json['serviceTypeName']?.toString(),
    status: json['status']?.toString(),
    startDateTime: json['startDateTime']?.toString(),
    endDateTime: json['endDateTime']?.toString(),
    createDate: json['createDate']?.toString(),
    source: json['source']?.toString(),
    url: json['url']?.toString(),
    programRefId: json['programRefId']?.toString(),
    type: json['type']?.toString(),
    virtualMeetingId: json['virtualMeetingId']?.toString(),
    assignedBy: json['assignedBy']?.toString(),
    assignName: json['assignName']?.toString(),
    inmateId: json['inmateId']?.toString(),
      programAttributes: json['programAttributes'] != null
          ? ProgramAttributes.fromJson(json['programAttributes'])
          : null,
      progress: json['progress'] != null
          ? Progress.fromJson(json['progress'])
          : null,
      inmateEvents: json['inmateEvents'] != null ? List<dynamic>.from(json['inmateEvents']) : null,
      addressDTO: json['addressDTO'] != null ? List<dynamic>.from(json['addressDTO']) : null,
      assignedDetails: json['assignedDetails'] != null ? Map<String, dynamic>.from(json['assignedDetails']) : null,
      scheduledDateTime: json['scheduledDateTime']?.toString(),


    );
    
  }
}