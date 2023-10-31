class Horse_model{
  late String name,year_born,age;
  late String owner_name,owner_nbr;

  Horse_model({required this.name, required this.year_born, required this.age,
    required this.owner_name, required this.owner_nbr});

  factory Horse_model.fromJson(Map<dynamic, dynamic> json) {
    return Horse_model(
      name: json["name"],
      year_born: json["year_born"],
      age: json["age"],
      owner_name: json["owner_name"]??'',
      owner_nbr: json["owner_nbr"]??'',
    );
  }

  Map<dynamic, dynamic> toJson() {
    return {
      "name": this.name,
      "year_born": this.year_born,
      "age": this.age,
      "owner_name": this.owner_name,
      "owner_nbr": this.owner_nbr,
    };
  }

//
}