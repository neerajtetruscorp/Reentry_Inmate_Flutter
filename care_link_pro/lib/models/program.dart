import 'package:care_link_pro/models/program_attributes';
import 'package:care_link_pro/models/progress';

class Program {
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

  ProgramAttributes? programAttributes;
  Progress? progress;
  List<dynamic>? inmateEvents;
  List<dynamic>? addressDTO;



  Program({
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
    this.programAttributes,
    this.progress,
    this.inmateEvents,
    this.addressDTO,
  });

  factory Program.fromJson(Map<String, dynamic> json) {
    return Program(
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
      addressDTO: json['addressDTO'] != null ? List<dynamic>.from(json['addressDTO']) : null


    );
    
  }
}