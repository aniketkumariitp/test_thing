class MyEventModel {
  final String? message;
  final DataOfMyEvent? data;

  MyEventModel({this.message, this.data});

  factory MyEventModel.fromJson(Map<String, dynamic> json) {
    return MyEventModel(
      message: json['message'],
      data: json['data'] != null ? DataOfMyEvent.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'data': data?.toJson()};
  }
}

class DataOfMyEvent {
  final List<CreatedEvent>? createdEvents;

  DataOfMyEvent({this.createdEvents});

  factory DataOfMyEvent.fromJson(Map<String, dynamic> json) {
    return DataOfMyEvent(
      createdEvents: json['createdEvents'] != null
          ? List<CreatedEvent>.from(
              json['createdEvents'].map((v) => CreatedEvent.fromJson(v)),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'createdEvents': createdEvents?.map((e) => e.toJson()).toList()};
  }
}

class CreatedEvent {
  final String? id;
  final String? creatorId;
  final String? eventBanner;
  final String? eventName;
  final String? eventDescription;
  final int? eventTotalseat;
  final int? eventBookedseats;
  final String? eventLocation;
  final String? eventMapLocation;
  final int? ticketPrice;
  final String? contactNumber;
  final DateTime? startDate;
  final DateTime? endDate;

  CreatedEvent({
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
    this.contactNumber,
    this.startDate,
    this.endDate,
  });

  factory CreatedEvent.fromJson(Map<String, dynamic> json) {
    return CreatedEvent(
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
      contactNumber: json['contactNumber'],
      startDate: json['startDate'] != null
          ? DateTime.tryParse(json['startDate'])
          : null,
      endDate: json['endDate'] != null
          ? DateTime.tryParse(json['endDate'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
      'contactNumber': contactNumber,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }
}
