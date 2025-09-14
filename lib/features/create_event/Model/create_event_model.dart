class CreateEventModel {
  String? message;
  Data? data;

  CreateEventModel({this.message, this.data});

  CreateEventModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? id;
  String? creatorId;
  String? eventBanner;
  String? eventName;
  String? eventDescription;
  int? eventTotalseat;
  String? eventLocation;
  String? eventMapLocation;
  int? ticketPrice;
  String? contactNumber;
  String? creatorUpiID;
  DateTime? startDate;
  DateTime? endDate;
  Creator? creator;

  Data({
    this.id,
    this.creatorId,
    this.eventBanner,
    this.eventName,
    this.eventDescription,
    this.eventTotalseat,
    this.eventLocation,
    this.eventMapLocation,
    this.ticketPrice,
    this.creatorUpiID,
    this.contactNumber,
    this.startDate,
    this.endDate,
    this.creator,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    creatorId = json['creatorId'];
    eventBanner = json['eventBanner'];
    eventName = json['eventName'];
    eventDescription = json['eventDescription'];
    eventTotalseat = json['eventTotalseat'];
    eventLocation = json['eventLocation'];
    eventMapLocation = json['eventMapLocation'];
    ticketPrice = json['ticketPrice'];
    creatorUpiID = json['creatorUpiID'];
    contactNumber = json['contactNumber'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    creator = json['creator'] != null
        ? new Creator.fromJson(json['creator'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['creatorId'] = this.creatorId;
    data['eventBanner'] = this.eventBanner;
    data['eventName'] = this.eventName;
    data['eventDescription'] = this.eventDescription;
    data['eventTotalseat'] = this.eventTotalseat;
    data['eventLocation'] = this.eventLocation;
    data['eventMapLocation'] = this.eventMapLocation;
    data['ticketPrice'] = this.ticketPrice;
    data['creatorUpiID'] = this.creatorUpiID;
    data['contactNumber'] = this.contactNumber;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    if (this.creator != null) {
      data['creator'] = this.creator!.toJson();
    }
    return data;
  }
}

class Creator {
  String? name;

  Creator({this.name});

  Creator.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}
