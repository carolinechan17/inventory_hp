class PhoneColor {
  int? id;
  String? color;

  PhoneColor({this.id, this.color});

  factory PhoneColor.fromJson(Map<String, dynamic> json) => PhoneColor(
        id: json['id'],
        color: json['color'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'color': color,
      };
}
