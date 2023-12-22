class Horse_info_model{
  late String name;  
  late String cmnt,img,record,owner_name;
  late int time_of_cmnt;
  late int img_picked;

  Horse_info_model({required this.name, required this.cmnt, required this.img,required this.record, required this.owner_name,
    required this.time_of_cmnt, required this.img_picked});

  factory Horse_info_model.fromJson(Map<dynamic, dynamic> json) {
    return Horse_info_model(
      name: json["name"]??"",
      cmnt: json["cmnt"]??"",
      img: json["img"]??"",
      record: json["record"]??"",
      owner_name: json["owner_name"],
      time_of_cmnt: json["time_of_cmnt"],
      img_picked: json["img_picked"]??0,
    );
  }

  Map<dynamic, dynamic> toJson() {
    return {
      "name": this.name,      
      "cmnt": this.cmnt,
      "img": this.img,
      "record": this.record,
      "owner_name": this.owner_name,
      "time_of_cmnt": this.time_of_cmnt,
      "img_picked": this.img_picked,
    };
  }
//
}