class GetEventModel {
  final String? message;
  final List<Data>? data;

  GetEventModel({this.message, this.data});

  factory GetEventModel.fromJson(Map<String, dynamic> json) {
    return GetEventModel(
      message: json['message'],
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => Data.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'message': message,
    'data': data?.map((e) => e.toJson()).toList(),
  };
}

class Data {
  final String? id;
  final String? creatorId;
  final String? eventBanner;
  final String? eventName;
  final String? eventDescription;
  final int? eventTotalseat;
  final int? eventBookedseats;
  final String? eventLocation;
  final String? eventMapLocation;
  int? ticketPrice;
  final String? creatorUpiID;
  final String? contactNumber;
  final DateTime? startDate;
  final DateTime? endDate;
  final Creator? creator;

  Data({
    this.id,
    this.creatorId,
    this.eventBanner,
    this.eventName,
    this.eventDescription,
    this.eventTotalseat,
    this.eventBookedseats,
    this.eventLocation,
    this.eventMapLocation,
    this.ticketPrice,
    this.creatorUpiID,
    this.contactNumber,
    this.startDate,
    this.endDate,
    this.creator,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'],
      creatorId: json['creatorId'],
      eventBanner: json['eventBanner'],
      eventName: json['eventName'],
      eventDescription: json['eventDescription'],
      eventTotalseat: json['eventTotalseat'],
      eventBookedseats: json['eventBookedseats'],
      eventLocation: json['eventLocation'],
      eventMapLocation: json['eventMapLocation'],
      ticketPrice: json['ticketPrice'],
      creatorUpiID: json['creatorUpiID'],
      contactNumber: json['contactNumber'],
      startDate: json['startDate'] != null
          ? DateTime.tryParse(json['startDate'])
          : null,
      endDate: json['endDate'] != null
          ? DateTime.tryParse(json['endDate'])
          : null,
      creator: json['creator'] != null
          ? Creator.fromJson(json['creator'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'creatorId': creatorId,
    'eventBanner': eventBanner,
    'eventName': eventName,
    'eventDescription': eventDescription,
    'eventTotalseat': eventTotalseat,
    'eventBookedseats': eventBookedseats,
    'eventLocation': eventLocation,
    'eventMapLocation': eventMapLocation,
    'ticketPrice': ticketPrice,
    'creatorUpiID': creatorUpiID,
    'contactNumber': contactNumber,
    'startDate': startDate?.toIso8601String(),
    'endDate': endDate?.toIso8601String(),
    'creator': creator?.toJson(),
  };
}

class Creator {
  final String? name;
  final String? email;
  final String? profilePic;

  Creator({this.name, this.email, this.profilePic});

  factory Creator.fromJson(Map<String, dynamic> json) {
    return Creator(
      name: json['name'],
      email: json['email'],
      profilePic: json['profilePic'],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'profilePic': profilePic,
  };
}
