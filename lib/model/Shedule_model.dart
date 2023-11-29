class Shedule_modle{
  late int horse=0;
  late String time,owner_name,owner_phone;
  late bool alert_on;
  late String reason;
  late int shedule_time;

  Shedule_modle({required this.horse, required this.time,
    required this.owner_name, required this.owner_phone,
    required this.alert_on, required this.reason, required this.shedule_time});

  factory Shedule_modle.fromJson(Map<dynamic, dynamic> json) {
    return Shedule_modle(
      horse: json["horse"]??0,
      time: json["time"],
      owner_name: json["owner_name"],
      owner_phone: json["owner_phone"],
      alert_on: json["alert_on"]??true,
      reason: json["reason"]??'',
      shedule_time: json["shedule_time"]??0,
    );
  }

  Map<dynamic, dynamic> toJson() {
    return {
      "horse": this.horse,
      "time": this.time,
      "owner_name": this.owner_name,
      "owner_phone": this.owner_phone,
      "alert_on": this.alert_on,
      "reason": this.reason,
      "shedule_time": this.shedule_time,
    };
  }

//
}