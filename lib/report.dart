class Report {
  final String status;
  final double longitude;
  final double latitude;
  String info;
  int id;
  int userId;


  Report(this.status, this.longitude, this.latitude, this.info);


  Report.fromJson(Map<String, dynamic> json)
      : status = json['status'],
        longitude = json['longitude'],
        latitude = json['latitude'],
        id = json['id'],
        userId = json['userId'];

  Map<String, dynamic> toJson() =>
      {
        'status': status,
        'id': id,
        'longitude': longitude,
        'latitude': latitude,
        'info': info
      };

}